# 🔭 Hermes 生态扫描报告 V3.0

> 扫描时间: 2026-05-30 05:00 (第三轮)
> 扫描范围: GitHub hermes-agent 搜索 + hermes agent framework 搜索 + 直接检查已有项目 Stars 变化

---

## 📊 扫描结果总览

| 指标 | 数值 |
|:----|:----:|
| 新发现项目 | 1 个 |
| 重大 Stars 跳增 | 5 个 |
| 已追踪项目总数 | 21 个 |
| 新创建技能 | 1 个 (nemoclaw-sandboxed-agents) |

---

## 🆕 本轮新发现项目

| 序号 | 项目 | ⭐Stars | 类别 | 价值评级 |
|:----:|------|:------:|------|:--------:|
| 1 | **NVIDIA/NemoClaw** | 20.7k | NVIDIA 官方沙箱化 AI 代理安全栈 | ⭐⭐⭐⭐⭐ |

### NVIDIA NemoClaw — NVIDIA 官方沙箱化 AI 代理安全栈

**Stars:** 20.7k ⭐ | **Forks:** 2.8k | **许可证:** Apache 2.0
**语言:** TypeScript 76.9%, Shell 17.9%, Python 1.8%
**提交数:** 1,893 | **发布标签:** 59

**描述:** NVIDIA NemoClaw 是用于在 OpenShell 沙箱中更安全地运行始终在线的 AI 代理的参考栈。它提供引导式上手、加固蓝图、路由推理、网络策略和生命周期管理，全部通过一个 CLI 控制。

**与 Hermes 的关联:** NemoClaw 将 Hermes Agent 作为一等公民原生支持！安装时设置 `NEMOCLAW_AGENT=hermes` 即可使用 `nemohermes` 别名。NVIDIA 官方文档有专门面向 Hermes 的快速入门指南。

**核心能力:**
- 代理沙箱安全隔离（OpenShell 容器引擎）
- 加固蓝图生命周期（构建 → 部署 → 销毁）
- 多供应商路由推理
- 网络策略（基线规则 + 操作员审批流程 + 出站控制）
- 安全态势配置（3 种姿态）
- CLI 单一入口管理

**对 Hermes 生态的价值:** 这是 NVIDIA 官方背书的 Hermes 安全运行时，解决了 Hermes 目前缺失的沙箱隔离、网络策略和生命周期管理问题。与 Hermes 的组合可以覆盖从`开发 → 安全运行 → 管理`的全链路。

**反哺技能:** [nemoclaw-sandboxed-agents](/home/zbc/.hermes/skills/security/nemoclaw-sandboxed-agents/SKILL.md)

---

## 🔄 已追踪项目 Stars 变化

| # | 项目 | 上一轮 Star | 本轮 Star | 变化 | 变化率 |
|:-:|------|:----------:|:---------:|:----:|:-----:|
| 1 | NousResearch/hermes-agent | 164k | **173k** | +9k | +5.5% |
| 2 | farion1231/cc-switch | 78.8k | **84.7k** | +5.9k | +7.5% |
| 3 | thedotmack/claude-mem | 77.6k | **79.6k** | +2k | +2.6% |
| 4 | nexu-io/open-design | 50.4k | **55.5k** | +5.1k | +10.1% |
| 5 | CherryHQ/cherry-studio | 46.2k | **46.6k** | +0.4k | +0.9% |
| 6 | 1Panel-dev/1Panel | 35.6k | **35.7k** | +0.1k | +0.3% |
| 7 | iOfficeAI/AionUi | 26.2k | **27.2k** | +1k | +3.8% |
| 8 | OthmanAdi/planning-with-files | 21.9k | **22.3k** | +0.4k | +1.8% |
| 9 | garrytan/gbrain | 18.4k | **19.8k** | +1.4k | +7.6% |
| 10 | colbymchenry/codegraph | 18.5k | **33.4k** | **+14.9k** | **+80.5%** 🔥 |
| 11 | NVIDIA/NemoClaw | NEW | **20.7k** | NEW | NEW |
| 12 | LetsFG/LetsFG | 1.1k | **1.1k** | — | — |
| 13 | awizemann/scarf | 524 | **524** | — | — |
| 14 | anysearch-ai/anysearch-mcp-server | 512 | **512** | — | — |
| 15 | Shelpuk-AI/kindly-web-search-mcp-server | 331 | **331** | — | — |
| 16 | yoloshii/ClawMem | 172 | **172** | — | — |
| 17 | jnMetaCode/shellward | 99 | **99** | — | — |
| 18 | mlennie/hermes-mcp | 38 | **38** | — | — |
| 19 | Ridwannurudeen/hermes-council | 29 | **29** | — | — |
| 20 | jangyuxue/hermes-soul-governance | 9 | **10** | +1 | +11.1% |

