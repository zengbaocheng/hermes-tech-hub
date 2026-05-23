# OpenRouter 模型状态实测报告

**测试时间**: 2026-05-09 07:00-07:30 UTC
**API Key**: sk-or-v1-76a... (有效)

## 实测结果

### ✅ 可用模型

| 模型 | 费用 | 响应情况 |
|------|-----|---------|
| deepseek/deepseek-chat-v3 | 低成本 | ✅ 正常响应 |
| deepseek/deepseek-r1 | 低成本 | ✅ 正常响应 |
| meta-llama/llama-3.1-8b-instruct | 免费 | ✅ 正常响应 |
| meta-llama/llama-3.2-3b-instruct | 免费 | ✅ 正常响应 |
| meta-llama/llama-3.2-11b-vision-instruct | 免费 | ✅ 正常响应 (视觉模型) |

### ❌ 不可用模型

| 模型 | 错误类型 | 错误信息 |
|------|---------|---------|
| anthropic/claude-3-5-sonnet | Internal Server Error | 500 |
| anthropic/claude-3-5-sonnet-20241022 | Internal Server Error | 500 |
| openai/gpt-4o | Internal Server Error | 500 |
| openai/gpt-4-turbo | Internal Server Error | 500 |
| openai/gpt-4o-mini | 地区限制 | 403 - not available in your region |
| openai/o3-mini | Internal Server Error | 500 |
| anthropic/claude-3-haiku | 地区限制 | 403 - not available in your region |
| meta-llama/llama-3.1-70b-instruct | Internal Server Error | 500 |
| microsoft/phi-4 | Internal Server Error | 500 |
| qwen/qwen-2.5-72b-instruct | Internal Server Error | 500 |
| qwen/qwen-2.5-32b-instruct | Internal Server Error | 500 |
| perplexity/sonar | Internal Server Error | 500 |
| google/gemini-pro | Internal Server Error | 500 |
| google/gemini-2.0-flash | Internal Server Error | 500 |
| mistralai/mistral-7b-instruct | Internal Server Error | 500 |
| deepseek/deepseek-v3 | 无效模型ID | 400 - not a valid model ID |

## 主模型 (NVIDIA)

| 模型 | Provider | 状态 |
|------|----------|------|
| minimaxai/minimax-m2.7 | NVIDIA | ✅ 正常 (主模型) |

## 观察结论

1. **OpenRouter 大量 500 错误**: 可能是服务端限流或维护，建议错峰检测
2. **地区限制**: OpenAI 和 Anthropic 部分模型受地区限制
3. **Llama 3.2 Vision**: `meta-llama/llama-3.2-11b-vision-instruct` 可用，不是文档说的"不存在"
4. **DeepSeek 模型**: 目前最稳定的备用选择

## 建议

- 优先使用 `deepseek/deepseek-chat-v3` 和 `deepseek/deepseek-r1`
- 视觉任务使用 `meta-llama/llama-3.2-11b-vision-instruct`
- 免费轻量任务使用 `meta-llama/llama-3.1-8b-instruct`