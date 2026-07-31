---
topic: profiles
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Profiles (multiple isolated Hermes instances)

The agent's own profile system. Short version.

## What a profile is

A profile is an isolated Hermes config tree:

```
~/.hermes/profiles/<name>/
  config.yaml
  .env
  auth.json
  skills/
  sessions/
  ...
```

Each profile has its own config, secrets, skills, sessions, and memory. They share the binary.

## Find your active profile

```bash
hermes profile list                   # all profiles
hermes profile show                   # active + path
hermes config get profile.name        # the active one in config
echo "$HERMES_PROFILE"                # or env var override
```

## Switch profile

```bash
hermes profile use <name>             # persistent
hermes --profile <name> -q "..."      # one-off
export HERMES_PROFILE=<name>          # env override
```

## Create / delete

```bash
hermes profile create NAME [--clone | --clone-all | --clone-from SOURCE]
hermes profile delete NAME
hermes profile rename OLD NEW
hermes profile alias NAME ALIAS
hermes profile export NAME OUT.tar.gz
hermes profile import FILE
```

`--clone` copies the current config, `--clone-all` also copies skills and sessions, `--clone-from SOURCE` clones from a specific named profile.

## When to use multiple profiles

- Separate work vs personal
- Different model per profile (e.g. one for code, one for writing)
- Different providers per profile (e.g. local LLM in one, cloud in another)
- Per-project isolation (each project gets its own profile)
- Test a config change without breaking the main one (`hermes profile create test --clone`)

## In-session

```bash
/profile [NAME]                       # show or switch
```

## Self-check

```bash
hermes profile show
hermes profile list
hermes --profile <name> doctor        # doctor on a specific profile
```

## Escalate to T2 when:

- Profile commands don't match this list → T3 `/reference/profile-commands` (authoritative)
- Cross-profile workflows (delegate between profiles) → `hermes-agent/references/background-systems.md`
- Profile paths / per-platform profile setup → T3 `/user-guide/profiles`
- Kanban across profiles → T3 `/user-guide/features/kanban`
