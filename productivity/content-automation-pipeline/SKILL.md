---
name: content-automation-pipeline
description: "中文内容自动化生产线 — 从选题→写作→发布的完整管线，源自大V实战复盘（2.2万阅读，2600转发）。适用于：想搭建自媒体自动化管线、需要选题/写作工作流、用Hermes做内容生产的用户。"
version: "1.1.0"
source: "https://mp.weixin.qq.com/s?__biz=MzkzMjkyMDExOA==&mid=2247485205&idx=1&sn=8921671fe1a010c08f9e83b274c7b4fb"
---
platforms: [linux, macos, windows]
metadata:
  tags: [内容自动化, 自媒体, AI写作, 选题, RSS, 知识库]
  triggers:
    - "搭建内容管线"
    - "内容自动"
    - "自媒体自动化"
    - "选题脚本"
    - "写作脚本"
    - "自动化写稿"
---

# 内容自动化生产线 Skill

> 来源：微信公众号大V实战复盘（2.2万阅读，2600转发）
> 原文：https://mp.weixin.qq.com/s?__biz=MzkzMjkyMDExOA==&mid=2247485205&idx=1&sn=8921671fe1a010c08f9e83b274c7b4fb
>
> ⚡ **核心原则：AI能做的事别自己做，但思考的时间不能省。**
>
> - 信源够不够 → 你的判断，AI只负责抓
> - 选题该不该写 → 你的判断，AI帮你算分
> - 观点够不够尖锐 → 你的思维，AI只会面面俱到
> - 原文里哪些重要 → 你的眼光，AI只会做摘要
> - 什么方向数据好 → 你的积累，AI只会看关键词

---

## 架构总览

```
信源层 → 选题层 → 写作层 → 发布层 → 知识沉淀
   ↓         ↓        ↓        ↓         ↓
 RSS/X/Twitter  Scout   Writer   Publisher  知识库
（180个源）  (评分)  (7阶段)  (一键)    (4类库)
```

**三栏Web界面**（可选）：
- 左栏：实时信源流（按评分/时间/类型过滤）
- 中栏：阅读器 + 编辑器（可并排对照）
- 右栏：工具箱 + 本地知识库

---

## 核心问题与答案

### Q1：信源够不够？
**原则：信源质量决定选题上限。20个高质量源 > 200个垃圾源。**

分层管理（可按需调整）：

| 等级 | 举例 | 权重系数 |
|------|------|---------|
| T1 官方一手 | OpenAI博客、Anthropic工程博客、Sam Altman推特 | ×1.15 |
| T1.5 权威账号 | OpenAI官推、DeepMind官推 | ×1.08 |
| T2 二手/媒体/KOL | TechCrunch、HackerNews、各类RSS | ×1.00 |

**180个信源构成**：
- RSS：83个（官方博客+垂直领域+Jina深度抓取）
- X：48个账号分8档（CEO和创始人35分→国产AI公司16分）
- GitHub Trending：12个仓库
- Reddit：18个板块
- Web搜索兜底

> 真实教训：Karpathy转发Thariq那条引爆讨论的推文，Scout因为只盯了几个账号+提取器易超时，慢了24小时才抓到。信源不全的代价就是永远慢半拍。

**信源获取渠道**：自己关注的、zarazhang的follow builders skill、youmind在X整理的、folo trend等。

### Q2：扫出来的东西怎么看？
**原则：看不见的东西总觉得心没底。**

→ 三栏布局可视化（见下方详细设计）
→ 信源流每30分钟刷新，评分/新鲜度/类型标签一目了然
→ 不需要SSH，用浏览器直接看

### Q3：哪些值得写？
**原则：选最没人写但值得写的。信息增量是选题的灵魂。**

**双层评分体系**：

**第一层：值不值得关注（attention_score）**
```
attention_score = min(100,
  (original_score^1.3) × 0.35
  + viral_score × 0.30
  + max(0, (freshness_score+15)/35) × 100 × 0.35
)
```
- 源质量（指数加权放大差距）+ 传播潜力 + 新鲜度
- <40分直接丢弃

**第二层：值不值得写（increment_score）**
```
increment_score =
  saturation_score × 0.40
  + novelty_score × 0.35
  + self_repeat_score × 0.25
```
- **饱和度**：同事件超25%实重叠率聚成一组，>10条→饱和度扣到20分
- **新颖度**：该话题候选里出现≤3次→60分，全新→100分，>10次→0分
- **自重复**：同实体同方向→10分，同实体不同方向→50分，全新→100分

**最终公式**：
```
final_score = min(100,
  attention_score × 0.55
  + increment_score × 0.25
  + feasibility_score × 0.20
) × tier_multiplier
```

