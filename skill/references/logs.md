---
topic: logs
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Logs (where to find them, how to read them)

The agent's own logs. Short version.

## Where

```
$HERMES_HOME/logs/
  gateway.log         # gateway activity (messaging platforms, webhooks)
  errors.log          # error stream
  agent.log           # agent loop activity
  tools.log           # tool calls
  hermes.log          # everything (when HERMES_LOG_LEVEL=DEBUG)
```

## Commands

```bash
hermes logs                          # recent log lines (tail)
hermes logs -f                       # follow (tail -f)
hermes logs errors                   # only errors
hermes logs --filter webhook         # filter by tag
hermes logs --since 1h               # time range
hermes logs --session ID             # one session
```

## Levels

```bash
hermes config set log.level INFO     # DEBUG, INFO, WARNING, ERROR
export HERMES_LOG_LEVEL=DEBUG
```

## Self-check

```bash
tail -50 ~/.hermes/logs/hermes.log
hermes logs errors --since 10m
hermes logs --filter "<your-tag>"
```

## Escalate to T2 when:

- Log file is huge and you need to rotate/archive → `hermes-agent/references/configuration.md`
- Log format is unclear (structured logging, fields) → T3 `/docs/reference/faq`
- A specific subsystem isn't logging (gateway, MCP, voice) → `hermes-agent/references/troubleshooting.md`
- Need to ship logs to an external system (Datadog, etc.) → T3 `/docs/reference/faq`
