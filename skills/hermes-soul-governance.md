---
name: hermes-soul-governance
description: SOUL.md（Structured Operating Unified Lifecycle）治理框架——技能生命周期管理、健康度监控、依赖关系追踪、覆盖率评估。
---

# SOUL.md 技能治理框架

> 出自 `jangyuxue/hermes-soul-governance`
> 为 Hermes Agent 提供体系化的技能治理能力

## SOUL.md 核心原则

SOUL.md = Structured Operating Unified Lifecycle

每个技能都应有一个 SOUL.md（或对应结构），覆盖完整生命周期：

```
创建 → 验证 → 发布 → 监控 → 弃用
         ↓
      健康度检查
         ↓
      覆盖率评估
```

## 实施方法

### 1. 技能健康度检查

对每个技能评估以下维度：

- **文档完整性** — 是否有 SKILL.md？包含触发条件、步骤、注意事项？
- **代码新鲜度** — 上次更新是否在 30 天内？引用的 API/工具是否已变更？
- **可用性** — 技能引用的命令/tool 是否仍可用？
- **依赖关系** — 技能依赖的其他技能是否健康？

### 2. 覆盖率监控

- 按领域统计技能覆盖情况（编程/视觉/写作/研究/数据…）
- 标记缺失技能的领域
- 当某个领域覆盖率低于阈值时，自动建议创建新技能

### 3. 依赖关系图

```
skills-devops/auto-file-cleanup
  → 依赖 skills-system/disk-space-monitor (健康)
  → 被 skills-automation/health-monitor 依赖

skills-automation/health-monitor  
  → 依赖 skills-vendor/vendor-model-manager (⚠️ 模型名可能变更)
  → 依赖 skills-devops/auto-file-cleanup (健康)
```

### 4. 新技能建议生成器

```
系统缺失检测 → 缺失功能描述 → 自动生成 SKILL.md 模板
                       ↓
                  主上审批 → 创建/调整
```

## 参考命令

```bash
# 列出所有技能及健康状态
hermes skills list --format=json | jq '.[] | {name, health}'

# 检查依赖关系（使用 skills-ref 工具）
skills-ref validate --show-deps

# 生成覆盖率报告
skills-ref coverage --format=markdown > coverage-report.md
```