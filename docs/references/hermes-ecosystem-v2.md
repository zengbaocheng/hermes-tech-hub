# Hermes Agent 生态圈深度扫描（第二版）

> 扫描时间：2026-05-23
> 来源：GitHub 公开仓库
> 关键词：hermes-agent, hermes agent framework（按 Stars 降序）

---

## 概览

共发现 **8 个顶级 Hermes 生态相关项目**，Star 总数超 300K，覆盖以下领域：

- **记忆系统** — 跨会话持久化、智能感知
- **代码图谱** — 预索引知识图谱，大幅降低 Agent 调用成本
- **桌面 Launcher** — 一站式切换多 Agent CLIs
- **治理框架** — SOUL.md 技能治理与生命周期管理
- **Brain 系统** — 技能自动编排、知识图谱自连接
- **规划工具** — Manus 式持久化 Markdown 规划
- **设计工具** — 本地优先的 AI 设计替代方案
- **生产力工作室** — 300+ 预设技能

---

## 1. cc-switch — 跨平台桌面 All-in-One 助手切换器

- **仓库**: `farion1231/cc-switch`
- **Stars**: ⭐78,800
- **核心功能**: 跨平台桌面应用，为 Claude Code、Codex、OpenCode、OpenClaw、Gemini CLI 和 **Hermes Agent** 提供统一的一体化切换界面
- **对 Hermes 的价值**: 可以直接当作 Hermes Agent 的桌面前端，一键切换不同底层 Agent
- **关键亮点**:
  - 支持多 Agent CLI 的统一任务分派
  - 无需脱离当前环境切换模型
  - 适用于 Linux/macOS/Windows

---

## 2. claude-mem — 持久化上下文跨会话记忆系统

- **仓库**: `thedotmack/claude-mem`
- **Stars**: ⭐77,600
- **核心功能**: 自动捕捉 Agent 会话中的工具使用观察，AI 压缩后注入到未来会话，实现跨会话知识连续性。支持 Claude Code、OpenClaw、Codex、Gemini、**Hermes**、Copilot、OpenCode
- **对 Hermes 的价值**: 与 Hermes 内置的后见之明记忆系统互补，提供插件式替代方案
- **关键亮点**:
  - 5 个生命周期 Hook（SessionStart/UserPromptSubmit/PostToolUse/Stop/SessionEnd）
  - 3 层渐进式信息检索（搜索索引→时间线→完整详情），节省 10 倍 Token
  - MCP 搜索工具 + SQLite + Chroma 向量数据库混合检索
  - Web Viewer UI（localhost:37777）
  - 中文支持（内置 `code--zh` 模式）
  - `npx claude-mem install --ide gemini-cli` 单命令安装
  - 支持 OpenClaw 网关插件

---

## 3. open-design — 本地优先的开源 Claude Design 替代

- **仓库**: `nexu-io/open-design`
- **Stars**: ⭐50,300
- **核心功能**: 本地优先、开源设计工具，与 Hermes Agent 生态兼容
- **对 Hermes 的价值**: 可与 Hermes 的 `claude-design` skill 互补使用

---

## 4. cherry-studio — AI 生产力工作室

- **仓库**: `CherryHQ/cherry-studio`
- **Stars**: ⭐46,200
- **核心功能**: 智能聊天、自主 Agent、300+ 预设助手
- **对 Hermes 的价值**: 300+ 预设助手的 Skill 设计理念可借鉴到 Hermes 技能体系中

---

## 5. planning-with-files — Manus 风格持久化 Markdown 规划

- **仓库**: `OthmanAdi/planning-with-files`
- **Stars**: ⭐21,900
- **核心功能**: 通过持久化 Markdown 文件实现的 Manus 风格规划系统，适用于任何 Agent CLI，包括 Hermes Agent
- **对 Hermes 的价值**: 与 Hermes 的 `writing-plans` 和 `plan` skill 深度互补，提供更好的文件级规划持久化
- **关键亮点**:
  - 基于文件系统的规划持久化（非内存）
  - 跨 Agent CLI 兼容（Hermes, Claude Code, Codex 等）
  - 规划步骤可视化、可追溯

---

## 6. gbrain — Garry Tan 的 Agent Brain 系统