### Stars 增长亮点 🔥

- **colbymchenry/codegraph** 从 18.5k → 33.4k（+80.5%），实现了惊人的跳跃，可能是社区广泛采用 AI 代码理解工具的标志
- **NousResearch/hermes-agent** 从 164k → 173k（+9k），保持稳健增长
- **nexu-io/open-design** 从 50.4k → 55.5k（+10.1%），表现出强劲的增长趋势
- **garrytan/gbrain** 从 18.4k → 19.8k（+7.6%），作为 YC CEO 的个人项目继续受到关注
- **farion1231/cc-switch** 从 78.8k → 84.7k（+7.5%），接近 10 万 Star 门槛

---

## 🏆 生态重点项目详解

### V2 时期项目（持续追踪）

#### NousResearch/hermes-agent — 生态核心 (173k⭐)
Hermes Agent 自身增长稳健 +9k，社区持续活跃。

#### farion1231/cc-switch — MCP 头部项目 (84.7k⭐)
接近 10 万 ⭐，增长 5.9k，反映出开发者对 MCP 工具切换需求的强烈。

#### thedotmack/claude-mem — 记忆层先行者 (79.6k⭐)
增长 2k，继续稳居头部 AI 代理记忆系统。

#### nexu-io/open-design — 开源 UI 组件 (55.5k⭐)
+5.1k（+10.1%），推出 259+ 技能后社区反响强烈。

#### colbymchenry/codegraph — 代码图谱 (33.4k⭐)
**涨幅最大**，+14.9k（+80.5%），表明代码理解工具正被社区广泛采纳。已有 Hermes Agent 原生集成。

#### garrytan/gbrain — YC CEO 的个人大脑 (19.8k⭐)
+1.4k（+7.6%），现在支持团队版（公司大脑），增强多用户数据隔离。

### V3 本期亮点

#### NemoClaw — NVIDIA 官方安全沙箱 (20.7k⭐)
详见上方新发现项目章节。

---

## 📚 推荐技能列表

| 技能名 | 来源项目 | 说明 |
|:------|:--------|:-----|
| nemoclaw-sandboxed-agents | NVIDIA/NemoClaw | 在本轮创建，用于在 OpenShell 沙箱中安全运行 Hermes 代理 |

**V2 时期创建的技能**（已存在于技能库中）:
- agent-patterns (来自 gbrain 的 43 技能)
- autonomous-ai-agents (来自 AionUi Team Mode)
- on-device-memory-layer (来自 ClawMem)
- mcp-service-integration (来自 LetsFG + AnySearch MCP)
- hermes-soul-governance (来自 SOUL.md 规范)
- gbrain-patterns

---

## 📈 生态趋势分析

### 第三轮扫描观察

1. **NVIDIA 正式入场**: NemoClaw 将 Hermes 列为官方支持代理，标志着 NVIDIA 对 Hermes 的认可
2. **CodeGraph 爆发增长**: 80.5% 的增长说明代码图谱理解已成为 AI 代理的关键基础设施
3. **hermes-agent Stars 增长趋稳**: +5.5% 仍然健康，但增速放缓，处于成熟期
4. **NVIDIA OpenShell 生态**: NemoClaw + OpenShell + OpenClaw + Hermes 形成了 NVIDIA 主导的代理生态栈
5. **中等规模项目稳定**: MCP 服务和工具类项目（LetsFG, Scarf, AnySearch）Star 数保持不变，进入稳定期

### 并发趋势（持续有效）
- Web 搜索 + 知识检索成为基础 MCP 套件
- 本地设备端持久化记忆层成为差异化功能
- Shellward 8层安全防御代表 AI 代理安全的新方向
- 任务编排（Kanban 模式）在 AI 代理协作中价值凸显
- 代码质量提升工具（CodeRabbit）在 AI 代理管线中普及

### 下一轮建议扫描方向
1. **topic:web-search+mcp-server** — 搜索类 MCP 服务器生态
2. **topic:memory+mcp-server** — 记忆层 MCP 服务器
3. **topic:hermes-agent** 重试（上次被限流）
4. **GitHub Topics 扫描**: `topic:model-context-protocol` 按 Stars 排序，发现新的 MCP 服务器实现
5. **NVIDIA OpenShell 生态** — 新的 OpenShell 插件和扩展
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