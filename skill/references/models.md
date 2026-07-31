---
topic: models
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Models (which one am I on, how do I switch)

## What's running right now

```bash
hermes model                    # current model + provider
hermes config get model.name
hermes config get model.provider
```

The `model.name` is `<provider>/<model>` (e.g., `anthropic/claude-sonnet-4-5`, `openai/gpt-4o`).

## Switch for one query

```bash
hermes -m openai/gpt-4o -q "hello"
hermes --model anthropic/claude-sonnet-4-5 -q "hello"
hermes --provider openai --model gpt-4o -q "hello"
```

## Switch persistently

```bash
hermes model                    # interactive picker
# or
hermes config set model.name anthropic/claude-sonnet-4-5
hermes config set model.provider anthropic
```

Restart your session after a persistent change — most model settings are read once at startup.

## Multi-model orchestration (MoA)

For mixture-of-agents setups (multiple models in one workflow), see `hermes moa` and the MoA slots config:

```bash
hermes moa                      # show current slots
hermes config get moa.slots     # see the full slot list
```

## Aux models (separate from the main model)

Some features use a different model than the main one (cheaper model for summarisation, vision model for image description, etc.). Check the aux config:

```bash
hermes config get aux_models
hermes config get model.aux
```

## Self-check

```bash
# Is the model reachable?
hermes doctor

# What model did I just use? (after a chat)
hermes sessions list --last 1   # shows model used in last session

# Force a known-good model for a sanity check
hermes -m openai/gpt-4o-mini -q "ping"
```

## Escalate to T2 when:

- The picker doesn't show the model you want → `hermes-agent/references/providers-and-models.md` (35+ provider profiles)
- You need to set up Mixture-of-Agents (MoA) properly → `hermes-agent/references/configuration.md` and T3 `/docs/user-guide/features/batch-processing`
- You want to know which models are bundled with which provider profiles → T3 `/docs/reference/model-catalog`
- An aux model is failing (vision, summarisation) → `hermes-agent/references/troubleshooting.md`
