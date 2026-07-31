---
topic: memory
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Memory (where it lives, how to read it)

The agent's persistent memory. Short version.

## Files

```
$HERMES_HOME/
  MEMORY.md          # facts the agent learned (auto-injected)
  USER.md            # who the user is (auto-injected)
  memory/            # structured memory store (per-session entries)
```

`MEMORY.md` and `USER.md` are loaded into the system prompt at session start. Edits take effect on the next session.

## Commands

```bash
hermes memory setup                  # wizard for memory provider
hermes memory status                 # which provider, what's stored
hermes memory off                    # disable memory
hermes memory reset                  # wipe MEMORY.md + USER.md (DANGER)
hermes memory edit                   # open MEMORY.md in $EDITOR
hermes memory list                   # list stored facts
hermes memory add "fact"             # add a fact programmatically
hermes memory search QUERY           # full-text search
```

## In-session

```bash
/memory                              # show status
/memory edit                         # open in $EDITOR
/memory on/off
```

## What gets written

The agent writes to `MEMORY.md` automatically when it learns something durable. The user can also add things via the slash command. `USER.md` is for stable user info (preferences, name, environment).

## External providers

For richer memory (Honcho, OpenViking, Mem0, Hindsight, Holographic, RetainDB, ByteRover, Supermemory), the agent doesn't need to know the wire details — `hermes memory setup` walks through provider selection.

```bash
hermes memory setup                  # choose provider
hermes config get memory.provider    # current
```

## Self-check

```bash
ls -la ~/.hermes/MEMORY.md ~/.hermes/USER.md
hermes memory status
hermes memory search "your topic"
```

## Escalate to T2 when:

- Setting up an external memory provider (Honcho, etc.) → T3 `/docs/user-guide/features/memory-providers`
- Honcho-specific config (dialectic reasoning, multi-agent user modelling) → T3 `/docs/user-guide/features/honcho`
- Memory is causing context bloat → `hermes-agent/references/troubleshooting.md`
- Conflict between MEMORY.md and USER.md → `hermes-agent/references/configuration.md`
