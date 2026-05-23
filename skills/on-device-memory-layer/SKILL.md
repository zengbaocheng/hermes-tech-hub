---
name: on-device-memory-layer
description: 设备端 AI 代理记忆层 — 基于 ClawMem 架构的本地持久记忆系统，MCP Server + 钩子 + 混合 RAG 即时检索
version: 1.0.0
categories:
  - autonomous-ai-agents
  - mlops
  - mcp
---

# 🧠 设备端 AI 代理记忆层

## 概述
为 AI 代理（Hermes、Claude Code、Codex、OpenClaw）提供**完全本地、无外部依赖**的持久记忆层。基于 ClawMem (172⭐) 架构。

**核心特性**：
- MCP Server 统一访问（Hermes 原生支持）
- Hooks API — 在代码中自然嵌入记忆
- 混合 RAG：Query-based Memory Decay + Embedding 语义搜索
- 文件存储 — 零数据库依赖

## 架构全景

```
┌─────────────────────────────────────────────┐
│            AI Agent 进程                       │
├─────────────────────────────────────────────┤
│  MCP Client   ←→   Hook 装饰器               │
└──────────────────┬──────────────────────────┘
              stdio/HTTP
┌──────────────────▼──────────────────────────┐
│              MCP Server (核心)               │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────┐       │
│  │  记忆操作 API                    │       │
│  │  • remember(key, value, tags)    │       │
│  │  • recall(query, limit, filter)  │       │
│  │  • forget(keys/pattern)          │       │
│  │  • search(text, semantic)        │       │
│  └──────────────────────────────────┘       │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────┐       │
│  │  记忆引擎                        │       │
│  │  • QMD: Query-based Memory Decay │       │
│  │  • Embedding: 语义向量索引       │       │
│  │  • Hybrid Rank: 多路重排序       │       │
│  └──────────────────────────────────┘       │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────┐       │
│  │  存储后端                        │       │
│  │  • JSON Lines 文件              │       │
│  │  • 索引文件缓存                  │       │
│  │  • 自动过期/压缩                 │       │
│  └──────────────────────────────────┘       │
└─────────────────────────────────────────────┘
```

## 核心技术 — QMD（Query-based Memory Decay）

ClawMem 的核心创新是 **基于查询的记忆衰减**：

| 机制 | 说明 | 对比传统 |
|:----|------|---------|
| **访问激活** | 每次被查询命中，记忆权重+1 | 时间衰减（越久越弱） |
| **关联激活** | 相关记忆被查时，关联记忆权重微增 | 孤立评分 |
| **渐进衰减** | 长时间未被查询，权重逐步降低 | 硬删除/LRU |
| **语义关联** | 相似嵌入的记忆互相强化 | 仅精确匹配 |

**效果**：真正重要的记忆（经常被查询）自动留存，噪声自动衰减消失。

## 安装与配置

### Hermes Agent 集成

```yaml
# ~/.hermes/config.yaml
mcp_servers:
  memory-layer:
    command: npx
    args: [-y, clawmem]
    # 或本地安装版:
    # command: node
    # args: [/path/to/clawmem/dist/mcp-server.js]
```

### 其他代理集成

| 代理 | 集成方式 |
|:----|---------|
| Claude Code | `claude mcp add memory-layer npx clawmem` |
| Codex | `codex mcp add memory-layer npx clawmem` |
| OpenClaw | 内置支持 |

## 使用示例

### MCP 工具调用

```
# 存储记忆
remember(key="project_deploy_config", value={"env": "staging", "region": "us-east-1"}, tags=["deploy", "infra"])

# 语义检索
recall(query="how did we deploy last time", limit=5)

# 按标签筛选
search(text="deploy", filter={"tags": ["production"]})

# 清理过期记忆
forget(pattern="temp_*")
```

### Hook API（代码嵌入）

```python
from clawmem import remember, recall

@remember(tags=["api", "auth"])
def login_user(user_id: str):
    # 函数执行后自动记忆返回值
    result = authenticate(user_id)
    return result

@recall(context=True)
def handle_question(question: str):
    # 自动注入相关记忆到上下文
    memories = get_relevant_memories(question)
    return generate_answer(question, memories)
```

## 与 Hindsight Memory 对比

| 特性 | Hindsight Memory (Hermes) | ClawMem 模式 |
|:----|:------------------------:|:----------:|
| 存储位置 | Hermes 内置 | 独立 MCP Server |
| 检索方式 | 自动注入 | MCP 工具调用 |
| 向量索引 | 有（Hindsight） | 可选 Embedding |
| 跨代理共享 | Hermes 独占 | 任何 MCP Agent |
| 过期策略 | 手动 retain/forget | QMD 自动衰减 |
| 文件存储 | 内部 DB | JSON Lines + 索引 |
| 扩展性 | 配置内 | 可独立部署 |

## 最佳实践

### 记忆分类
- **短期**：当前会话上下文 → 自动过期（1天衰减）
- **中期**：用户偏好/项目决策 → 标签标记，7天衰减
- **长期**：配置/凭证/架构 → 高权重固定，永不衰减

### 性能优化
- Embedding 模型：本地小模型（all-MiniLM-L6-v2）
- 索引分片：超过 10K 条自动分片
- 查询缓存：相同 query 60 秒内命中缓存

## 参考项目
- [yoloshii/ClawMem](https://github.com/yoloshii/ClawMem) — 172⭐ 设备端记忆层