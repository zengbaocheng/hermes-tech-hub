---
metadata:
  hermes:
    tags:
    - GitHub
    - gh-cli
    - CLI
    - Repository
    - Issue
    - PR
    - Actions
    - Release
    related_skills:
    - github-auth
    - github-pr-workflow
    - github-code-review
    - github-issues
    - github-repo-management
  version: 1.0.0
  author: 马丞相
  platforms:
  - linux
  - macos
description: gh CLI 全能操作技能 - 仓库/Issues/PR/Release/Gist/Actions/Secrets 全功能管理
name: gh-cli-operations
---
# gh CLI 全能操作技能

> GitHub CLI (`gh`) 的多平台管理技能。适用于创建仓库、管理 Issues、处理 PR、发布 Release、管理 Gist、搜索、操作 Secrets/变量等各种场景。

## 环境检测

```bash
# 检查 gh 是否安装
command -v gh &>/dev/null && echo "gh $(gh --version | head -1)" || echo "gh 未安装"

# 检查认证状态
gh auth status 2>&1 | head -3

# 检查当前仓库上下文（若有）
gh repo view --json nameWithOwner 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);print(f'当前仓库: {d[\"nameWithOwner\"]}')" 2>/dev/null || echo "不在 GitHub 仓库目录"
```

## 安装 gh CLI（无 sudo）

```bash
# 方法一：直接下载二进制（推荐，无 root 依赖）
GH_VERSION="2.67.0"
curl -sL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" -o /tmp/gh.tar.gz
tar xzf /tmp/gh.tar.gz -C /tmp/
mkdir -p ~/.local/bin
cp /tmp/gh_${GH_VERSION}_linux_amd64/bin/gh ~/.local/bin/
chmod +x ~/.local/bin/gh
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
gh --version

# 方法二：apt（需要 sudo，仅限 Debian/Ubuntu）
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
sudo apt update && sudo apt install gh
```

## 认证

```bash
# Token 登录（headless 服务器最常用）
echo "<GITHUB_TOKEN>" | gh auth login --with-token

# 交互式登录（桌面环境）
gh auth login
# 选 GitHub.com → HTTPS → Login with a web browser

# 配置 git 凭证（让 gh 管理 git 认证）
gh auth setup-git

# 查看状态
gh auth status

# 查看 Token 权限范围
gh auth status 2>&1 | grep "Token scopes"

# 登出
gh auth logout
```

**⚠️ 常见陷阱：全局 `url.insteadof` 配置会覆盖 SSH 地址**
```bash
# 检查是否有 HTTPS 强转配置
git config --global --list | grep insteadof

# 若有，删除之（否则 SSH 推送永远走 HTTPS）
git config --global --unset-all url.https://github.com/.insteadof
```

## 仓库操作

### 创建仓库
```bash
# 创建公开仓库（默认当前目录名）
gh repo create <repo-name> --public --description "description"

# 创建私有仓库
gh repo create <repo-name> --private --description "description"

# 从当前目录创建并推送已有代码
cd /path/to/existing/project
gh repo create <repo-name> --public --source=. --remote=origin --push
```

### 克隆/复刻
```bash
# 克隆
gh repo clone <owner>/<repo>
gh repo clone <owner>/<repo> <target-dir>

# 复刻（fork）
gh repo fork <owner>/<repo> --clone

# 复刻到组织
gh repo fork <owner>/<repo> --org <org-name>
```

### 查看仓库信息
```bash
# 基本信息
gh repo view <owner>/<repo>

# JSON 格式（灵活提取字段）
gh repo view <owner>/<repo> --json name,description,url,owner,forkCount,stargazerCount

# 列出仓库列表
gh repo list <owner> --limit 30 --json name,description,updatedAt

# 仓库语言分布
gh repo view <owner>/<repo> --json languages
```

### 仓库设置
```bash
# 修改描述
gh repo edit <owner>/<repo> --description "new description"

# 添加 Topics
gh repo edit <owner>/<repo> --add-topic "topic1" --add-topic "topic2"

# 设置默认分支
gh repo edit <owner>/<repo> --default-branch main

# 启用/禁用 Wiki、Issues、Projects
gh repo edit <owner>/<repo> --enable-wiki=false
gh repo edit <owner>/<repo> --enable-issues=false

# 删除仓库
gh repo delete <owner>/<repo> --confirm
```

