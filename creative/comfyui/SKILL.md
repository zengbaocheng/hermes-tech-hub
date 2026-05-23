---
name: comfyui
description: ComfyUI 多媒体生成技能 - 一句话生成图片、视频、音频，支持复杂工作流编排
version: 1.0.0
author: hermes-self-learner
metadata:
  tags: [image-generation, video-generation, multimedia, comfyui, workflow]
---

# ComfyUI 多媒体生成技能

## 功能概述

Hermes 的 ComfyUI Skill 把 Agent 和 ComfyUI 之间的整个交互链路都封装好了，让用户只需一句话就能在本地出图、出视频、用自然语言完成复杂的工作流。

### 核心能力

| 能力 | 说明 |
|------|------|
| 出图 | 文生图、图生图 |
| 出视频 | 配合 AnimateDiff、Wan、HunyuanVideo 等工作流 |
| 出音频 | 配合 AudioCraft 工作流 |
| 批量处理 | 批量 prompt、批量 seed |
| 工作流链式调用 | 出图 -> 放大 -> 局部重绘，全自动 |

## 技术架构

### 生命周期管理
- 用 comfy-cli 负责 ComfyUI 的安装、启动、自定义节点管理
- 自动安装缺失的节点依赖

### 执行层面
- 直接走 ComfyUI 的 REST + WebSocket API
- 工作流 JSON 加载 → 参数注入 → 执行 → 返回结果

### 工作流管理
- 导入任意复杂的工作流 JSON
- 自动解析可注入参数（prompt、seed、LoRA 权重、尺寸等）
- 建立干净的映射层，Agent 调用时无需碰原始节点图

### 多实例支持
- 本地机器、远程服务器、不同显卡
- 可以注册多个 ComfyUI 实例
- 执行时指定路由到哪台

## 使用方法

### 基本语法

使用 ComfyUI 帮我生成 [内容描述]，ComfyUI 运行地址: [URL]

### 示例

#### 生成图片
使用 ComfyUI 帮我生成一张猫咪图片，ComfyUI 运行地址: http://192.168.33.106:8188/

#### 批量生成不同风格
用 ComfyUI 的 txt2img-workflow 分别生成水彩风、油画风、像素风三张图，内容都是"一只猫坐在窗边"

#### 链式工作流
通过 ComfyUI 完成以下操作：先用 flux-workflow 生成一张建筑概念图，然后用 upscale-workflow 放大到 4K，再用 inpaint-workflow 把天空部分重绘成黄昏

#### 检查依赖
我想通过 ComfyUI 跑 animatediff-workflow，先检查一下缺哪些节点和模型

## 执行流程

用户一句话描述需求
    1. 检查 ComfyUI 服务是否在线
    2. 找到对应工作流
    3. 把描述翻译成 prompt 注入进去
    4. 设置随机 seed
    5. 调用 API 执行生成
    6. 返回结果文件路径

## 安装检查

检查 Skill 是否已安装：
ls ~/.hermes/skills/creative/
看到 comfyui 目录说明已安装

如需手动安装：
hermes skills install creative/comfyui

## 前置条件

1. Hermes Agent 已经跑起来
2. 本地或远程已经安装 ComfyUI

## 适用场景

| 场景 | 示例 |
|------|------|
| 快速出图 | 生成一张产品展示图 |
| 风格化创作 | 生成水彩风、油画风、像素风图片 |
| 视频生成 | 用 AnimateDiff 生成动画 |
| 批量生产 | 批量生成 10 张不同 prompt 的图片 |
| 工作流编排 | 生成 -> 放大 -> 局部重绘 全自动 |
| 配图生成 | 为文章生成 3 张配图 |

## 核心价值

把 ComfyUI 从一个"需要手动操作的工具"变成一个"Agent 可以调用的能力"。不只是省去拖节点的步骤，而是让 ComfyUI 的出图能力可以被编排进更大的工作流里。

写文章、做 PPT、生成配图——以前这些步骤是断开的，现在可以全部交给 Agent 串起来。

## 注意事项

1. 需要提供正确的 ComfyUI 运行地址
2. 确保 ComfyUI 服务已启动
3. 复杂工作流可能需要分步骤执行
4. 首次使用可能需要安装节点依赖

## 相关技能

- auto-router: 自动选择合适技能
- hermes-self-learner: 自主学习新技能
