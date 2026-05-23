---
metadata:
  tags:
  - vendor
  - model-manager
  - auto-cleanup
  schedule: 0 5 * * *
  version: 1.0.0
  author: 马丞相
description: 供应商模型分类管理系统 - 按角色分类管理模型，连续失败自动删除，无可用时汇报授权
name: vendor-model-manager
---
# 供应商模型分类管理系统

## 功能概述

1. **模型分类**：按角色将供应商模型分类管理
2. **健康追踪**：记录每个模型连续失败次数
3. **自动清理**：连续2次检测失败自动从列表删除
4. **可用路由**：只调用当前可用的模型
5. **授权机制**：无可用模型时向主上汇报并请求授权

## 角色模型分类表

### ⚠️ 模型可用性 (2026年5月 OpenRouter 测试)

**永久不可用模型（不要使用）：**
- Claude 系列: 无 endpoint (404)
- GPT-4 系列: 地区限制 (403)
- Llama-3.2-Vision, Qwen-VL: 模型ID不存在
- sensenova-6.7-flash-lite: **不是有效的 OpenRouter 模型 ID** (HTTP 400: not a valid model ID)

**可用模型（2026年5月9日验证）：**
- microsoft/phi-4 ✓ (免费)
- meta-llama/llama-3.1-70b-instruct ✓ (免费)
- deepseek/deepseek-chat-v3 ✓
- deepseek/deepseek-r1 ✓
- deepseek-v4-flash ✓ (免费，Sensenova 代理)
- qwen/qwen-2.5-72b-instruct ✓ (免费，但有瞬时失败，需重试)
- minimax/minimax-01 ✓
- perplexity/sonar ✓ (免费)

**测试脚本位置**：`references/model-health-2026-05-09.md`

### 编程助手
| 模型 | 供应商 | 免费 | 状态 | 连续失败 |
|------|--------|------|------|----------|
| microsoft/phi-4 | Microsoft/OpenRouter | ✓ | 可用 | 0 |
| meta-llama/llama-3.1-70b-instruct | Meta/OpenRouter | ✓ | 可用 | 0 |
| deepseek/deepseek-chat-v3 | DeepSeek/OpenRouter | ✗ | 可用 | 0 |

### 视觉助手
| 模型 | 供应商 | 免费 | 状态 | 连续失败 |
|------|--------|------|------|----------|
| minimax/minimax-01 | Minimax/OpenRouter | ✗ | 可用 | 0 |
| ❌ 无免费VL模型 | — | — | — | — |

### 写作助手
| 模型 | 供应商 | 免费 | 状态 | 连续失败 |
|------|--------|------|------|----------|
| qwen/qwen-2.5-72b-instruct | Qwen/OpenRouter | ✓ | 可用 | 0 |
| deepseek/deepseek-chat-v3 | DeepSeek/OpenRouter | ✗ | 可用 | 0 |

### 研究助手
| 模型 | 供应商 | 免费 | 状态 | 连续失败 |
|------|--------|------|------|----------|
| perplexity/sonar | Perplexity/OpenRouter | ✓ | 可用 | 0 |
| deepseek/deepseek-r1 | DeepSeek/OpenRouter | ✗ | 可用 | 0 |

### 数据助手
| 模型 | 供应商 | 免费 | 状态 | 连续失败 |
|------|--------|------|------|----------|
| microsoft/phi-4 | Microsoft/OpenRouter | ✓ | 可用 | 0 |
| deepseek/deepseek-r1 | DeepSeek/OpenRouter | ✗ | 可用 | 0 |

## 运行逻辑

### 每日5点执行流程

```
┌─────────────────────────────────────────────────┐
│ 每日5点自动触发                                 │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│ 读取当前模型状态文件 (~/.hermes/vendor_models.json) │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│ 对每个角色按优先级检测模型                      │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│ 检测结果处理                                    │
│ - 成功: 重置 fail_count 为 0                    │
│ - 失败: fail_count +1                           │
│ - API不可达: 标记 fail_count=1 (非删除)         │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│ 检查连续失败次数                                │
│ - ≥2次: 从列表删除模型                          │
│ - <2次: 保留并继续检测                          │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│ 检查角色可用模型数量                            │
│ - >0: 更新状态文件                              │
│ - =0: 向主上汇报+请求授权                       │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│ 汇报结果给主上                                  │
└─────────────────────────────────────────────────┘
```

