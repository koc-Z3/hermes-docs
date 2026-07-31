---
topic: security
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Security Toggles (the ones that matter for self-config)

The agent's own security model. Short version.

## Toggles

| Toggle | What it does | Default |
|---|---|---|
| `security.approval` | Ask before dangerous commands | `true` |
| `security.yolo` | Skip approval (DANGEROUS) | `false` |
| `security.safe_mode` | Disable ALL customizations | `false` |
| `security.secret_redaction` | Redact API keys from tool output | `true` |
| `security.pii_redaction` | Redact PII from tool output | `false` |
| `security.allowed_commands` | Whitelist of executable commands | `["*"]` |
| `security.denied_commands` | Blacklist of blocked commands | `[]` |
| `security.sandbox` | Run terminal in a sandbox | `local` (no sandbox by default) |

## Set a toggle

```bash
hermes config set security.yolo true
hermes config set security.pii_redaction true
hermes config get security            # see all
```

## In-session

```bash
/yolo                                # toggle yolo for this session
/safe-mode                           # toggle safe-mode
```

## CLI flags

```bash
hermes --yolo                        # one-off, no approval prompts
hermes --safe-mode                   # one-off, disable all customizations
```

## Restart required

Most security toggles are read **once at session start**. If you change them, you need a new session:

```bash
hermes config set security.pii_redaction true
# then start a new hermes session — the change takes effect on the next launch
```

In-session `/yolo` and `/safe-mode` are the exception — they take effect immediately.

## Self-check

```bash
hermes config get security
hermes doctor                        # verify config is sane
```

## Escalate to T2 when:

- Need to understand the full security model (dangerous-command detection, container isolation, user authorisation) → T3 `/user-guide/security`
- A specific toggle isn't being respected → `hermes-agent/references/security-privacy.md` and `hermes-agent/references/troubleshooting.md`
- Setting up sandboxed execution (Docker backend, SSH backend) → `hermes-agent/references/configuration.md` and T3 `/user-guide/docker`
- Production deployment / threat model → T3 `/user-guide/security` and `/docs/observability/`
