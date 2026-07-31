---
topic: example-self-config
tier: example
audience: agent-self-config
last_verified: 2026-07-31
---

# Example: agent audits and tunes its own config

**Scenario:** The agent is asked to "make sure your setup is healthy and optimise for cost." This is a self-config task that spans many subsystems — exactly what this skill was designed for.

## The audit checklist

The agent works through this top-to-bottom. Each step is a T1 lookup unless something needs deeper investigation.

### 1. Health

```bash
hermes doctor
hermes status --all
hermes logs errors --since 24h
```

All T1 (`references/self-check.md`, `references/logs.md`). No escalation needed unless doctor reports a failure.

### 2. Provider / model

```bash
hermes config get model.provider
hermes config get model.name
hermes config get model.aux
hermes config get moa.slots
hermes auth status
```

T1 (`references/models.md`, `references/providers.md`). If the agent is on a single expensive model and the user wants cost optimisation, the agent might suggest MoA — that's T2 (`hermes-agent/references/configuration.md`).

### 3. Secrets

```bash
test -f ~/.hermes/.env
hermes config env | grep -i api_key
hermes auth list
```

T1 (`references/secrets.md`, `references/providers.md`). If using credential pools, that's T2 / T3.

### 4. Memory

```bash
hermes memory status
ls -la ~/.hermes/MEMORY.md ~/.hermes/USER.md
hermes memory search "your topic"
```

T1 (`references/memory.md`). External providers → T3 `/user-guide/features/memory-providers`.

### 5. Skills

```bash
hermes skills list
hermes skills check
hermes skills search "domain you use"
```

T1 (`references/skills.md`). If the user is missing a domain skill, install from the Skills Hub (T3 `/reference/skills-catalog`).

### 6. Cron

```bash
hermes cron list
hermes cron status
```

T1 (`references/cron.md`). If a cron is failing or duplicating, T2 / T3.

### 7. Webhooks

```bash
hermes webhook list
hermes webhook test <name>
```

T1 (`references/webhooks.md`). If a webhook isn't firing, T2 `hermes-agent/references/webhooks.md`.

### 8. Gateway (if enabled)

```bash
hermes gateway status
tail -100 ~/.hermes/logs/gateway.log
```

T1 (`references/gateway.md`). Platform-specific issues → T3 `/user-guide/messaging/<platform>`.

### 9. Security

```bash
hermes config get security
hermes config get platforms.<name>.allowed_users   # for each enabled platform
```

T1 (`references/security.md`). Threat model / production hardening → T3 `/user-guide/security`.

### 10. Logs and observability

```bash
hermes logs errors --since 7d
du -sh ~/.hermes/logs/
hermes config get log.level
```

T1 (`references/logs.md`). Structured logging / shipping → T3 `/docs/observability/`.

## Cost optimisation pass

After the audit, the agent may recommend:

| Finding | Recommendation | Tier for the recommendation |
|---|---|---|
| On a single expensive model for trivial tasks | Set `model.aux` to a cheaper model for summarisation | T1 (`references/models.md`) |
| Single key, hitting rate limits | Add a credential pool | T1 (`references/providers.md`) |
| Long sessions chewing context | Enable checkpoints + periodic `/reset` | T1 (`references/sessions.md`) |
| Memory bloat | Trim `MEMORY.md` or move to external provider | T1 (`references/memory.md`) |
| Cron jobs running more often than needed | Adjust schedule | T1 (`references/cron.md`) |
| One model for everything | Set up MoA | T2 / T3 |

## The routing pattern

The agent's audit followed a **T1-first** pattern: for every subsystem, the T1 file answered the question. T2 and T3 were only consulted for:
- MoA configuration (T2)
- External memory provider setup (T3)
- Production security hardening (T3)
- Structured logging / observability (T3)

Roughly **85% of the audit was T1**, ~10% was T2, ~5% was T3. That's the orchestrator doing its job: routing to the cheapest tier that can answer.

## Lessons

- The agent's self-config questions are predominantly single-fact lookups, which T1 handles well.
- T1 should answer in <2 seconds (no fetch). If a T1 file says "escalate," it points to the right T2 / T3 file by name.
- The orchestrator's biggest value isn't answering questions — it's deciding *which tier to read*. A wrong choice (T1 when the answer needs T3) is the failure mode to design against.
- For ongoing self-config, the agent should bookmark `INDEX.md` (in this skill) and consult it before answering any Hermes question.

## Escalate from this example when:

- The user wants a deep security audit → T3 `/user-guide/security` + `/docs/observability/`
- The user wants to add multi-agent orchestration (Kanban) → T2 + T3
- The user wants a specific platform setup → T3 `/user-guide/messaging/<platform>`
- The agent's audit finds a real problem → T2 `hermes-agent/references/troubleshooting.md`
