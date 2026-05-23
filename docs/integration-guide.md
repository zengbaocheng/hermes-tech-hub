# docs/integration-guide.md — 外部技术集成指南

# 🔗 Hermes Agent 外部技术集成指南

> 如何将 GitHub 上爬取的开源技术整合到 Hermes Agent 中，实现持续增强。

## 集成原则

1. **适配不替代** — 外部技术需要适配 Hermes 的技能体系（SKILL.md 格式）
2. **分层吸收** — 核心功能直接集成，辅助功能作为参考学习
3. **持续更新** — 追踪上游变化，及时同步优化

---

## 🧬 一、Hermes 核心生态集成

### 1.1 Self-Evolution 自我进化

**项目**: [Hermes Agent Self-Evolution](../vendors/hermes-ecosystem/hermes-self-evolution/README.md)

**价值**: 自动分析 Hermes Agent 的使用数据，优化技能、提示词和工作流配置。

**集成方法**:
```bash
# 克隆到本地
cd ~/projects
git clone https://github.com/NousResearch/hermes-agent-self-evolution.git

# 安装依赖（如有）
cd hermes-agent-self-evolution
pip install -r requirements.txt

# 配置定时优化任务
hermes cron create "0 3 * * 0" \
  --name "self-evolution" \
  --prompt "运行 self-evolution 分析上周使用数据，优化低效技能"
```

**优化对象**:
- 使用频率低但保留价值高的技能
- 频繁出错的工具调用模式
- 上下文压缩策略调优

### 1.2 Awesome Hermes Agent 资源导航

**项目**: [Awesome Hermes Agent](../vendors/hermes-ecosystem/awesome-hermes-agent/README.md)

**价值**: 持续追踪 Hermes 生态的最新技能、工具和集成方案。

**使用方法**:
```bash
# 定期同步精选列表
cd ~/projects
git clone https://github.com/0xNyk/awesome-hermes-agent.git

# 每周检查更新
cd awesome-hermes-agent && git pull

# 根据列表安装新技能
hermes skills install <skill-id-from-list>
```

### 1.3 Hermes Workspace / Web UI

**项目**: 
- [Hermes Workspace](../vendors/hermes-ecosystem/hermes-workspace/README.md) ⭐4,727
- [Hermes Web UI](../vendors/hermes-ecosystem/hermes-web-ui/README.md) ⭐5,811

**价值**: Web 端管理界面，可视化操作 Hermes。

**部署建议**:
```bash
# Workspace（功能更全）
git clone https://github.com/outsourc-e/hermes-workspace.git
cd hermes-workspace
docker compose up -d

# Web UI（更轻量）
git clone https://github.com/EKKOLearnAI/hermes-web-ui.git
cd hermes-web-ui
docker compose up -d
```

---

## 🎯 二、技能集合适配

### 2.1 Karpathy 技能适配

**项目**: [Karpathy Skills](../vendors/skills-collection/karpathy-skills/README.md) ⭐148,558

**价值**: Andrej Karpathy 的编码习惯提示词，提升代码质量。

**适配为 Hermes 技能**:
```bash
# 克隆项目
git clone https://github.com/multica-ai/andrej-karpathy-skills.git

# 将 CLAUDE.md 转换为 Hermes SKILL.md 格式
# 核心内容：代码审查标准、工程实践、调试方法
cp andrej-karpathy-skills/CLAUDE.md ~/.hermes/skills/karpathy-coding/SKILL.md
```

**核心适配内容**:
| CLAUDE.md 规则 | Hermes 技能映射 |
|---------------|----------------|
| 代码审查标准 | requesting-code-review 技能增强 |
| 调试方法论 | systematic-debugging 技能增强 |
| 工程最佳实践 | writing-plans / test-driven-development 增强 |

### 2.2 Superpowers 中文版

**项目**: [Superpowers 中文版](../vendors/skills-collection/superpowers-zh/README.md) ⭐3,799

**价值**: 6 个中文原创技能，特别适合中文场景的 AI 编程。

**集成方式**:
```bash
git clone https://github.com/jnMetaCode/superpowers-zh.git
cp -r superpowers-zh/skills/* ~/.hermes/skills/
```

**推荐优先使用的 3 个技能**:
1. **代码审查** — 中文代码审查标准
2. **架构设计** — 系统架构方案生成
3. **调试辅助** — 中文场景的 Bug 排查

### 2.3 SkillClaw 技能进化

**项目**: [SkillClaw](../vendors/skills-collection/skillclaw/README.md) ⭐1,438

**价值**: 自动化技能进化系统，让技能自我优化。

