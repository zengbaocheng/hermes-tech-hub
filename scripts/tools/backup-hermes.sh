#!/bin/bash
# scripts/tools/backup-hermes.sh
# Hermes 环境备份脚本

set -e

BACKUP_DIR="${HOME}/hermes-backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/hermes-backup-${TIMESTAMP}.tar.gz"

mkdir -p "${BACKUP_DIR}"

echo "📦 备份 Hermes 环境..."
echo "   输出: ${BACKUP_FILE}"

tar czf "${BACKUP_FILE}" \
    -C "${HOME}" \
    .hermes/skills/ \
    .hermes/config.yaml \
    .hermes/.env \
    --exclude='.hermes/sessions' \
    --exclude='.hermes/logs' \
    --exclude='.hermes/cache' \
    2>/dev/null

echo "✅ 备份完成: ${BACKUP_FILE}"
echo "   大小: $(du -h "${BACKUP_FILE}" | cut -f1)"