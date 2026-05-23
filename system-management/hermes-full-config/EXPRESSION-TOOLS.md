---
name: expression-tools
description: Hermes 表达能力配置 - 语音识别、语音合成、图片生成工具
version: 1.0.0
author: hermes-self-learner
metadata:
  tags: [voice, speech, image-generation, expression]
---

# 表达能力配置

## 语音工具链

| 工具 | 用途 | 特点 |
|------|------|------|
| Whisper | 语音识别 | 支持99+语言 |
| Edge TTS | 语音合成 | 免费使用 |

## 图片生成工具

| 工具 | 用途 | 特点 |
|------|------|------|
| Fal.ai | 图片生成 | API 调用 |
| FLUX Skill | 高质量出图 | Hermes 原生支持 |
| ComfyUI | 高级工作流 | 复杂生成（之前已学习）|

## 已安装技能

- comfyui: ~/.hermes/skills/creative/comfyui/SKILL.md

## 使用示例

### 语音识别
```bash
whisper audio.mp3 --language zh
```

### 语音合成
```bash
edge-tts --text "你好" --output hello.mp3
```

### 图片生成
```
使用 ComfyUI 或 Fal.ai 生成一张 [描述]
```

### FLUX 出图
```
使用 FLUX Skill 生成 [描述] 图片
```
