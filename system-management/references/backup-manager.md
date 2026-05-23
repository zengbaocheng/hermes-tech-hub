#!/bin/bash
#===============================================
# Hermes 备份与恢复管理脚本
# 功能：手动备份 / 选择恢复 / Gateway 管理
# 路径：~/.hermes/scripts/hermes-backup-manager.sh
# 快捷链接：~/hermes-backup.sh
#===============================================
#
# 使用方式：
#   ~/hermes-backup.sh           # 交互式菜单
#   ~/hermes-backup.sh backup     # 立即备份
#   ~/hermes-backup.sh list       # 列出备份
#   ~/hermes-backup.sh restore    # 恢复（交互式）
#   ~/hermes-backup.sh delete     # 删除备份
#   ~/hermes-backup.sh rg         # 重启 Gateway
#   ~/hermes-backup.sh gs         # Gateway 状态
#   ~/hermes-backup.sh gstart     # 启动 Gateway
#   ~/hermes-backup.sh gstop      # 停止 Gateway
#   ~/hermes-backup.sh stop/start # 完整 Hermes 控制
#   ~/hermes-backup.sh help       # 帮助
#
# 备份包含（12项）：
#   config.yaml, .env, auth.json, gateway_state.json,
#   vendor_models.json, channel_directory.json, version_history.json,
#   skills/, cron/, memories/, scripts/, plugins/
#
# 已排除（自动重建或太大）：
#   state-snapshots/, state.db, sessions/, logs/, cache/
#
# 保留策略：最近 10 个手动备份
#
# 技术要点：
#   - gateway.pid 是 JSON 格式：{"pid":42690,...}，需用 grep 提取数字 pid
#   - stop/restore 前会自动停止 Hermes，恢复后自动重启
#   - 恢复需要输入 YES 确认，防止误操作