- **仓库**: `garrytan/gbrain`
- **Stars**: ⭐18,400
- **核心功能**: 为 OpenClaw 和 Hermes Agent 打造的 43 个技能的 Brain 系统，采用**自连接知识图谱**和**混合搜索**技术
- **对 Hermes 的价值**: **目前对 Hermes 生态价值最高的项目之一**
- **关键亮点**:
  - **43 个 Hermes 原生技能** — 包含搜索、记忆诊断、代码分析、Troves 收藏、项目上下文等
  - **自连接知识图谱** — 实体提取器自动从对话中提取实体，建立图谱边
  - **混合搜索** — 关键词 + 向量 + 图谱三重检索
  - **Troves 收藏系统** — 类似浏览器的书签，可收藏查询结果
  - **记忆诊断** — 主动检查记忆健康状态
  - **Planner 规划器** — 记忆感知型多步骤任务分解
  - **评估系统** — 消息评估、目标完成度评分
  - 配置文件位于 `~/.gbrain/config.yaml`
  - 数据目录 `~/.gbrain/data/`

---

## 7. codegraph — 预索引代码知识图谱 MCP

- **仓库**: `colbymchenry/codegraph`
- **Stars**: ⭐18,200
- **核心功能**: 通过预索引的知识图谱（SQLite + tree-sitter），让 Agent 直接查询代码结构，节省约 35% 成本、70% 工具调用
- **对 Hermes 的价值**: 可作为 Hermes Agent 的 MCP 工具，极大提升代码库探索效率
- **关键亮点**:
  - **基准测试结果**: 35% 更便宜、59% 更少 Token、49% 更快、70% 更少工具调用
  - **19+ 语言支持**: TypeScript, Python, Go, Rust, Java, C#, PHP, Ruby 等
  - **框架感知路由**: 识别 Django, Flask, FastAPI, Express, NestJS, Spring 等 14 个框架的路由模式
  - **100% 本地**: SQLite 数据库，无外部 API 调用
  - **自动同步**: OS 原生文件事件（FSEvents/inotify）+ 去抖自动同步
  - **MCP 工具集**: search, context, callers, callees, impact, node, explore, files, status
  - `curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh` 单命令安装
  - 支持 Hermes Agent 原生配置
  - `codegraph affected` 查找受变更影响的测试文件

---

## 8. hermes-soul-governance — SOUL.md 治理框架

- **仓库**: `jangyuxue/hermes-soul-governance`
- **Stars**: ⭐9
- **核心功能**: **SOUL.md**（Structured Operating Unified Lifecycle）治理框架，用于 Hermes Agent 的技能生命周期管理
- **对 Hermes 的价值**: **挖掘出 Hermes 技能治理的新范式**
- **关键亮点**:
  - SOUL.md 覆盖率监控 — 跟踪技能文档化率
  - 技能健康度检查 — 技能是否过时、损坏或需要更新
  - 技能依赖关系图 — 可视化技能之间的耦合
  - 建议新技能生成 — 基于系统缺失功能自动提出技能创建建议
  - 完整技能生命周期：创建 → 验证 → 发布 → 监控 → 弃用

---

## 整合建议

| 项目 | 优先级 | 整合方式 |
|------|--------|----------|
| **gbrain** | ⭐⭐⭐⭐⭐ | 直接克隆其 43 个技能到我们的技能库，学习自连接图谱模式 |
| **codegraph** | ⭐⭐⭐⭐⭐ | 安装为 MCP 工具，用于仓库自身的代码探索 |
| **claude-mem** | ⭐⭐⭐⭐ | 评估是否作为 Hermes 后见之明记忆的补充方案 |
| **cc-switch** | ⭐⭐⭐⭐ | 作为桌面入口，简化多 Agent 管理 |
| **planning-with-files** | ⭐⭐⭐ | 学习其文件级规划持久化模式 |
| **hermes-soul-governance** | ⭐⭐⭐ | 将 SOUL.md 理念引入我们的技能管理流程 |
| **cherry-studio** | ⭐⭐ | 借鉴 300+ 预设助手的设计思路 |
| **open-design** | ⭐⭐ | 作为设计类技能的可选补充 |