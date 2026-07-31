---
topic: surfaces
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Surfaces (CLI / TUI / desktop / dashboard / API)

The agent has multiple UI surfaces. Each has a different launch command.

## Pick a surface

| Surface | Launch | Best for |
|---|---|---|
| **CLI** (default) | `hermes` | Interactive chat in the terminal |
| **TUI** (Ink) | `hermes --tui` | Richer terminal UI, mouse, overlays |
| **One-shot** | `hermes -q "..."` | Scripts, pipes, single queries |
| **Desktop app** | `hermes desktop` or `hermes gui` | Native Electron app, multi-pane |
| **Dashboard** | `hermes dashboard` | Web admin panel + embedded chat |
| **API server** | `hermes proxy` | OpenAI-compatible local API |
| **ACP server** | `hermes acp` | IDE integration (VS Code, Zed, JetBrains) |

## Force a surface

```bash
hermes --tui                         # force TUI
hermes --cli                         # force classic CLI
```

## Default surface

```bash
hermes config get display.interface  # 'cli' or 'tui'
hermes config set display.interface tui
```

## Dashboard

```bash
hermes dashboard                     # start (default port)
hermes dashboard --port 9000
hermes dashboard --status
hermes dashboard --stop
```

## API server (OpenAI-compatible)

```bash
hermes proxy                         # exposes OpenAI-compatible endpoint on localhost
hermes proxy --port 8080
```

Any OpenAI-compatible client (Open WebUI, LibreChat, Continue, etc.) can point at this endpoint.

## ACP (Agent Context Protocol) for IDEs

```bash
hermes acp                           # start ACP server
```

Configure your IDE (VS Code, Zed, JetBrains) to connect to the ACP server.

## Self-check

```bash
hermes --version
hermes dashboard --status
hermes proxy --status
hermes config get display.interface
```

## Escalate to T2 when:

- Building a custom TUI widget (clock, ticker, dashboard panel) → `hermes-agent/references/tui-widgets.md` + `templates/clock.mjs`
- Building a desktop app plugin (pane, ⌘K command, page) → `hermes-agent/references/desktop-plugins.md` + `templates/plugin.js`
- Choosing between API server vs ACP for an integration → T3 `/user-guide/features/api-server` and `/user-guide/features/acp`
- A surface isn't launching → `hermes-agent/references/troubleshooting.md`
- TUI walkthrough / keybindings → T3 `/user-guide/tui`
