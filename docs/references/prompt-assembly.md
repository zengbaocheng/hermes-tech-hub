# 提示组装机制

> 来源: https://hermes-agent.nousresearch.com/docs/developer-guide/prompt-assembly

## 缓存系统提示分层 (10层)
1. Agent 身份 — SOUL.md 或 DEFAULT_AGENT_IDENTITY
2. 工具感知行为指南
3. Honcho 静态块（活跃时）
4. 可选系统消息
5. 冻结的 MEMORY 快照
6. 冻结的 USER 快照
7. 技能索引
8. 项目上下文文件
9. 时间戳/会话 ID
10. 平台提示

## SOUL.md 机制
- 位置: ~/.hermes/SOUL.md
- 作为 agent 身份的第一部分
- 安全扫描 + 截断(20k字符)
- 未找到时使用默认 DEFAULT_AGENT_IDENTITY

## 项目上下文文件优先级
1. .hermes.md / HERMES.md（搜索到git根目录）
2. AGENTS.md（仅CWD）
3. CLAUDE.md（仅CWD）
4. .cursorrules / .cursor/rules/*.mdc（仅CWD）

所有上下文文件都经过安全扫描和截断处理。

## 推荐的自定义路径
- 改身份: 编辑 ~/.hermes/SOUL.md
- 改项目规则: 编辑项目上下文文件
- 改工作流: 添加或修改技能
- 改提示组装: 编辑代码（仅当贡献上游时）

文档来源: https://hermes-agent.nousresearch.com/docs/developer-guide/prompt-assembly
