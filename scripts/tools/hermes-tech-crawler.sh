#!/usr/bin/env bash
# ==============================================================
# hermes-tech-crawler.sh
# 自动爬取 GitHub 上 Hermes Agent 相关技术项目
# 用法: ./hermes-tech-crawler.sh [--push]
# ==============================================================
set -euo pipefail

HUB_DIR="/tmp/hermes-tech-hub"
GITHUB_TOKEN=$(grep GITHUB_TOKEN ~/.hermes/.env 2>/dev/null | cut -d= -f2- || echo "")

if [ -z "$GITHUB_TOKEN" ]; then
  echo "错误: 未找到 GITHUB_TOKEN" >&2
  exit 1
fi

# 确保仓库存在
if [ ! -d "$HUB_DIR/.git" ]; then
  echo "首次运行，克隆仓库..."
  git clone https://zengbaocheng:${GITHUB_TOKEN}@github.com/zengbaocheng/hermes-tech-hub.git "$HUB_DIR"
fi

cd "$HUB_DIR"
git fetch origin
git reset --hard origin/main

mkdir -p vendors/{hermes-ecosystem,skills-collection,mcp-servers,memory-systems,planning-workflows,management-tools}

# 搜索查询列表（按优先级）
SEARCH_QUERIES=(
  "hermes+agent+topic:ai-agent"
  "topic:hermes-agent"
  "claude+code+skill+topic:agent-skills"
  "topic:mcp-server+topic:ai"
  "hermes+skill+OR+agent+skill+topic:skill"
  "topic:autonomous-agent+topic:ai"
  "topic:model-context-protocol"
)

fetch_repo_info() {
  local repo="$1"
  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$repo" 2>/dev/null
}

categorize_repo() {
  local topics="$1"
  local lang="$2"
  local desc="$3"
  
  # MCP 相关
  if echo "$topics" | grep -qi "mcp\|model-context-protocol"; then
    echo "mcp-servers"
  # 记忆系统
  elif echo "$topics" | grep -qi "memory\|memor" || echo "$desc" | grep -qi "memory.*agent\|agent.*memory"; then
    echo "memory-systems"
  # 规划工作流
  elif echo "$topics" | grep -qi "planning\|workflow" || echo "$desc" | grep -qi "planning\|workflow"; then
    echo "planning-workflows"
  # 管理工具
  elif echo "$topics" | grep -qi "dashboard\|panel\|admin\|control-room" || echo "$desc" | grep -qi "dashboard\|panel\|management"; then
    echo "management-tools"
  # 技能集合
  elif echo "$topics" | grep -qi "skill\|agent-skills\|coding" || echo "$desc" | grep -qi "skill\|claude.*skill\|collection.*skill"; then
    echo "skills-collection"
  # 默认: Hermes 生态
  else
    echo "hermes-ecosystem"
  fi
}

NEW_REPOS=0
SKIPPED_REPOS=0

# 遍历每个搜索查询
echo "🔍 开始搜索 Hermes 相关技术..."
for query in "${SEARCH_QUERIES[@]}"; do
  echo "  → 搜索: $query"
  
  # 搜索 GitHub
  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/search/repositories?q=${query}&sort=stars&per_page=10" \
    | python3 -c "
import sys,json
data=json.load(sys.stdin)
for r in data.get('items',[]):
    print(f\"{r['full_name']}|{r['stargazers_count']}|{r['language'] or ''}|{','.join(r.get('topics',[]))}|{r.get('html_url','')}|{r.get('description','')[:100]}\")
" | while IFS='|' read -r repo stars lang topics url desc; do
    # 跳过已经存在的项目
    if find vendors/ -name ".meta" -exec grep -l "^${repo}|" {} \; | grep -q .; then
      SKIPPED_REPOS=$((SKIPPED_REPOS + 1))
      continue
    fi
    
    # 跳过低星项目（<100星）
    if [ "$stars" -lt 100 ]; then
      SKIPPED_REPOS=$((SKIPPED_REPOS + 1))
      continue
    fi
    
    # 确定分类
    category=$(categorize_repo "$topics" "$lang" "$desc")
    safe_name=$(echo "$repo" | tr '/' '-' | tr '[:upper:]' '[:lower:]')
    
    echo "    ✅ 新增: $repo (⭐$stars) → $category/$safe_name"
    
    mkdir -p "vendors/$category/$safe_name"
    
    # 保存元数据
    echo "${repo}|${stars}|${lang}|${desc}|${url}|${topics}" > "vendors/$category/$safe_name/.meta"
    
    # 获取 README
    curl -s -L -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.raw" \
      "https://api.github.com/repos/$repo/readme" \
      -o "vendors/$category/$safe_name/README.md" 2>/dev/null || \
      echo "# $repo\n\n> 自动爬取: $url\n\nREADME 不可用" > "vendors/$category/$safe_name/README.md"
    
    NEW_REPOS=$((NEW_REPOS + 1))
  done
done

echo ""
echo "📊 爬取报告:"
echo "  新增项目: $NEW_REPOS"
echo "  跳过（已存在/低星）: $SKIPPED_REPOS"

# 更新 vendors/README.md 索引
bash -c "
cat > vendors/README.md << 'ENDMARKER'
# 🌐 外部技术资源库

> 自动从 GitHub 爬取的 Hermes Agent 生态相关开源项目
> 定时更新: $(date '+%Y-%m-%d %H:%M')

ENDMARKER

for cat_dir in vendors/*/; do
  c=\$(basename "\$cat_dir")
  if [ "\$c" = "README.md" ]; then continue; fi
  count=\$(find "\$cat_dir" -name '.meta' | wc -l)
  
  echo \"### \$(echo \$c | tr '-' ' ' | sed 's/.*/\\u&/')\" >> vendors/README.md
  echo \"| 项目 | ⭐ 星 | 语言 | 说明 |\" >> vendors/README.md
  echo \"|------|:----:|:----:|------|\" >> vendors/README.md
  
  for proj_dir in \"\$cat_dir\"*/; do
    meta=\"\$proj_dir.meta\"
    if [ -f \"\$meta\" ]; then
      IFS='|' read -r name stars lang desc url topics < \"\$meta\"
      echo \"| [\$name](\$proj_dir) | ⭐\$stars | \$lang | \${desc:0:60} |\" >> vendors/README.md
    fi
  done
  echo \"\" >> vendors/README.md
done
"

# 更新集成指南中的统计
echo ""
echo "✅ vendors/README.md 索引已更新"
echo "ℹ️  运行 --push 参数可将更改提交并推送到 GitHub"

# 如果指定了 --push
if [ "\${1:-}" = "--push" ]; then
  git add -A
  git commit -m "vendors: 自动爬取更新 $(date '+%Y-%m-%d')" 2>/dev/null || echo "  无新更改"
  git push origin main
  echo "✅ 已推送到 GitHub"
fi