⚠️ **重要**：当 OpenRouter API 不可达时（超时/401等），fail_count 只会增加到 1，不会立即删除模型。只有连续 2 次检测失败才删除。这给了一次重试机会，避免因临时网络问题误删模型。

## 自动删除规则

- **触发条件**：同一模型连续2次健康检测失败
- **删除操作**：从对应角色的模型列表中移除
- **记录操作**：记录删除日志，包含删除原因
- **不可恢复**：删除后需手动重新添加（或通过主上授权）

## 汇报模板

### 正常情况（有可用模型）

```
【供应商模型管理报告】
⏰ 时间: YYYY-MM-DD 05:00

📊 模型状态:

💻 编程助手 (3个模型)
 - microsoft/phi-4: 可用 ✓
 - meta-llama/llama-3.1-70b-instruct: 可用 ✓
 - deepseek/deepseek-chat-v3: 可用 ✓

👁️ 视觉助手 (1个模型)
 - minimax/minimax-01: 可用 ✓

✍️ 写作助手 (2个模型)
 - qwen/qwen-2.5-72b-instruct: 可用 ✓
 - deepseek/deepseek-chat-v3: 可用 ✓

🔬 研究助手 (2个模型)
 - perplexity/sonar: 可用 ✓
 - deepseek/deepseek-r1: 可用 ✓

📊 数据助手 (2个模型)
 - microsoft/phi-4: 可用 ✓
 - deepseek/deepseek-r1: 可用 ✓

🔄 变更记录:
 - 无

【检测完成】
```

### 有模型被删除

```
【供应商模型管理报告】
⏰ 时间: YYYY-MM-DD 05:00

📊 模型状态:

💻 编程助手 (2个模型)
 - microsoft/phi-4: 可用 ✓
 - meta-llama/llama-3.1-70b-instruct: 可用 ✓
 ⚠️ deepseek/deepseek-chat-v3: 已删除 (连续2次检测失败)

👁️ 视觉助手 (1个模型)
 - minimax/minimax-01: 可用 ✓

🔄 变更记录:
 - 编程助手: 删除 deepseek/deepseek-chat-v3 (连接失败×2)

【检测完成】
```

### 紧急情况（无可用模型）

```
【⚠️ 紧急汇报 - 角色模型全部失效】

⏰ 时间: YYYY-MM-DD 05:00

❌ 视觉助手: 无可用模型
   - minimax/minimax-01 ✗ (删除: 连续2次失败)

❌ 写作助手: 无可用模型
   - qwen/qwen-2.5-72b-instruct ✗ (删除: 连续2次失败)
   - deepseek/deepseek-chat-v3 ✗ (删除: 连续2次失败)

📋 可选方案:

1. 添加新供应商模型
   - 方案A: 添加 microsoft/phi-4 (免费)
   - 方案B: 添加 meta-llama/llama-3.1-70b-instruct (免费)
   - 方案C: 检查 OPENROUTER_API_KEY 是否有效

2. 暂时使用主模型
   - 使用 minimax/m2.5 作为临时备选

请主上授权丞相执行哪个方案？
```

## 授权机制

当某个角色没有可用模型时：

1. **停止自动路由**：该角色不再被调用
2. **向主上汇报**：说明哪个角色缺少模型
3. **提供方案**：列出可选的新模型方案
4. **等待授权**：主上选择方案后执行
5. **更新配置**：添加新模型后继续运行

## 数据存储

模型状态存储在 `~/.hermes/vendor_models.json`（注意：必须使用 OpenRouter 模型 ID，不能使用 CLI 工具名称）：

```json
{
  "编程助手": [
    {"model": "microsoft/phi-4", "vendor": "Microsoft/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "meta-llama/llama-3.1-70b-instruct", "vendor": "Meta/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-chat-v3", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0}
  ],
  "视觉助手": [
    {"model": "minimax/minimax-01", "vendor": "Minimax/OpenRouter", "free": false, "available": true, "fail_count": 0}
  ],
  "写作助手": [
    {"model": "qwen/qwen-2.5-72b-instruct", "vendor": "Qwen/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-chat-v3", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0}
  ],
  "研究助手": [
    {"model": "perplexity/sonar", "vendor": "Perplexity/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-r1", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0}
  ],
  "数据助手": [
    {"model": "microsoft/phi-4", "vendor": "Microsoft/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-r1", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0}
  ]
}
```

