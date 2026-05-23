---
name: github-repo-monitor
description: GitHub 仓库自动化监控 - Issue/PR 动态监控 + Telegram 推送，支持多仓库分组管理
version: 1.0.0
author: 马丞相
metadata:
  tags: [github, monitoring, automation, cron, telegram]
  platforms: [linux]
---

# GitHub 仓库自动化监控系统

## 功能概述

监控多个 GitHub 仓库的 Issue 和 PR 动态，有更新时自动推送到 Telegram。

**核心能力：**
- 🌐 支持官方仓库 + 个人仓库分组监控
- 🆕 检测新 Issue 开放
- 💬 检测已关注 Issue 有新评论/更新
- 📊 断点续报：状态存储在本地文件，重启不丢失
- ⏰ 每2小时自动检查（可调整频率）

## 监控范围（当前配置）

| 分组 | 仓库 | 说明 |
|------|------|------|
| 官方 | `NousResearch/hermes-agent` | Hermes Agent 主仓库，15万 star，1.1万 open issues |
| 个人 | `zengbaocheng/*` | 主上自己的 20 个仓库 |

## 工作原理

```
每2小时 cron 触发
    ↓
脚本读取 ~/.hermes/.env 获取 GITHUB_TOKEN + TELEGRAM_BOT_TOKEN
    ↓
遍历所有仓库，查 GitHub API（/repos/{owner}/{repo}/issues?state=open）
    ↓
与 /tmp/github_issue_state.json 中的上次状态对比
    ↓
有新动态 → 拼装 HTML 消息 → 推送到 Telegram
    ↓
更新状态文件
```

## 添加/删除监控仓库

编辑 `~/.hermes/scripts/github_issue_monitor.py`，修改两个列表：

```python
# 【官方仓库】 需重点关注的仓库
OFFICIAL_REPOS = [
    "NousResearch/hermes-agent",
    # 添加更多...
]

# 【个人仓库】 自己的仓库
PERSONAL_REPOS = [
    "zengbaocheng/WorkerVless2sub",
    # 添加更多...
]
```

## 修改监控频率

编辑 cron job：
```
# 每小时一次
0 * * * *

# 每2小时一次（当前）
0 */2 * * *

# 每天早上8点
0 8 * * *
```

修改方式：
```bash
hermes cron edit <job_id> --schedule "0 */2 * * *"
```

## 手动触发检查

```bash
GITHUB_TOKEN=$(grep "^GITHUB_TOKEN=" ~/.hermes/.env | cut -d= -f2) \
  python3 ~/.hermes/scripts/github_issue_monitor.py
```

正常输出：`✅ 暂无新动态` 或 `✅ 已推送 | N 个仓库有动态`

## Telegram 推送格式

```
📋 GitHub Issue 动态
⏰ 05/17 00:00

📁 NousResearch/hermes-agent
🆕 #25568 [Bug] Shift+Enter triggers send instead of newline
   👤 sddgwj | 💬 2 | [type/bug]
   🔗 https://github.com/NousResearch/hermes-agent/issues/25568
```

## 文件路径

| 文件 | 作用 |
|------|------|
| `~/.hermes/scripts/github_issue_monitor.py` | 监控脚本 |
| `~/.hermes/.env` | 存放 GITHUB_TOKEN、TELEGRAM_BOT_TOKEN |
| `/tmp/github_issue_state.json` | 状态文件（断点续报） |

## 依赖

- `GITHUB_TOKEN`：GitHub Personal Access Token（需有 `repo` scope）
- `TELEGRAM_BOT_TOKEN`：Telegram Bot Token
- `TELEGRAM_HOME_CHANNEL`：Telegram 频道/用户 ID（默认 178274859）
- Python 3 标准库（无第三方依赖）

## 故障排查

### HTTP 451 某仓库返回 451
个别被 GitHub 限制的仓库会返回 451，不影响其他仓库监控，可忽略。

### TELEGRAM_BOT_TOKEN 未配置
确保 `.env` 中有 `TELEGRAM_BOT_TOKEN=xxx` 配置项。

### 一直报"有新动态"不停止
删除状态文件重置：`rm /tmp/github_issue_state.json`，下次运行会重新记录。

## 相关 Skills

- `github-auth`：GitHub 认证配置
- `github-issue-manager`：Issue 增删改查 + 自动分类
- `github-code-review`：PR 自动审查

## 参考资料

- `references/github-repo-monitor-setup.md` — 本次搭建记录（2026-05-16）