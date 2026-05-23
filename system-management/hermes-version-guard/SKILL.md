---
name: hermes-version-guard
description: Hermes 版本守护机制 - 检测升级问题、自动修复、版本回滚，保护系统稳定运行
version: 1.0.0
author: 马丞相
metadata:
  tags: [version-guard, rollback, auto-recovery, system-protection]
---

# Hermes 版本守护机制

## 重要说明

**当 Hermes 版本升级后出现无法正常运行/启用时，自动修复失败后自动回滚到升级前的稳定版本，确保系统始终可用。**

## 工作流程

```
版本升级检测
     │
     ▼
┌─────────────────────────┐
│ 启动后健康检查          │
│ - Gateway 是否运行      │
│ - 核心功能是否正常      │
└─────────────────────────┘
     │
     ▼
┌─────────────────────────┐
│ 正常运行？              │
│ 是 → 记录稳定版本       │
│ 否 → 进入修复流程       │
└─────────────────────────┘
     │
     ▼
┌─────────────────────────┐
│ 自动修复尝试            │
│ - 检查依赖              │
│ - 重新加载配置          │
│ - 重启服务              │
└─────────────────────────┘
     │
     ▼
┌─────────────────────────┐
│ 修复成功？              │
│ 是 → 记录新稳定版本     │
│ 否 → 执行版本回滚       │
└─────────────────────────┘
     │
     ▼
┌─────────────────────────┐
│ 版本回滚                │
│ - 恢复上一稳定版本      │
│ - 验证回滚后正常运行    │
│ - 向主上汇报            │
└─────────────────────────┘
```

## 版本管理机制

### 版本记录文件

```bash
~/.hermes/version_history.json
```

### 记录格式

```json
{
  "current_version": "x.x.x",
  "stable_version": "x.x.x",
  "history": [
    {
      "version": "x.x.x",
      "date": "YYYY-MM-DD",
      "status": "stable|failed|rolled-back",
      "note": "说明"
    }
  ]
}
```

## 备份机制

### 升级前自动备份

1. **配置备份**
   - config.yaml
   - .env
   - auth.json

2. **hermes-agent 备份**
   - 整个 venv 目录
   - 所有技能文件

3. **保留策略**
   - 保留最近 3 个版本的备份
   - 每个备份包含完整恢复所需文件

### 备份目录

```bash
~/.hermes/backups/versions/
├── hermes-agent-v1.x.x-YYYYMMDD/
├── hermes-agent-v1.x.x-YYYYMMDD/
└── hermes-agent-v1.x.x-YYYYMMDD/
```

## 手动备份与恢复（用户主动触发）

> 对于非升级场景的主动备份（如改配置前、做实验前），使用专用脚本：
> **路径：** `~/.hermes/scripts/hermes-backup-manager.sh`
> **快捷链接：** `~/hermes-backup.sh`

### 功能概览

| 功能 | 说明 |
|---|---|
| `backup` | 创建手动快照（保留最近 10 个） |
| `restore` | 交互式选择备份恢复（覆盖前需输入 YES） |
| `list` | 列出所有手动备份 |
| `delete` | 删除指定备份 |
| `status/stop/start/restart` | Hermes 进程管理 |

### 备份内容（12项）

```
config.yaml, .env, auth.json, gateway_state.json,
vendor_models.json, channel_directory.json, version_history.json,
skills/, cron/, memories/, scripts/, plugins/
```

### 避坑

- ⚠️ `state-snapshots/` 不在备份清单内：由 version-guard 自动管理（224MB），手动备份会超时
- ⚠️ 恢复时 Hermes 会被停止，完成后自动重启
- ⚠️ 恢复前必须输入大写 `YES` 确认，否则取消
- ⚠️ **Bash `(( ))` 算术陷阱**：在 `set -e` 脚本中 `((var++))` 当 var=0 时返回 exit code 1 触发提前退出。修复：用 `var=$((var+1))` 或 `((++var))`。同类问题：`((count))` 当 count=0 时也为 false。

### 使用示例

```bash
# 菜单交互
~/hermes-backup.sh

# 命令行直接用
~/hermes-backup.sh backup   # 创建备份
~/hermes-backup.sh list     # 列出备份
~/hermes-backup.sh restore  # 恢复（交互式）
```