**集成方案**:
```bash
git clone https://github.com/AMAP-ML/SkillClaw.git
cd SkillClaw

# 分析现有技能使用数据
python evolver.py --analyze ~/.hermes/skills/

# 生成优化建议
python evolver.py --optimize --skill my-skill
```

---

## 🔌 三、MCP 服务器集成

### 3.1 FastAPI MCP

**项目**: [FastAPI MCP](../vendors/mcp-servers/fastapi-mcp/README.md) ⭐11,875

**价值**: 将自己部署的 FastAPI 服务暴露为 MCP 工具，让 Hermes 直接调用。

```bash
# 安装
pip install fastapi-mcp

# 在 FastAPI 应用中添加 MCP 端点
# 参见项目文档

# 在 Hermes 中注册
hermes mcp add my-api \
  --url http://localhost:8000/mcp \
  --description "自部署 API 的 MCP 接口"
```

### 3.2 MCP Use 框架

**项目**: [MCP Use](../vendors/mcp-servers/mcp-use/README.md) ⭐9,991

**价值**: 全栈 MCP 应用开发框架，快速构建 Hermes 可调用的工具。

```bash
npm install -g @mcp-use/cli

# 创建新的 MCP 服务器
mcp-use init my-tool
cd my-tool

# 开发完成后在 Hermes 中注册
hermes mcp add my-tool --command "node dist/index.js"
```

---

## 🧠 四、记忆系统集成

**项目**: [MemOS](../vendors/memory-systems/memos/README.md) ⭐9,351

**价值**: 为 LLM/AI Agent 设计的超持久记忆系统。

**与 Hermes 记忆系统的对比**:

| 特性 | Hermes 内置记忆 | MemOS |
|------|:--------------:|:-----:|
| 持久性 | 会话间持久 | 超持久 |
| 检索方式 | 语义搜索 | 混合检索（语义+关键词+图） |
| 自进化 | ❌ | ✅ |
| 集成复杂度 | 零配置 | 需部署 |

**集成建议**: 当需要更复杂的分层记忆（长期/中期/短期）时，将 MemOS 作为 Hermes 的辅助记忆后端。

---

## 📋 五、规划工作流适配

**项目**: [Planning with Files](../vendors/planning-workflows/planning-with-files/README.md) ⭐21,918

**价值**: Manus 风格的持久化 Markdown 规划系统。

**与 Hermes 现有规划系统的整合**:

```bash
# 将外部规划技能适配为 Hermes 格式
cat >> ~/.hermes/skills/external-planning/SKILL.md << 'EOF'
---
name: external-planning
description: "Manus 风格文件化规划 — 基于 Planning with Files 项目适配"
version: 1.0.0
---
# 核心模式：.plan/ 目录 + 步骤文件
1. 创建 .plan/<task-name>/ 目录
2. 每个步骤一个 .md 文件
3. 步骤文件包含：目标、状态、依赖、完成标准
EOF
```

---

## 🛠️ 六、管理工具部署

### 6.1 Control Room

**项目**: [Hermes Control Room](../vendors/management-tools/hermes-control-room/README.md) ⭐839

**价值**: 在多服务器场景下集中管理多个 Hermes 实例。

```bash
git clone https://github.com/CryptoDmitry/hermes-agent-control-room.git
cd hermes-agent-control-room
# 按照 README 配置 SSH 密钥和 agent 列表
./setup.sh
```

### 6.2 ClawPanel

**项目**: [ClawPanel](../vendors/management-tools/clawpanel/README.md) ⭐2,749

**价值**: 跨平台桌面管理面板，同时管理 Hermes Agent 和 OpenClaw。

```bash
# Tauri 应用，跨平台
git clone https://github.com/qingchencloud/clawpanel.git
cd clawpanel
npm install
npm run tauri dev
```

---

## 🔄 持续增强循环

```
1. 爬取 → 2. 学习 → 3. 适配 → 4. 集成 → 5. 沉淀 → (回到 1)
```

### 日常维护建议

| 频率 | 任务 |
|:----:|------|
| 每日 | 检查 awesome-hermes-agent 的新增项目 |
| 每周 | 拉取各项目更新，检查是否有可吸收的新功能 |
| 每月 | 评估集成效果，清理不再使用的技术 |
| 每季 | 更新 vendors README，标记各项目的使用状态 |

---

## 贡献指南

- 发现新的有价值项目 → 添加到 `vendors/` 对应分类
- 适配成功 → 更新集成指南 + 创建新技能
- 优化改进 → 给上游项目提 PR，回馈社区

---

*最后更新: 2026-05-23 | 覆盖 13 个外部项目*