---
name: cad-workflow
description: build123d + text-to-cad skill 环境配置与 CAD 生成完整工作流。从环境检查→代码生成→STEP 导出→CAD Explorer 预览的完整链路。使用场景：生成零件 CAD（.step/.stl）、机械设计、机器人 URDF 导出。
---

# CAD Workflow — build123d + text-to-cad 完整工作流

## 触发条件

用户要求生成 CAD 文件、STEP/STL/GLB、build123d 代码、机械零件、机器人描述文件（URDF/SDF/SRDF）时使用。

## 完整流程（每步必检）

### 0. 检查 build123d 环境（第一步！）

```python
import build123d  # 失败 → 先装环境
```

**环境就绪检查**：
```bash
/tmp/cad_build/bin/python -c "import build123d; print(build123d.__version__)"
```
如果报错，执行安装：
```bash
uv venv /tmp/cad_build --python 3.11
uv pip install build123d --python /tmp/cad_build
```

> ⚠️ 安装失败常见原因：pip 默认超时、PEP 668 限制。正确方式是用 uv 建独立 venv（见 `references/build123d-setup.md`）。

### 1. 生成 build123d Python 代码

代码规范：
- 全局参数放顶部（尺寸变量）
- 每个几何特征加 `@cad[...]` 引用句柄
- 使用 `gen_step()` 导出，不要直接操作 STEP 内部格式
- 代码和 STEP 输出放同一目录

### 2. 执行生成

```bash
/tmp/cad_build/bin/python /path/to/model.py
# 生成: model.step, model.stl
```

### 3. CAD Explorer 预览

```bash
npm --prefix ~/.hermes/skills/cad/scripts/explorer run dev:ensure -- \
  --workspace-root /path/to/workspace \
  --file /path/to/model.step
```

## 非 negotiable

- **先装 build123d runtime 再谈 CAD 生成**。skill 代码（cad、cad-explorer、urdf 等）只是指令模板，不含运行时。
- STEP 是主格式，DXF/STL/3MF 是副产物。
- 代码必须含 `@cad[...]` 句柄，否则无法做局部修改。
- 生成结果必须通过 Telegram 发送给主上（telegram:178274859）。

## 参考文档

- `references/build123d-setup.md` — build123d 安装与环境配置（含已知失败路径）