其中 feasibility_score（可行性，满分45+）：
```
feasibility_score =
  min(45, cluster_size × 15)   # 事件聚类大小
  + fetchable                  # URL存在且非t.co短链 → +20
  + image_score               # 有配图 → +15
  + diversity_score           # min(20, source_type_diversity × 20)
```
- <55分淘汰，>70分候选，>85分强推

### Q4：人应该站在AI哪个环节？
**原则：原文是你的锚，没有锚AI就会飘。**

协作模式（核心）：
1. **先读原文** → 标注重点段落、加笔记、翻译
2. **再让AI写** → 边写边看7阶段进度（抓取→生成→审校→修订→排版→标题→配图）
3. **对照修改** → 阅读器和编辑器并列，原文和作品对照

→ 高亮/笔记自动进入知识库
→ 认为不行可以直接重写（不是审批，是协作）

### Q5：怎么让经验沉淀？
**原则：写到第50篇，靠的是积累不是灵感。**

四个知识库：
- **选题库**：所有候选+精选文章+近期话题
- **爆款库**：历史爆款标题、高频关键词、话题模式
- **历史库**：发布过的文章+阅读数据
- **策略库**：沉淀规则，如"AI方向最近数据好"、"对比型标题表现好"

**最简版**：一个笔记软件、一个表格、一个txt文件都行。关键是从今天开始记。

### Q6：从写完到发出去能否一个按钮？
**原则：任何需要超过3步的动作，最终都不会持续做。**

技术要点（4个坑）：
- **异步Job**：发布按钮创建Job，后端子进程运行（最长20分钟），前端SSE实时拉进度
- **多用户隔离**：通过环境变量注入路径，Agent代码一行不动
- **双格式保存**：HTML（发布用）+ Markdown（存档用），用Turndown转会有列表/代码块细节丢失
- **Cookie安全**：每个用户cookie存在自己目录，API层强制校验user_id

---

## 5个核心Prompt（最小版）

按顺序执行，搭建最小可跑版本。

### Prompt 1：搭骨架

在当前目录创建一个最小内容管线项目 content-pipeline/。目录结构：

```
content-pipeline/
├── scout.py          # 选题脚本
├── writer.py         # 写作脚本
├── publisher.py      # 发布脚本
├── config.py         # 配置
├── prompts/          # prompt模板
│   ├── write.md      # 写作prompt
│   └── review.md     # 审校prompt
├── queue/            # 数据队列
│   ├── pending/
│   ├── published/
│   └── failed/
└── requirements.txt
```

config.py 定义：
- LLM_API_KEY 从环境变量读取
- LLM_BASE_URL 默认 https://api.openai.com/v1
- LLM_MODEL 默认 gpt-4o
- RSS_FEEDS：10个科技源（Hacker News、TechCrunch、The Verge、Ars Technica、OpenAI Blog、Anthropic Blog、MIT Technology Review、Wired、VentureBeat、Google AI Blog）
- QUEUE_DIR 指向 queue/
- SCORE_THRESHOLD 默认 50

requirements.txt 写入依赖：feedparser, requests, openai, markdown

创建所有目录和空文件。

---

### Prompt 2：选题脚本

实现 content-pipeline/scout.py，从RSS源筛选选题。

核心逻辑：
1. feedparser 遍历 config.RSS_FEEDS
2. 每篇提取：title, link, source, summary（前200字）, published
3. 打分：
   - source_weight：Hacker News=25, TechCrunch=20, 官方博客=25, 其他=10
   - freshness：24h内+20, 48h内+10, 超48h -15
   - keyword_boost：标题/摘要含(AI, agent, LLM, GPT, Claude, model, open source)每个+5，上限+15
   - score = source_weight + freshness + keyword_boost
4. 按score降序，取前10个
5. 输出 queue/scout_results.json
   格式：`[{"topic":"标题","url":"链接","source":"来源","score":分,"freshness":"爆发期/热议期/已过期","summary":"摘要"}]`

去重：相同URL只保留一条。打印进度 "正在扫描 X/Y 个RSS源..."

命令行：`python3 scout.py --count 10`

---

### Prompt 3：写作脚本

实现 content-pipeline/writer.py，用LLM生成文章并降AI味。

核心逻辑：
1. 读 queue/scout_results.json，取第一个选题（或 --index N）
2. requests抓URL内容，提取正文前3000字。失败则只用summary
3. 读 prompts/write.md 填充模板，调LLM生成初稿
4. 读 prompts/review.md 审校初稿，LLM返回修改版
5. 正则跑AI腔自动替换（见下方规则）
6. 保存 queue/pending/{YYYYMMDD-HHMMSS}-{type}.md + .meta.json
   meta: `{"topic":"","url":"","score":0,"type":"article/micro","word_count":0,"ai_slop_count":0}`

