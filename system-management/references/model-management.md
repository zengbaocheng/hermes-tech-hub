# Model Management Module (hermes-model-manager.sh)

Integrated into `hermes-backup-v2.sh` — accessed via menu option `[m]` or direct CLI:
```bash
bash ~/hermes-backup-v2.sh model
```

Separate source file: `~/hermes-model-manager.sh` (auto-sourced by backup script)

## Architecture

The model management module is a separate bash script sourced at runtime:
```bash
MODEL_MODULE="$(dirname "$(readlink -f "$0")")/hermes-model-manager.sh"
[[ -f "$MODEL_MODULE" ]] && source "$MODEL_MODULE" || log_info "模型管理模块未安装"
```

**Key vars** (shared with main script): `$HERMES_HOME`, `$CONFIG_FILE`, `$VENDOR_FILE`, `$GREEN`/`$RED`/`$CYAN`/etc colors.

## Menu Structure

```
模型管理工具                            (model_submenu)
  [1] 查看模型配置概览                   (model_overview)
  [2] 查看角色模型配置                   (model_role_list)
  [3] 测试主模型连通性                   (model_test_main)
  [4] 测试视觉模型                       (model_test_vision)
  [5] 测试所有角色模型                   (model_test_all_roles)
  [6] 切换模型/供应商                    (model_switch_wizard)
  [7] 新增角色模型                       (model_role_add)
  [8] 编辑角色模型                       (model_role_edit)
  [9] 删除角色模型                       (model_role_delete)
  [0] 返回主菜单
```

## Configuration Reading

### Reading config.yaml

```bash
# Helper function — extracts single value by key
get_cfg_val() {
    grep "^$1:" "$CONFIG_FILE" 2>/dev/null | head -1 | \
        sed 's/^[^:]*: *//' | sed 's/^"//;s/"$//' | sed "s/^'//;s/'$//"
}

# Usage — note indentation matters
local main_model=$(get_cfg_val "  default")    # 2-space indent
local main_provider=$(get_cfg_val "  provider")
local main_base=$(get_cfg_val "  base_url")
```

### Reading auxiliary (vision) config

```bash
# grep for nested YAML section
local vision_provider=$(grep -A5 "vision:" "$CONFIG_FILE" | grep "provider:" | head -1 | awk '{print $2}')
local vision_model=$(grep -A5 "vision:" "$CONFIG_FILE" | grep "model:" | head -1 | awk '{print $2}')
local vision_base=$(grep -A5 "vision:" "$CONFIG_FILE" | grep "base_url:" | head -1 | awk '{print $2}' | sed "s/^'//;s/'$//" | sed 's/^"//;s/"$//')
# The sed stripping is critical — config.yaml stores empty string as '' not empty
```

### Reading vendor_models.json (role-based models)

```python
# Embedded python3 for JSON parsing:
python3 -c "
import json
with open('$VENDOR_FILE') as f:
    d = json.load(f)
for k,v in d.items():
    if k.startswith('_'): continue  # skip metadata keys
    cur = v.get('current','?')
    pri = v.get('primary',{}).get('model','?')
    falls = [fb.get('model','?') for fb in v.get('fallbacks',[])]
    ...
    print(f'{k}:')
    print(f'  主选: {pri}')
    print(f'  当前: {cur}')
    print(f'  备用: {falls_str}')
"
```

## API Testing via Curl

### Generic model test function

```bash
model_test_api() {
    local base_url="$1"
    local api_key="$2"
    local model="$3"
    local label="$4"

    # Ensure endpoint is /chat/completions
    local endpoint="${base_url%/}"
    [[ "$endpoint" != *"/chat/completions" ]] && endpoint="${endpoint}/chat/completions"

    # Send minimal request with --max-time 15
    local response
    response=$(curl -s -w "\n%{http_code}" --max-time 15 \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d '{"model":"'"$model"'","messages":[{"role":"user","content":"say OK"}],"max_tokens":5}' \
        "$endpoint" 2>/dev/null) || true

    local http_code=$(echo "$response" | tail -1)
    local body=$(echo "$response" | sed '$d')

    if [[ "$http_code" == "200" ]]; then
        echo -e "  ✓ $label: OK"
        return 0
    else
        echo -e "  ✗ $label: HTTP $http_code"
        return 1
    fi
}
```

Key curl technique:
- `-s -w "\n%{http_code}"` — silent mode, appends HTTP code as last output line
- `tail -1` = HTTP code, `sed '$d'` = response body
- `|| true` on curl to avoid `set -e` abort from network errors
- `--max-time 15` prevents hanging on unresponsive endpoints

### API Key Discovery Priority

1. `config.yaml` → `model.api_key` field
2. Shell environment variable (e.g. `$OPENROUTER_API_KEY`)
3. `.env` file → `grep 'KEY_NAME' ~/.hermes/.env`

```bash
# From config
local api_key=$(get_cfg_val "  api_key")

# From env var
local api_key="${OPENROUTER_API_KEY:-}"

# From .env file
local api_key=$(grep 'OPENROUTER_API_KEY' "${HERMES_HOME}/.env" | head -1 | cut -d= -f2- || true)
```

### Provider-Specific Endpoints

| Provider | Base URL | Notes |
|----------|----------|-------|
| OpenRouter | `https://openrouter.ai/api/v1` | Uses `OPENROUTER_API_KEY` |
| NVIDIA | `https://integrate.api.nvidia.com/v1` | Uses `NVIDIA_API_KEY` |
| Token.sensenova.cn | `https://token.sensenova.cn/v1` | Uses config `api_key` |
| OpenAI | `https://api.openai.com/v1` | Uses `OPENAI_API_KEY` |
| Custom | config `model.base_url` | Uses config `model.api_key` |

