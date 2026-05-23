#!/bin/bash
# scripts/setup/sync-skills.sh
# 将 Hermes Tech Hub 中的技能同步到本地 Hermes 环境

set -e

HERMES_SKILLS_DIR="${HOME}/.hermes/skills"
HUB_SKILLS_DIR="$(cd "$(dirname "$0")/../../skills" && pwd)"

echo "🔄 同步技能到本地 Hermes 环境..."
echo "  来源: ${HUB_SKILLS_DIR}"
echo "  目标: ${HERMES_SKILLS_DIR}"

# 遍历所有技能目录
for skill_dir in "${HUB_SKILLS_DIR}"/*/; do
    skill_name=$(basename "${skill_dir}")
    
    if [ -f "${skill_dir}/SKILL.md" ]; then
        echo "  📦 安装技能: ${skill_name}"
        cp -r "${skill_dir}" "${HERMES_SKILLS_DIR}/${skill_dir##*/}" 2>/dev/null || true
    fi
done

echo "✅ 技能同步完成"
echo "💡 执行 '/reload-skills' 或重启 Hermes 使新技能生效"