---
name: html-screenshot-image-gen
description: "Free image generation using HTML templates + browser screenshot. Zero API calls. Perfect for WeChat public accounts, data cards, and infographic-style images."
version: 1.0.0
author: Hermes Agent (inspired by 娇姐's tutorial)
license: MIT
dependencies: []
metadata:
  hermes:
    tags: [Image, Screenshot, HTML, Infographic, WeChat, Free, No-API]
    trigger_phrases:
      - "做成信息图"
      - "做成数据卡片"
      - "生成封面"
      - "做一张对比图"
      - "生成图片"
      - "做成金句图"
    related_skills: [excalidraw, baoyu-infographic]

---

# HTML Screenshot Image Generator

用 HTML 模板 + 浏览器截图实现零成本生图。适合公众号配图、数据卡片、信息图、金句图。

**核心优势：**
- 完全免费，不调用任何生图 API
- 版式精确可控，像素级排版
- 中文渲染完美
- 风格统一可复用

## 工作流（三步出图）

```
Step 1: write_file → 保存 HTML 文件到 /tmp/img-output/card.html
Step 2: browser_navigate → 打开 HTML 文件
Step 3: browser_vision → 截图保存
```

## 模板 A：米色暖系（公众号配图/教程步骤图）

**配色：** 背景 #f5f0e8，强调色 #8b6f47（棕褐）

```html
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { 
    width: 1080px; 
    min-height: 1920px;
    background: #f5f0e8; 
    padding: 60px; 
    font-family: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
  }
  .card { 
    background: #fffdf8; 
    border-radius: 20px; 
    padding: 50px;  
    box-shadow: 0 4px 30px rgba(0,0,0,0.06);
  }
  .title {
    font-size: 42px;
    font-weight: 800;
    color: #3d3d3d;
    line-height: 1.4;
    margin-bottom: 40px;
  }
  .title span { color: #8b6f47; }
  .step { display: flex; align-items: flex-start; margin: 24px 0; gap: 20px; }
  .num { 
    background: #8b6f47; 
    color: white; 
    border-radius: 50%; 
    width: 42px; 
    height: 42px; 
    display: flex; 
    align-items: center; 
    justify-content: center;
    font-size: 18px;
    font-weight: 700;
    flex-shrink: 0;
  }
  .step-text {
    font-size: 28px;
    color: #4a4a4a;
    line-height: 1.6;
    padding-top: 6px;
  }
  .footer {
    margin-top: 50px;
    font-size: 20px;
    color: #999;
    text-align: right;
  }
  .divider {
    height: 2px;
    background: linear-gradient(to right, #8b6f47, transparent);
    margin: 30px 0;
  }
</style>
</head>
<body>
<div class="card">
  <div class="title">{{TITLE}}</div>
  <div class="divider"></div>
  {{STEPS_HTML}}
  <div class="footer">{{FOOTER}}</div>
</div>
</body>
</html>
```

**Steps HTML 格式：**
```html
<div class="step">
  <div class="num">1</div>
  <div class="step-text">步骤内容</div>
</div>
```

## 模板 B：深色极简（数据卡片/金句图/朋友圈）

**配色：** 背景 #0d0d0d，强调色 #4ade80（荧光绿）

```html
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { 
    width: 1080px; 
    min-height: 1080px;
    background: #0d0d0d; 
    padding: 60px; 
    font-family: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
  }
  .card { 
    background: #141414; 
    border: 1px solid #2a2a2a;        
    border-radius: 16px; 
    padding: 56px;
    min-height: 960px;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  h1 { 
    color: #ffffff; 
    font-size: 56px; 
    font-weight: 800; 
    line-height: 1.3;
    margin-bottom: 40px;
  }
  h1 span { color: #4ade80; }
  .stat { 
    font-size: 88px; 
    font-weight: 800; 
    color: #4ade80;
    margin: 30px 0;
    font-family: 'Arial Black', sans-serif;
  }
  .conclusion {
    font-size: 32px;
    color: #cccccc;
    line-height: 1.6;
    margin-top: 30px;
  }
  .tags { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 40px; }
  .tag {
    background: #1f1f1f;
    border: 1px solid #333;
    border-radius: 8px;
    padding: 10px 20px;
    font-size: 18px;
    color: #888;
  }
</style>
</head>
<body>
<div class="card">
  <h1>{{TITLE}}</h1>
  {{CONTENT}}
</div>
</body>
</html>
```

## 触发词 → 场景对照表

| 触发词 | 场景 | 使用模板 |
|--------|------|----------|
| 做成信息图 | 步骤/列表可视化 | 模板 A 米色暖系 |
| 做成数据卡片 | 数字/结论高亮 | 模板 B 深色极简 |
| 生成封面 | 公众号封面图 | 模板 A + 竖版 |
| 做一张对比图 | 双列风格对比 | Grid 双列模板 |
| 做成金句图 | 朋友圈传播 | 模板 B 深色极简 |
| 生成图片 | 通用生图 | 根据内容自动选择 |

## 使用方法

### 1. 分析内容类型
- **步骤列表型** → 选择模板 A（米色暖系）
- **数据结论型** → 选择模板 B（深色极简）
- **混合型** → 根据主体内容选择

### 2. 执行流程
```bash
# Step 1: 保存 HTML
write_file("/tmp/img-output/card.html", html_content)

# Step 2: 浏览器渲染
browser_navigate("file:///tmp/img-output/card.html")

# Step 3: 截图
result = browser_vision("截图整个页面，展示完整视觉效果")

# Step 4: 复制到输出目录
terminal(f"cp {result['screenshot_path']} /tmp/img-output/output.png")
```

## 占位符说明

- `{{TITLE}}` - 主标题
- `{{STEPS_HTML}}` - 步骤列表 HTML（模板 A 用）
- `{{FOOTER}}` - 底部标注（模板 A 用）
- `{{CONTENT}}` - 数据/结论内容（模板 B 用）

## 扩展模板指南

添加新风格只需：
1. 创建新的 HTML 模板
2. 定义替换占位符
3. 在 trigger_phrases 中添加触发词
4. 在执行逻辑中新增模板分支

**模板制作要点：**
- 固定宽度 1080px（可根据需要调整）
- 使用中文友好的字体栈
- 所有颜色使用十六进制代码
- 圆角、阴影等 CSS 效果提升视觉质感
