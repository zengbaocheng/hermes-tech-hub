# build123d Installation Reference

**Purpose:** Quick-start for installing build123d (the Python CAD kernel behind text-to-cad / cad skills) on this system.

## Why build123d is tricky

build123d wraps **OpenCASCADE Technology (OCCT)** — a heavy C++ solid-modeling kernel. `pip install build123d` triggers compilation/installation of OCCT bindings. Expect **5–15 minutes** on first install and significant disk I/O.

## Correct installation sequence (hermes-agent venv)

```bash
# 1. Bootstrap pip in the hermes venv (it may not have pip ready)
python -m ensurepip

# 2. Use pip3 (NOT pip — the venv has pip3/pip3.11, not bare pip)
/path/to/venv/bin/pip3 install build123d

# 3. Run in background, give it 10+ minutes
# Background: terminal(background=true, notify_on_complete=true, timeout=900)
```

### Finding the right pip

```bash
ls /home/zbc/.hermes/hermes-agent/venv/bin/ | grep pip
# → pip3  pip3.11
```

NOT:
- `pip` (doesn't exist in venv)
- `uv pip install --system` (blocked by PEP 668 on this system)
- `pip install --break-system-packages` (system Python 3.12 is restricted)

## Verify it works

```python
python3 -c "import build123d; print(build123d.__version__)"
```

## If installation is impossible (no compiler / time constraints)

The generated `.py` source files are still fully valid and portable. Ship the `.py` to a machine with build123d installed, or use the cad skill's CLI tools (`scripts/step`) which may have a different runtime path.

## Key imports

```python
from build123d import *
# Common: BuildPart, BuildSketch, BuildLine, BuildAssembly, Extrude, export_step, export_stl
# Geometry: Box, Cylinder, Sphere, Cone, Torus, Circle, Rectangle, Trapezoid, Line, Arc
# Operations: Boolean, Chamfer, Fillet, Shell, Loft, Revolve, Sweep, Hole
# Selection: faces(), edges(), vertices(), sort_by(Axis.X/Y/Z), filter_by(Axis.X)
# Assembly: add(), Location, Vector, Align.MIN/CENTER/MAX, Mode.ADD/SUBTRACT
```

## Common build123d workflow

```bash
# Generate STEP + STL from a .py generator
python /path/to/cad/scripts/step/cli.py my_part.py

# Inspect geometry (bounds, planes, positions)
python /path/to/cad/scripts/inspect/cli.py my_part.step

# Render image
python /path/to/cad/scripts/render/cli.py my_part.step
```

## text-to-cad @cad[] reference convention

Every named part in a build123d script should have a comment:

```python
with BuildPart() as frame:
    ...
# @cad[frame] — Lower receiver / grip frame
```

This enables precise conversational modification:
- User: "make the grip 10mm longer"
- AI: "modify @cad[grip] by changing GRIP_LENGTH from 85 to 95"
- No full regeneration needed — just the targeted part.

## Skill source locations

- Installed by `npx agent-skills-cli add earthtojake/text-to-cad --all --yes`
- Per-agent locations: `~/.claude/skills/cad/`, `~/.config/opencode/skill/cad/`, etc.
- CAD skill root: `$AGENT_SKILL_DIR/cad/scripts/step|inspect|render|dxf/`