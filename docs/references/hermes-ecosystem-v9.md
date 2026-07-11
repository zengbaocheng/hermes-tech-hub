# Hermes Agent 生态扫描报告 — 第九轮 (V9)

**扫描时间**: 2026-07-12 06:00 CST
**扫描工具**: gh CLI (GitHub API) — 全部成功，curl 脚本超时 (JSONDecodeError，如预期)
**扫描周期**: V8 (2026-07-05) → V9 (2026-07-12)，间隔 7 天
**已收录项目**: 27 个 (未变更)
**新发现候选项目**: 7 个 (新增 mindsdb/mindshub, xintaofei/codeg, EverMind-AI/Raven, itq5/OpenClaw-Admin, abundantbeing/hermes-browser-extension, freestylefly/wesight, stephenschoettler/hermes-lcm)

---

## 本轮新发现候选项目 (7 个)

| 序号 | 项目 | Stars | 类别 | 优先级 | 理由 |
|:----:|------|:-----:|:----:|:-----:|------|
| 1 | **mindsdb/mindshub** | ⭐39,397 | hermes-ecosystem | 🔴高 | topic:hermes-agent ✅, 39k⭐ 超大项目，Make AI do actual work |
| 2 | **xintaofei/codeg** | ⭐2,022 | hermes-ecosystem | 🟡中 | topic:hermes-agent ✅, 多 Agent 协作编码工作空间 |
| 3 | **EverMind-AI/Raven** | ⭐1,379 | hermes-ecosystem | 🟡中 | topic:hermes-agent ✅, EverOS 记忆优先 Agent 框架 |
| 4 | **itq5/OpenClaw-Admin** | ⭐837 | management-tools | 🟡中 | topic:hermes-agent ✅, OpenClaw+Hermes 管理面板 |
| 5 | **abundantbeing/hermes-browser-extension** | ⭐828 | hermes-ecosystem | 🟡中 | topic:hermes-agent ✅, 浏览器侧边栏插件 |
| 6 | **freestylefly/wesight** | ⭐762 | hermes-ecosystem | 🟡中 | topic:hermes-agent ✅, 开源桌面 AI Agent 工作空间 |
| 7 | **stephenschoettler/hermes-lcm** | ⭐847 | hermes-ecosystem | 🟡中 | 描述明确含 Hermes Agent, DAG 无损上下文引擎 |

### 已收录候选状态更新 (V8→V9)

| 项目 | V8 Stars | 当前 Stars | 增长 | 状态 |
|------|:--------:|:----------:|:----:|:----:|
| ruvnet/ruflo | ⭐63,179 | **64,031** | +852 🚀 | 无 hermes-agent topic，但描述含 Hermes |
| Mintplex-Labs/anything-llm | ⭐62,575 | **63,124** | +549 | topic:hermes-agent ✅，稳定增长 |
| screenpipe/screenpipe | ⭐19,642 | **19,766** | +124 | 稳定增长 |
| EverMind-AI/EverOS | ⭐10,234 | **10,803** | +569 🚀 (+5.6%) | 突破 10.8k⭐ |
| MervinPraison/PraisonAI | ⭐8,343 | **8,389** | +46 | 稳定 |
| ThinkInAIXYZ/deepchat | ⭐6,077 | **6,094** | +17 | 稳定 |
| liaohch3/claude-tap | ⭐2,346 | **2,460** | +114 ⬆️ | 突破 2.4k⭐ |
| eugeniughelbur/obsidian-second-brain | 未追踪 | **3,141** | 🆕 | 跨 CLI Obsidian 技能，无 hermes-agent topic |
| mnemosyne-oss/mnemosyne | ⭐1,385 | **1,495** | +110 | 稳定 |
| Jamailar/Beav | ⭐1,188 | **1,213** | +25 | 稳定 |
| NousResearch/autonovel | ⭐1,259 | **1,281** | +22 | 稳定 |
| ksimback/hermes-ecosystem | ⭐1,097 | **1,125** | +28 | 稳定 |
| NousResearch/hermes-paperclip-adapter | ⭐1,680 | **1,706** | +26 | 官方项目 |
| CryptoDmitry/hermes-agent-control-room | ⭐861 | **863** | +2 | 稳定 |
| Eynzof/Hermes-CN-Desktop | ⭐739 | **885** | +146 ⬆️ (+19.8%) | 高速增长，逼近 1k⭐ |

---

## 完整项目列表 (27 个已收录)

