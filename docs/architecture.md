# docs/architecture.md

# Hermes Tech Hub 系统架构

## 整体架构

```
┌──────────────────────────────────────────────────────────────┐
│                     Hermes Tech Hub                          │
├──────────────────────────────────────────────────────────────┤
│  Skills Layer    │  Config Layer    │  Automation Layer      │
├──────────────────┼──────────────────┼────────────────────────┤
│ • 自主AI代理技能   │ • Profile管理    │ • GitHub Actions       │
│ • DevOps技能      │ • 模型供应商配置   │ • 健康监控             │
│ • 创意技能        │ • 网关平台配置    │ • 技能CI/CD           │
│ • 系统管理技能     │ • 环境变量模板    │ • 定时任务             │
├──────────────────┴──────────────────┴────────────────────────┤
│                     Docs Layer                               │
│           架构文档 / 开发指南 / 故障排除 / 更新日志            │
└──────────────────────────────────────────────────────────────┘
```

## 技能架构

每个技能遵循标准 SKILL.md 格式：

```yaml
---
name: skill-name
description: "技能描述"
version: 1.0.0
author: 马丞相
platforms: [linux, macos]
metadata:
  hermes:
    tags: [tag1, tag2]
    related_skills: [skill-a, skill-b]
---

# 内容体

## 环境检测
## 步骤
## 故障排除
```

## 分支工作流

```
main (稳定) ←── PR ── skills-dev (技能迭代)
main (稳定) ←── PR ── enhancements (功能增强)
main (稳定) ←── PR ── automation-ci (自动化)
```

## 持续增强循环

```
观察 (Observe) ──→ 实验 (Experiment) ──→ 沉淀 (Solidify)
      ↑                                         │
      └─────────────────────────────────────────┘
```