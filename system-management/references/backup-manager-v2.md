# Hermes 备份与恢复管理脚本 v1.0 参考文档

## 脚本信息

- **路径**：`/home/zbc/hermes-backup-v2.sh`
- **快捷链接**：`~/hermes-backup-v2.sh`
- **备份目录**：`~/.hermes/backups/`

## 命令清单

```bash
~/hermes-backup-v2.sh           # 交互式菜单
~/hermes-backup-v2.sh backup   # 立即备份（推荐日常使用）
~/hermes-backup-v2.sh list     # 列出所有备份
~/hermes-backup-v2.sh restore  # 选择备份恢复（需 YES 确认）
~/hermes-backup-v2.sh delete   # 删除旧备份（保留最近10个）
~/hermes-backup-v2.sh gs       # Gateway 状态
~/hermes-backup-v2.sh rg       # 重启 Gateway
~/hermes-backup-v2.sh start    # 启动 Gateway
~/hermes-backup-v2.sh stop     # 停止 Gateway
~/hermes-backup-v2.sh doctor   # 健康检查（等价 hermes doctor）
~/hermes-backup-v2.sh profile-export  # 导出 Profile
~/hermes-backup-v2.sh profile-import  # 导入 Profile
~/hermes-backup-v2.sh skill-backup    # curator 快照备份
~/hermes-backup-v2.sh session-export # 导出会话（30s超时）
~/hermes-backup-v2.sh help     # 帮助信息
~/hermes-backup-v2.sh model    # 模型管理子菜单（查看/测试/切换模型）
~/hermes-model-manager.sh      # 单独运行模型管理模块
```

## 备份内容（共 12 项）

| 项目 | 类型 | 说明 |
|------|------|------|
| config.yaml | 文件 | 主配置 |
| .env | 文件 | API 密钥 |
| auth.json | 文件 | OAuth 令牌 |
| gateway_state.json | 文件 | Gateway 状态 |
| vendor_models.json | 文件 | 模型配置 |
| channel_directory.json | 文件 | 渠道配置 |
| version_history.json | 文件 | 版本历史 |
| skills/ | 目录 | 已安装技能 |
| cron/ | 目录 | 定时任务 |
| memories/ | 目录 | 记忆数据 |
| scripts/ | 目录 | 自定义脚本 |
| plugins/ | 目录 | 插件 |

## 已排除（自动重建）

- `sessions/` — 自动重建
- `logs/` — 自动重建
- `cache/` — 自动重建
- `state.db` — 自动重建
- `state-snapshots/` — 太大，仅备份 index.json

## 保留策略

- 最多保留 10 个备份
- 超出时自动删除最旧备份
- 备份命名：`hermes_backup_YYYYMMDD_HHMMSS`

## 关键实现细节

### gateway.pid 读取（JSON 格式）

文件内容：`{"pid": 1186, "kind": "hermes-gateway", ...}`

```bash
# ✅ 正确（冒号后可能有空格）
PID=$(grep -o '"pid": *[0-9]*' "$PID_FILE" | grep -o '[0-9]*')

# ❌ 错误（漏了空格）
PID=$(grep -o '"pid":[0-9]*' "$PID_FILE" | grep -o '[0-9]*')
```

### set -u 下的空输入处理

脚本使用 `set -euo pipefail`，空变量会导致脚本终止：

```bash
# ✅ 正确写法
read -rp "请输入编号: " idx || true
if [[ -z "$idx" ]]; then
    echo "已取消"
    return 0
fi

# ❌ 错误写法（空输入触发 set -u 报错）
read -rp "请输入编号: " idx
if [[ -n "$idx" ]] && [[ "$idx" -ge 0 ]]; then
    ...
```

### 会话导出超时

`hermes sessions export` 在大量会话时可能很慢：

```bash
timeout 30 hermes sessions export "$export_file" || echo "导出失败（超时）"
```

## Profile 导入导出

使用官方命令 `hermes profile export/import`，备份格式为 `.tar.gz`：

```bash
hermes profile export default ~/default_profile.tar.gz
hermes profile import ~/default_profile.tar.gz
```

## 技能库备份

使用 curator 快照，不受备份脚本管理：

```bash
hermes curator backup
# 快照保存到 ~/.hermes/skills/.curator_backups/
```

## 健康检查

```bash
~/hermes-backup-v2.sh doctor
# 等价于 hermes doctor
```