---

## 回滚触发条件

满足以下任一条件时触发回滚：

1. **启动失败** - Hermes 无法启动
2. **Gateway 崩溃** - 连续 3 次启动失败
3. **核心功能异常** - 无法响应基本命令
4. **依赖缺失** - 关键 Python 包无法导入
5. **配置错误** - 配置文件损坏无法读取

## 回滚执行流程

```bash
1. 停止当前 hermes-agent 进程
2. 备份当前版本（以防回滚失败）
3. 恢复上一稳定版本的 hermes-agent 目录
4. 恢复配置文件
5. 重新安装依赖（如需要）
6. 启动 Gateway
7. 验证功能正常
8. 向主上发送回滚报告
```

## 自动修复尝试

回滚前先尝试以下修复：

### 修复步骤

1. **检查 Python 依赖**
   ```bash
   cd ~/.hermes/hermes-agent
   pip install -e . --force-reinstall
   ```

2. **重新加载配置**
   ```bash
   hermes config reload
   ```

3. **重启 Gateway**
   ```bash
   systemctl --user restart hermes-gateway
   ```

4. **清理缓存**
   ```bash
   rm -rf ~/.hermes/__pycache__
   find ~/.hermes -name "*.pyc" -delete
   ```

5. **验证修复**
   - 重新启动健康检查
   - 如仍失败，执行回滚

## 汇报模板

### 回滚成功

```
【⚠️ Hermes 版本回滚报告】
⏰ 时间: YYYY-MM-DD HH:MM

🔄 回滚原因:
   版本升级后无法正常启动

📊 事件过程:
   - 升级到: v.x.x → 失败
   - 自动修复: 尝试 3 次 → 失败
   - 执行回滚: v.x.x → v.x.x-1

✅ 回滚后状态:
   - Gateway: 运行中 ✓
   - Telegram: 已连接 ✓
   - WeChat: 已连接 ✓

📦 当前版本: v.x.x-1 (稳定版)
💾 可随时重新升级

【系统已恢复稳定】
```

### 回滚失败

```
【🚨 Hermes 回滚失败警告】
⏰ 时间: YYYY-MM-DD HH:MM

❌ 严重问题:
   版本回滚后仍然无法正常运行

📋 已尝试:
   1. 自动修复 → 失败
   2. 版本回滚 → 失败

💾 可用备份:
   - v.x.x-2 (可尝试)
   - v.x.x-3 (可尝试)

⚠️ 建议:
   请主上手动介入处理

【需要主上指示】
```

> 📎 参考资料: [`references/health-check-commands.md`](references/health-check-commands.md) — 版本历史 JSON 格式样本、健康检查指标阈值、Telegram 已知问题模式、实际可用修复命令、备份目录结构。

## 定时检查任务

Hermes runs this check automatically as a cron job every hour. No manual trigger needed.

## 实际可用的检查命令

> ⚠️ The skill name `hermes-version-guard` is not a real CLI subcommand. The following commands are the actual interfaces:

```bash
# Gateway 状态检查（主要）
hermes gateway status

# 系统健康检查
hermes doctor

# 版本信息
hermes version

# 查看日志
hermes logs --follow gateway
```

## 版本历史查看

```bash
cat ~/.hermes/version_history.json
```

## 回滚操作（手动）

由于 `hermes-version-guard rollback` 不存在，手动回滚流程：

```bash
# 1. 停止 Gateway
systemctl --user stop hermes-gateway

# 2. 备份当前版本
cp -r ~/.hermes/hermes-agent ~/.hermes/backups/versions/hermes-agent-$(date +%Y%m%d)

# 3. 恢复稳定版本（从备份目录）
# cp -r ~/.hermes/backups/versions/hermes-agent-v<x.x.x-YYYYMMDD>/* ~/.hermes/hermes-agent/

# 4. 重启 Gateway
systemctl --user start hermes-gateway
```

## 手动命令

> ⚠️ 以下命令为 skill 文档目标，实际不存在。请使用上述实际命令。

```bash
# 手动检查版本状态 → 用: hermes gateway status
# 手动回滚 → 见上方手动回滚流程
# 手动回滚到指定版本 → 见上方手动回滚流程
# 查看版本历史 → 用: cat ~/.hermes/version_history.json
```
