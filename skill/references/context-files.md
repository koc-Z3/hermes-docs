---
topic: context-files
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Project Context Files (AGENTS.md, .hermes.md, CLAUDE.md, SOUL.md)

The agent's own context-file loader. Short version.

## Discovery order (first match wins)

Hermes reads these from the **current working directory**, in this order:

1. `.hermes.md` — Hermes-specific
2. `AGENTS.md` — cross-tool (Claude Code, Hermes, OpenCode)
3. `CLAUDE.md` — Claude Code convention (Hermes reads it for compat)
4. `.cursorrules` — Cursor convention (read if present)
5. (Global) `~/.hermes/SOUL.md` — personality/persona
6. (Global) `~/.hermes/USER.md` — user info

**Only ONE of `.hermes.md` / `AGENTS.md` / `CLAUDE.md` is loaded per session** (first match). Don't write all three expecting them to merge.

## Global vs per-project

| File | Scope | Use for |
|---|---|---|
| `SOUL.md` (global) | Every session | Personality, voice, tone |
| `USER.md` (global) | Every session | Who the user is |
| `MEMORY.md` (global) | Every session | Learned facts |
| `.hermes.md` (project) | This project | Project conventions |
| `AGENTS.md` (project) | This project | Cross-tool instructions |
| `CLAUDE.md` (project) | This project | Claude-Code compat |
| `.cursorrules` (project) | This project | Cursor compat |

## Skip rules

```bash
hermes --ignore-rules                # skip all (for one-off debug)
hermes config set context.enabled false
```

## When to use which

- **SOUL.md**: global persona. Loaded into the system prompt. Same across all projects.
- **AGENTS.md / .hermes.md**: per-project rules. Loaded when you `cd` into the project.
- **USER.md**: who the user is. Don't put transient project info here.
- **MEMORY.md**: facts the agent learned. Don't put hand-written project rules here.

## Self-check

```bash
ls -la .hermes.md AGENTS.md CLAUDE.md 2>/dev/null
cat .hermes.md                        # see what's loaded
hermes --ignore-rules -q "what's my project context"   # compare
```

## Escalate to T2 when:

- Precedence rules / conflict between files → `hermes-agent/references/project-context-files.md`
- SOUL.md vs AGENTS.md boundary / how they differ → T3 `/user-guide/features/personality` and `/guides/use-soul-with-hermes`
- A project file isn't being loaded → `hermes-agent/references/troubleshooting.md`
- Custom context sources → T3 `/user-guide/features/context-files` and `/user-guide/features/context-references`
