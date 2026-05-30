# NVIDIA NemoClaw

> **NVIDIA 官方沙箱化 AI 代理安全运行栈**
> ⭐20.7k | Apache 2.0 | TypeScript 76.9% | 1,893 commits

## 简介

NVIDIA NemoClaw 是一个开源参考栈，用于在 [OpenShell](https://github.com/NVIDIA/OpenShell) 沙箱内更安全地运行始终在线的 AI 代理。

**官方网站:** https://docs.nvidia.com/nemoclaw/latest/
**GitHub:** https://github.com/NVIDIA/NemoClaw

## Hermes 集成

NemoClaw 将 Hermes Agent 作为一等公民原生支持：

```bash
# 使用 Hermes 代理
export NEMOCLAW_AGENT=hermes
curl -fsSL https://raw.githubusercontent.com/NVIDIA/NemoClaw/main/install.sh | bash

# 或使用 nemohermes 别名
nemohermes run "analyze this repo"
```

NVIDIA 官方文档提供专门的 [Hermes 快速入门](https://docs.nvidia.com/nemoclaw/latest/get-started/quickstart-hermes.html)。

## 核心架构

- **Plugin Layer**: 自定义入口点
- **Blueprint Lifecycle**: 构建 → 部署 → 销毁
- **Sandbox Environment**: 容器隔离
- **Routed Inference**: 多供应商路由
- **Network Policy**: 出站控制 + 审批流
- **Lifecycle Management**: 代理状态管理

## 安全特性

- Container capability drops
- 进程限制 (seccomp)
- 网络策略 (基线 + 动态)
- 3 种安全态势配置
- 操作员审批流程

## 发现日期

2026-05-30 (第三轮生态扫描)

## 参考链接

- https://docs.nvidia.com/nemoclaw/latest/about/overview.html
- https://docs.nvidia.com/nemoclaw/latest/get-started/quickstart-hermes.html
- https://docs.nvidia.com/nemoclaw/latest/reference/architecture.html
- https://github.com/NVIDIA/OpenShell