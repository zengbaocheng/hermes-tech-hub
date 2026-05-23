---
description: Hermes 系统管理：开机自启配置、定时任务、手动备份恢复、Gateway 管理。
name: system-management
metadata:
  related_skills:
  - hermes-version-guard
---
## 开机自动运行配置

### 已配置的服务

| 服务 | 文件位置 | 状态 |
|------|----------|------|
| Hermes Gateway | ~/.config/systemd/user/hermes-gateway.service | ✅ 已启用 |

### 自动启动原理

1. **systemd user service** - 用户级服务，登录后自动启动
2. **WantedBy=default.target** - 登录时自动启动
3. **Restart=on-failure** - 故障时自动重启

### 手动命令

```bash
# 启动
systemctl --user start hermes-gateway

# 停止
systemctl --user stop hermes-gateway

# 重启
systemctl --user restart hermes-gateway

# 查看状态
systemctl --user status hermes-gateway

# 启用开机自启（默认已启用）
systemctl --user enable hermes-gateway
```

### 启动脚本

```bash
~/.hermes/startup.sh  # 完整启动脚本
```

### 已自启的服务

1. **hermes-gateway** - Telegram/WeChat 消息网关
2. **定时任务** - cron jobs（健康监控、文件清理等）
3. **Hindsight** - 长期记忆系统（由 hermes-agent 管理）

### 验证自启成功

```bash
# 检查 Gateway 状态
systemctl --user status hermes-gateway

# 检查进程
ps aux | grep hermes | grep -v grep

# 验证 Hindsight
hermes memory status
```

---

## 手动备份与恢复

> 参考文档：`references/backup-manager-v2.md`（最新 v2）
> 旧版脚本：`references/backup-manager.md`（旧版 v1，已废弃）

### 模型管理（v2 新增）

模型管理功能集成在备份脚本的 `[m]` 菜单项中，也可直接从命令行调用：

```bash
bash ~/hermes-backup-v2.sh model           # 进入模型管理子菜单
bash ~/hermes-model-manager.sh              # 单独运行模型管理模块
```

模型管理子菜单选项：
- `[1]` 查看模型配置概览 — 主模型、视觉模型、备用链、认证供应商
- `[2]` 查看角色模型配置 — vendor_models.json 中 5 个角色（编程/视觉/写作/研究/数据助手）
- `[3]` 测试主模型连通性 — curl 调用 `/chat/completions` 验证 API 是否可用
- `[4]` 测试视觉模型 — 测试 OpenRouter 视觉模型
- `[5]` 测试所有角色模型 — 批量测试全部 5 个角色模型
- `[6]` 切换模型/供应商 — 交互式向导（OpenRouter / NVIDIA / Token.sensenova / OpenAI / 自定义）
- `[7]` 新增角色模型 — 交互式新建，可配置主模型+备用列表，覆盖保护
- `[8]` 编辑角色模型 — 5项子操作：改主模型/改当前模型/添加备用/删除备用/切换可用状态
- `[9]` 删除角色模型 — 列出所有角色，选中后 YES 确认删除

> 详细实现：`references/model-management.md`

### 快速使用（hermes-backup-v2.sh）

```bash
~/hermes-backup-v2.sh              # 交互式菜单（推荐）
~/hermes-backup-v2.sh backup      # 立即备份
~/hermes-backup-v2.sh list        # 列出所有备份
~/hermes-backup-v2.sh restore     # 选择备份恢复
~/hermes-backup-v2.sh delete     # 删除备份
~/hermes-backup-v2.sh gs         # 查看 Gateway 状态
~/hermes-backup-v2.sh rg         # 重启 Gateway
~/hermes-backup-v2.sh start      # 启动 Gateway
~/hermes-backup-v2.sh stop       # 停止 Gateway
~/hermes-backup-v2.sh doctor     # 健康检查 (hermes doctor)
~/hermes-backup-v2.sh profile-export  # 导出 Profile（生成 .tar.gz）
~/hermes-backup-v2.sh profile-import  # 导入 Profile
~/hermes-backup-v2.sh skill-backup    # curator 技能库快照
~/hermes-backup-v2.sh session-export  # 导出会话（带 30s 超时保护）
```

> 脚本路径：`/home/zbc/hermes-backup-v2.sh`（从用户主目录快捷链接：`~/hermes-backup-v2.sh`）

### 已知陷阱

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| `gateway.pid` 状态总显示"未运行" | JSON 格式 `{"pid": 1186,...}` 冒号后有空格，grep 模式漏了空格 | 用 `'\"pid\": *[0-9]*' \| grep -o '[0-9]*'` |
| 交互菜单空输入时报错 | `set -u` 下读取空变量导致脚本终止 | `read -rp "..." idx \|\| true` 后加 `[[ -z "$idx" ]]` 判断 |
| `help` 命令输出 grep 残余 | 脚本 case 标签格式与 grep 模式不匹配 | 用硬编码帮助文本，不依赖 grep 提取 |
| `hermes sessions export` 超时 | 730+ 会话处理耗时过长 | 脚本内置 30s `timeout` 保护 |
| `json.dumps` → Python `NameError` | Bash 内嵌 Python 时，`json.dumps()` 输出 `true`/`false` 被 Python 当作未定义变量 | 用 heredoc `'PYEOF'` + 环境变量传参，不用内嵌插值 |

### 技术要点

- **`gateway.pid` 是 JSON 格式**：文件内容为 `{"pid": 1186, ...}`（冒号后有空格）。正确提取方式：
  ```bash
  grep -o '"pid": *[0-9]*' "$PID_FILE" | grep -o '[0-9]*'
  ```
  ❌ 错误写法：`grep -o '"pid":[0-9]*'`（漏了冒号后的空格，导致 PID 提取失败，状态显示"未运行"误报）
- **备份包含**：config.yaml、.env、auth.json、gateway_state.json、vendor_models.json、channel_directory.json、version_history.json、skills/、cron/、memories/、scripts/、plugins/（共12项，约25MB）
- **已排除**：state-snapshots/（224MB太大，仅备份索引）、state.db、sessions/、logs/、cache/（自动重建）
- **恢复流程**：自动停止 Hermes → 覆盖文件（需输入 YES 确认）→ 重启 Hermes
- **保留策略**：最近 10 个手动备份，超出自动删除旧备份
- **会话导出超时**：730+ 会话时 `hermes sessions export` 可能超时，脚本内置 30s timeout 保护
- **Profile 导入导出**：使用 `hermes profile export/import`，备份为 .tar.gz 格式
- **技能库备份**：使用 `hermes curator backup`，快照保存到 `~/.hermes/skills/.curator_backups/`
