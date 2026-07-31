---
topic: paths
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Paths (where Hermes keeps things)

The agent checks its own state by reading files. This is the map.

## Canonical locations

```
$HERMES_HOME  (defaults to ~/.hermes if unset)
  ├── config.yaml          Main config (settings, NEVER secrets)
  ├── .env                 API keys and secrets ONLY
  ├── auth.json            OAuth tokens and credential pools
  ├── state.db             Session store (SQLite + FTS5)
  ├── logs/
  │   ├── gateway.log      Gateway activity
  │   └── errors.log       Error stream
  ├── sessions/            Gateway routing index, *.jsonl transcripts
  ├── skills/              Installed skills (this skill lives here)
  ├── skins/               Custom themes
  ├── desktop-plugins/     Desktop app UI plugins
  ├── tui-widgets/         TUI widget apps
  ├── pets/                Installed pet mascots
  └── hermes-agent/        Source code (only if git-installed)
```

## Find your paths in one command

```bash
hermes config path           # main config.yaml
hermes config env-path       # .env location
hermes status                # component status with paths
```

## Override `$HERMES_HOME`

Set `HERMES_HOME` in your shell env (or `.env`) to relocate the whole tree. Useful for:
- multiple profiles (each profile can have its own `$HERMES_HOME`)
- containerized setups (mount a volume at `$HERMES_HOME`)
- per-project isolation

## Per-platform

| Platform | Config overlay |
|---|---|
| Linux | `~/.config/hermes/` (XDG) — falls back to `~/.hermes/` |
| macOS | `~/Library/Application Support/hermes/` — falls back to `~/.hermes/` |
| Windows | `%APPDATA%\hermes\` — falls back to `~/.hermes/` |
| WSL | Linux paths inside the WSL distro |
| Termux | `~/.hermes/` (no XDG) |

The fallback is what you get on a fresh install; the canonical paths are what most docs reference.

## Self-check

```bash
test -f ~/.hermes/config.yaml && echo "config exists" || echo "no config"
test -d ~/.hermes/skills && ls ~/.hermes/skills | wc -l   # count installed skills
ls ~/.hermes/sessions/ | wc -l                           # session count
```

## Escalate to T2 when:

- You need to debug a path that's not where this file says (custom install, container mount, symlink) → `hermes-agent/references/configuration.md`
- You're authoring a plugin that needs to know the canonical install path → `hermes-agent/SKILL.md` "Key Paths" section
- You're on Windows and seeing path errors → `hermes-agent/references/windows-quirks.md`
