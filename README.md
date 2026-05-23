# 🧠 Hermes Tech Hub

> **Hermes Agent 技术增强中心** — 技能集合、配置管理、自动化运维、持续优化

本项目作为 **Hermes Agent** 生态系统的技术整合枢纽，汇集了自定义技能、配置方案、自动化工作流、脚本工具和文档体系，旨在持续增强 Hermes Agent 的能力边界。

## 📋 项目概览

```
hermes-tech-hub/
├── skills/              # 自定义技能集合（124个）
│   ├── autonomous-ai-agents/   # 自主AI代理技能
│   ├── devops/                 # DevOps 运维技能
│   ├── creative/               # 创意创作技能
│   ├── github/                 # GitHub 操作技能
│   ├── mlops/                  # ML 运维技能
│   ├── productivity/           # 生产力工具
│   ├── research/               # 研究技能
│   ├── software-development/   # 软件开发技能
│   └── ... 共24个分类
├── vendors/             # 外部技术库（爬取自GitHub）
│   ├── hermes-ecosystem/       # Hermes 核心生态
│   ├── skills-collection/      # 优质技能集合
│   ├── mcp-servers/            # MCP 服务器
│   ├── memory-systems/         # 记忆系统
│   ├── planning-workflows/     # 规划工作流
│   └── management-tools/       # 管理工具
├── configs/             # 配置方案与 Profile
│   ├── profiles/               # 多场景配置 Profile
│   └── examples/               # 配置示例
├── workflows/           # GitHub Actions 自动化
│   ├── skills-ci.yml           # 技能质量检查
│   └── health-monitor.yml      # 健康监控
├── scripts/             # 辅助脚本
│   ├── setup/                  # 环境安装脚本
│   └── tools/                  # 工具脚本
├── docs/                # 文档体系
│   ├── architecture.md         # 系统架构
│   ├── integration-guide.md    # 外部技术集成指南 🔥
│   ├── skills-guide.md         # 技能开发指南
│   └── changelog/              # 更新日志
└── plugins/             # 插件开发
```

## 🚀 分支策略

| 分支 | 用途 | 合并策略 |
|------|------|----------|
| `main` | 稳定基线，生产可用 | 保护分支，需 PR |
| `skills-dev` | 技能开发与迭代 | PR → main |
| `enhancements` | 功能增强实验 | PR → main |
| `automation-ci` | CI/CD 与自动化 | PR → main |

## 🎯 核心能力

### 1. 技能集合 (Skills)
- 高质量自定义技能，持续迭代优化
- 分类管理：自主代理、DevOps、创意、系统管理
- 自动质量检查与版本管理

### 2. 配置管理 (Configs)
- 多场景 Profile 配置（开发、运维、研究）
- 模型供应商配置方案
- 网关平台配置

### 3. 自动化运维 (Automation)
- GitHub Actions 自动化工作流
- 系统健康监控与告警
- 技能质量 CI/CD

### 4. 文档体系 (Docs)
- 架构文档
- 技能开发指南
- 故障排除手册

## 🔧 快速开始

```bash
# 克隆项目
git clone https://github.com/zengbaocheng/hermes-tech-hub.git
cd hermes-tech-hub

# 安装技能到 Hermes
# 方法一：直接复制 skill
cp -r skills/* ~/.hermes/skills/

# 方法二：通过 hermes skills 安装
# hermes skills install <skill-id>
```

## 🌐 外部技术爬取集成

本项目持续从 GitHub 爬取 Hermes Agent 生态的优秀项目，纳入 `vendors/` 目录：

| 分类 | 项目数 | 亮点 |
|:----|:-----:|------|
| 核心生态 | 4 | Self-Evolution、Workspace、Awesome List |
| 技能集合 | 3 | Karpathy Skills(⭐148k)、Superpowers-zh、SkillClaw |
| MCP 服务器 | 2 | FastAPI MCP(⭐11k)、MCP Use(⭐10k) |
| 记忆系统 | 1 | MemOS(⭐9k) — 超持久 Agent 记忆 |
| 规划工作流 | 1 | Planning with Files(⭐22k) — Manus 风格 |
| 管理工具 | 2 | Control Room、ClawPanel |

> 📖 详细集成指南: [docs/integration-guide.md](docs/integration-guide.md)
> 📦 完整外部库索引: [vendors/README.md](vendors/README.md)

## 🌱 持续增强

本项目采用 **"观察-实验-沉淀"** 的持续增强循环：

1. **观察**: 监控 Hermes 运行状态，发现优化点
2. **实验**: 在 enhancements 分支开发新功能
3. **沉淀**: 成熟的方案合并到 main，形成技能/配置/文档

## 📜 许可

MIT License

---

*Powered by Hermes Agent & 马丞相*