## Model Switching Wizard

```bash
# Interactive choice of provider presets:
# [1] OpenRouter    → provider=openrouter,    base=https://openrouter.ai/api/v1
# [2] NVIDIA        → provider=nvidia,        base=https://integrate.api.nvidia.com/v1
# [3] Token.sensenova → provider=custom,      base=https://token.sensenova.cn/v1
# [4] OpenAI        → provider=openai,        base=https://api.openai.com/v1
# [5] Custom        → user provides name + base_url

# Apply via hermes CLI:
hermes config set model.default "$new_model"
hermes config set model.provider "$new_provider"
hermes config set model.base_url "$new_base"
```

## Role Model CRUD Functions

Three functions manage `vendor_models.json` entries (one JSON object per role with `primary`, `fallbacks[]`, `current` fields):

### model_role_add — Add a new role

```bash
# Flow:
# 1. Show existing roles (Python reads vendor_models.json)
# 2. Prompt for role name, primary model, fallback models
# 3. Validate: check duplicate name → offer overwrite
# 4. Build fallback list from comma-separated input
# 5. Confirm with YES
# 6. Write to vendor_models.json via Python + env vars
```

### model_role_edit — Edit an existing role

Sub-options (interactive after selecting role):
| # | Operation | JSON field affected |
|---|-----------|-------------------|
| 1 | Change primary model | `role.primary.model` |
| 2 | Change current model | `role.current` |
| 3 | Add fallback model | `role.fallbacks[].push` |
| 4 | Delete fallback by index | `role.fallbacks[].pop` |
| 5 | Toggle primary availability | `role.primary.available` = not available |

### model_role_delete — Delete a role

```bash
# Flow:
# 1. List all roles with index numbers
# 2. Read index, validate bounds (≥0 && < array length)
# 3. Confirm with YES
# 4. del d['rolename'] from JSON + write back
```

## Critical Technique: Safe Bash → Python JSON Passing

**Problem**: When bash interpolates a JSON string (from `json.dumps()`) into inline Python code, `true`/`false`/`null` are valid JSON but **not valid Python** — they cause `NameError: name 'true' is not defined`.

```bash
# ❌ WRONG — json.dumps output contains `true`/`false`, Python can't parse them
fallback_list=$(python3 -c "import json; print(json.dumps(items))")
python3 -c "
import json
d['role'] = { 'fallbacks': $fallback_list }   # ← NameError on 'true'!
"
```

**Fix**: Use `heredoc with single-quote delimiter` + `environment variable passing`:

```bash
# ✅ CORRECT — env vars preserve JSON exactly; 'PYEOF' prevents bash expansion
VENDOR_FILE="$VENDOR_FILE" \
  ROLE_NAME="$role_name" \
  FALLBACK_LIST="$fallback_list" \
  python3 << 'PYEOF' 2>/dev/null || { log_error "写入失败"; return; }
import json, os
vendor_file = os.environ['VENDOR_FILE']
role_name = os.environ['ROLE_NAME']
fallback_list = json.loads(os.environ['FALLBACK_LIST'])  # ← json.loads handles true/false

with open(vendor_file) as f:
    d = json.load(f)
d[role_name]['fallbacks'] = fallback_list
with open(vendor_file, 'w') as f:
    json.dump(d, f, ensure_ascii=False, indent=2)
PYEOF
```

**Why this works**:
- `'PYEOF'` (single-quote) prevents bash from expanding `$var` inside heredoc
- `VENDOR_FILE="..."` before command sets env vars scoped to that command only
- `json.loads()` correctly parses `true`/`false`/`null` from JSON
- No inline string interpolation = no injection risk from user-input model names

**Alternative** (if heredoc is inconvenient): pass via temp file, but env vars are cleaner for short data.

## Known Model Config (current environment)

- **Main model**: `deepseek-v4-flash` via custom provider `Token.sensenova.cn` at `https://token.sensenova.cn/v1`
- **Vision model**: `meta-llama/llama-3.2-11b-vision-instruct` via OpenRouter
- **Role models** (in `vendor_models.json`): 编程助手/视觉助手/写作助手/研究助手/数据助手 with primary+fallback structure
- **Credential pools**: copilot (1), token.sensenova.cn (2), nvidia (2)

## Pitfalls

1. **config.yaml empty string** — `base_url: ''` reads as `''` not empty. Always strip quotes: `sed "s/^'//;s/'$//"`
2. **API key scope** — The main model's `api_key` is in config.yaml as `model.api_key`, NOT in `.env`. Other providers (OpenRouter, NVIDIA) use env vars.
3. **Curl timeout** — Never omit `--max-time`. Default curl timeout is 10+ minutes on slow connections.
4. **`set -e` interaction** — Always add `|| true` after curl in scripts with `set -e`.
5. **vendor_models.json `_` prefixed keys** — The file has metadata keys `_comment`, `_note`, `_last_check`, `_api_error_note`. Always skip them with `if k.startswith('_'): continue`.
6. **Color code display** — ANSI escape codes don't render in Telegram. In bash scripts run from terminal they work fine. For cross-platform output, strip or use plain text.
7. **`true`/`false` JSON in embedded Python** — `json.dumps()` outputs JavaScript-style `true`/`false`/`null` which Python interprets as undefined variable names when the JSON string is interpolated directly into `python3 -c "..."`. **Always use heredoc `'PYEOF'` + env vars** when passing JSON from bash to Python (see "Critical Technique" section above).
8. **Role index for delete/edit** — When selecting a role to edit or delete, indices are 0-based. After add/delete operations, indices shift. Always display current list before selection. Bounds check: `[[ "$idx" -ge "${#array[@]}" ]]` catches out-of-range.