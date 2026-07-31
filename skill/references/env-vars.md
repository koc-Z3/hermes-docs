---
topic: env-vars
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Environment Variables (the ones you'll actually use)

The agent's own env. Secrets and overrides, not the full catalogue.

## Critical (read this first)

| Var | What it does | Default |
|---|---|---|
| `HERMES_HOME` | Override the whole config root | `~/.hermes` |
| `HERMES_API_KEY` | API key for the default provider | (read from `~/.hermes/.env`) |
| `HERMES_MODEL` | Default model to use | (set during `hermes model`) |
| `HERMES_PROVIDER` | Default provider | (set during `hermes model`) |
| `OPENAI_API_KEY` | If using OpenAI directly | — |
| `ANTHROPIC_API_KEY` | If using Anthropic directly | — |
| `NOUS_PORTAL_TOKEN` | Nous Portal OAuth | (set by `hermes login`) |

## Display / UX

| Var | What it does |
|---|---|
| `HERMES_INTERFACE` | `cli` or `tui` (default `cli`) |
| `HERMES_NO_BANNER` | `1` to skip the startup banner |
| `HERMES_THEME` | Skin name (also: `hermes skin use <name>`) |
| `NO_COLOR` | Disable color output (any non-empty value) |
| `TERM` | `dumb` disables rich formatting |
| `HERMES_LOG_LEVEL` | `DEBUG` / `INFO` / `WARNING` / `ERROR` |

## Runtime

| Var | What it does |
|---|---|
| `HERMES_CONFIG` | Path to a custom config.yaml |
| `HERMES_PROFILE` | Active profile name (overrides the file) |
| `HERMES_WORKTREE` | `1` to enable git worktree isolation |
| `HERMES_YOLO` | `1` to skip dangerous command approval |
| `HERMES_SAFE_MODE` | `1` to disable all customizations (troubleshooting) |
| `HERMES_MAX_TURNS` | Cap tool-calling iterations |
| `HERMES_CHECKPOINTS` | `1` to enable filesystem checkpoints |
| `HERMES_IGNORE_RULES` | `1` to skip AGENTS.md/SOUL.md/memory/skill injection |

## Skills & memory

| Var | What it does |
|---|---|
| `HERMES_SKILLS` | Comma-separated skill IDs to preload |
| `HERMES_SKILLS_DIR` | Override the skills directory |
| `HERMES_MEMORY` | `off` to disable memory, `provider:name` to force a specific one |
| `HERMES_USER_MD` | Override `USER.md` path |

## Gateway

| Var | What it does |
|---|---|
| `HERMES_GATEWAY_HOST` | Bind address (default `127.0.0.1`) |
| `HERMES_GATEWAY_PORT` | Bind port |
| `HERMES_TELEGRAM_TOKEN` | Telegram bot token |
| `HERMES_DISCORD_TOKEN` | Discord bot token |
| `HERMES_SLACK_APP_TOKEN` | Slack app-level token (Socket Mode) |
| `HERMES_SLACK_BOT_TOKEN` | Slack bot token |
| `HERMES_MATRIX_HOMESERVER` | Matrix homeserver URL |
| `HERMES_SIGNAL_PHONE` | Signal phone number |
| `HERMES_SMTP_HOST` / `HERMES_SMTP_USER` / `HERMES_SMTP_PASS` | Email gateway |
| `HERMES_TWILIO_SID` / `HERMES_TWILIO_TOKEN` / `HERMES_TWILIO_FROM` | SMS gateway |

## Find the full list

```bash
hermes config env-path        # which .env is in use
hermes config env             # dump every var Hermes reads (some are computed)
```

## Self-check

```bash
echo "HERMES_HOME=$HERMES_HOME"
env | grep -E "^HERMES_" | sort
hermes config env | wc -l     # how many vars does this Hermes version know about
```

## Escalate to T2 when:

- You need a specific provider's env vars not listed here (gateway adapters, OAuth providers) → `hermes-agent/references/providers-and-models.md`
- You're on Windows and env vars aren't taking effect → `hermes-agent/references/windows-quirks.md`
- You need the authoritative env-var list for the current Hermes version → T3 `/reference/environment-variables`
