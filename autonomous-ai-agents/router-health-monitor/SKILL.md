---
name: router-health-monitor
description: 角色路由健康监控系统 - 深夜检测各角色模型可用性，失效时自动切换主备模型，汇报结果给主上
version: 2.0.0
author: 马丞相
metadata:
  tags: [health-monitor, router, auto-fallback, nightly]
  schedule: "0 3 * * *"  # 每天深夜3点
---

# 角色路由健康监控系统 v2.0

## 功能概述

1. **深夜健康检测**：每天深夜3点自动检测各角色模型可用性
2. **主备模型管理**：每个角色配置主模型+备用模型，失效自动切换
3. **免费优先原则**：优先使用免费模型，备用付费模型
4. **主上汇报**：检测结果和切换记录汇报给主上

## 角色模型配置（主+备模式）

### 编程助手
- 主模型: `meta-llama/llama-3.1-8b-instruct` (免费)
- 备用1: `deepseek/deepseek-chat-v3` (低成本)
- 备用2: `microsoft/phi-4` (免费，待确认)

### 视觉助手
- 主模型: `meta-llama/llama-3.2-11b-vision-instruct` (免费)
- 备用1: `minimax/minimax-01` (付费)

### 写作助手
- 主模型: `deepseek/deepseek-chat-v3` (低成本)
- 备用1: `meta-llama/llama-3.1-8b-instruct` (免费)

### 研究助手
- 主模型: `deepseek/deepseek-r1` (低成本)
- 备用1: `deepseek/deepseek-chat-v3` (低成本)

### 数据助手
- 主模型: `meta-llama/llama-3.1-8b-instruct` (免费)
- 备用1: `deepseek/deepseek-chat-v3` (低成本)
- 备用2: `deepseek/deepseek-r1` (低成本)

## 检测逻辑

```
开始深夜检测 → 遍历所有角色

对每个角色:
  1. 检测主模型 → 可用? → 标记正常 → next role
                ↓ 不可用
  2. 尝试备用1 → 可用? → 切换 + 记录 → next role
                ↓ 不可用
  3. 尝试备用2 → 可用? → 切换 + 记录 → next role
                ↓ 不可用
  4. 标记"全部失效" → 记录紧急

检测完成 → 更新 vendor_models.json → 向主上汇报
```

## 自动切换规则

| 错误类型 | 处理方式 |
|---------|---------|
| 连接超时 | 切换备用模型，重试3次 |
| 认证失败 (401) | 切换备用模型 |
| 额度不足 (429) | 切换备用模型 |
| 服务不可用 (503) | 切换备用模型 |
| Internal Server Error | 切换备用模型 |

## 检测方法

1. **API 连接测试**：发送简单查询验证响应
2. **错误识别**：超时、认证失败、额度不足等
3. **状态更新**：更新 fail_count 和 available 状态

## 汇报模板

### 全部正常
```
【深夜路由健康检测报告】 🌙
⏰ 检测时间: YYYY-MM-DD 03:00

✅ 正常角色 (5/5):
• 编程助手: llama-3.1-8b ✓ (主)
• 视觉助手: llama-3.2-11b-vision ✓ (主)
• 写作助手: deepseek-chat-v3 ✓ (主)
• 研究助手: deepseek-r1 ✓ (主)
• 数据助手: llama-3.1-8b ✓ (主)

🔄 切换记录: 无

【检测完成】所有角色运行正常
```

### 有切换
```
【深夜路由健康检测报告】 🌙
⏰ 检测时间: YYYY-MM-DD 03:00

✅ 正常角色 (4/5):
• 编程助手: deepseek-chat-v3 ✓ (备用切换)
• 视觉助手: llama-3.2-11b-vision ✓ (主)
• 写作助手: deepseek-chat-v3 ✓ (主)
• 数据助手: llama-3.1-8b ✓ (主)

⚠️ 需关注:
• 研究助手: 主模型失效 → 已切换至备用 deepseek-chat-v3

🔄 切换记录:
• 研究助手: deepseek-r1 → deepseek-chat-v3 (主模型无响应)

【检测完成】已自动切换，请留意
```

### 紧急情况
```
【紧急汇报 - 角色模型全部失效】 🚨
⏰ 检测时间: YYYY-MM-DD 03:00

❌ 研究助手: 
  • deepseek-r1 ✗ (服务不可用)
  • deepseek-chat-v3 ✗ (服务不可用)
  
  建议: 检查网络或 OpenRouter API 状态

【需要主上处理】
```

## 执行方式

1. **自动触发**: Cron Job 每天深夜3点
2. **手动触发**: 加载 skill 后说"检测路由健康"

## 故障排除

### OpenRouter 500 错误诊断流程

**关键判断**: 如果所有模型同时返回500错误 → 极可能是OpenRouter服务端问题，而非模型问题

诊断思路：
1. 先测试 openrouter.ai 域名可达性（ping/curl）
2. 再测试 /api/v1/models 返回是否正常（验证 Key 有效）
3. 最后测试 /api/v1/chat/completions 是否返回 500（服务端故障）

**实测案例 (2026-05-13)**:
- openrouter.ai API 端点可达
- /api/v1/models 返回完整模型列表
- /api/v1/chat/completions 所有模型均返回 500
- **结论**: OpenRouter 服务端故障，等待恢复即可

### OpenRouter 500 错误
- 等待30秒后重试
- 减少并发检测数量
- 错峰执行

### 检测失败
1. 检查网络连接
2. 检查 OPENROUTER_API_KEY
3. 暂时使用主模型 minimax-m2.7

## 参考文档

- `references/openrouter-model-status.md` - OpenRouter 模型实测状态
- `references/openrouter-500-diagnostic.md` - 500错误诊断流程（本session新增）
- `references/hindsight-installation.md` - Hindsight 安装指南
