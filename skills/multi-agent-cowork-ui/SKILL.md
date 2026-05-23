---
name: multi-agent-cowork-ui
description: 多 AI 代理同事桌面 UI 模式 — 让 Hermes Agent 与其他 AI CLI 代理在统一桌面界面中协同工作
version: 1.1.0
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
┌──────────────────────────────────────────────────┐
│              统一桌面 UI (AionUi)                  │
├──────────────────────────────────────────────────┤
│  ┌─────────── Single-Agent Mode ────────────┐    │
│  │  内置 Agent引擎 · 零配置启动 · 内置 20+ 助手   │    │
│  │  文件读写 · 网页搜索 · 图像生成 · MCP 工具    │    │
│  └──────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────── Multi-Agent Mode ─────────────┐     │
│  │  Auto-detect: Claude Code / Codex        │     │
│  │  / Hermes Agent / Qwen Code / OpenClaw   │     │
│  │  / Gemini CLI / Kiro + 16+ CLI agents    │     │
│  └──────────────────────────────────────────┘     │
│                                                     │
│  ┌─────────── Team Mode (AC Protocol) ─────┐      │
│  │  Leader → 任务分解 → Teammates (并行)     │     │
│  │  Teammate A (Claude Code) → 写代码       │     │
│  │  Teammate B (Codex) → 测试               │     │
│  │  Teammate C (Hermes) → 文档              │     │
│  │  ACP通信 · 异步信箱 · 共享工作区          │     │
│  └──────────────────────────────────────────┘     │
├──────────────────────────────────────────────────┤
│  聊天集成: Telegram / Lark / DingTalk / WeChat    │
│  定时任务: Cron · 固定间隔 · 一次触发              │
│  远程访问: WebUI · LAN · 密码/QR 登录              │
│  24/7 自动化 · 本地优先 · 跨平台(macOS/Win/Linux) │
└──────────────────────────────────────────────────┘
```

## 三大代理模式详解

### 🟢 Single-Agent Mode（内置代理）
- **零安装**：内置完整 Agent 引擎，无需额外安装 CLI
- **20+ 专业助手**：Cowork、PPT 创建、Word 文档、Excel 分析、Morph PPT 3D、Pitch Deck、Dashboard、学术论文、金融模型等
- **零配置**：用 Google 登录或用任意 API Key 即用

### 🟡 Multi-Agent Mode（多代理并行）
- **Auto-detect**：自动识别已安装的 CLI 工具
- **统一界面**：一个 Cowork 平台管理所有 AI 代理
- **并行会话**：多个代理独立上下文并发运行
- **MCP 统一管理**：一次配置 MCP 工具，自动同步到所有代理

### 🔴 Team Mode（团队协奏模式）
- **Leader 代理**：接收指令，分解为子任务，协调 Teammate
- **Teammate 代理**：并行执行子任务，各自独立模型
- **ACP 协议**：Agent Communication Protocol 层
- **共享工作区**：所有代理读写同一文件夹
- **异步信箱**：结果通过内置 Team MCP Server 同步
- **动态扩缩**：运行时添加/移除 Teammate，闲置代理自动回收

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

### 在 AionUi 中配置 Hermes

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

### Team Mode 配置（Leader + Teammate）

```json
{
  "team": {
    "leader": {
      "agent": "claude-code",
      "role": "架构与分解"
    },
    "teammates": [
      { "agent": "codex", "role": "编码实现" },
      { "agent": "hermes", "role": "文档测试" },
      { "agent": "qwen-code", "role": "前端开发" }
    ],
    "protocol": "acp",
    "shared_workspace": "./project",
    "mailbox": "async"
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