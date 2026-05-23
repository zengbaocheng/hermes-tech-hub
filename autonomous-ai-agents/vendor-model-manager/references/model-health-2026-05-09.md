# 供应商模型健康检测结果 (2026-05-09)

## 测试方法

使用 OpenRouter Chat Completions API 测试每个模型：
```bash
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "<model_id>", "messages": [{"role": "user", "content": "Hi"}], "max_tokens": 5}'
```

## 测试结果

| 模型 | 状态 | 备注 |
|------|------|------|
| microsoft/phi-4 | ✓ 可用 | 稳定，免费 |
| meta-llama/llama-3.1-70b-instruct | ✓ 可用 | 稳定，免费 |
| deepseek/deepseek-chat-v3 | ✓ 可用 | 稳定 |
| deepseek/deepseek-r1 | ✓ 可用 | 稳定 |
| deepseek-v4-flash | ✓ 可用 | 稳定，免费 (Sensenova代理) |
| qwen/qwen-2.5-72b-instruct | ⚠️ 可用但不稳定 | 首次可能返回 Internal Server Error，重试成功 |
| minimax/minimax-01 | ✓ 可用 | 稳定 |
| perplexity/sonar | ✓ 可用 | 稳定，免费 |
| sensenova-6.7-flash-lite | ✗ 不可用 | HTTP 400: not a valid model ID |

## 关键发现

1. **sensenova-6.7-flash-lite 不是有效的 OpenRouter 模型 ID** - 不要在 vendor_models.json 中使用此模型

2. **qwen/qwen-2.5-72b-instruct 有瞬时失败** - 首次请求可能失败，重试后成功。健康检测逻辑需要：
   - 对失败模型重试最多 3 次
   - 只有连续 3 次失败才标记为真正的失败
   - 区分"瞬时错误"(Internal Server Error) 和"永久错误"(invalid model ID)

3. **deepseek-v4-flash 是可用的免费模型** - 虽然是 Sensenova 代理，但通过 OpenRouter 可以正常调用

## 当前 vendor_models.json 结构

```json
{
  "编程助手": [
    {"model": "microsoft/phi-4", "vendor": "Microsoft/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "meta-llama/llama-3.1-70b-instruct", "vendor": "Meta/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-chat-v3", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0},
    {"model": "deepseek-v4-flash", "vendor": "Sensenova", "free": true, "available": true, "fail_count": 0}
  ],
  "视觉助手": [
    {"model": "minimax/minimax-01", "vendor": "Minimax/OpenRouter", "free": false, "available": true, "fail_count": 0},
    {"model": "deepseek-v4-flash", "vendor": "Sensenova", "free": true, "available": true, "fail_count": 0}
  ],
  "写作助手": [
    {"model": "qwen/qwen-2.5-72b-instruct", "vendor": "Qwen/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-chat-v3", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0},
    {"model": "deepseek-v4-flash", "vendor": "Sensenova", "free": true, "available": true, "fail_count": 0}
  ],
  "研究助手": [
    {"model": "perplexity/sonar", "vendor": "Perplexity/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-r1", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0},
    {"model": "deepseek-v4-flash", "vendor": "Sensenova", "free": true, "available": true, "fail_count": 0}
  ],
  "数据助手": [
    {"model": "microsoft/phi-4", "vendor": "Microsoft/OpenRouter", "free": true, "available": true, "fail_count": 0},
    {"model": "deepseek/deepseek-r1", "vendor": "DeepSeek/OpenRouter", "free": false, "available": true, "fail_count": 0},
    {"model": "deepseek-v4-flash", "vendor": "Sensenova", "free": true, "available": true, "fail_count": 0}
  ]
}
```