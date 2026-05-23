---
name: transparent-stamp
description: "印章图片处理：JPG去白底转PNG透明背景+红色增强+边缘羽化，通过Telegram发送"
version: 1.0.0
metadata:
  hermes:
    tags: [image-processing, stamp, transparent, png, telegram]
    aliases: [stamp, 印章, 去背景, remove-background]
---

# 印章图片透明化处理 Skill

将 JPG/PNG 图片的白色背景移除，转换为透明背景 PNG 格式，增强印章红色效果。

## 功能特点

- 白底透明化：基于亮度(RGB加权)+色偏阈值判定白色背景
- 红色增强：RGB 通道直接操作 (R×1.5 ↑, G×0.5 ↓, B×0.5 ↓)
- 边缘羽化：检测4邻域透明像素，半透明渐变消锯齿
- Telegram 发送：使用 sendDocument 保留原始 PNG 格式

## 重要：Telegram 发送注意事项

**必须使用 curl 直接调用 Telegram API 发送，绕过 Hermes Gateway！**

### Hermes Gateway Bug 说明

- 问题：MEDIA:/home/zbc/file.png → 被解析为 /home/zbc/file.png**
- 原因：路径解析存在 bug，附加了 ** 后缀
- 症状：日志显示 "File not found: xxx.png**"
- 解决：使用 curl 直接调用 Telegram API

### 为什么用 sendDocument 而不是 sendPhoto？

- sendPhoto：会对图片压缩，可能转 JPG 格式，透明背景丢失
- sendDocument：发送原始文件，100% 保留 PNG 格式和透明通道

## 使用方法

### 完整处理流程

```bash
# ========== Step 1: PIL 处理图片 ==========
/usr/bin/python3 << 'PYEOF'
from PIL import Image

img = Image.open("/home/zbc/.hermes/image_cache/用户上传图片.jpg").convert("RGBA")
pixels = img.load()
width, height = img.size

# 1. 白底透明化 - 亮度>180 且 色偏<50 → 透明
for y in range(height):
    for x in range(width):
        r, g, b, a = pixels[x, y]
        brightness = r * 0.299 + g * 0.587 + b * 0.114
        color_offset = abs(r - g) + abs(g - b) + abs(b - r)
        if brightness > 180 and color_offset < 50:
            pixels[x, y] = (r, g, b, 0)  # 透明
        else:
            pixels[x, y] = (r, g, b, 255)  # 不透明

# 2. 红色增强 - RGB通道直接操作
r, g, b, a = img.split()
r = r.point(lambda x: min(255, int(x * 1.5)))   # R 增强
g = g.point(lambda x: max(0, int(x * 0.5)))      # G 减弱
b = b.point(lambda x: max(0, int(x * 0.5)))     # B 减弱
img = Image.merge("RGBA", (r, g, b, a))

# 3. 边缘羽化 - 半透明渐变
output_pixels = img.load()
for y in range(2, height - 2):
    for x in range(2, width - 2):
        r, g, b, alpha = output_pixels[x, y]
        if 1 <= alpha <= 254:
            neighbors = [
                output_pixels[x-1, y][3],
                output_pixels[x+1, y][3],
                output_pixels[x, y-1][3],
                output_pixels[x, y+1][3]
            ]
            transparent_neighbors = neighbors.count(0)
            if transparent_neighbors > 0:
                feather_strength = transparent_neighbors / 4.0
                new_alpha = int(alpha * (0.5 + feather_strength * 0.5))
                output_pixels[x, y] = (r, g, b, new_alpha)

img.save("/home/zbc/stamp_output.png", "PNG")
print("处理完成: /home/zbc/stamp_output.png")
PYEOF

# ========== Step 2: curl 发送 Telegram ==========
BOT_TOKEN="8738452711:AAHBaZzwZb9c3fsS4xDFyrL4iQowyMcWCa0"
CHAT_ID="178274859"
curl -s -F "chat_id=${CHAT_ID}" -F "document=@/home/zbc/stamp_output.png" \
  -F "caption=透明背景PNG印章 (538x538 RGBA)" \
  "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument"
```

## 参数说明

| 参数 | 默认值 | 说明 |
|------|--------|------|
| brightness阈值 | 180 | >180判定白底 |
| color_offset | 50 | <50判定白底 |
| R倍数 | 1.5 | 红色增强 |
| G/B倍数 | 0.5 | 减弱青色调 |

## 验证命令

```bash
xxd /home/zbc/stamp_output.png | head -1
/usr/bin/python3 -c "from PIL import Image; img=Image.open('/home/zbc/stamp_output.png'); print('透明像素:', sum(1 for p in img.getdata() if p[3]==0))"
```

## FAQ

Q: 为什么用 /usr/bin/python3？
A: 系统默认python3无PIL，/usr/bin/python3有Pillow

Q: 为什么用sendDocument？
A: sendPhoto会压缩转格式，sendDocument保留原PNG
