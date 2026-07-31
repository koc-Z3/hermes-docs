---
topic: example-messaging-setup
tier: example
audience: agent-self-config
last_verified: 2026-07-31
---

# Example: agent sets up Telegram for itself

**Scenario:** The user wants Hermes to be reachable on Telegram. The agent does the setup, end-to-end.

## What the agent does — step by step

### Step 1: route the question

The question is "set up Telegram for me." That's a **multi-step within one system** (Telegram bot creation + Hermes config + token storage + gateway restart). The orchestrator routes to **T3** (live fetch) first, because T1 doesn't have a Telegram setup file and T2 (the deep `hermes-agent/references/`) doesn't either.

```bash
# Tier 3 — live fetch
# 1. Fetch the index
curl -fsSL https://hermes-agent.nousresearch.com/docs/llms.txt

# 2. Find the Telegram URL
# → /user-guide/messaging/telegram

# 3. Fetch only that page
curl -fsSL https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram
```

### Step 2: do the setup

Following the live page:

```bash
# 1. Create a Telegram bot via @BotFather
#    (the user does this in Telegram; the agent can't, but it tells the user how)

# 2. Get the bot token from BotFather

# 3. Store it in .env (NOT config.yaml)
echo "HERMES_TELEGRAM_TOKEN=123456:ABC-..." >> ~/.hermes/.env

# 4. Configure allowed users
hermes config set platforms.telegram.enabled true
hermes config set platforms.telegram.allowed_users '["@your_telegram_handle"]'

# 5. Restart the gateway
hermes gateway restart
hermes gateway status
```

### Step 3: verify

```bash
# Send a test message from another Telegram account to your bot
# Then check:
hermes logs --filter telegram --since 5m
hermes sessions list --source telegram
```

## Routing recap

| Question | Tier | Why |
|---|---|---|
| "Where do I put the bot token?" | **T1** (`references/secrets.md`) | Single-fact lookup |
| "What env var does Telegram use?" | **T1** (`references/env-vars.md`) | Single-fact lookup |
| "How do I create a Telegram bot?" | **T3** (`/user-guide/messaging/telegram`) | Multi-step procedure, only on the live docs |
| "How do I restart the gateway?" | **T1** (`references/gateway.md`) | Single-fact lookup |
| "Where do the Telegram sessions go?" | **T1** (`references/sessions.md`) | Single-fact lookup |
| "Bot isn't responding, what now?" | **T2** (`hermes-agent/references/troubleshooting.md`) | Debugging, within one system |

The agent used **T1 five times and T3 once**. T2 wasn't needed for the setup itself, only for the hypothetical debugging step. The orchestrator picked the right tier each time.

## Lessons

- T1 covered ~80% of the question. T3 covered the one piece that isn't in T1 (the BotFather flow, which is a Telegram concept, not a Hermes concept).
- The token goes in `.env`, not `config.yaml`. This is in T1's `secrets.md` and `env-vars.md` — both were consulted.
- `hermes config set platforms.telegram.allowed_users` is the security gate: without it, anyone who finds the bot can talk to the agent.
- The agent did NOT need to read `hermes-agent/references/` (T2) for this. T2 is for deep dives within one system; the Telegram setup is shallow-but-multi-step, which T3 handles better.

## Escalate from this example when:

- A different platform (Discord, Slack, WhatsApp) → T3 `/user-guide/messaging/<platform>` (one URL each)
- The setup needs to span multiple platforms (Telegram + cron + Kanban) → T3 still, but the agent consults multiple catalogue pages
- Troubleshooting a failed Telegram setup → T2 `hermes-agent/references/troubleshooting.md`
- Adding a custom platform adapter → T3 `/developer-guide/adding-platform-adapters`
