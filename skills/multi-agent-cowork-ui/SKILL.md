---
name: multi-agent-cowork-ui
description: 多 AI 代理同事桌面 UI 模式 — 让 Hermes Agent 与其他 AI CLI 代理在统一桌面界面中协同工作
version: 1.0.0
categories:
  - autonomous-ai-agents
  - productivity
---

# 🖥️ 多 AI 代理同事桌面 UI 模式

## 概述
将多个 AI CLI 代理（Hermes Agent、Claude Code、Codex、OpenCode、Gemini CLI 等）集成到一个统一的桌面 UI 中，实现 24/7 协作工作模式。

**来源项目**: AionUi (26.2k⭐) · Scarf (524⭐)

## 核心架构

```
┌─────────────────────────────────────────┐
│          统一桌面 UI (AionUi/Scarf)      │
├────────────────┬────────────────────────┤
│ Hermes Agent   │ Claude Code / Codex    │
├────────────────┼────────────────────────┤
│ OpenCode       │ Gemini CLI / OpenClaw  │
├────────────────┴────────────────────────┤
│  跨代理会话管理 · 记忆共享 · 工作流编排   │
├─────────────────────────────────────────┤
│  24/7 后台运行 · 本地优先 · SSH 远程     │
└─────────────────────────────────────────┘
```

## 适用场景
- 需要同时使用多个 AI 代理工具的开发者
- 希望 24/7 后台运行 AI 代理的自动化需求
- 远程服务器上的 Hermes Agent 管理
- 跨代理的任务协调和结果比对

## 方案对比

| 特性 | AionUi (26.2k⭐) | Scarf (524⭐) | 纯终端 |
|:----|:---------------:|:------------:|:------:|
| 平台 | 跨平台 (Tauri) | macOS/iOS 原生 | 任何 |
| 24/7 运行 | ✅ | ✅ | ❌ (需 tmux) |
| 多代理切换 | ✅ (20+ CLI) | ✅ (Hermes 为主) | ✅ |
| 会话管理 | ✅ | ✅ | ❌ |
| 远程 SSH | ❌ | ✅ | ✅ |
| 原生通知 | ✅ | ✅ | ❌ |
| 适用语言 | TypeScript | Swift | 任何 |

## 安装配置

### AionUi（推荐，跨平台）
```bash
# 安装
git clone https://github.com/iOfficeAI/AionUi.git
cd AionUi
npm install

# 配置 Hermes Agent 支持
# 在 AionUi 设置中添加 Hermes CLI 路径
```

### Scarf（macOS/iOS）
```bash
# 通过 Homebrew 或 App Store 安装
# 配置 SSH 连接远程 Hermes 实例
```

## 核心功能模块

### 1. 代理管理
- 添加/移除 AI CLI 代理
- 每个代理独立会话
- 代理间消息转发

### 2. 会话持久化
- 自动保存会话历史
- 跨重启恢复
- 导出/导入会话

### 3. 远程连接
- SSH 隧道访问远程代理
- 多服务器管理
- 安全凭证管理

### 4. 工作流编排
- 跨代理任务链
- 结果汇总比对
- 自动重试/切换

## Hermes Agent 集成配置

在 AionUi 或类似 UI 中配置 Hermes：

```json
{
  "agents": {
    "hermes": {
      "name": "马丞相",
      "command": "hermes",
      "args": [],
      "workdir": "/home/zbc/.hermes/hermes-agent",
      "env": {
        "HERMES_HOME": "/home/zbc/.hermes"
      }
    }
  }
}
```

## 进阶模式

### 本地 + 远程混合
```
本地 Scarf UI → SSH → 远程 Hermes Agent
                → 本地 Claude Code
                → 远程 Codex
```

### 24/7 自动化工作站
```
[AionUi 常驻后台]
├── Hermes Agent（日常助手，异步任务）
├── Claude Code（代码审查，PR 管理）
└── Codex（自动化测试，CI/CD 监控）
```

## 注意事项
- AionUi 依赖 Tauri，需要系统 WebView 支持
- Scarf 仅限 Apple 生态（macOS 12+ / iOS 16+）
- 使用远程 SSH 时注意密钥管理和安全传输
- 多代理并发可能引起 token 消耗加速

## 参考项目
- [iOfficeAI/AionUi](https://github.com/iOfficeAI/AionUi) — 26.2k⭐ 跨平台同事桌面
- [awizemann/scarf](https://github.com/awizemann/scarf) — 524⭐ macOS/iOS Hermes 应用