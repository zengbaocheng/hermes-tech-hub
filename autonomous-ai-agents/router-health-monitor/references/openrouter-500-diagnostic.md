# OpenRouter 500 错误诊断指南

## 快速判断逻辑

**核心原则**: 所有模型同时返回500 ≠ 模型问题，99%是OpenRouter服务端故障

```
收到500错误? → 测试其他模型也500? → YES → OpenRouter服务端问题，等待恢复
                              ↓ NO
                        → 该模型特定问题，尝试备用
```

## 诊断命令清单

### 1. 网络连通性
```bash
ping -c 2 openrouter.ai
curl -s -o /dev/null -w "HTTP:%{http_code}" https://openrouter.ai --max-time 10
```

### 2. API Key有效性
```bash
curl -s https://openrouter.ai/api/v1/models \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  --max-time 15 | head -100
```
**期望**: 返回200 + JSON模型列表

### 3. Chat Completions端点
```bash
curl -s -w "\nHTTP:%{http_code}" -X POST \
  "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"openai/gpt-4o-mini","messages":[{"role":"user","content":"test"}]}' \
  --max-time 30
```

### 4. 测试不同模型类
```bash
# 免费模型
curl -s -w "\nHTTP:%{http_code}" -X POST \
  "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"google/gemma-2-27b-it","messages":[{"role":"user","content":"test"}]}'

# 付费模型
curl -s -w "\nHTTP:%{http_code}" -X POST \
  "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"openai/gpt-4o","messages":[{"role":"user","content":"test"}]}'
```

## 错误码解读

| HTTP状态码 | 含义 | 处理 |
|-----------|------|-----|
| 200 | 成功 | - |
| 400 | 请求格式错误 | 检查JSON payload |
| 401 | 认证失败 | 检查API Key |
| 403 | 权限不足 | 检查模型是否可用 |
| 429 | 额度不足/限流 | 切换备用，延迟重试 |
| 500 | **服务端错误** | 等待恢复，**不是模型问题** |
| 503 | 服务不可用 | 等待恢复，尝试备用 |

## 关键发现 (2026-05-13)

### 实测数据
- 网络: ✓ openrouter.ai ping 153ms, HTTP 200
- API Key: ✓ /api/v1/models 返回200+完整模型列表
- Chat Completions: ✗ 所有模型返回500

### 结论
这是OpenRouter服务端问题，不是:
- API Key问题 (Key验证通过)
- 网络问题 (端点可达)
- 某个模型的问题 (所有模型同时500)

### 实际影响
- 5/5角色所有模型均受影响
- 无需手动切换，等待OpenRouter恢复
- 下次检测会自动重试

## 恢复后的验证
```bash
curl -s -w "\nHTTP:%{http_code}" -X POST \
  "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/llama-3.1-8b-instruct","messages":[{"role":"user","content":"Hi"}],"max_tokens":5}' \
  --max-time 30
```
期望: 返回200 + 有效响应