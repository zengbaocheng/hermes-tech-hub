---
name: market-research
description: "Stock market, financial data, and business intelligence research — A股/港股/美股 indices, sectors, concepts, and news via public APIs and web scraping."
version: 1.0.0
platforms: [linux, macos]
metadata:
  hermes:
    tags: [stock, market, finance, A股, 港股, 美股, financial, market-data, indices, sectors, concepts]
    related_skills: [blogwatcher]
---

# Market Research

Research stock market data, indices, sector performance, concept themes, and financial news. Covers Chinese A股 (via 东方财富 Eastmoney), Hong Kong, and US markets.

## 中国A股数据 (Eastmoney 东方财富)

### 主要指数

```bash
# 上证/深证/创业板/沪深300/科创50 等核心指数，一行搞定
curl -s "https://push2.eastmoney.com/api/qt/ulist.np/get?\
fltt=2&invt=2&fields=f12,f14,f3,f4,f2&\
secids=1.000001,0.399001,0.399006,1.000300,1.000688&\
ut=b2884a393a59ad64002292a3e90d46a5" \
-H "Referer: https://quote.eastmoney.com"
```

**返回字段说明：**
- `f2` = 当前点位
- `f3` = 涨跌幅(%)
- `f4` = 涨跌额
- `f12` = 代码
- `f14` = 名称

**常用 secids 代码对照：**
| 指数 | secid |
|------|-------|
| 上证指数 | `1.000001` |
| 深证成指 | `0.399001` |
| 创业板指 | `0.399006` |
| 沪深300 | `1.000300` |
| 科创50 | `1.000688` |
| 上证50 | `1.000016` |
| 中小100 | `0.399005` |
| 成份B指 | `0.399003` |

### 行业板块 (m:90+t:2)

```bash
# 东方财富行业板块，100个/页，需要翻页
curl -s "https://push2.eastmoney.com/api/qt/clist/get?\
cb=jQuery&pn=1&pz=100&po=1&np=1&\
ut=bd1d9ddb04089700cf9c27f6f7426281&\
fltt=2&invt=2&fid=f3&fs=m:90+t:2&\
fields=f12,f14,f3,f4,f2" \
-H "Referer: https://quote.eastmoney.com"
```

### 概念板块 (m:90+t:3)

```bash
# 东方财富概念板块，共约486个，需翻页(pn=1~5, 每页100)
# 例：第1页
curl -s "https://push2.eastmoney.com/api/qt/clist/get?\
cb=jQuery&pn=1&pz=100&po=1&np=1&\
ut=bd1d9ddb04089700cf9c27f6f7426281&\
fltt=2&invt=2&fid=f3&fs=m:90+t:3&\
fields=f12,f14,f3,f4,f2" \
-H "Referer: https://quote.eastmoney.com"
```

**返回格式：** JSONP (`jQuery({...})`)，用正则提取：
```
jQuery\((.+)\)
```

**解析示例 (Python)：**
```python
import re, json

data = curl_output
m = re.search(r'jQuery\((.+)\)', data)
if m:
    d = json.loads(m.group(1))
    items = d['data']['diff']  # list of dicts
    # 每个item: {"f2":4077.28,"f3":-2.04,"f4":-84.9,"f12":"000001","f14":"上证指数"}
```

**板块过滤关键词（科技/新能源相关）：**
```python
tech_kw = ['半导','芯片','光刻','IC','硅片','软件','互联','通信','5G',
           '光通','算力','AI','人工智','数据','云','计算机','消费电',
           '汽车电','显示','面板','光学','元件','电子材','电子元']
ne_kw = ['锂电','电动','太阳能','风电','储能','电池','氢能','光伏',
         '新能','充电','充电桩','电网','电力设备','核能','水力']
filtered = [i for i in items if any(k in i['f14'] for k in tech_kw + ne_kw)]
```

### 搜索特定板块/概念

不用翻页，直接用 `secids` 方式按代码查单个板块：
- 在板块列表中先找到代码(如 `BK0488`)，再查详情
- 概念板块代码前缀一般是 `BK`，行业板块是数字代码

### 解析后排序输出
```python
items.sort(key=lambda x: x['f3'], reverse=True)  # 涨幅序
items.sort(key=lambda x: x['f3'])                  # 跌幅序
for i in items:
    print(f"{i['f14']}: {i['f3']:+.2f}%")
```

## AI/科技新闻

### AI News (英文)
```bash
curl -s "https://www.artificialintelligence-news.com/feed/"
```

### Hacker News / Tech
```bash
curl -s "https://news.ycombinator.com/rss"
```

## 格式化输出规范

主上偏好：表格+emoji，表情符号标注涨跌（📈📉🟢🔴），不超过3个板块级别，每级8-15条，控制总长度避免刷屏。

## Notes

- Eastmoney API 不需要认证，但必须带 `Referer: https://quote.eastmoney.com` 请求头
- 板块数据更新较慢，适合盘后或盘中快照，不适合高频
- 概念板块翻页：pn=1~5（每页100），总共约486个
- `t:2` = 行业板块，`t:3` = 概念板块

## References

- `references/eastmoney-api.md` — 实际返回示例、分页数据、pitfalls（已验证不可用的API、解析正则、格式化偏好）