### hermes-ecosystem (25 个)

| 序号 | 项目 | V8 Stars | 当前 Stars | 增长 | 语言 | 说明 |
|:----:|------|:--------:|:----------:|:----:|:----:|------|
| 1 | NousResearch/hermes-agent | 209,162 | **213,243** | +4,081 🚀 | Python | 核心项目 |
| 2 | farion1231/cc-switch | 113,171 | **115,966** | +2,795 🚀 | Rust | 跨平台桌面助手 |
| 3 | thedotmack/claude-mem | 85,818 | **86,861** | +1,043 ⬆️ | JavaScript | Agent 持久上下文 |
| 4 | mem0ai/mem0 | 60,086 | **60,622** | +536 | Python | 通用 AI 记忆层 |
| 5 | nexu-io/open-design | 74,940 | **77,338** | +2,398 🚀 | TypeScript | 本地优先设计工具 |
| 6 | CherryHQ/cherry-studio | 48,157 | **48,451** | +294 | TypeScript | AI 生产力工作室 |
| 7 | 1Panel-dev/1Panel | 36,078 | **36,177** | +99 | Go | AI VPS 控制面板 |
| 8 | colbymchenry/codegraph | 57,523 | **59,265** | +1,742 🚀 | TypeScript | 代码知识图谱 |
| 9 | iOfficeAI/AionUi | 29,276 | **29,840** | +564 ⬆️ | TypeScript | 24/7 同行桌面应用 |
| 10 | OthmanAdi/planning-with-files | 24,496 | **25,204** | +708 ⬆️ | Python | Manus 式持久化规划 |
| 11 | NVIDIA/NemoClaw | 21,598 | **21,729** | +131 | TypeScript | NVIDIA 安全沙箱 |
| 12 | garrytan/gbrain | 25,005 | **25,907** | +902 ⬆️ | TypeScript | Agent 大脑知识图谱 |
| 13 | langbot-app/LangBot | 16,665 | **16,844** | +179 | Python | 多平台机器人 |
| 14 | jnMetaCode/agency-agents-zh | 16,598 | **17,127** | +529 | Shell | 266 专家角色 |
| 15 | nesquena/hermes-webui | 15,456 | **15,877** | +421 | Python | Web 端 Hermes |
| 16 | fathah/hermes-desktop | 13,071 | **13,262** | +191 | TypeScript | 桌面伴侣 |
| 17 | mnfst/manifest | 7,201 | **7,240** | +39 | TypeScript | 智能模型路由 |
| 18 | EKKOLearnAI/hermes-studio | 8,813 | **9,041** | +228 | TypeScript | Web 仪表盘 |
| 19 | Sylinko/Everywhere | 6,140 | **6,151** | +11 | C# | 桌面 AI 助手 |
| 20 | the-open-agent/openagent | 5,337 | **5,384** | +47 | Go | 个人 AI 助手 |
| 21 | outsourc-e/hermes-workspace | 5,956 | **6,033** | +77 | JavaScript | Web 工作空间 |
| 22 | alchaincyf/hermes-agent-orange-book | 4,606 | **4,629** | +23 | — | 橙皮书教程 |
| 23 | NousResearch/hermes-agent-self-evolution | 4,497 | **4,627** | +130 | Python | 自我进化 |
| 24 | 0xNyk/awesome-hermes-agent | 4,415 | **4,646** | +231 | — | 生态精选列表 |
| 25 | LetsFG/LetsFG | 1,248 | **1,534** | +286 ⬆️ | Python | MCP 航班搜索 |
| 26 | awizemann/scarf | 696 | **714** | +18 | Swift | macOS/iOS Hermes |
| 27 | yoloshii/ClawMem | 189 | **191** | +2 | TypeScript | 设备端记忆层 |

### skills-collection (2 个 — 已收录 + 新增候补)

| 序号 | 项目 | V8 Stars | 当前 Stars | 增长 | 语言 |
|:----:|------|:--------:|:----------:|:----:|:----:|
| 1 | jnMetaCode/superpowers-zh | 6,367 | **6,760** | +393 | JavaScript |
| 2 | wondelai/skills | 1,548 | **1,607** | +59 | Shell |

---

## 星标变化亮点 (V8 → V9, 间隔 7 天)

### 🚀 爆炸性增长 (>2k ⭐)