**AI腔自动替换规则**：
- "在当今时代"→删
- "综上所述"→删
- "值得注意的是"→删
- "不仅.*而且"→拆短句
- "显著提升"→"提升了很多"
- "旨在"→"为了"
- "致力于"→"一直在做"
- "一方面.*另一方面"→只保留一方
- "许多"/"一些"/"大量"→标记【需具体数字】

prompts/write.md 内容：
```
你是一个中文科技自媒体写手。根据原始材料写一篇{type}。
风格：口语化，有观点有态度，用具体数字不要说许多。
不用这些词：在当今时代、综上所述、值得注意的是、不仅…而且、显著提升、旨在、致力于。
文章1500-3000字，微头条300-800字。开头3秒抓住读者。
原始材料：{source_content}
```

prompts/review.md 内容：
```
你是严格的中文编辑。审校文章去AI痕迹。
6维度扣分：套话-8/处，AI句式-5/处，书面词汇-3/处，
机械结构-5/处，态度中立-8/处，细节缺失-5/处。
满分100。输出JSON：{"score":0,"issues":[],"revised_text":""}
```

命令行：`python3 writer.py --type article --index 0`
打印进度：抓取→生成→审校→保存

---

### Prompt 4：发布脚本

实现 content-pipeline/publisher.py，格式化输出文章。

逻辑：
1. 扫描 queue/pending/ 找最新.md文件
2. Markdown转HTML（用markdown库）
3. 输出到 queue/published/{filename}.html 和 .md
4. 打印 "已生成HTML，请复制到头条/公众号后台发布"

命令行：`python3 publisher.py`（最新）/ `--all`（全部）/ `--file XXX.md`（指定）

---

### Prompt 5：定时任务

创建 content-pipeline/run-pipeline.sh。

用法：`./run-pipeline.sh [slot]`
slot：morning(06:00) / noon(11:30) / evening(17:00) / night(20:30)

流程：打印开始→scout.py --count 5→按slot写N篇
（morning=1, noon=1, evening=2, night=0）→publisher.py --all→打印完成摘要

crontab配置示例：
```bash
0 6 * * * cd /path/to/content-pipeline && ./run-pipeline.sh morning
30 11 * * * cd /path/to/content-pipeline && ./run-pipeline.sh noon
0 17 * * * cd /path/to/content-pipeline && ./run-pipeline.sh evening
30 20 * * * cd /path/to/content-pipeline && ./run-pipeline.sh night
```

**合并版Prompt**：把5个Prompt合并为一个，加开头一句"按顺序完成以下5个任务，每个完成后再开始下一个"，一口气搭出最小版。

---

## 三栏Web界面设计（可选升级）

### 左栏：信源流
- 实时信源（30分钟刷新）+ 精选新源 + 高分选题
- 时间线排列，附评分/来源/新鲜度标签
- 支持搜索、按类型过滤（RSS/Twitter/Web）
- 全屏模式可用

### 中栏：阅读器 + 编辑器
- 阅读模式：高亮重点段落 + 添加笔记 + 实时翻译英文
- 编辑模式：与阅读器并列（split view）
- 7阶段进度条：抓取原文→AI写作→AI腔审校→批评修订→排版处理→标题优化→配图生成

### 右栏：工具箱 + 知识库
- 当前文章信息
- 本地知识库（选题库/爆款库/历史库/策略库）
- 高亮/笔记/翻译自动入库

---

## 迭代路径

| 阶段 | 规模 | 关键升级 |
|------|------|---------|
| 最小版 | 10个RSS + 单层评分 | 跑通流程 |
| 基础版 | 50个源 + 双层评分 + 6条AI腔规则 | 质量提升 |
| 完整版 | 180个源 + 完整评分体系 + 100条规则 + 浏览器自动化 | 生产级 |
| 旗舰版 | 多用户 + Web界面 + 异步Job + 一键发布 | 一站式 |

**原则：完美不是第一天的事，跑通才是。**

---

## 核心原则（精华摘录）

> AI能做的事，别自己做。但你该想的事，别让AI替你想。

- **信源够不够** → 你的判断，AI只负责抓
- **选题该不该写** → 你的判断，AI帮你算分
- **观点够不够尖锐** → 你的思维，AI只会面面俱到
- **原文里哪些重要** → 你的眼光，AI只会做摘要
- **什么方向数据好** → 你的积累，AI只会看关键词

---

## 使用方式

1. **用Prompt搭建**：将5个Prompt按顺序（或合并后一次）丢给任何AI Coding Agent
2. **用Hermes Cron**：搭配Hermes定时任务，每天定时跑 `run-pipeline.sh`
3. **升级完整版**：一个模块一个模块升级，从最小版到生产级