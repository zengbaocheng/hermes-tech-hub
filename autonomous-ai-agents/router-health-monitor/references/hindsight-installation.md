# Hindsight 客户端安装与故障排除

## 安装步骤

hindsight-client 包需要安装到 hermes-agent 的虚拟环境中：

```bash
# 1. 进入 hermes-agent venv
cd ~/.hermes/hermes-agent && source venv/bin/activate

# 2. 使用 uv 安装（推荐，比 pip 更可靠）
uv pip install hindsight-client

# 3. 验证安装
python3 -c "from hindsight_client import Hindsight; print('✅ 成功')"
```

## 故障排除

### 问题：No module named 'hindsight_client'

**原因**：hindsight-client 未安装

**排查**：
```bash
cd ~/.hermes/hermes-agent && source venv/bin/activate && pip list | grep hindsight
```

**解决**：
```bash
# 方法1：使用 uv（推荐）
uv pip install hindsight-client

# 方法2：使用 pip（可能需要 --break-system-packages）
pip3 install hindsight-client --break-system-packages
```

### 问题：hindsight_recall/reflect/retain 提示 "No module named 'hindsight_client'"

**原因**：包安装到了系统 Python 而非 hermes-agent venv

**验证当前环境**：
```bash
cd ~/.hermes/hermes-agent && source venv/bin/activate && python3 -c "import hindsight_client; print(hindsight_client.__version__)"
```

## 配置说明

| 配置项 | 位置 | 说明 |
|--------|------|------|
| API Key | `~/.hermes/.env` 的 `HINDSIGHT_API_KEY` | 自动读取，无需在 config.yaml 配置 |
| bank_id | `config.yaml` 的 `hindsight.bank_id` | 当前值：hermes |
| budget | `config.yaml` 的 `hindsight.budget` | 当前值：mid |

## 相关 Cron Job

- Hermes版本守护 (version-guard) - 使用 hindsight 记忆功能

## 官方资源

- API Key 获取：https://ui.hindsight.vectorize.io
- 文档：https://hindsight.so/