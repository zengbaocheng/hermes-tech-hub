---
name: codegraph-mcp
description: CodeGraph MCP 服务 — 预索引代码知识图谱，减少 Agent 代码探索时 70% 工具调用、降低 35% 成本。使用 tree-sitter 构建的本地 SQLite 知识图谱。
---

# CodeGraph MCP 集成

## 触发条件

当用户要求提高 Agent 代码探索效率、减少 Token 消耗、或需要快速理解大型代码库时

## 安装步骤

### 1. 安装 CodeGraph

```bash
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
```

或用 npm（已有 Node.js）：
```bash
npm i -g @colbymchenry/codegraph
```

### 2. 为项目建立索引

```bash
cd /path/to/your/project
codegraph init -i
```

### 3. 配置到 Hermes Agent

编辑 `~/.hermes/config.yaml` 的 MCP Servers 部分：

```yaml
mcpServers:
  codegraph:
    type: stdio
    command: codegraph
    args: ["serve", "--mcp"]
```

重启 Hermes Agent 后即可使用以下 MCP 工具：
- `codegraph_search` — 按名称搜索符号
- `codegraph_context` — 为任务构建相关代码上下文
- `codegraph_callers` / `codegraph_callees` — 追踪调用流
- `codegraph_impact` — 分析变更影响范围
- `codegraph_node` — 获取单个符号详情
- `codegraph_explore` — 一次调用返回多个相关符号源码
- `codegraph_files` — 获取索引的文件结构
- `codegraph_status` — 检查索引健康状态

## 使用模式

### 探索模式（推荐在子 Agent 中使用）
将以下指令传给子 Agent：
> 本项目已初始化 CodeGraph。使用 `codegraph_explore` 作为主要探索工具——它一次调用返回所有相关文件的完整源码段。
> 规则：
> 1. 遵循 explore 调用的预算限制
> 2. 不要重新读取 codegraph_explore 已返回源码的文件
> 3. 仅在 codegraph 未返回结果时才回退到 grep/glob/read

### 轻量查询（主会话中使用）
主会话中只使用轻量工具：
- `codegraph_search` — 找符号
- `codegraph_callers`/`codegraph_callees` — 追踪调用
- `codegraph_impact` — 改前检查影响

### 测试影响分析
```bash
git diff --name-only | codegraph affected --stdin --quiet
```

## CLI 命令参考

```bash
codegraph                         # 交互式安装器
codegraph install                 # 显式安装
codegraph uninstall               # 从所有 Agent 移除
codegraph init [path]             # 初始化项目（--index 同时索引）
codegraph index [path]            # 完整索引
codegraph sync [path]             # 增量更新
codegraph status [path]           # 查看统计
codegraph query <search>          # 搜索符号
codegraph context <task>          # 构建 AI 上下文
codegraph callers <symbol>        # 找调用者
codegraph callees <symbol>        # 找被调用者
codegraph impact <symbol>         # 分析影响范围
codegraph affected [files...]     # 找受影响的测试文件
codegraph serve --mcp             # 启动 MCP 服务
```

## 注意事项

- CodeGraph 100% 本地，数据不出机器
- 自动读取 `.gitignore` 排除不需要的文件
- 支持 19+ 编程语言
- 文件变更后自动同步（2秒去抖窗口）
- 索引在 `.codegraph/codegraph.db` SQLite 数据库中
- 每次文件 > 1MB 会跳过
- 使用 WAL 模式的 node:sqlite，读写不冲突