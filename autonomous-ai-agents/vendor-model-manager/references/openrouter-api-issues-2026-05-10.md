# OpenRouter API 连接问题 (2026-05-10)

## 问题现象

执行健康检测时，所有模型返回错误：
- HTTP 500 (Python urllib超时)
- HTTP 401 "Missing Authentication header" (curl直接调用)

## 排查过程

1. **API Key 存在且格式正确**
   - 从 `~/.hermes/.env` 读取到 `OPENROUTER_API_KEY`（已脱敏）
   - Key 格式是标准的 OpenRouter v1 格式

2. **公共端点正常**
   ```bash
   curl -s --max-time 5 https://openrouter.ai/api/v1/models
   # 返回 200
   ```

3. **认证端点失败**
   ```bash
   curl -X POST https://openrouter.ai/api/v1/chat/completions \
     -H "Authorization: Bearer $OPENROUTER_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"model":"microsoft/phi-4","messages":[{"role":"user","content":"."}],"max_tokens":1}'
   # 返回 {"error":{"message":"Missing Authentication header","code":401}}
   ```

4. **Python 环境完全超时**
   - urllib.request.urlopen 超时 (300s)
   - concurrent.futures 部分超时

## 可能原因

1. **API Key 过期或被撤销** - 最可能
2. **OpenRouter 服务端问题** - 公共端点正常但认证端点异常
3. **IP 限制** - 某些 API key 有 IP 白名单
4. **Rate Limiting** - 短时间内请求过多

## 应急处理

当 OpenRouter API 不可用时：

1. **不要删除所有模型** - fail_count 达到 2 才会删除，给一次重试机会
2. **下次检测继续使用** - 如果下次成功，fail_count 重置为 0
3. **降级到主模型** - 使用 minimax/m2.5 作为临时备选

## 验证脚本

```bash
# 快速验证 API Key 有效性
curl -s --max-time 10 -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"microsoft/phi-4","messages":[{"role":"user","content":"test"}],"max_tokens":5}'
```

## 相关日志位置

- Hermes Agent: `~/.hermes/logs/agent.log`
- Cron 执行: `~/.hermes/logs/gateway.log`