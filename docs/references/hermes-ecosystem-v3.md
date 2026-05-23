# 🔭 Hermes 生态扫描报告 V3.0

> 扫描时间: 2026-05-23 23:41
> 扫描范围: GitHub hermes-agent 关键词 + MCP 服务器 + 框架生态

---

## 📊 本轮新发现总览

| 序号 | 项目 | ⭐Stars | 类别 | 价值评级 |
|:----:|------|:------:|------|:--------:|
| 1 | **AionUi** (iOfficeAI/AionUi) | 26.2k | Hermes 原生桌面端 | ⭐⭐⭐⭐⭐ |
| 2 | **1Panel** (1Panel-dev/1Panel) | 35.6k | AI VPS 控制面板 | ⭐⭐⭐⭐⭐ |
| 3 | **LetsFG** (LetsFG/LetsFG) | 1.1k | MCP 航班搜索 | ⭐⭐⭐⭐ |
| 4 | **Scarf** (awizemann/scarf) | 524 | macOS/iOS Hermes 应用 | ⭐⭐⭐⭐ |
| 5 | **AnySearch MCP** | 512 | 统一搜索引擎 MCP | ⭐⭐⭐⭐ |
| 6 | **Kindly Web Search MCP** | 331 | Web 搜索 MCP | ⭐⭐⭐ |
| 7 | **ClawMem** (yoloshii/ClawMem) | 172 | 设备端记忆层 MCP | ⭐⭐⭐⭐ |
| 8 | **Shellward** (jnMetaCode/shellward) | 99 | AI 代理安全中间件 | ⭐⭐⭐ |
| 9 | **hermes-mcp** (mlennie/hermes-mcp) | 38 | Hermes → 任意 LLM 桥接 | ⭐⭐⭐ |
| 10 | **hermes-council** (Ridwannurudeen) | 29 | 对抗性多视角委员会 | ⭐⭐⭐ |
| 11 | **RemNote MCP** (robert7) | 11 | 知识库连接 MCP | ⭐⭐ |
| 12 | **Remote Device MCP** (beibei030) | 10 | 多设备协作 MCP | ⭐⭐ |
| 13 | **Token Scout** (jackccrawford) | 8 | 免费 LLM 模型发现 | ⭐⭐ |

---

## 🏆 重点项目详解

