---
metadata:
  tags:
  - router
  - multi-agent
  - task-dispatch
  triggers:
  - 编程任务
  - 图片分析
  - 写作任务
  - 研究调研
  - 数据处理
  version: 1.0.0
  author: 马丞相
description: 自动路由系统 - 根据任务类型自动调度到对应角色处理，完成后汇报结果给主上
name: auto-router
---
# 自动路由系统

## 角色体系

| 角色 | 模型 | 任务范围 |
|------|------|---------|
| 通用助手 | minimax-m2.5 | 对话、推理、总调度 |
| 编程助手 | Claude Code / Codex / OpenCode | 写代码、调试、重构 |
| 视觉助手 | Llama-3.2-Vision | 图片分析、OCR、分割 |
| 写作助手 | GPT-4o | 文案、创作、翻译 |
| 研究助手 | Perplexity / GPT-4 | 搜索、调研、读论文 |
| 数据助手 | Python + Claude | 数据处理、图表、分析 |

## 核心规则

1. **通用助手（主上）** 是总调度，负责识别任务类型并分发
2. **任何角色执行任务后必须向主上汇报结果**
3. 主上可以通过 `/model` 手动切换当前模型

## 任务识别关键词

### 编程助手触发词
- 写代码、写程序、写接口
- Debug、调试、修复 bug
- 重构、优化代码
- 创建项目、搭建框架
- 编程、开发

### 视觉助手触发词
- 分析图片、分析照片
- 识别图片内容
- OCR 文字识别
- 图片分割
- 图像处理
- 看图、这张图

### 写作助手触发词
- 写文案、写文章
- 创作、写作
- 翻译
- 写报告、写总结

### 研究助手触发词
- 搜索、调研
- 查资料、找信息
- 研究、分析趋势
- 读论文

### 数据助手触发词
- 数据分析
- 处理数据
- 生成图表
- 统计数据

## 使用流程

1. 主上下达任务
2. 通用助手识别任务类型
3. 调用对应角色处理任务
4. 角色完成任务后汇报结果给主上

## 技能绑定

每个角色自动加载对应技能：

- **编程助手**: claude-code, codex, opencode, test-driven-development, systematic-debugging, python-debugpy, node-inspect-debugger, requesting-code-review, writing-plans, github-pr-workflow
- **视觉助手**: segment-anything-model, clip, ocr-and-documents, blender-mcp, pixel-art
- **写作助手**: humanizer, excalidraw, architecture-diagram, popular-web-designs, ideation
- **研究助手**: arxiv, blogwatcher, llm-wiki, polymarket
- **数据助手**: jupyter-live-kernel, chroma, weights-and-biases

## Fallback 机制

当指定模型失效时：
1. 自动重试 3 次
2. 切换到备用模型
3. 备用模型也失效时，回退到通用助手（主模型）
4. 向主上汇报切换原因

## 调用示例

```
用户: 帮我写个登录接口
→ 通用助手识别: 编程任务
→ 调用编程助手 (Claude Code)
→ 编程助手完成任务
→ 汇报结果给主上

用户: 分析这张图片
→ 通用助手识别: 视觉任务
→ 调用视觉助手 (Llama-3.2-Vision)
→ 视觉助手完成任务
→ 汇报结果给主上
```
