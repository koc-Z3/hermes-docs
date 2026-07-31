---
topic: gateway
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Gateway (messaging platforms)

The agent's own gateway. Short version.

## Status

```bash
hermes gateway status                # running? which platforms?
hermes gateway run                   # foreground (Ctrl-C to stop)
hermes gateway install               # install as a service (systemd / launchd / Windows service)
hermes gateway start                 # background (uses the service)
hermes gateway stop
hermes gateway restart
hermes gateway setup                 # wizard for adding a platform
```

## Where the gateway lives

```
$HERMES_HOME/gateway/
  config.yaml         # platform configs
  sessions/           # per-platform session routing
  webhook/            # webhook endpoint
  logs/               # gateway-specific logs (also in $HERMES_HOME/logs/)
```

## Per-platform config

Each platform has its own config block under `platforms.<name>`:

```bash
hermes config get platforms.telegram
hermes config set platforms.telegram.enabled true
hermes config set platforms.telegram.allowed_users '["@you"]'
```

## 20+ supported platforms

Telegram, Discord, Slack, WhatsApp (Baileys + Business Cloud), iMessage (Photon), Signal, Email, SMS (Twilio), Matrix, Mattermost, Microsoft Teams, LINE, SimpleX, ntfy, Google Chat, Home Assistant, DingTalk, Feishu, WeCom, Weixin, API Server (OpenAI-compatible), Webhooks.

## Self-check

```bash
hermes gateway status
hermes gateway status --platform telegram
tail -50 ~/.hermes/logs/gateway.log
```

## Escalate to T2 when:

- Adding a new platform from scratch (OAuth flow, bot token, allowed users) → T3 `/user-guide/messaging/<platform>` (one URL per platform)
- Gateway is crashing on startup → `hermes-agent/references/troubleshooting.md`
- A specific platform isn't listed in the picker → T3 `/integrations/providers` (custom adapters)
- Webhook routing config → `hermes-agent/references/webhooks.md`
- Authoring a new platform adapter → T3 `/developer-guide/adding-platform-adapters`
