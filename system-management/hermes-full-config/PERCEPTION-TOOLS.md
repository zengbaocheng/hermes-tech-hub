---
name: perception-tools
description: Hermes 感知能力配置 - 内容抓取工具 + 搜索与文档处理工具
version: 1.0.0
author: hermes-self-learner
metadata:
  tags: [crawling, search, document-processing, perception]
---

# 感知能力配置

## 内容抓取工具

| 工具 | 用途 | 特点 |
|------|------|------|
| Jina Reader | 单页抓取 | 极简集成 |
| Crawl4 AI | 批量深度抓取 | 支持批量 |
| Scrapling | 反爬绕过 | 绕过反爬 |
| CamoFox | 隐身浏览器 | 官方原生支持 |

安装命令：
```bash
hermes tools + pip install camofox scrapling
```

---

## 搜索与文档处理工具

### 搜索工具

| 工具 | 特点 | 免费额度 |
|------|------|----------|
| Tavily | AI 专用搜索 | 1000次/月 |
| DuckDuckGo | 零成本兜底搜索 | 无限 |

### 文档处理工具

| 工具 | 用途 |
|------|------|
| Pandoc | 万能格式转换器 |
| Marker | PDF 转 Markdown 增强 |

安装完成后：
- 搜索能力：Tavily（主力）+ DuckDuckGo（兜底）
- 文档处理：任意格式互转 + 高精度 PDF 文件提取

---

## 使用示例

```bash
# 单页抓取
jina reader https://example.com

# 批量抓取
crawl4ai --urls "url1,url2,url3"

# AI 搜索
tokscale search "你的问题"

# 文档转换
pandoc input.pdf -o output.md
```
