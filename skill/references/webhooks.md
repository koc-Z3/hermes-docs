---
topic: webhooks
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Webhooks (event-driven triggers)

The agent's own webhook subscriptions. Short version.

## Where

```
$HERMES_HOME/webhooks/
  subscriptions.yaml   # active subscriptions
  deliveries/          # delivery log
```

## List / status

```bash
hermes webhook list
hermes webhook status NAME
hermes webhook test NAME              # send a test event
```

## Create / remove

```bash
hermes webhook subscribe NAME --source github --event push --repo owner/repo
hermes webhook subscribe NAME --url https://example.com/hook
hermes webhook remove NAME
```

## In-session

```bash
/webhook list
/webhook subscribe NAME
/webhook test NAME
/webhook remove NAME
```

## What sources are supported

Hermes subscribes to events from:
- GitHub (push, PR, issue, release)
- GitLab
- Stripe
- Generic HTTP POST (any source with HMAC)

For a generic webhook, the sender POSTs to the URL Hermes exposes (default `$HERMES_HOME/gateway/webhook`).

## Self-check

```bash
hermes webhook list
hermes webhook test <name>            # sends a synthetic event
hermes logs --filter webhook         # recent webhook deliveries
```

## Escalate to T2 when:

- Need to author a webhook subscription from scratch (HMAC, payload shape, retry) → `hermes-agent/references/webhooks.md`
- Webhook isn't firing → `hermes-agent/references/troubleshooting.md`
- Need webhook payloads for a specific source (GitHub, GitLab, Stripe) → `hermes-agent/references/webhooks.md`
- Setting up webhook delivery to a messaging platform → T3 `/docs/user-guide/messaging/webhooks`
