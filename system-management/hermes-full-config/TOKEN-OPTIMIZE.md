---
name: token-optimize
description: Hermes Token 精细管控 - Tokscale监控、RTK压缩、Self-Evolution自动优化
version: 1.0.0
author: hermes-self-learner
metadata:
  tags: [token, cost, optimization, efficiency]
---

# Token 精细管控

## 效率与成本工具

| 工具 | 功能 | 效果 |
|------|------|------|
| Tokscale | Token 用量监控 | 实时查看全局消耗 |
| hermes-hudui | 成本拆解 | 按模型/组件/会话深度 |
| RTK | 终端输出压缩 | 减少60-90% Token |
| hermes-agent-self-evolution | 提示词自动优化 | 遗传算法优化 |

---

## Tokscale 安装与使用

专为 Hermes 等 AI 编码助手设计的 CLI 监控工具。

### 快速启动
```bash
# 推荐方式
npx tokscale@latest

# 或用 Bun（更轻量）
bunx tokscale@latest
```

### 使用命令
```bash
tokscale                  # 启动交互式 TUI（全局所有平台 Token 消耗总览）
tokscale --hermes         # 只看 Hermes Agent 的全局消耗
tokscale --hermes --week  # 过去7天 Hermes Token 趋势
tokscale --json           # JSON 导出全局数据
tokscale models           # 按模型统计 Token（含 Hermes）
```

---

## hermes-hudui 安装

支持按模型/组件/会话深度拆解 Token 成本、实时 WebSocket 更新。

### 安装
```bash
git clone https://github.com/joeynyc/hermes-hudui.git
cd hermes-hudui
./install.sh          # 自动安装 Python + Node 依赖
hermes-hudui          # 启动
```

### 访问
浏览器打开 http://localhost:3001（支持手机端）

---

## RTK（Rust Token Killer）

Rust 写的零依赖 CLI 代理，智能过滤/压缩终端输出，直接减少 60-90% Token。

### 安装

```bash
# Homebrew（最简单）
brew install rtk

# 一键脚本（Linux/macOS/Windows WSL）
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

### 集成到 Hermes
```bash
rtk init -g       # 安装全局 Hook + RTK.md（推荐）
```

---

## hermes-agent-self-evolution

用遗传算法自动优化 Agent 提示词和行为（DSPy + GEPA 遗传-帕累托进化算法），能自动优化 Skill、System Prompt、工具描述。

### 安装
```bash
git clone https://github.com/NousResearch/hermes-agent-self-evolution.git
cd hermes-agent-self-evolution
pip install -e ".[dev]"
```

---

## 汇报模板

安装完成后向主上汇报：
- Tokscale 监控状态
- hermes-hudui 访问地址
- RTK 集成状态
- Self-Evolution 优化状态

### 每日 Token 消耗报告
```
【Token 消耗报告】
⏰ 时间: YYYY-MM-DD

📊 全局消耗:
   - 今日: xxx Tokens / $xx
   - 本周: xxx Tokens / $xx

📈 趋势: [上升/下降] xx%

💡 优化建议:
   - [具体建议]

【报告完成】
```
