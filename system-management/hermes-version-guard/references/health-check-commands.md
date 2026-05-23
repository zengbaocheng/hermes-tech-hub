# Hermes Version Guard - 参考资料

## version_history.json 格式

```json
{
  "current_version": "v2026.5.7-545-g486b692dd",
  "stable_version": "v2026.5.7-273-gb67ea7ff4",
  "last_check": "2026-05-14T17:19:38.333685",
  "health_check": {
    "gateway": "running",
    "pid": 1093,
    "uptime": "2d19h",
    "telegram": "connected",
    "telegram_note": "Last error May 13 23:09, auto-recovered. Using fallback IP 149.154.166.110.",
    "wechat": "connected",
    "issues": []
  },
  "status": "stable",
  "note": "Gateway running (PID 1093, ~71h uptime). Telegram: connected (fallback IP stable). WeChat: connected. System fully operational. No rollback needed."
}
```

## 健康检查关键指标

| 字段 | 正常值 | 异常信号 |
|------|--------|----------|
| `health_check.gateway` | `running` | 非 running |
| `health_check.pid` | 存在且进程在 | 进程不存在 |
| `health_check.telegram` | `connected` | `disconnected` |
| `health_check.wechat` | `connected` | `disconnected` |
| `health_check.issues` | `[]` | 有内容 = 有问题 |
| `status` | `stable` | `unstable` / `failed` |

## 实际 Gateway 日志最后活跃判断

正常运行的 gateway.log 应有 `agent.auxiliary_client: Auxiliary auto-detect` 每小时条目（健康检查任务）和消息处理日志。

最近 24 小时无日志 = gateway 可能已停止。

## Telegram 已知问题模式

- `Primary api.telegram.org connection failed` → 尝试 fallback IPs
- `using sticky fallback IP 149.154.166.110` → 已切换到备用 IP 工作
- `Telegram polling resumed after network error` → 自动恢复，不是严重问题
- 这些都是 WARNING 级别，auto-recovered 后不影响运行

## 回滚触发条件（已验证）

1. Gateway 进程不存在 (`ps aux | grep hermes` 无结果)
2. Gateway 进程存在但 `hermes gateway status` 显示 `inactive`/`failed`
3. Gateway 进程存在但无任何日志活动超过 24 小时
4. 核心功能（telegram/wechat）持续 `disconnected` 超过 30 分钟

## 修复命令（实际可用）

```bash
# 重启 Gateway
systemctl --user restart hermes-gateway

# 查看 Gateway 状态
systemctl --user status hermes-gateway

# 强制重新加载配置
hermes config reload

# 重新安装依赖
cd ~/.hermes/hermes-agent && pip install -e . --force-reinstall
```

## 备份目录结构

```
~/.hermes/backups/versions/
├── hermes-agent-v1.x.x-YYYYMMDD/   # 每次升级前自动创建
└── ...
```

备份由 `hermes update` 自动创建（升级前）。也可手动备份：
```bash
mkdir -p ~/.hermes/backups/versions
cp -r ~/.hermes/hermes-agent ~/.hermes/backups/versions/hermes-agent-$(date +%Y%m%d)
```