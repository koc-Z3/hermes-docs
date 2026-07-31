---
topic: providers
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Providers (which one am I using, where's the key)

The agent's own LLM provider setup. Short version.

## Find your current provider

```bash
hermes model                    # interactive picker, shows current
hermes config get model.provider
hermes config get model.name
```

## Where the key lives

| Key type | Location |
|---|---|
| OpenAI-compatible API key | `~/.hermes/.env` as `OPENAI_API_KEY` (or `HERMES_API_KEY`) |
| Anthropic API key | `~/.hermes/.env` as `ANTHROPIC_API_KEY` |
| Nous Portal OAuth | `~/.hermes/auth.json` (managed by `hermes login`) |
| Custom provider | `~/.hermes/.env` as `<PROVIDER>_API_KEY` |
| Credential pool (multiple keys) | `~/.hermes/auth.json` as a list, rotates automatically |

**Rule: secrets go in `.env`, never in `config.yaml`.** `config.yaml` is checked into git by many users; `.env` is gitignored by default.

## Self-check

```bash
# Is my key actually loaded?
hermes config env | grep -i api_key

# Is the provider reachable?
hermes doctor

# Switch provider / model without editing files
hermes model                     # interactive
hermes --provider openai --model gpt-4o -q "test"   # one-shot override
```

## Switching provider

The fast way (one-off, doesn't persist):

```bash
hermes -m anthropic/claude-sonnet-4-5 -q "hello"
hermes --provider openai --model gpt-4o -q "hello"
```

The persistent way (writes to `config.yaml`):

```bash
hermes model                     # picker
# or
hermes config set model.provider anthropic
hermes config set model.name claude-sonnet-4-5
```

## Adding a new provider

For most providers:

```bash
echo "ANTHROPIC_API_KEY=sk-ant-..." >> ~/.hermes/.env
hermes model                     # pick Anthropic from the list
```

For Nous Portal:

```bash
hermes login                     # opens browser OAuth flow
```

For 35+ pre-configured provider profiles, the agent does not need to edit config — the profile ships with Hermes and is selectable from `hermes model`.

## Credential pools (multiple keys per provider)

If you have multiple API keys (e.g., several OpenAI keys for rate-limit rotation), add them all to `auth.json` and Hermes rotates them automatically, skipping exhausted keys.

```bash
hermes auth add openai          # interactive
hermes auth list                # show current pool
hermes auth status              # show which keys are exhausted
```

## Escalate to T2 when:

- A provider isn't in the picker (custom endpoint, on-prem LLM) → `hermes-agent/references/providers-and-models.md` for the full profile list
- You need fallback chains (`primary fails → fallback`) → `hermes-agent/references/configuration.md` and T3 `/docs/user-guide/features/fallback-providers`
- You need credential pool details (rotation policy, exhausted-key detection) → T3 `/docs/user-guide/features/credential-pools`
- A provider's auth is failing and `hermes doctor` doesn't explain it → T3 `/docs/reference/faq`
