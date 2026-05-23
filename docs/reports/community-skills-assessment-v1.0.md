# 社区技能评估报告 v1.0

**日期**: 2026-05-23
**来源源**: [anthropics/skills](https://github.com/anthropics/skills) (140k ⭐)
**评估目标**: 筛选适合 Hermes Agent 环境的社区技能

---

## 评估结果

### Anthropic Skills (17 个)

| 技能 | 推荐 | 理由 |
|------|------|------|
| algorithmic-art | ❌ 已有替代 | 我们已有 `p5js`, `pixel-art`, `ascii-art` |
| brand-guidelines | ❌ 不相关 | 品牌规范指南，非 Hermes 场景 |
| canvas-design | ❌ 已有替代 | 我们已有 `sketch`, `claude-design` |
| claude-api | ❌ 已有替代 | 我们已有 `claude-code` |
| doc-coauthoring | ❌ 不相关 | 文档协作，非自动化场景 |
| docx | ❌ 已有替代 | 我们已有 `ocr-and-documents`, `nano-pdf` |
| frontend-design | ❌ 已有替代 | 我们已有 `sketch`, `claude-design` |
| internal-comms | ❌ 不相关 | 企业内部通讯 |
| **mcp-builder** | **✅ 推荐** | 创建 MCP 服务器 - 补充 `native-mcp`，有完整脚本和参考文档 |
| pdf | ❌ 已有替代 | 我们已有 `nano-pdf`, `ocr-and-documents` |
| pptx | ❌ 已有替代 | 我们已有 `powerpoint` |
| **skill-creator** | **✅ 推荐** | 创建技能的元技能 - 完善我们已有的 `hermes-agent-skill-authoring` |
| slack-gif-creator | ❌ 不相关 | Slack 专用，非本环境 |
| theme-factory | ❌ 不相关 | VS Code 主题创建 |
| web-artifacts-builder | ❌ 已有替代 | 我们已有 `hyperframes`, `pretext` |
| **webapp-testing** | **✅ 推荐** | 系统化 Web 应用测试 - 补充 `dogfood`，测试方法论更完整 |
| xlsx | ❌ 已有替代 | Excel 格式，非核心需求 |

### 推荐整合的技能 (3 个)

| 技能 | 仓库路径 | 理由 |
|------|----------|------|
| mcp-builder | `skills/mcp-builder/` | 含 `scripts/` 和 `reference/`，可直接移植 |
| skill-creator | `skills/skill-creator/` | 创建技能的规范指南 |
| webapp-testing | `skills/webapp-testing/` | 含 `examples/` 和 `scripts/`，Playwright 测试方法论 |

---

## 其他社区来源

### LobeHub (lobehub/lobe-chat-agents, 505 agents)

- **格式**: JSON 格式的 agent 提示词 → **非 SKILL.md 格式**，需要转换
- **适用性**: 低。这些是对话 agent 配置，非 Agent Skills 工作流
- **可考虑**: 挑选 10-20 个高星 agent，转为 Agent Skills 格式纳入

### 社区注册中心

根据 Hermes Skills Hub 数据：
- LobeHub: 505 技能 (JSON 格式)
- Smithery: MCP 服务目录
- Pulse: 任务模板
- Agent Skill Store: 付费技能市场

**建议**: 关注 LobeHub 的热门 agent，在后续迭代中选择性转换