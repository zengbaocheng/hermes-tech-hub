# GitHub Repo Monitor 搭建记录

**日期**：2026-05-16
**背景**：主上（zengbaocheng）用 Hermes 搭建 GitHub Issue 自动化追踪系统

---

## 问题

GitHub 仓库 Issue 全靠手动刷网页，效率低、容易漏。
主上有 20 个个人仓库 + 想监控 Hermes Agent 官方仓库（15万 star，1.1万 open issues）。

---

## 解决方案

用 cron job + Python 脚本 + Telegram 推送，构建自动化监控体系。

---

## 关键决策

### 1. 为什么用 HTTPS Token 而不是 SSH

主上环境没有安装 `gh` CLI，机器上只有 `git`。走了 git-only 方案：
- 创建 GitHub Personal Access Token（repo scope）
- Token 存 `~/.hermes/.env` → `GITHUB_TOKEN=github_pat_xxx`
- Python 脚本直接读 `.env` 文件加载 token

**注意**：GitHub 2021年后不再支持密码push，HTTPS + PAT 是标准方案。

### 2. 状态文件 `/tmp/github_issue_state.json`

不用状态文件的话，每次都要拉全量 Issue 再对比。
用状态文件记录每个仓库每个 Issue 的 `comments` 数量，下次只报有变化的。
这样：
- 重启不丢位置
- 只报新动态，不重复
- 状态文件损坏/删除 → 下次从头开始，不报错

### 3. 域名白名单（tirith 误报）

脚本里用 curl 调用 GitHub API 带 `Authorization: Bearer` 头，被 tirith 安全扫描误判为 `exfil_curl_auth_header` 攻击，直接把 cron job 拦成 `error`。

**解决**：`tirith trust add openrouter.ai --rule exfil_curl_auth_header --ttl 30d`

注意：只是让 tirith 对这个域名的 curl 请求放行，其他安全规则不受影响。

### 4. `.env` 加载函数

cron job 里的 Python 脚本不走 shell 环境变量，直接在脚本里写了个 `load_env()` 从 `~/.hermes/.env` 读。

```python
def load_env():
    env_path = os.path.expanduser("~/.hermes/.env")
    if os.path.exists(env_path):
        with open(env_path) as f:
            for line in f:
                line = line.strip()
                if "=" in line and not line.startswith("#"):
                    k, v = line.split("=", 1)
                    os.environ.setdefault(k.strip(), v.strip())
```

### 5. 只监控 Issue 不监控 PR

GitHub API 的 `/repos/{o}/{r}/issues` 同时返回 Issue 和 PR，需要过滤：
```python
issues = [i for i in issues if "pull_request" not in i]
```

---

## 最终监控范围

**官方**：`NousResearch/hermes-agent`
**个人**：20个 zengbaocheng 仓库

---

## Cron Job 配置

| 项目 | 值 |
|------|---|
| 任务名 | GitHub Issue 自动化监控 |
| 调度 | `0 */2 * * *`（每2小时） |
| 脚本 | `github_issue_monitor.py` |
| no_agent | true（纯脚本，不走 LLM） |
| 投递 | telegram:178274859 |
| job_id | b141a6c27ebc |

---

## 验证方法

```bash
# 手动跑脚本
GITHUB_TOKEN=$(grep "^GITHUB_TOKEN=" ~/.hermes/.env | cut -d= -f2) \
  python3 ~/.hermes/scripts/github_issue_monitor.py

# 期望：✅ 暂无新动态  或  ✅ 已推送 | N 个仓库有动态

# 看 cron job 列表
hermes cron list

# 看白名单
/home/zbc/.hermes/bin/tirith trust list
```