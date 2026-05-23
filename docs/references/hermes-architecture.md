# Hermes Agent 架构参考

> 来源: https://hermes-agent.nousresearch.com/docs/developer-guide/architecture
> 自动爬取于 2026-05-23

## 系统总览

Hermes Agent 有 4 个入口点:
- CLI (cli.py) — 交互式终端
- Gateway (gateway/run.py) — 消息平台网关
- ACP (acp_adapter/) — IDE集成（VS Code / Zed / JetBrains）
- Batch Runner / API Server / Python Library

## 核心架构

### AIAgent (run_agent.py) — 核心对话循环
- Prompt Builder (prompt_builder.py) — 系统提示组装
- Provider Resolution (runtime_provider.py) — 供应商选择
- Tool Dispatch (model_tools.py) — 工具调度
- Compression & Caching — 上下文压缩与缓存
- 3种 API 模式: chat_completions / codex_responses / anthropic_messages

### 目录结构

hermes-agent/
├── run_agent.py              # AIAgent — 核心对话循环
├── cli.py                    # HermesCLI — 交互式终端
├── agent/                    # Agent 内部组件
│   ├── prompt_builder.py     # 系统提示组装
│   ├── context_engine.py     # ContextEngine ABC
│   ├── context_compressor.py # 上下文压缩
│   ├── prompt_caching.py     # Anthropic 提示缓存
│   ├── memory_manager.py     # 记忆管理编排
│   └── memory_provider.py    # 记忆提供者 ABC
├── hermes_cli/               # CLI 子命令
├── tools/                    # 工具实现（每个文件一个工具）
│   ├── registry.py           # 中央工具注册表
│   ├── terminal_tool.py      # 终端编排（7个后端）
│   └── environments/         # local, docker, ssh, modal, daytona, singularity
├── gateway/                  # 消息平台网关（20个适配器）
│   └── platforms/            # telegram, discord, weixin, feishu 等
├── cron/                     # 调度器
├── plugins/                  # 插件系统
├── skills/                   # 内置技能
├── optional-skills/          # 官方可选技能
└── acp_adapter/              # ACP 服务器

### 设计原则
1. Prompt stability — 系统提示在对话期间不变化
2. Observable execution — 所有工具调用对用户可见
3. Interruptible — API调用和工具执行可被取消
4. Platform-agnostic core — 一个 AIAgent 服务所有入口
5. Profile isolation — 每个 profile 独立配置/记忆/会话

文档来源: https://hermes-agent.nousresearch.com/docs/developer-guide/architecture
