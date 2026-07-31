---
topic: cron
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Cron (scheduled tasks)

The agent's own cron. Short version.

## Where

```
$HERMES_HOME/cron/
  jobs.yaml           # job definitions
  state/              # last-run timestamps, run history
```

## List / status

```bash
hermes cron list                     # all jobs
hermes cron status                   # last run + next run
hermes cron status ID                # specific job
```

## Create / edit

```bash
hermes cron create SCHEDULE PROMPT   # SCHEDULE: '30m', 'every 2h', '0 9 * * *', ISO timestamp
hermes cron create "0 9 * * *" "summarise my last 24h of messages and post to Telegram"
hermes cron edit ID                  # open in $EDITOR
hermes cron run ID                   # run now
hermes cron pause ID
hermes cron resume ID
hermes cron remove ID
```

## In-session

```bash
/cron list
/cron create SCHEDULE
/cron edit ID
/cron run ID
/cron pause/resume/remove
```

## Schedule formats

- `30m`, `2h`, `1d` — relative
- `every 30m`, `every 2h` — recurring relative
- `0 9 * * *` — cron expression
- `2026-08-01T09:00:00` — ISO timestamp (one-shot)

## Attach skills to a job

```bash
hermes cron create "0 9 * * *" "..." --skills hermes-docs,git-status
```

## Self-check

```bash
hermes cron list
hermes cron status
hermes cron run <id>                 # manual trigger to verify it works
```

## Escalate to T2 when:

- Authoring complex cron with skill chains, deliver targets, retry → T3 `/docs/user-guide/features/cron` and `/docs/guides/automate-with-cron`
- Cron isn't firing on time → `hermes-agent/references/troubleshooting.md`
- Want cron delivered to a specific platform (Telegram, Discord) → T3 `/docs/user-guide/messaging/index`
- Cron syntax edge cases (DST, leap seconds) → T3 `/docs/reference/faq`
