---
name: auto-file-cleanup
description: 自动文件清理机制 - 当生成文件超过10G时自动删除最早的文件
version: 1.0.0
author: 马丞相
metadata:
  tags: [auto-cleanup, file-management]
---

# 自动文件清理机制

## 重要说明

**只删除各角色执行任务时生成的文件和文档**，系统依赖的配置文件和文档**没有授权不能删除**。

## 功能概述

1. **定期检查**：检查任务生成文件的总大小
2. **自动清理**：当超过 10G 时删除最早生成的任务文件
3. **汇报结果**：向主上汇报清理结果
4. **严格保护**：不删除任何系统依赖文件

## 文件分类

### 可清理：任务生成文件（执行任务时产生）

| 目录 | 说明 |
|------|------|
| /home/zbc/*.docx | 生成的 Word 文档 |
| /home/zbc/*.pdf | 生成的 PDF 文档 |
| /home/zbc/*.txt | 生成的文本文件 |
| /home/zbc/*.csv | 生成的 CSV 数据文件 |
| /home/zbc/*.json | 生成的 JSON 文件 |
| /home/zbc/*.zip | 下载的压缩包 |
| /home/zbc/*.mp4 / *.mp3 | 生成的媒体文件 |
| /home/zbc/images/ | 生成的图片 |
| /home/zbc/downloads/ | 下载的文件 |
| ~/.hermes/sessions/*.json | 旧的会话文件（可选） |

### 严格保护：系统依赖文件（禁止删除）

| 目录/文件 | 说明 |
|-----------|------|
| ~/.hermes/config.yaml | Hermes 配置文件 |
| ~/.hermes/.env | API 密钥配置 |
| ~/.hermes/skills/ | 所有技能文件 |
| ~/.hermes/hermes-agent/ | Hermes 源代码 |
| ~/.hermes/auth.json | 认证文件 |
| ~/.hermes/vendor_models.json | 模型状态文件 |
| ~/.hermes/cron/ | 定时任务配置 |
| /home/zbc/.ssh/ | SSH 密钥 |
| /home/zbc/.hermes/ | 同上，Hermes 配置 |
| 所有 .py 文件 | Python 代码文件 |
| 所有 .sh 文件 | 脚本文件 |
| 所有 .yaml/.yml 文件 | 配置文件 |

## 触发条件

- **总大小 > 10GB**：开始清理最早的文件
- **每次清理**：删除最早生成的 20% 文件
- **最低保留**：至少保留最近 5 个文件

## 执行流程

```
定时触发（每小时） 或 手动触发
         │
         ▼
┌─────────────────────────┐
│ 扫描生成文件目录        │
│ (/home/zbc/, sessions/) │
└─────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 计算总大小              │
└─────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 大小 > 10GB?            │
│ 是 → 继续               │
│ 否 → 结束               │
└─────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 按创建时间排序          │
│ 删除最早的文件          │
└─────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│ 向主上汇报结果          │
└─────────────────────────┘
```

## 清理规则

1. **只清理任务生成文件**：.docx, .pdf, .txt, .csv, .json, .zip, .mp4, .mp3, images/, downloads/
2. **严格保护系统文件**：任何 .hermes 目录内容、.py、.sh、.yaml、.env 文件绝对不删
3. **保护技能文件**：~/.hermes/skills/ 下所有文件不删
4. **保护配置**：config.yaml, .env, auth.json, vendor_models.json 等不删
5. **分批删除**：每次删除 20% 最早的任务文件，直到低于 10G

## 严格保护的文件类型（禁止删除）

```json
{
  "protected_extensions": [".py", ".sh", ".yaml", ".yml", ".env", ".json"],
  "protected_dirs": [
    ".hermes/",
    ".hermes/skills/",
    ".hermes/hermes-agent/",
    ".hermes/cron/",
    ".ssh/",
    "skills/"
  ],
  "protected_files": [
    "config.yaml",
    ".env",
    "auth.json",
    "vendor_models.json",
    "AGENTS.md",
    "CLAUDE.md"
  ]
}
```

**注意**：即使任务生成的文件是 .json 或 .docx，如果是重要配置或文档，也需要确认后再删。

## 汇报模板

### 正常情况（无需清理）

```
【文件清理检查报告】
⏰ 时间: YYYY-MM-DD HH:MM

📊 监控目录大小:
 - /home/zbc/: 2.5GB (无需清理)
 - ~/.hermes/sessions/: 1.2GB
 - ~/.hermes/logs/: 0.3GB

✅ 总计: 4.0GB < 10GB，无需清理

【检查完成】
```

### 需要清理

```
【文件清理报告】
⏰ 时间: YYYY-MM-DD HH:MM

📊 清理前大小:
 - /home/zbc/: 11.2GB ⚠️

🔄 已删除文件（最早生成）:
 - /home/zbc/download_2024_01_01.zip (2.1GB)
 - /home/zbc/video_2024_01_03.mp4 (1.8GB)
 - /home/zbc/backup_2024_01_05.tar (1.5GB)
 ... 共删除 5 个文件，释放 8.2GB

📊 清理后大小:
 - /home/zbc/: 3.0GB ✓

【清理完成】
```

### 无法清理（需主上干预）

```
【⚠️ 文件清理警告】

⏰ 时间: YYYY-MM-DD HH:MM

❌ 尝试清理失败
   原因: 磁盘空间不足，无法创建临时文件

📊 当前状态:
 - /home/zbc/: 12.5GB
 - 可用空间: 0.5GB

💡 建议方案:
 1. 手动删除大文件
 2. 清理系统日志
 3. 扩容磁盘

请主上处理。
```

## 执行方式

1. **自动**：每小时检查一次
2. **手动**：加载 skill 后说"检查文件大小"或"清理文件"

## 相关命令

```bash
# 查看各目录大小
du -sh /home/zbc/*
du -sh ~/.hermes/sessions/
du -sh ~/.hermes/logs/

# 查看文件创建时间
ls -lt /home/zbc/ | head -20

# 手动清理（示例）
rm /home/zbc/最旧的文件名
```