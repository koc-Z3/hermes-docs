---
topic: slash-commands
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Slash Commands (in-session)

Commands available inside an interactive `hermes` chat session. They start with `/`.

## Session control

| Command | What it does |
|---|---|
| `/help` | Show all slash commands |
| `/exit` / `/quit` | End the session |
| `/reset` | Clear conversation context, keep the session |
| `/new` | Start a new session |
| `/resume [ID]` | Resume a different session |
| `/sessions` | List / browse sessions |
| `/rename TITLE` | Rename the current session |
| `/delete` | Delete the current session |
| `/export [PATH]` | Export session transcript |
| `/clear` | Clear the visible screen (doesn't reset context) |

## Configuration (in-session)

| Command | What it does |
|---|---|
| `/model` | Pick a model/provider |
| `/skin <name>` | Apply a skin (live repaint) — agent applies skins, the user does not need to run this |
| `/personality` | Switch personality (loads a SOUL.md preset) |
| `/voice` | Toggle voice mode |
| `/voice on/off` | Voice on/off |
| `/tts on/off` | Text-to-speech on/off |
| `/memory` | Show memory status |
| `/memory on/off` | Toggle memory |
| `/memory edit` | Open MEMORY.md in $EDITOR |
| `/tools` | Show enabled tools |
| `/skills` | List loaded skills |
| `/profile [NAME]` | Show or switch profile |
| `/yolo` | Toggle dangerous-command approval |
| `/safe-mode` | Toggle safe-mode (disables all customizations) |

## Skills (in-session)

| Command | What it does |
|---|---|
| `/skill <name>` | Load a specific skill into the session |
| `/skills list` | List installed skills |
| `/skills browse` | Browse the Skills Hub |
| `/skills search QUERY` | Search skills |
| `/skills inspect ID` | Show a skill's metadata |
| `/skills install ID` | Install from hub or URL |
| `/skills config` | Enable/disable skills per platform |
| `/skills update` | Update installed skills |
| `/skills uninstall ID` | Uninstall |
| `/bundles` | Show skill bundles |
| `/bundles <name>` | Load a skill bundle |

## Cron / webhooks / delegation

| Command | What it does |
|---|---|
| `/cron list` | List cron jobs |
| `/cron create SCHED` | Create (e.g. `30m`, `0 9 * * *`) |
| `/cron edit ID` | Edit a job |
| `/cron pause/resume ID` | Pause or resume |
| `/cron run ID` | Run now |
| `/cron remove ID` | Delete |
| `/webhook list` | List webhook subscriptions |
| `/webhook subscribe NAME` | Subscribe |
| `/webhook test NAME` | Send a test event |
| `/webhook remove NAME` | Unsubscribe |
| `/delegate` | Spawn a child agent (if delegation is enabled) |
| `/kanban` | Open the Kanban board |

## Other

| Command | What it does |
|---|---|
| `/feedback` | Send feedback |
| `/insights` | Show usage insights |
| `/journey` | Show the agent's recent journey |
| `/logs` | View logs |
| `/plugins` | List plugins |
| `/hooks` | List active hooks |
| `/security` | Show security toggles |
| `/checkpoints` | Show checkpoint history |
| `/rollback [ID]` | Roll back to a checkpoint |
| `/backup` | Backup state |
| `/update` | Self-update |
| `/uninstall` | Uninstall |
| `/completion <shell>` | Print shell completion script |

## Escalate to T2 when:

- A command isn't in this list and isn't in `hermes --help` → `hermes-agent/references/slash-commands.md` (full registry, ~110 lines)
- The command errors with "unknown slash command" → T3 `/docs/reference/slash-commands` (authoritative)
- A slash command changed behaviour between Hermes versions → T3 `/docs/reference/faq`