| 项目 | 增长量 | 增长率 |
|------|:-----:|:------:|
| NousResearch/hermes-agent | +4,081 | +2.0% |
| farion1231/cc-switch | +2,795 | +2.5% |
| nexu-io/open-design | +2,398 | +3.2% |
| colbymchenry/codegraph | +1,742 | +3.0% |

### ⬆️ 显著增长 (>500 ⭐)

| 项目 | 增长量 | 增长率 |
|------|:-----:|:------:|
| thedotmack/claude-mem | +1,043 | +1.2% |
| garrytan/gbrain | +902 | +3.6% |
| OthmanAdi/planning-with-files | +708 | +2.9% |
| iOfficeAI/AionUi | +564 | +1.9% |
| jnMetaCode/agency-agents-zh | +529 | +3.2% |
| mem0ai/mem0 | +536 | +0.9% |

### 🔊 候选项目亮点

| 项目 | 增长量 | 增长率 |
|------|:-----:|:------:|
| ruvnet/ruflo | **+852** | — |
| EverMind-AI/EverOS | **+569** | **+5.6%** 🚀 |
| Mintplex-Labs/anything-llm | +549 | +0.9% |
| Eynzof/Hermes-CN-Desktop | +146 | **+19.8%** 🚀 |
| liaohch3/claude-tap | +114 | +4.9% |

**增长亮点**: hermes-agent 核心突破 ⭐213k (+4,081/周)。cc-switch 逼近 116k。EverOS 突破 10.8k⭐ (+5.6%)。Hermes-CN-Desktop 暴增 19.8% 逼近 1k⭐。本轮新增 7 个候选项目，其中 mindsdb/mindshub (39k⭐) 是最大亮点。

---

## 生态趋势分析

1. **核心生态持续爆发**: 27 个已收录项目单周总增长约 17,300 ⭐，日均 2,470 ⭐
2. **7 个新候选项目**: 最大亮点 mindsdb/mindshub (39.4k⭐, topic:hermes-agent ✅)，标志性的大项目入局
3. **EverOS 生态分叉**: Raven (1.4k⭐, memory-first agent) 作为 EverOS 子项目出现，记忆层赛道持续细分
4. **桌面端增长**: Hermes-CN-Desktop (+19.8%) 高速增长，桌面端需求持续旺盛
5. **浏览器扩展新赛道**: abundantbeing/hermes-browser-extension (828⭐) 开辟了 Hermes 浏览器集成新方向
6. **管理面板拥挤**: OpenClaw-Admin (837⭐) + Hermes Control Room (863⭐) + ClawPanel (2.9k⭐) 三足鼎立
7. **DAG 上下文管理**: hermes-lcm (847⭐) 提出 DAG 无损上下文引擎，可能是下一代上下文管理方案

## 建议优先收录 (下一轮)

1. **mindsdb/mindshub** (39.4k⭐, topic:hermes-agent ✅) — **最高优先级**，超大项目首次发现
2. **EverMind-AI/EverOS** (10.8k⭐, +5.6%/周) — 持续高增长，建议正式收录
3. **Mintplex-Labs/anything-llm** (63.1k⭐, topic:hermes-agent ✅) — 大规模项目
4. **screenpipe/screenpipe** (19.8k⭐, topic:hermes-agent ✅, YC S26)
5. **xintaofei/codeg** (2.0k⭐, topic:hermes-agent ✅, 多 Agent 协作)
6. **eugeniughelbur/obsidian-second-brain** (3.1k⭐, 跨 CLI Obsidian 技能)
7. **Eynzof/Hermes-CN-Desktop** (885⭐, +19.8%/周)
8. **stephenschoettler/hermes-lcm** (847⭐, DAG 无损上下文)
9. **abundantbeing/hermes-browser-extension** (828⭐, 浏览器扩展)

---

## 扫描元数据

- **搜索覆盖**: 5 维 gh CLI 搜索 (hermes-agent, topic:hermes-agent, hermes agent, topic:mcp-server)
- **API 调用**: 70+ 次 gh api 调用 (27 已知项目 + 18 候选 + 7 新候选 + 额外验证)
- **工具状态**: gh CLI ✅ (完美工作), curl/脚本 ❌ (JSONDecodeError 超时，如预期)
- **新发现**: 7 个候选项目 (mindsdb/mindshub 39k⭐ 为最大亮点)
- **值得关注的非 topic 项目**: ruvnet/ruflo (64k⭐, Agent 元编排框架，描述含 Hermes)
- **CodeGraph 图谱**: 待同步