---
name: soul-memory-setup
description: Hermes 身份与记忆配置 - SOUL.md 角色定义 + Hindsight 长期记忆系统
version: 1.0.0
author: hermes-self-learner
metadata:
  tags: [soul, memory, persona, identity]
---

# 身份与记忆配置

## 第一部分：SOUL.md 角色定义

### 安装 agency-agents-zh 角色库

GitHub: https://github.com/jnMetaCode/agency-agents-zh

### 角色库内容
- 211 个中文角色模板
- 46 个中国市场原创智能体
- 18个部门分类（工程、设计、营销、产品、游戏、安全、金融、HR等）

### 使用方法
告诉 Hermes 激活哪个角色：
```
激活 [角色名称] 角色
```

---

## 第二部分：Hindsight 长期记忆

### 内置 MEMORY vs Hindsight

| 特性 | 内置 MEMORY | Hindsight |
|------|-------------|-----------|
| 写入机制 | 只有 Hermes 认为重要时才写入 | 自动从每轮对话提取实体、事实、关系、时间戳 |
| 容量上限 | ≈2200 字符（硬上限） | 无硬上限 |
| 知识组织 | 线性文本 | 知识图谱 |

### 安装步骤

1. 运行官方向导：
```bash
hermes memory setup
```
选择 hindsight，向导自动安装依赖、配置一切。

2. 获取 Hindsight API Key：
- 打开 https://ui.hindsight.vectorize.io/connect
- 注册/登录，生成 API Key（免费额度足够）

3. 验证是否生效：
```bash
hermes memory status
```
应显示 Hindsight 已激活，bank_id、auto-recall、auto-retain 等状态。

---

## 汇报模板

安装完成后向主上汇报：
- SOUL.md 角色库状态
- Hindsight 记忆系统状态
- 当前可用角色列表
