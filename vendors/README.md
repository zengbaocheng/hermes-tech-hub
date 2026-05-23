# vendors/README.md — 外部技术库

# 🌐 外部技术资源库

> 从 GitHub 爬取的与 Hermes Agent 生态相关的优秀开源项目。
> 包含学习笔记、集成指南和适配分析。

## 分类索引

### 🧬 Hermes 核心生态

| 项目 | ⭐ 星 | 说明 |
|------|:-----:|------|
| [Hermes Agent Self-Evolution](hermes-ecosystem/hermes-self-evolution/README.md) | 3,485 | Hermes Agent 自我进化系统 — 自动优化技能、提示词和工作流 |
| [Awesome Hermes Agent](hermes-ecosystem/awesome-hermes-agent/README.md) | 3,310 | Hermes Agent 精选资源大全 — 技能、工具、集成、最佳实践 |
| [Hermes Workspace](hermes-ecosystem/hermes-workspace/README.md) | 4,727 | Hermes Agent 原生 Web 工作台 — 聊天、终端、记忆、技能管理 |
| [Hermes Web UI](hermes-ecosystem/hermes-web-ui/README.md) | 5,811 | Hermes Agent Web 仪表盘 — 多平台 AI 聊天、会话管理 |

### 🎯 技能集合

| 项目 | ⭐ 星 | 说明 |
|------|:-----:|------|
| [Karpathy Skills](skills-collection/karpathy-skills/README.md) | 148,558 | Andrej Karpathy 风格的 CLAUDE.md 技能 — 顶级 AI 工程师的编码习惯 |
| [Superpowers 中文版](skills-collection/superpowers-zh/README.md) | 3,799 | AI 编程超能力中文增强版 — 6 个原创 skills，适配 Claude Code / Cursor |
| [SkillClaw](skills-collection/skillclaw/README.md) | 1,438 | 让技能集体进化 — 代理进化器，自动化技能优化 |

### 🔌 MCP 服务器

| 项目 | ⭐ 星 | 说明 |
|------|:-----:|------|
| [FastAPI MCP](mcp-servers/fastapi-mcp/README.md) | 11,875 | 将 FastAPI 端点暴露为 MCP 工具，支持认证 |
| [MCP Use](mcp-servers/mcp-use/README.md) | 9,991 | 全栈 MCP 框架 — 为 ChatGPT / Claude 开发 MCP 应用 |

### 🧠 记忆系统

| 项目 | ⭐ 星 | 说明 |
|------|:-----:|------|
| [MemOS](memory-systems/memos/README.md) | 9,351 | 自进化记忆操作系统 — 超持久记忆、混合检索，为 LLM & AI Agent 设计 |

### 📋 规划工作流

| 项目 | ⭐ 星 | 说明 |
|------|:-----:|------|
| [Planning with Files](planning-workflows/planning-with-files/README.md) | 21,918 | Manus 风格持久化 Markdown 规划 — Claude Code 技能，文件即规划 |

### 🛠️ 管理工具

| 项目 | ⭐ 星 | 说明 |
|------|:-----:|------|
| [Hermes Control Room](management-tools/hermes-control-room/README.md) | 839 | Hermes Agent 控制室 — 从单 VPS 管理多 agent 的模板 |
| [ClawPanel](management-tools/clawpanel/README.md) | 2,749 | OpenClaw & Hermes Agent 多引擎管理面板 — Tauri 跨平台桌面应用 |

## 💡 利用指南

本目录的项目可以通过以下方式发挥作用：

### 1️⃣ 直接集成
- **技能类** → 复制其 SKILL.md / CLAUDE.md 到 `~/.hermes/skills/`
- **MCP 类** → 通过 `hermes mcp add` 注册为 MCP 服务器
- **UI/面板** → 本地部署作为 Hermes 管理界面

### 2️⃣ 学习借鉴
- 阅读 README 了解项目的核心设计理念
- 将优秀的工作流/提示词/配置迁移到自己的 Hermes 环境
- 追踪高星项目的更新，紧跟生态发展趋势

### 3️⃣ 融合创新
- 把多个项目的优秀特性组合使用
- 将外部的 Skills 适配为 Hermes 格式的 SKILL.md
- 用自己的经验反向改进和 PR 到这些项目

---

*自动更新于 2026-05-23 | 共 13 个外部项目*