⚠️ **常见错误**：不要使用 CLI 工具名称（如 `opencode`、`codex`、`claude-code`）作为 model 字段。这些是命令行工具的名称，不是 OpenRouter API 的模型 ID。正确格式示例：`microsoft/phi-4`、`deepseek/deepseek-r1`。

## 执行方式

1. **自动**: 每天5点 Cron Job 触发
2. **手动**: 加载 skill 后说"管理供应商模型"

## 故障排除

### ⚠️ 模型 ID 必须是 OpenRouter 格式，不能使用 CLI 工具名称

**问题现象**：健康检测时所有模型都失败，错误信息如：
```
HTTP 400: opencode is not a valid model ID
HTTP 400: codex is not a valid model ID
HTTP 400: claude-code is not a valid model ID
```

**根本原因**：误将 CLI 工具名称（opencode、codex、claude-code）当作 OpenRouter 模型 ID 使用。这些是命令行工具的名称，不是 OpenRouter API 的模型标识符。

**正确格式示例**：
- ✅ `microsoft/phi-4` (Microsoft 在 OpenRouter 上的模型)
- ✅ `deepseek/deepseek-r1` (DeepSeek 在 OpenRouter 上的模型)
- ✅ `qwen/qwen-2.5-72b-instruct` (Qwen 在 OpenRouter 上的模型)
- ❌ `opencode` (这是 CLI 工具名称，不是模型 ID)
- ❌ `codex` (这是 CLI 工具名称，不是模型 ID)
- ❌ `claude-code` (这是 CLI 工具名称，不是模型 ID)

**验证方法**：在 OpenRouter API 文档或 `https://openrouter.ai/models` 确认模型 ID 格式。

### WeChat 投递超时

**问题现象**：Cron Job 执行成功，但投递报告给 WeChat 时失败：
```
delivery error: Weixin send failed: Timeout context manager should be used inside a task
```

**解决方案**：将投递目标改为 Telegram：
```bash
hermes cron update <job_id> --deliver telegram:178274859
```

**已修复**：2026-05-07 已将自动路由健康检测和供应商模型管理的 deliver 从 WeChat 改为 Telegram

### Hindsight 记忆功能不可用

**问题现象**：`hindsight_recall` 失败，提示 `No module named 'hindsight_client'`

**排查步骤**：
1. 检查 hindsight-client 是否安装：
   ```bash
   cd ~/.hermes/hermes-agent && source venv/bin/activate && pip list | grep hindsight
   ```
2. 如果未安装，使用 uv 安装：
   ```bash
   cd ~/.hermes/hermes-agent && source venv/bin/activate && uv pip install hindsight-client
   ```

### OpenRouter API 401 认证错误

**问题现象**：健康检测时所有模型失败，错误信息：
```
HTTP 401: {"error":{"message":"Missing Authentication header","code":401}}
```

**排查步骤**：
1. 验证 API Key 有效性：
   ```bash
   curl -s --max-time 10 -X POST "https://openrouter.ai/api/v1/chat/completions" \
     -H "Authorization: Bearer $OPENROUTER_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"model":"microsoft/phi-4","messages":[{"role":"user","content":"test"}],"max_tokens":5}'
   ```

2. 检查 Key 是否过期或被撤销（在 OpenRouter Dashboard 查看）

3. **临时方案**：如果 OpenRouter API 不可用：
   - **不要手动删除模型** - fail_count 达到 2 才删除，给一次重试机会
   - 下次检测若成功，fail_count 自动重置为 0
   - 降级使用主模型 `minimax/m2.5` 作为临时备选

**详细排查记录**：`references/openrouter-api-issues-2026-05-10.md`

## 依赖

- 需要健康检测先执行（建议7点检测，5点清理）
- 需要写入 vendor_models.json 的权限
- 需要向主上发送消息的能力

## 参考文档

- `references/wechat-delivery-fix.md` - WeChat 投递超时问题解决方案
- `references/model-health-2026-05-09.md` - 2026年5月9日模型健康检测结果，包含实际测试数据
- `references/openrouter-api-issues-2026-05-10.md` - OpenRouter API 401认证错误排查记录
