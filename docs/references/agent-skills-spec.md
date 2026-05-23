# Agent Skills 规范参考

> 来源: https://agentskills.io/specification
> 官方技能市场: https://agentskills.io (由 Anthropic 发起)

## 目录结构
```
skill-name/
├── SKILL.md          # 必需：元数据 + 指令
├── scripts/          # 可选：可执行代码
├── references/       # 可选：参考文档
├── assets/           # 可选：模板、资源
└── ...               # 额外文件
```

## SKILL.md 格式

### 必需字段
- name: 1-64字符，小写字母+数字+连字符
- description: 1-1024字符，说明做什么和何时使用

### 可选字段
- license: 许可协议
- compatibility: 兼容性说明（<500字符）
- metadata: 自定义键值对
- allowed-tools: 预批准工具列表（实验性）

### 渐进式加载
1. 元数据 (~100 tokens) — 启动时加载所有技能的name和description
2. 指令 (<5000 tokens推荐) — 激活时加载完整SKILL.md
3. 资源 (按需) — 需要时才加载脚本/参考文件

## 最佳实践
1. 从实际经验出发 — 完成真实任务后提取技能
2. 通过实际运行优化 — 第一次草稿通常需要打磨
3. 明智使用上下文 — 只添加代理不知道的信息
4. 提供默认值，不提供菜单 — 选择默认工具
5. 用流程优于声明 — 教方法而非给答案
6. Gotchas 章节 — 记录环境特定的坑
7. 模板化输出格式 — 提供具体模板
8. 验证循环 — 先验证再提交
9. Plan-Validate-Execute — 批量操作先规划验证

## 验证工具
```bash
skills-ref validate ./my-skill
```

文档来源: https://agentskills.io
