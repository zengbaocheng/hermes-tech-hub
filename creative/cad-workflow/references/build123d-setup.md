# build123d 安装与环境配置

## 快速安装（推荐 uv 方式）

```bash
# 创建独立 venv（避免 PEP 668 系统限制）
uv venv /tmp/cad_build --python 3.11

# 安装 build123d（依赖 OpenCASCADE，首次约 5-15 分钟）
uv pip install build123d --python /tmp/cad_build

# 验证
/tmp/cad_build/bin/python -c "import build123d; print(build123d.__version__)"
```

## 已知失败路径（不要用）

| 方式 | 问题 |
|------|------|
| `pip install build123d` | PEP 668 externally managed |
| `pip install --break-system-packages` | files.pythonhosted.org read timeout |
| `uv pip install --system` | PEP 668 externally managed |
| `uv pip install build123d`（不指定 python） | 用了系统 Python 3.12，被挡 |
| hermes-agent venv 的 `pip3` | 没有 `pip`，需先 `python -m ensurepip` |

## 运行时环境路径约定

- venv 路径：`/tmp/cad_build/`
- 代码输出目录示例：`/home/zbc/handgun/`
- 生成文件：`.step`（主格式）、`.stl`（3D打印）、GLB（CAD Explorer 预览）
- CAD Explorer 启动路径：`~/.hermes/skills/cad/scripts/explorer/`

## 环境就绪后的用法

```bash
# 方式1：source venv 后运行
source /tmp/cad_build/bin/activate
cd /home/zbc/handgun && python handgun.py

# 方式2：直接用 venv 的 python 运行脚本
/tmp/cad_build/bin/python /home/zbc/handgun/handgun.py
```

## 安装耗时预估

build123d 依赖 OpenCASCADE 几何内核，完整安装约需 5-15 分钟（网络带宽决定）。建议后台运行并设置 `notify_on_complete=true`。