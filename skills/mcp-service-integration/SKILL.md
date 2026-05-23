---
name: mcp-service-integration
description: 真实世界服务 MCP 集成模式 — 将航班搜索、Web 搜索、知识库等真实服务封装为 MCP Server，供 Hermes Agent 直接调用
version: 1.0.0
categories:
  - autonomous-ai-agents
  - mcp
  - software-development
---

# 🔌 真实世界服务 MCP 集成模式

## 概述
将真实世界的第三方服务（航班搜索、Web 搜索、知识库等）通过 MCP (Model Context Protocol) 封装为 AI Agent 可调用的工具，实现 Agent 与真实世界的交互。

**来源项目**: LetsFG (1.1k⭐) · AnySearch MCP (512⭐) · Kindly Web Search MCP (331⭐)

## 核心架构

```
┌─────────────────────────────────────────────┐
│            AI Agent (Hermes/Claude/etc)      │
├─────────────────────────────────────────────┤
│               MCP Client                     │
└───────────────────┬─────────────────────────┘
                    │ stdio/HTTP
┌───────────────────▼─────────────────────────┐
│               MCP Server                     │
├─────────────────────────────────────────────┤
│  服务连接器 1 │ 服务连接器 2 │ ... │ 连接器 N│
├─────────────────────────────────────────────┤
│  去重 · 价格归一化 · 组合引擎                │
├─────────────────────────────────────────────┤
│  后端 API (认证 · 支付 · 预订)              │
└─────────────────────────────────────────────┘
```

## 三路径服务模型（源自 LetsFG）

| 路径 | 运行位置 | 搜索成本 | 集成方式 | 适用场景 |
|:----|:-------:|:--------:|---------|---------|
| **本地 MCP** | 用户本机 | 免费 | `npx` / `pip` | 开发者本地测试 |
| **Web API** | 服务端 | 免费搜索 | HTTP REST | AI Agent 无浏览器环境 |
| **开发者 API** | 服务端 | 预付费信用 | API Key | 商业级批量使用 |

## 高价值 MCP 服务汇总

### 🛫 航班搜索 — LetsFG (1.1k⭐)
```bash
# MCP 配置
npx letsfg-mcp

# 或 pip 安装
pip install letsfg
letsfg search LHR BCN 2025-06-15

# 在 Hermes config.yaml 中配置
# mcp_servers:
#   letsfg:
#     command: npx
#     args: [-y, letsfg-mcp]
```

### 🔍 统一搜索 — AnySearch MCP (512⭐)
```python
# 统一搜索搜索引擎
# 支持: web, news, images, videos, scholar
```

### 🌐 Web 搜索 — Kindly Web Search (331⭐)
```python
# 网页搜索 + 内容检索
# 适用于: Claude Code, Codex, Cursor, Copilot
```

### 🧠 设备记忆 — ClawMem (172⭐)
```bash
# 设备端 AI 代理记忆层
# 支持: Hermes, Claude Code, OpenClaw
# 功能: Hooks + MCP Server + 混合 RAG 搜索
```

### 🛡️ 安全中间件 — Shellward (99⭐)
```bash
# 8 层 AI 代理安全防御
# DLP 数据流控制 + 提示注入检测
```

## 在 Hermes 中配置 MCP

```yaml
# ~/.hermes/config.yaml
mcp_servers:
  letsfg:
    command: npx
    args: [-y, letsfg-mcp]
    env:
      LETSFG_API_KEY: "${LETSFG_API_KEY}"
  
  anysearch:
    command: python
    args: [-m, anysearch_mcp_server]
  
  clawmem:
    command: npx
    args: [-y, clawmem]
```

## 最佳实践

### 1. 服务选择原则
- **高频率调用** → 本地 MCP（免费，低延迟）
- **低频率/偶发调用** → Web API（无需安装）
- **商业级使用** → 开发者 API（稳定，有 SLA）

### 2. 安全考虑
- API Key 存储在环境变量中，不要硬编码
- 使用 `env` 字段传递凭证
- 对高敏感服务启用 DLP

### 3. 错误处理
```python
# 典型的 MCP 调用模式
try:
    result = await mcp_client.call_tool("search", {
        "origin": "LHR",
        "dest": "BCN",
        "date": "2025-06-15"
    })
except TimeoutError:
    # 回退到 Web API
    result = await web_api.search(...)
except AuthError:
    # 提示用户配置 API Key
    logger.warning("API key not configured")
```

### 4. 监控健康度
- 定期检查 MCP 服务连接状态
- 记录服务响应时间
- 服务降级时自动切换备用方案

## 技术栈建议

| 组件 | 推荐方案 | 备选方案 |
|:----|---------|---------|
| MCP Server 语言 | Python (FastAPI) | TypeScript (Express) |
| 客户端 SDK | `mcp` Python 包 | TypeScript SDK |
| 本地运行 | stdio transport | 子进程 |
| 远程运行 | HTTP SSE transport | WebSocket |
| 认证 | API Key header | JWT / OAuth |

## 参考项目
- [LetsFG/LetsFG](https://github.com/LetsFG/LetsFG) — 1.1k⭐ 航班搜索 MCP
- [anysearch-ai/anysearch-mcp-server](https://github.com/anysearch-ai/anysearch-mcp-server) — 512⭐ 统一搜索
- [Shelpuk-AI/kindly-web-search-mcp-server](https://github.com/Shelpuk-AI-Technology-Consulting/kindly-web-search-mcp-server) — 331⭐ Web 搜索
- [yoloshii/ClawMem](https://github.com/yoloshii/ClawMem) — 172⭐ 设备记忆
- [jnMetaCode/shellward](https://github.com/jnMetaCode/shellward) — 99⭐ 安全中间件