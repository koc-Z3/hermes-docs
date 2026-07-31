---
topic: self-check
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Self-Check (doctor, status, env-path)

The agent's own diagnostics. Short version.

## Doctor

```bash
hermes doctor                        # full health check
hermes doctor --fix                  # auto-fix what's safe to fix
hermes doctor --verbose              # show every check
hermes doctor --json                 # machine-readable
```

Doctor checks: Python version, uv/venv, dependencies, config syntax, secrets presence, gateway reachability, MCP servers, provider connectivity, file permissions on `$HERMES_HOME`.

## Status

```bash
hermes status                        # high-level
hermes status --all                  # every component
hermes status --json
```

## Where is my config

```bash
hermes config path                   # path to config.yaml
hermes config env-path               # path to .env
hermes config env                    # dump every env var Hermes reads
```

## One-shot sanity

```bash
hermes -q "ping"                     # round-trip a trivial query
hermes -m openai/gpt-4o-mini -q "ping"   # test a specific model
hermes --safe-mode -q "ping"         # test in safe-mode (no customizations)
```

## Profiles

```bash
hermes --profile <name> doctor       # doctor on a specific profile
```

## Self-check checklist

```bash
hermes doctor
hermes config path
hermes status --all
hermes skills check
hermes gateway status                # if messaging is enabled
hermes logs errors --since 10m
```

## Escalate to T2 when:

- Doctor reports a failure and the message is unclear → `hermes-agent/references/troubleshooting.md`
- A specific subsystem check fails (gateway, MCP, voice, memory provider) → `hermes-agent/references/troubleshooting.md`
- Doctor --fix doesn't fix it → T3 `/reference/faq`
- Need a different health check (e.g. relay connector, observability) → T3 `/docs/observability/`