### 1️⃣ AionUi — 24/7 AI 同行桌面应用 (26.2k⭐)
- **GitHub**: [iOfficeAI/AionUi](https://github.com/iOfficeAI/AionUi)
- **语言**: TypeScript
- **标签**: chat, ai, skills, opencode, chatbot

**核心功能**：
- 免费、本地、开源 24/7 同行应用，支持 **Hermes Agent**、Claude Code、Codex、OpenCode、Gemini CLI 等 20+ CLI 工具
- 可定制的聊天、工作流、自动化
- 专为 AI CLI 代理设计的协作 UI

**对 Hermes 的价值**：
- 原生支持 Hermes Agent 作为后端代理
- 提供 24/7 运行的图形界面，扩展 Hermes 的使用场景
- 可作为 Hermes 的桌面前端选项

---

### 2️⃣ 1Panel — AI 原生 VPS 控制面板 (35.6k⭐)
- **GitHub**: [1Panel-dev/1Panel](https://github.com/1Panel-dev/1Panel)
- **语言**: Go + Vue (67.1% / 32.9%)
- **标签**: linux, agent, docker, hermes, ollama, hermes-agent

**核心功能**：
- 唯一原生支持 AI 代理运行时的 VPS 控制面板
- 一键部署 Ollama LLM 模型
- 运行 OpenClaw 个人代理
- 可视化 Docker 管理、165+ 应用市场
- 内置防火墙、fail2ban、WAF

**对 Hermes 的价值**：
- 直接标注 `hermes-agent` topic，第一生态位支持
- 提供 VPS 管理 + AI 代理一体化的运维方案
- 适合管理 Hermes 运行的基础设施

---

### 3️⃣ LetsFG — AI 代理原生航班搜索 (1.1k⭐)
- **GitHub**: [LetsFG/LetsFG](https://github.com/LetsFG/LetsFG)
- **语言**: Python 64.2% + TypeScript 26.9%
- **标签**: hermes, hermes-agent, mcp, ai-agents, openclaw

**核心功能**：
- 200+ 连接器并行搜索 400+ 航空公司
- 无加价、无追踪、无涨价
- 三种使用路径: CLI / MCP Server / Developer API
- 支持虚拟联运（不同航司组合往返）
- MCP 配置: `npx letsfg-mcp`

**对 Hermes 的价值**：
- 最佳 MCP Server 实战案例
- `SKILL.md` 标准遵循，可直接集成
- 展示了将真实世界服务封装为 AI 代理可调用的 MCP 模式的完整方法

---

### 4️⃣ Scarf — Hermes 原生 macOS/iOS 应用 (524⭐)
- **GitHub**: [awizemann/scarf](https://github.com/awizemann/scarf)
- **语言**: Swift
- **标签**: macos, swift, gui, terminal, hermes

**核心功能**：
- 原生 macOS 和 iOS 应用，专为 Hermes AI 代理设计
- 多窗口、多服务器（本地 + 远程 SSH）
- 聊天、仪表盘、会话、记忆管理

**对 Hermes 的价值**：
- 展示如何将 Hermes 嵌入原生桌面应用
- 支持远程 SSH 连接，适用于管理远程 Hermes 实例
- 移动端 (iOS) 扩展 Hermes 的使用场景

---

### 5️⃣ ClawMem — 设备端记忆层 (172⭐)
- **GitHub**: [yoloshii/ClawMem](https://github.com/yoloshii/ClawMem)
- **语言**: TypeScript
- **标签**: plugin, memory, sqlite, embeddings, mcp

**核心功能**：
- 设备端 AI 代理记忆层：支持 Claude Code、Hermes 和 OpenClaw
- Hooks + MCP Server + 混合 RAG 搜索
- 基于 SQLite + Embeddings 的本地记忆

**对 Hermes 的价值**：
- 可替代/补充 Hermes 内置的记忆系统
- MCP 集成模式可直接用于 Hermes
- 混合 RAG 搜索架构值得参考

---

### 6️⃣ Shellward — AI 代理安全中间件 (99⭐)
- **GitHub**: [jnMetaCode/shellward](https://github.com/jnMetaCode/shellward)
- **语言**: TypeScript
- **标签**: security, mcp, dlp, ai-safety

**核心功能**：
- 8 层防御体系
- DLP 数据流控制
- 提示注入检测
- 零依赖
- SDK + MCP Server

**对 Hermes 的价值**：
- 提供 AI 代理安全防护层
- 提示注入检测对任何 AI 代理系统都至关重要
- 8 层防御架构值得学习

---

## 🔁 交叉分析：模式与趋势

### 趋势 1: MCP Server 生态爆发
本轮发现 7 个 MCP 相关项目，说明 MCP 已成为 Hermes 生态扩展的标准方式：
| MCP 项目 | 功能 | 集成方式 |
|---------|------|---------|
| LetsFG | 航班搜索 | `npx letsfg-mcp` |
| AnySearch | 统一搜索 | npm/Python |
| Kindly Web Search | Web 搜索 | Python MCP |
| ClawMem | 设备记忆 | TypeScript MCP |
| Shellward | 安全中间件 | TypeScript MCP |
| hermes-mcp | Hermes 桥接 | Python MCP |
| RemNote | 知识库 | TypeScript MCP |

### 趋势 2: Hermes 的桌面化
- AionUi (26.2k⭐) — 跨平台桌面应用
- Scarf (524⭐) — macOS/iOS 原生应用
- 这两个项目让 Hermes 从纯 CLI 走向 GUI

### 趋势 3: AI 代理安全
- Shellward — 8 层防御，提示注入检测
- 随着 AI 代理越来越普及，安全成为刚需

### 趋势 4: 记忆系统多元化
- ClawMem (172⭐) — 设备端 MCP 记忆
- 与 claude-mem (77.6k⭐) 互补竞争
- Hermes 的 Hindsight Memory 可借鉴其混合 RAG 搜索

---

## 🔗 外部文档爬取状态

| 文档来源 | 状态 | 上次更新 |
|---------|:----:|:--------:|
| Hermes Skills Hub (691技能) | ✅ 已归档 | V2.0 |
| Hermes 架构文档 | ✅ 已归档 | V2.0 |
| Agent Loop 机制 | ✅ 已归档 | V2.0 |
| Agent Skills 规范 | ✅ 已归档 | V2.0 |
| Skills Hub 来源参考 | ✅ 已归档 | V2.0 |

---

## 📋 反哺技能建议

基于本轮扫描，建议创建以下技能：

| 技能名 | 来源项目 | 模式描述 | 优先级 |
|--------|---------|---------|:------:|
| `multi-agent-cowork-ui` | AionUi + Scarf | 多 AI 代理同事桌面 UI 模式 | 🔴 高 |
| `on-device-memory-mcp` | ClawMem | 设备端记忆 + MCP + 混合 RAG | 🟡 中 |
| `mcp-service-integration` | LetsFG + AnySearch | 真实世界服务封装为 MCP | 🟡 中 |
| `agent-security-layer` | Shellward | AI 代理安全中间件模式 | 🟢 低 |

---

## 📈 生态演化轨迹

```
Round 1 (前):  收集基础工具 (13 vendor 项目)
Round 2 (前):  收录核心项目 + 反哺 3 技能 (gbrain, codegraph, soul-governance)
Round 3 (本轮): 发现 13 新项目，覆盖 MCP 生态、桌面化、安全、记忆四大趋势
```

**累计生态覆盖**: 26 个独立项目 | 3 轮扫描 | 6 个反哺技能 | 114+ SKILL 技能

---

*报告由马丞相自动生成 | 2026-05-23*