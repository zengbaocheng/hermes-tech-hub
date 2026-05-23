---
name: github-issue-manager
description: GitHub Issue 自动化管理 - 自然语言创建/查询/追踪 Issue，自动分类和状态更新
version: 1.0.0
author: 马丞相
metadata:
  tags: [github, issues, automation, project-management]
  platforms: [linux]
---

# GitHub Issue 自动化管理器

## 功能概述

1. **自然语言创建 Issue** - 一句话创建，AI 自动生成标题/正文/标签
2. **查询 Issue** - 按仓库/标签/状态/关键词搜索
3. **Issue 状态管理** - 添加标签、分配负责人、评论、关闭/重开
4. **自动化分类** - 创建时自动推荐合适的标签

## 前置条件

确保已配置 `GITHUB_TOKEN`（已在 ~/.hermes/.env 中）

## 使用方法

### 1. 创建 Issue

直接跟我说：
- "帮我在 xxx 仓库提一个 Issue，标题是 XXX，内容是 XXX"
- "帮我给 FREE-vpn 创建一个 bug 报告"
- "在 ecs 仓库提一个 Issue，建议添加 Xray 支持"

我会自动：
- 生成符合规范的标题和正文
- 推荐合适的 Label（bug/enhancement/question/documentation）
- 提交到 GitHub 并返回 Issue 链接

### 2. 查询 Issue

- "查看 FREE-vpn 所有 open 的 Issue"
- "列出所有仓库的 bug Issue"
- "搜索 FREE-vpn 里包含 'Xray' 的 Issue"

### 3. 管理 Issue

- "给 #12 添加 label: priority:high"
- "关闭 FREE-vpn 的 #8"
- "给 #15 添加评论：已修复"

## 技术实现（curl API）

```bash
OWNER="zengbaocheng"
GITHUB_TOKEN="从 ~/.hermes/.env 读取"

# 读取 token
export GITHUB_TOKEN=$(grep "^GITHUB_TOKEN=" ~/.hermes/.env | cut -d= -f2 | tr -d '\n\r')

# 列出 open issues
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$OWNER/$REPO/issues?state=open&per_page=50" \
  | python3 -c "
import sys,json
for i in json.load(sys.stdin):
    if 'pull_request' not in i:
        labels = ','.join(l['name'] for l in i['labels'])
        print(f\"#{i['number']} [{labels}] {i['title']}\")"

# 创建 Issue
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/$OWNER/$REPO/issues \
  -d '{
    "title": "标题",
    "body": "正文内容",
    "labels": ["bug", "enhancement"]
  }'

# 更新 Issue（添加标签/分配负责人）
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/$OWNER/$REPO/issues/$NUM/labels \
  -d '{"labels": ["priority:high"]}'

# 评论
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/$OWNER/$REPO/issues/$NUM/comments \
  -d '{"body": "评论内容"}'

# 关闭 Issue
curl -s -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/$OWNER/$REPO/issues/$NUM \
  -d '{"state": "closed", "state_reason": "completed"}'
```

## 支持的仓库列表

- zengbaocheng/WorkerVless2sub
- zengbaocheng/ecs
- zengbaocheng/one-click-installation-script
- zengbaocheng/openclash-auto-installer
- zengbaocheng/FREE-vpn
- zengbaocheng/WechatMoments
- zengbaocheng/ech-wk
- zengbaocheng/chaiwiki
- zengbaocheng/Hackintosh
- zengbaocheng/free-vps-py
- zengbaocheng/free111
- zengbaocheng/sublink-worker
- zengbaocheng/certimate
- zengbaocheng/epeius
- zengbaocheng/wkyggj
- zengbaocheng/wkyOpenWrt
- zengbaocheng/dd
- zengbaocheng/Network-Reinstall-System-Modify
- zengbaocheng/billd-desk
- zengbaocheng/Umi-OCR

## 标签规范

| 标签 | 用途 |
|------|------|
| bug | Bug 报告 |
| enhancement | 功能增强 |
| question | 问题咨询 |
| documentation | 文档改进 |
| priority:high | 高优先级 |
| priority:low | 低优先级 |
| help wanted | 需要帮助 |
| good first issue | 适合新手 |

## 常见 Issue 模板

### Bug 报告
```
## 问题描述
[简述问题]

## 复现步骤
1.
2.

## 预期行为
[应该怎样]

## 实际行为
[实际怎样]

## 环境
- 系统:
- 版本:
```

### 功能建议
```
## 功能描述
[想要什么功能]

## 使用场景
[什么情况下需要]

## 建议的实现方式
[如果有想法]
```

## 自动化监控

已有 cron job 每 2 小时自动检查所有仓库的新 Issue，发现新动态时推送到 Telegram。

**监控脚本**：`~/.hermes/scripts/github_issue_monitor.py`

当前监控的仓库分组：
- **官方仓库**：`NousResearch/hermes-agent`
- **个人仓库**：`zengbaocheng/*`（20个仓库）

如需添加/删除监控仓库，编辑脚本中的 `OFFICIAL_REPOS` 和 `PERSONAL_REPOS` 列表。

**触发条件**：
- 🆕 有新 Issue 开放
- 💬 已关注 Issue 有新评论（comments 数量增加）

**状态文件**：`/tmp/github_issue_state.json`（记录每个仓库各 Issue 的 comments 数和更新时间，断点续报）

**手动触发测试**：
```bash
GITHUB_TOKEN=$(grep "^GITHUB_TOKEN=" ~/.hermes/.env | cut -d= -f2) \
  python3 ~/.hermes/scripts/github_issue_monitor.py
```