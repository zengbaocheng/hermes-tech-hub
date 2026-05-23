# Agent Loop 内部机制

> 来源: https://hermes-agent.nousresearch.com/docs/developer-guide/agent-loop

## 核心职责
- 组装系统提示和工具模式
- 选择正确的 API 模式 (chat_completions / codex_responses / anthropic_messages)
- 可中断的模型调用（支持取消）
- 并行执行工具调用（ThreadPoolExecutor）
- 维护对话历史（OpenAI 消息格式）
- 上下文压缩、重试、后备模型切换
- 跟踪迭代预算（默认90次）

## 回合生命周期
1. 生成 task_id
2. 追加用户消息到历史
3. 构建/复用缓存的系统提示
4. 检查是否需要预压缩（超过50%上下文窗口）
5. 构建 API 消息
6. 注入临时提示层
7. 应用提示缓存标记（Anthropic）
8. 发起可中断的 API 调用
9. 解析响应：
   - 有工具调用 → 执行，追加结果，回到步骤5
   - 文本响应 → 持久化会话，刷新记忆

## 消息交替规则
- 系统消息后: User → Assistant → User → Assistant → ...
- 工具调用时: Assistant(含tool_calls) → Tool → Tool → ... → Assistant
- 永远不能有两个连续的 assistant 消息
- 只有 tool 角色可以连续出现（并行工具结果）

## 工具执行
- 单工具调用 → 主线程直接执行
- 多工具调用 → ThreadPoolExecutor 并发执行
- 交互式工具（如 clarify）强制顺序执行

## 预算与后备
- 迭代预算: 默认90次 (agent.max_turns)
- 后备模型: 主模型失败时尝试 fallback_providers

## 上下文压缩触发
- 预压缩: 超过50%上下文窗口
- 网关自动压缩: 超过85%（更激进）

文档来源: https://hermes-agent.nousresearch.com/docs/developer-guide/agent-loop
