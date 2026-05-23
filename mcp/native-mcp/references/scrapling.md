# Scrapling MCP Server Integration

Scrapling (https://github.com/D4Vinci/Scrapling) is a Python web scraping framework with 52k GitHub stars. It exposes 10 MCP tools for AI-augmented web scraping, including anti-bot bypass (Cloudflare Turnstile), headless browser automation, and a spider crawl framework.

> **Important**: Scrapling has NO `__main__.py` — `python3 -m scrapling mcp` does NOT work. Always use the `scrapling` binary from the venv directly.

## Installation

```bash
# Create venv (use uv to avoid PEP 668 system-pip restrictions)
uv venv ~/.hermes/venvs/scrapling --python 3.11
uv pip install "scrapling[all]>=0.4.8" --python ~/.hermes/venvs/scrapling/bin/python3

# Download Chromium browser binaries only (skip system-deps which requires sudo):
~/.hermes/venvs/scrapling/bin/python3 -m playwright install chromium
```

> **Pitfall**: `scrapling install` runs `playwright install-deps chromium` internally, which requires `sudo` for system library installation and will fail in rootless containers or sudo-less VMs. The Chromium browser binaries are all you need — they install successfully via `playwright install chromium` even when `install-deps` fails. Binaries land in `~/.cache/ms-playwright/`.

Python 3.10+ required. Browser download is ~2-3GB and takes several minutes on first run.

## Hermes MCP Config

Add to `~/.hermes/config.yaml` as a **top-level** key (not nested inside any section like `display:`):

```yaml
mcp_servers:
  scrapling:
    command: /home/zbc/.hermes/venvs/scrapling/bin/scrapling
    args: ["mcp"]
    timeout: 300          # browser tools are slow, raise from default 120
    connect_timeout: 120
```

> **Pitfall**: YAML insertion point matters. The `mcp_servers` block must be a top-level key in config.yaml. If inserted after a nested section's indented keys (e.g., after `display:`'s `skin: default`), subsequent indented keys will incorrectly become children of `mcp_servers` and corrupt the config. Safest spot: very end of the file, or after a blank line with no preceding indented block.

## 10 MCP Tools Exposed

| Tool | Purpose |
|------|---------|
| `get` | Fast HTTP GET with browser TLS/header fingerprint |
| `bulk_get` | Concurrent HTTP GET for multiple URLs |
| `fetch` | Playwright browser render (JS-required pages) |
| `bulk_fetch` | Concurrent browser fetch for multiple URLs |
| `stealthy_fetch` | Anti-bot bypass: Cloudflare Turnstile/Interstitial auto-solve |
| `bulk_stealthy_fetch` | Concurrent stealth fetch |
| `open_session` | Persistent browser session (avoids re-launching Chrome each time) |
| `close_session` | Close a persistent session |
| `list_sessions` | List active browser sessions |
| `screenshot` | Screenshot as native MCP ImageContent (bytes, not base64) |

## Tool Selection Guide

| Scenario | Tool |
|----------|------|
| Static page, no bot protection | `get` |
| Multiple static pages | `bulk_get` |
| JavaScript-rendered / SPA | `fetch` |
| Cloudflare or strong anti-bot | `stealthy_fetch` with `solve_cloudflare=true` |
| Multiple protected pages | `bulk_stealthy_fetch` |
| Multiple pages from same site | `open_session` + `fetch`/`stealthy_fetch` with `session_id` |
| Screenshot | `open_session` + `screenshot` with `session_id` |

## Key Parameters Worth Knowing

- `css_selector` — narrow content BEFORE sending to LLM (saves tokens significantly)
- `main_content_only=true` (default) — strips nav/footer, enables prompt injection sanitization
- `extraction_type` — `"markdown"` (default, best readability) / `"text"` / `"html"`
- `headless` — default `true`; set `false` for visible browser debugging
- `network_idle` — wait 500ms no network activity before extracting
- `wait_selector` / `wait_selector_state` — wait for specific DOM element before extract

## Session Pattern (Recommended for Multi-Page Crawls)

```python
# Open a persistent session once
open_session(session_type="stealthy", headless=True, solve_cloudflare=True)
# Returns session_id like "a3f1b2c9d4e5"

# Reuse it across multiple pages — no browser re-launch overhead
fetch(url="https://example.com/page1", session_id="a3f1b2c9d4e5", ...)
fetch(url="https://example.com/page2", session_id="a3f1b2c9d4e5", ...)
screenshot(url="https://example.com/page3", session_id="a3f1b2c9d4e5", full_page=True)

# Close when done
close_session(session_id="a3f1b2c9d4e5")
```

## Limitations / Gotchas

- **Browser memory**: Each stealthy session holds a Chrome process. Close sessions when done.
- **First launch慢**: `scrapling install --force` downloads Chromium (~2-3GB, 5-15 min).
- **Python 3.10+**: System Python works; Hermes venv pip is at `~/.hermes/hermes-agent/venv/bin/pip3`.
- **Proxy auth format**: `{"server": "http://host:port", "username": "...", "password": "..."}` — not a plain URL string for some tools.
- **MCP stdio blocking**: The `scrapling mcp` command runs a long-lived server. Ensure `timeout` is raised above default 120s for browser tools.
- **Session type binding**: `dynamic` sessions only work with `fetch`/`bulk_fetch`; `stealthy` only with `stealthy_fetch`/`bulk_stealthy_fetch`. Mixing causes errors.

## Prompt Injection Protection

`main_content_only=true` (default) sanitizes scraped content:
- Strips `display:none`, `visibility:hidden`, `opacity:0`, `font-size:0`, `height:0`, `width:0`
- Strips `aria-hidden="true"` elements
- Strips `<template>` tags and HTML comments
- Strips zero-width unicode characters

Keep default on for untrusted sites.

## Ad Blocking

All browser-based tools auto-block ~3,500 known ad/tracker domains. Always-on, no config needed. Saves tokens and speeds up page loads.