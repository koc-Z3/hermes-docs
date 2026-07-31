---
topic: secrets
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Secrets (where API keys live)

The agent's own secret management. Short version.

## The rule

**Secrets go in `~/.hermes/.env`, never in `config.yaml`.**

`config.yaml` is often checked into git (or shared across machines via dotfiles repos). `.env` is gitignored by default. `config.yaml` references secrets by env-var name, e.g.:

```yaml
# config.yaml — no secrets here
model:
  provider: openai
  api_key_env: OPENAI_API_KEY    # points to the env var
```

```bash
# .env — secrets here
OPENAI_API_KEY=sk-...
```

## Where secrets live

```
$HERMES_HOME/.env                   # main secrets file (gitignored)
$HERMES_HOME/auth.json              # OAuth tokens (gitignored)
$HERMES_HOME/credentials/           # additional credentials (gitignored)
```

## External secret stores

For shared / rotated secrets, Hermes can pull from external stores:

```bash
hermes secrets bitwarden             # use Bitwarden
hermes secrets onepassword          # use 1Password
```

## Find a secret

```bash
# Where is .env?
hermes config env-path

# Is a specific var set?
hermes config env | grep -i api_key

# Is a key loaded? (without printing the value)
hermes -m openai/gpt-4o-mini -q "ping"     # if it errors with "no key", you know
```

## Re-rotation

When you rotate a key:

1. Update `.env` (or your secret store)
2. Restart the session (most secrets are read at startup)
3. For OAuth: `hermes login` to refresh the token

## Self-check

```bash
test -f ~/.hermes/.env && echo "env exists"
hermes config env-path
hermes config env | grep -i api_key | head
hermes doctor                        # checks secret presence (not values)
```

## Escalate to T2 when:

- Setting up Bitwarden / 1Password integration → `hermes-agent/references/security-privacy.md`
- Re-rotation isn't taking effect (secrets cached) → `hermes-agent/references/security-privacy.md` "session restart" notes
- A secret is leaking into logs (redaction is failing) → `hermes-agent/references/security-privacy.md` "Secret redaction in tool output"
- Need credential pools (multiple keys per provider, auto-rotation) → T3 `/user-guide/features/credential-pools`
- Audit / threat model for secret storage → T3 `/user-guide/security`
