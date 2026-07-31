---
topic: sessions
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Sessions (where they live, how to find/resume)

The agent's session history. Short version.

## Where

```
$HERMES_HOME/state.db                # SQLite + FTS5 — canonical session store
$HERMES_HOME/sessions/               # routing index + *.jsonl transcripts
```

`state.db` is the source of truth. `sessions/` holds the raw transcripts and per-platform routing metadata.

## Commands

```bash
hermes sessions list                 # all sessions
hermes sessions browse               # interactive browser
hermes sessions rename ID TITLE      # rename
hermes sessions delete ID            # delete (DANGER: irreversible)
hermes sessions export ID OUT.jsonl  # export transcript
hermes sessions prune                # delete old sessions (configurable retention)
hermes sessions stats                # session count, disk usage
```

## In-session

```bash
/sessions                            # list (interactive)
/resume [ID]                         # resume by ID
/rename TITLE
/delete
/export [PATH]
```

## Resume from CLI

```bash
hermes --resume <ID>                 # resume specific session
hermes --continue                    # resume most recent
hermes -c "name"                     # resume by name
```

## Per-platform routing

Sessions are tagged with a `source` (default `cli`). Telegram, Discord, etc. have their own source tags. Each platform keeps its own session thread:

```bash
hermes sessions list --source telegram
hermes config get platforms.telegram.session_policy
```

## Self-check

```bash
hermes sessions list | wc -l
ls ~/.hermes/sessions/ | wc -l
sqlite3 ~/.hermes/state.db ".tables"   # see schema
hermes sessions stats
```

## Escalate to T2 when:

- Configuring session policy (retention, per-platform, cross-profile) → T3 `/user-guide/sessions` and `hermes-agent/references/configuration.md`
- Session storage internals (FTS5, schema, migrations) → T3 `/developer-guide/session-storage`
- Cross-profile session routing → `hermes-agent/references/background-systems.md` "Delegation" section
- A session is corrupted and `hermes sessions` errors → `hermes-agent/references/troubleshooting.md`