## Issue 管理

```bash
# 列出 Issues（默认 open）
gh issue list --limit 20
gh issue list --state all --label "bug"
gh issue list --author <username> --assignee <username>
gh issue list --json number,title,state,labels,assignees

# 创建 Issue
gh issue create --title "Issue title" --body "Issue body"
gh issue create --title "Bug report" --body-file bug-report.md
gh issue create --label "bug" --assignee @me

# 查看 Issue
gh issue view <number>
gh issue view <number> --json title,body,comments

# 关闭/重开 Issue
gh issue close <number>
gh issue reopen <number>

# 添加评论
gh issue comment <number> --body "comment text"
```

## PR 管理

```bash
# 列出 PRs
gh pr list --limit 20
gh pr list --base main --state open
gh pr list --author @me

# 创建 PR
gh pr create --title "PR title" --body "PR description"
gh pr create --base main --title "feat: xxx" --body "Closes #123"
gh pr create --draft --title "WIP: xxx"

# 查看 PR
gh pr view <number>
gh pr view <number> --json title,body,additions,deletions,files

# 审查 PR
gh pr review <number> --approve
gh pr review <number> --request-changes --body "fix please"
gh pr review <number> --comment --body "looks good"

# 合并 PR
gh pr merge <number> --merge        # 合并提交
gh pr merge <number> --squash       # 压缩合并
gh pr merge <number> --rebase       # 变基合并
gh pr merge <number> --delete-branch  # 合并后删除分支

# 检出 PR 到本地
gh pr checkout <number>

# 添加 PR 评论
gh pr comment <number> --body "review notes"
```

## Release 管理

```bash
# 列出 Releases
gh release list --limit 10
gh release list --json tagName,isLatest,publishedAt

# 创建 Release
gh release create v1.0.0 --title "v1.0.0" --notes "Release notes"
gh release create v1.0.0 --generate-notes  # 自动生成 release notes
gh release create v1.0.0 --notes-file changelog.md

# 上传附件
gh release upload v1.0.0 ./dist/app.zip

# 下载 Release
gh release download v1.0.0
gh release download v1.0.0 --pattern "*.zip" --dir ./downloads

# 删除 Release
gh release delete v1.0.0 --yes
```

## Gist 管理

```bash
# 创建 Gist
gh gist create file.py
gh gist create file.py -d "description"  # 带描述
gh gist create *.py                      # 多文件
gh gist create --public file.py          # 公开（默认是 secret）

# 列出 Gists
gh gist list --limit 20

# 查看 Gist
gh gist view <gist-id>
gh gist view <gist-id> --files file.py   # 查看特定文件

# 编辑 Gist（下载再上传）
gh gist clone <gist-id>  # 克隆到本地编辑后推送
```

## GitHub Actions 管理

```bash
# 列出 Workflows
gh workflow list
gh workflow list --json name,state,path

# 手动触发 Workflow
gh workflow run <workflow-name> --ref main
gh workflow run <workflow-name> -f param1=value1 -f param2=value2

# 查看 Workflow Runs
gh run list --limit 10
gh run list --workflow <workflow-name> --branch main

# 查看 Run 详情
gh run view <run-id>
gh run view <run-id> --log  # 查看完整日志

# 下载 Workflow Artifacts
gh run download <run-id>

# 重试失败的 Run
gh run rerun <run-id>

# 取消 Run
gh run cancel <run-id>

# 管理 Actions Cache
gh cache list
gh cache delete <cache-key>
```

## Secrets 和 Variables

```bash
# 列出 Secrets
gh secret list
gh secret list --org <org-name>

# 设置 Secret
gh secret set <KEY_NAME> --body "secret-value"
gh secret set <KEY_NAME> --body "$(cat /path/to/key.pem)"

# 删除 Secret
gh secret remove <KEY_NAME>

# 列出 Variables
gh variable list
gh variable set <VAR_NAME> --body "value"

# 设置环境级别（repo/org/environment）
gh secret set <KEY_NAME> --env <env-name>
```

## 搜索

```bash
# 搜索仓库
gh search repos "keyword" --limit 20
gh search repos "topic:awesome" --sort stars

# 搜索 Issues/PRs
gh search issues "bug in login" --state open
gh search prs "fix" --author @me --limit 10

# 搜索代码（需要 GitHub Code Search beta）
gh search code "function_name" --owner <owner>
```

