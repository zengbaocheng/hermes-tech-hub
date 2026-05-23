# hermes-web-ui

> **来源**: [EKKOLearnAI/hermes-web-ui](https://github.com/EKKOLearnAI/hermes-web-ui)
> ⭐ 5811 | 🍴 737 | 📝 Web dashboard for Hermes Agent — multi-platform AI chat, session management, sch
> 🏷️  agent,ai-agent,chat-ui,dashboard,hermes | 📅 最后更新: 2026-05-23T12:14:13Z
> 🛠️  Language: TypeScript

## 概览

从 GitHub 爬取的外部项目，与 Hermes Agent 生态相关。

## 核心技术

<p align="center">
  <strong>Hermes Web UI</strong>
  <a href="./README_zh.md">中文</a>
</p>

<p align="center">
  A full-featured web dashboard for <a href="https://github.com/NousResearch/hermes-agent">Hermes Agent</a>.<br/>
  Manage AI chat sessions, monitor usage & costs, configure platform channels,<br/>
  schedule cron jobs, browse skills — all from a clean, responsive web interface.
</p>

<p align="center">
  <code>npm install -g hermes-web-ui && hermes-web-ui start</code>
</p>

<p align="center">
  <img src="https://github.com/EKKOLearnAI/hermes-web-ui/blob/main/packages/client/src/assets/image1.png" alt="Hermes Web UI Demo" width="680"/>
</p>

<p align="center">
  <img src="https://github.com/EKKOLearnAI/hermes-web-ui/blob/main/packages/client/src/assets/image2.png" alt="Hermes Web UI Demo" width="680"/>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/hermes-web-ui"><img src="https://img.shields.io/npm/v/hermes-web-ui?style=flat-square&color=blue" alt="npm version"/></a>
  <a href="https://github.com/EKKOLearnAI/hermes-web-ui/blob/main/LICENSE"><img src="https://img.shields.io/npm/l/hermes-web-ui?style=flat-square" alt="license"/></a>
  <a href="https://github.com/EKKOLearnAI/hermes-web-ui/stargazers"><img src="https://img.shields.io/github/stars/EKKOLearnAI/hermes-web-ui?style=flat-square" alt="stars"/></a>
</p>

---

## Features

### AI Chat

- Real-time chat streaming over Socket.IO `/chat-run`; chat runs execute through the Hermes agent bridge
- Multi-session management — create, rename, delete, switch between sessions
- **Self-built session database** — local SQLite storage for Web UI sessions; Hermes state.db remains a read-only source for Hermes history APIs
- Session grouping by source (Telegram, Discord, Slack, etc.) with collapsible accordion
- Active session indicator — live sessions pin to top with spinner icon
- Sessions sorted by latest message time
- Markdown rendering with syntax highlighting and code copy
- Tool call detail 

---

*自动爬取于 2026-05-23 | 完整仓库: [https://github.com/EKKOLearnAI/hermes-web-ui](https://github.com/EKKOLearnAI/hermes-web-ui)*
