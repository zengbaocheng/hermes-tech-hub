---
metadata:
  tags:
  - manual
  - guide
  - router
  - health-check
  version: 1.0.0
  author: 马丞相
description: 角色路由管理机制手动操作教程 - 健康检测、模型管理、定时任务修改指南
name: router-manual-guide
---
# 角色路由管理机制 - 手动操作教程

## 目录

1. [定时任务概览](#定时任务概览)
2. [健康检测手动操作](#健康检测手动操作)
3. [供应商模型管理手动操作](#供应商模型管理手动操作)
4. [修改定时任务时间](#修改定时任务时间)
5. [模型配置修改](#模型配置修改)
6. [常见问题处理](#常见问题处理)

---

## 定时任务概览

| 任务名称 | Cron表达式 | 执行时间 | 功能 |
|----------|------------|----------|------|
| 供应商模型管理 | `0 5 * * *` | 每天 5:00 | 清理失效模型、追踪失败次数 |
| 自动路由健康检测 | `0 7 * * *` | 每天 7:00 | 检测模型可用性、自动切换 |

### 查看所有定时任务

```bash
hermes cron list
```

---

## 健康检测手动操作

### Skill 名称
`router-health-monitor`

### 手动触发检测

加载 skill 后直接说：
```
"检测路由健康"
```

或使用终端命令：
```bash
# 触发健康检测 Cron Job（立即执行）
hermes cron run <job_id>

# 查看 job_id
hermes cron list
```

### 修改检测模型列表

编辑 Skill 文件：
```bash
vim ~/.hermes/skills/autonomous-ai-agents/router-health-monitor/SKILL.md
```

找到 `## 检测的角色模型` 部分，修改模型优先级：

```markdown
## 检测的角色模型（按免费优先排序）

| 角色 | 优先级1 | 优先级2 | 优先级3 |
|------|---------|---------|---------|
| 编程助手 | OpenCode | Codex | Claude Code |
| 视觉助手 | Qwen-VL | Llama-Vision | GPT-4o |
```

### 修改免费模型列表

在 Skill 文件中找到 `### 免费模型列表` 部分添加或修改：

```markdown
### 免费模型列表

- **新模型名**: 免费说明
- 例如: **deepseek-chat**: DeepSeek 免费 API 额度
```

---

## 供应商模型管理手动操作

### Skill 名称
`vendor-model-manager`

### 手动触发管理

加载 skill 后直接说：
```
"管理供应商模型"
```

### 查看当前模型状态

模型状态存储在：`~/.hermes/vendor_models.json`

```bash
# 查看状态文件
cat ~/.hermes/vendor_models.json

# 格式化查看
cat ~/.hermes/vendor_models.json | jq .
```

### 手动添加模型

编辑 `~/.hermes/vendor_models.json`：

```json
{
  "编程助手": [
    {"model": "opencode", "vendor": "OpenCode", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek", "vendor": "DeepSeek", "free": true, "available": true, "fail_count": 0}
  ]
}
```

字段说明：
- `model`: 模型标识符
- `vendor`: 供应商名称
- `free`: 是否免费 (true/false)
- `available`: 是否可用 (true/false)
- `fail_count`: 连续失败次数

### 手动删除模型

从 JSON 文件中移除对应模型的条目即可。

### 重置失败计数

将某个模型的 `fail_count` 设为 0：

```json
{"model": "claude-code", "fail_count": 0}
```

---

## 修改定时任务时间

### 方法1：使用命令行修改

```bash
# 修改供应商模型管理时间（5点 → 6点）
hermes cron edit <job_id>
# 然后按提示修改 schedule

# 例如修改为每天6点
schedule: "0 6 * * *"

# 例如修改为每3小时一次
schedule: "0 */3 * * *"
```

### 方法2：删除重建

```bash
# 1. 查看 job_id
hermes cron list

# 2. 删除旧任务
hermes cron remove <job_id>

# 3. 重新创建（参考下方命令）
```

### 创建新定时任务

```bash
# 健康检测 Cron Job
hermes cron create "0 7 * * *" \
  --name "自动路由健康检测" \
  --skill router-health-monitor,auto-router \
  --deliver weixin \
  --prompt "执行自动路由健康检测..."

# 供应商模型管理 Cron Job
hermes cron create "0 5 * * *" \
  --name "供应商模型管理" \
  --skill vendor-model-manager,auto-router \
  --deliver weixin \
  --prompt "执行供应商模型分类管理..."
```

### Cron 表达式参考

| 表达式 | 含义 |
|--------|------|
| `0 5 * * *` | 每天 5:00 |
| `0 7 * * *` | 每天 7:00 |
| `0 */3 * * *` | 每 3 小时 |
| `0 9,18 * * *` | 每天 9:00 和 18:00 |
| `0 5 * * 1-5` | 工作日 5:00 |
| `30 4 * * *` | 每天 4:30 |

---

## 模型配置修改

### 修改主模型

```bash
# 查看当前模型
hermes config get model.default

# 修改主模型
hermes config set model.default minimaxai/minimax-m2.5
```

### 修改辅助视觉模型

```bash
# 查看当前配置
hermes config get auxiliary.vision.model

# 修改视觉模型
hermes config set auxiliary.vision.model qwen/qwen2-vl-72b-instruct
```

### 修改代理模型（delegate_task）

在 Skill `auto-router` 中修改 `acp_command`：

```yaml
# 编程助手使用 Claude Code
delegate_task(acp_command="claude")

# 或使用 OpenCode
delegate_task(acp_command="opencode")

# 或使用 Codex
delegate_task(acp_command="codex")
```

---

## 常见问题处理

### 问题1：Cron Job 不执行

```bash
# 检查调度状态
hermes cron status

# 检查是否有错误
hermes cron list --all

# 手动运行测试
hermes cron run <job_id>
```

### 问题2：检测结果不准确

```bash
# 检查 API Key
hermes doctor

# 检查网络连接
curl -I https://api.openai.com
```

### 问题3：模型状态文件损坏

```bash
# 备份旧文件
cp ~/.hermes/vendor_models.json ~/.hermes/vendor_models.json.bak

# 重新初始化（删除文件，让系统自动重建）
rm ~/.hermes/vendor_models.json
```

### 问题4：需要强制删除某个模型

直接编辑 `~/.hermes/vendor_models.json`，将对应模型的 `available` 设为 `false`，或者直接删除该条目。

### 问题5：想禁用某个角色的自动路由

在 `auto-router` Skill 中注释掉该角色的触发词，或者将角色从列表中移除。

---

## 相关文件位置

| 文件 | 路径 |
|------|------|
| 健康检测 Skill | `~/.hermes/skills/autonomous-ai-agents/router-health-monitor/SKILL.md` |
| 供应商管理 Skill | `~/.hermes/skills/autonomous-ai-agents/vendor-model-manager/SKILL.md` |
| 自动路由 Skill | `~/.hermes/skills/autonomous-ai-agents/auto-router/SKILL.md` |
| 模型状态文件 | `~/.hermes/vendor_models.json` |
| Hermes 配置 | `~/.hermes/config.yaml` |
| API Keys | `~/.hermes/.env` |
| Cron 日志 | `~/.hermes/logs/cron.log` |

---

## 快速命令汇总

```bash
# 查看定时任务
hermes cron list

# 手动触发健康检测
hermes cron run <健康检测_job_id>

# 手动触发模型管理
hermes cron run <模型管理_job_id>

# 查看模型状态
cat ~/.hermes/vendor_models.json | jq .

# 修改检测时间
hermes cron edit <job_id>

# 删除定时任务
hermes cron remove <job_id>

# 检查 Hermes 状态
hermes doctor
```

---

## 联系支持

如遇复杂问题，请检查：
1. API Key 是否过期
2. 网络是否正常
3. 配置文件是否正确

必要时可重启 Hermes：
```bash
# 重启 gateway（如使用）
hermes gateway restart

# 或重新加载配置
hermes config check
```