## API 原生调用

当 gh 没有对应命令时，直接用 `gh api` 访问 REST API：

```bash
# GET 请求
gh api /repos/{owner}/{repo}
gh api /repos/{owner}/{repo}/labels
gh api /repos/{owner}/{repo}/git/trees/main?recursive=1

# POST 请求
gh api /repos/{owner}/{repo}/labels -f name=enhancement -f color=84b6eb

# DELETE 请求
gh api -X DELETE /repos/{owner}/{repo}/labels/enhancement

# 分页获取全部结果（--paginate）
gh api /repos/{owner}/{repo}/issues --paginate

# 获取 JSON 并提取字段
gh api /user --jq '.login'
gh api /repos/{owner}/{repo} --jq '.stargazers_count'

# 列出仓库所有文件（大仓库用分页）
gh api /repos/{owner}/{repo}/git/trees/main?recursive=1 --jq '.tree[].path' | head -50
```

## 分支和标签管理

```bash
# 列出分支（gh api 实现，gh 无原生分支命令）
gh api /repos/{owner}/{repo}/branches --jq '.[].name'

# 创建分支（从 GitHub 端创建）
git checkout -b feature-branch
git push origin feature-branch

# 列出 Tags
gh api /repos/{owner}/{repo}/tags --jq '.[].name'

# 创建 Tag（本地创建再推送）
git tag v1.0.0
git push origin v1.0.0
```

## Webhook 管理

```bash
# 列出 Webhooks
gh api /repos/{owner}/{repo}/hooks --jq '.[].config.url'

# 创建 Webhook
gh api /repos/{owner}/{repo}/hooks \
  -f name=web \
  -f config[url]="https://example.com/webhook" \
  -f config[content_type]=json \
  -f events[0]=push \
  -f active=true

# 删除 Webhook
gh api -X DELETE /repos/{owner}/{repo}/hooks/<hook-id>
```

## 实用技巧

### JSON 输出 + jq 过滤

```bash
# gh 支持 --json 输出 + --jq 过滤（比完整 json 解析高效）
gh repo view --json name,owner,createdAt --jq '.name + " by " + .owner.login'

# 组合多个查询
gh issue list --json number,title,labels --jq '.[] | select(.labels | length == 0) | .number'
```

### 多个仓库批量操作

```bash
# 批量列出所有仓库
gh repo list <owner> --limit 100 --json name | \
  python3 -c "import json,sys; [print(r['name']) for r in json.load(sys.stdin)]" | \
  while read repo; do
    echo "=== $repo ==="
    gh api /repos/<owner>/$repo --jq '.stargazers_count'
  done
```

### 使用 gh 环境变量

```bash
# GH_HOST 指定 GitHub Enterprise 实例
export GH_HOST=github.mycompany.com

# GH_TOKEN / GITHUB_TOKEN 指定 Token（环境变量优先级高于配置文件）
export GH_TOKEN=<token>
# 或在 .env 中设置
export GITHUB_TOKEN=<token>
```

### 别名（Alias）配置

```bash
# 创建快捷别名
gh alias set ls "repo list"
gh alias set iv "issue view"
gh alias set pc "pr create"

# 之后可用
gh ls --limit 20
gh iv 123
```

## 故障排除

| 问题 | 原因 | 解决 |
|:---|:---|:---|
| `gh: command not found` | 未安装 | 下载二进制到 `~/.local/bin/` |
| `HTTP 403: Resource not accessible` | Token 权限不足 | 去 GitHub 更新 Token scopes |
| `Permission to X.git denied` | token 只读 | 需要 `repo` scope |
| `git push` 走 HTTPS 失败 | credential 配置问题 | `gh auth setup-git` 重配 |
| SSH 不工作 | `url.insteadof` 强转 HTTPS | `git config --global --unset-all url.https://github.com/.insteadof` |
| `GraphQL: Resource not accessible` | Fine-grained PAT 缺权限 | 检查 Repository permissions |
| 搜索结果不全 | 未加 `--limit` | 默认 limit=30，显式设大值 |
| JSON 解析报错 | Token 无效或过期 | `gh auth login` 重新认证 |
