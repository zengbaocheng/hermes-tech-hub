# docs/skills-guide.md

# 技能开发指南

## 技能结构规范

每个技能目录必须包含：

```
skill-name/
├── SKILL.md              # 主文件（必需）
├── references/           # 引用资料（可选）
├── templates/            # 模板文件（可选）
└── scripts/              # 脚本文件（可选）
```

## SKILL.md 前件规范

```yaml
---
name: skill-name                   # 小写+连字符，最长64字符
description: "简短描述"             # 一句话说明用途
version: 1.0.0                     # 语义化版本
author: 马丞相                     # 作者
platforms: [linux, macos]          # 支持平台
metadata:
  hermes:
    tags: [tag1, tag2]            # 分类标签
    related_skills: [skill-a]      # 相关技能
---
```

## 内容体规范

1. **环境检测** — 前置条件检查命令
2. **分步指南** — 编号步骤，包含完整命令
3. **故障排除** — 常见问题及解决
4. **验证步骤** — 确认成功的命令

## 高效技能 best practices

- 使用 `skill_view()` 先看已有技能再创建
- 写完复杂任务后主动提供保存技能
- 使用中发现遗漏立即用 `skill_manage(action='patch')` 更新
- 技能应自包含，不依赖其他技能的内部细节

## 版本管理

| 版本变化 | 说明 |
|---------|------|
| 主版本 | 重大重构，不兼容变化 |
| 次版本 | 新增功能，向后兼容 |
| 补丁 | 修复、优化、文档 |