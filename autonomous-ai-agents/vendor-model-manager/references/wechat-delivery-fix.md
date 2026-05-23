# WeChat 投递超时问题

## 问题现象

Cron Job 任务执行成功，但投递报告给 WeChat 时失败：

```
delivery error: Weixin send failed: Timeout context manager should be used inside a task
```

## 受影响的任务

| 任务名称 | Job ID | 调度时间 |
|----------|--------|----------|
| 自动路由健康检测 | b1f1e375c710 | 每天 07:00 |
| 供应商模型管理 | bb91df821c91 | 每天 05:00 |

## 根本原因

WeChat 投递通道存在超时问题，疑似与消息队列的上下文管理有关。

## 解决方案

将受影响任务的投递目标改为 Telegram：

```bash
# 修改自动路由健康检测
hermes cron update b1f1e375c710 --deliver telegram:178274859

# 修改供应商模型管理
hermes cron update bb91df821c91 --deliver telegram:178274859
```

## 已修复

2026-05-07 已将上述两任务的 deliver 从 WeChat 改为 Telegram。

## 验证修复

查看任务投递状态：
```bash
hermes cron list
```

检查任务的 `last_delivery_error` 字段是否为空。

## 相关文件

- 任务配置：`~/.hermes/cron/`
- 投递日志：查看 hermes logs 中的 delivery 相关日志