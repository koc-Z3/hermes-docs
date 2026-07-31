# Hermes Docs — Topic Routing Table

This is the **first file to read** when classifying a configuration question. Find the topic, then load the matching tier.

**Legend:**
- **T1** = self-config, in this skill at `references/<path>` (~5–10 KB)
- **T2** = deep, in this skill at `hermes-agent/references/<file>` (~10–100 KB)
- **T3** = live, fetch from `https://hermes-agent.nousresearch.com/docs/<path>`

## Tier rules (recap)

1. Start at T1. Escalate to T2 only when T1 says so or no T1 file matches.
2. Escalate to T3 only when T1 + T2 both fail or the question is multi-system.
3. If T3 fails (network), fall back to T2 then T1.

## Self-config topics (T1)

These are questions the agent most often asks about **its own setup**. Each T1 file is short, focused, and ends with explicit "escalate to T2" triggers.

| Question topic | T1 file | Escalate to T2 when |
|---|---|---|
| Where is the config / what file holds what | `references/paths.md` | Multi-file or multi-system |
| Common env vars (HOME, SKILLS, secrets) | `references/env-vars.md` | Provider-specific env vars |
| Provider setup / API key locations | `references/providers.md` | Adding a new provider from scratch |
| Model selection (which model am I on) | `references/models.md` | Multi-model orchestration / MoA |
| CLI flags the agent uses most | `references/cli-flags.md` | Full command reference |
| Slash commands available in-session | `references/slash-commands.md` | None — T1 is complete |
| Skills: list, enable, install, locate | `references/skills.md` | Authoring a new skill |
| Tools: list, enable, disable, toolsets | `references/toolsets.md` | Adding a new tool |
| Memory: where it lives, how to read/write | `references/memory.md` | External memory providers (Honcho etc.) |
| Sessions: locate, resume, search, delete | `references/sessions.md` | Cross-profile session routing |
| Profiles: which one is active, how to switch | `references/profiles.md` | Cross-profile workflows |
| Cron: list, status, location | `references/cron.md` | Authoring a cron with skill chains |
| Webhooks: list, status, location | `references/webhooks.md` | Authoring a new webhook subscription |
| Logging: where logs go, how to read them | `references/logs.md` | Tailing / parsing structured logs |
| Gateway: status, where it runs, log location | `references/gateway.md` | Adding a new messaging platform |
| TUI / desktop / dashboard launch flags | `references/surfaces.md` | Building a TUI widget or desktop plugin |
| Security toggles: yolo, approval, safe-mode | `references/security.md` | Threat model / production hardening |
| Project context files (AGENTS.md, .hermes.md) | `references/context-files.md` | Conflict between files / precedence rules |
| Self-check: doctor, status, env-path | `references/self-check.md` | Diagnosing a failing health check |
| Sandbox / container / backend selection | `references/backends.md` | Setting up a new backend (Docker, SSH, etc.) |
| Secret storage: where secrets live | `references/secrets.md` | External secret stores (Bitwarden, 1Password) |

## Deep tier (T2) — the bundled `hermes-agent` skill

For multi-step within one system, edge cases, and anything T1 escalates to.

| Topic | T2 file (in `hermes-agent/references/`) |
|---|---|
| Full CLI command reference | `cli-reference.md` |
| Full slash command registry | `slash-commands.md` |
| Configuration sections, toolsets, voice | `configuration.md` |
| Provider & model aliases, 35+ profiles | `providers-and-models.md` |
| Secret redaction, PII, approval modes | `security-privacy.md` |
| Project context file discovery order | `project-context-files.md` |
| Delegation, cron, curator, kanban | `background-systems.md` |
| Native MCP client (transport, discovery) | `native-mcp.md` |
| Webhook routes and event-driven runs | `webhooks.md` |
| Theme/skin authoring | `themes.md` |
| Desktop app plugin authoring | `desktop-plugins.md` |
| TUI widget authoring | `tui-widgets.md` |
| Pet mascot install/select | `petdex.md` |
| Windows-specific issues | `windows-quirks.md` |
| Troubleshooting (voice, tools, gateway) | `troubleshooting.md` |
| Contributor / PR workflow | `contributor-guide.md` |
| delegate_task "capped at N" diagnosis | `delegate-task-concurrency-diagnosis.md` |
| Third-party Portal OAuth (Karakeep, OpenWebUI) | `portal-auth-for-third-party-apps.md` |
| Authoring new tools, providers, platform adapters | `SKILL.md` (routing table at the top) |

## Live tier (T3) — fetch from the docs site

For multi-system, tutorials, production setup, and anything not bundled.

**Two-step procedure:**
1. Fetch `https://hermes-agent.nousresearch.com/docs/llms.txt` (~17 KB)
2. Find the URL path, then fetch `https://hermes-agent.nousresearch.com/docs/<path>`

Common T3 paths:

| Topic | Catalogue path |
|---|---|
| Installation matrix | `/docs/getting-started/installation` |
| First-run quickstart | `/docs/getting-started/quickstart` |
| Updating / uninstalling | `/docs/getting-started/updating` |
| Termux (Android) | `/docs/getting-started/termux` |
| Nix / NixOS module | `/docs/getting-started/nix-setup` |
| CLI user guide | `/docs/user-guide/cli` |
| TUI walkthrough | `/docs/user-guide/tui` |
| Configuration user guide | `/docs/user-guide/configuration` |
| Configuring models | `/docs/user-guide/configuring-models` |
| Sessions user guide | `/docs/user-guide/sessions` |
| Profiles user guide | `/docs/user-guide/profiles` |
| Git worktrees for parallel agents | `/docs/user-guide/git-worktrees` |
| Docker backend | `/docs/user-guide/docker` |
| Security model | `/docs/user-guide/security` |
| Checkpoints & rollback | `/docs/user-guide/checkpoints-and-rollback` |
| Features overview | `/docs/user-guide/features/overview` |
| Tools overview | `/docs/user-guide/features/tools` |
| Skills system | `/docs/user-guide/features/skills` |
| Curator (skill maintenance) | `/docs/user-guide/features/curator` |
| Memory | `/docs/user-guide/features/memory` |
| Memory providers | `/docs/user-guide/features/memory-providers` |
| Context files (the feature, not the bug) | `/docs/user-guide/features/context-files` |
| Context references (@-syntax) | `/docs/user-guide/features/context-references` |
| Personality & SOUL.md | `/docs/user-guide/features/personality` |
| Plugins | `/docs/user-guide/features/plugins` |
| Built-in plugins | `/docs/user-guide/features/built-in-plugins` |
| Cron jobs | `/docs/user-guide/features/cron` |
| Delegation | `/docs/user-guide/features/delegation` |
| Kanban multi-agent | `/docs/user-guide/features/kanban` |
| Persistent goals (Ralph loop) | `/docs/user-guide/features/goals` |
| Code execution | `/docs/user-guide/features/code-execution` |
| Hooks | `/docs/user-guide/features/hooks` |
| Batch processing | `/docs/user-guide/features/batch-processing` |
| Voice mode | `/docs/user-guide/features/voice-mode` |
| Browser | `/docs/user-guide/features/browser` |
| Vision | `/docs/user-guide/features/vision` |
| Image generation | `/docs/user-guide/features/image-generation` |
| Text-to-speech | `/docs/user-guide/features/tts` |
| Messaging platforms overview | `/docs/user-guide/messaging/index` |
| Telegram setup | `/docs/user-guide/messaging/telegram` |
| Discord setup | `/docs/user-guide/messaging/discord` |
| Slack setup (Socket Mode) | `/docs/user-guide/messaging/slack` |
| WhatsApp setup | `/docs/user-guide/messaging/whatsapp` |
| Signal setup | `/docs/user-guide/messaging/signal` |
| Email setup (IMAP/SMTP) | `/docs/user-guide/messaging/email` |
| SMS setup (Twilio) | `/docs/user-guide/messaging/sms` |
| Matrix setup | `/docs/user-guide/messaging/matrix` |
| Mattermost setup | `/docs/user-guide/messaging/mattermost` |
| Home Assistant setup | `/docs/user-guide/messaging/homeassistant` |
| Webhooks for messaging | `/docs/user-guide/messaging/webhooks` |
| Integrations overview | `/docs/integrations/index` |
| Providers integration | `/docs/integrations/providers` |
| MCP (Model Context Protocol) | `/docs/user-guide/features/mcp` |
| ACP (Agent Context Protocol) | `/docs/user-guide/features/acp` |
| API server (OpenAI-compatible) | `/docs/user-guide/features/api-server` |
| Honcho memory | `/docs/user-guide/features/honcho` |
| Provider routing | `/docs/user-guide/features/provider-routing` |
| Fallback providers | `/docs/user-guide/features/fallback-providers` |
| Credential pools | `/docs/user-guide/features/credential-pools` |
| Tips & best practices | `/docs/guides/tips` |
| Local LLMs on Mac | `/docs/guides/local-llm-on-mac` |
| Daily briefing bot tutorial | `/docs/guides/daily-briefing-bot` |
| Team Telegram assistant tutorial | `/docs/guides/team-telegram-assistant` |
| Use Hermes as a Python library | `/docs/guides/python-library` |
| Use MCP with Hermes | `/docs/guides/use-mcp-with-hermes` |
| Use voice mode with Hermes | `/docs/guides/use-voice-mode-with-hermes` |
| Use SOUL.md with Hermes | `/docs/guides/use-soul-with-hermes` |
| Build a Hermes plugin | `/docs/guides/build-a-hermes-plugin` |
| Automate with cron | `/docs/guides/automate-with-cron` |
| Work with skills | `/docs/guides/work-with-skills` |
| Delegation patterns | `/docs/guides/delegation-patterns` |
| GitHub PR review agent | `/docs/guides/github-pr-review-agent` |
| Architecture (developer) | `/docs/developer-guide/architecture` |
| Agent loop walkthrough | `/docs/developer-guide/agent-loop` |
| Prompt assembly | `/docs/developer-guide/prompt-assembly` |
| Context compression & caching | `/docs/developer-guide/context-compression-and-caching` |
| Gateway internals | `/docs/developer-guide/gateway-internals` |
| Session storage | `/docs/developer-guide/session-storage` |
| Provider runtime | `/docs/developer-guide/provider-runtime` |
| Adding a tool | `/docs/developer-guide/adding-tools` |
| Adding a provider | `/docs/developer-guide/adding-providers` |
| Adding a platform adapter | `/docs/developer-guide/adding-platform-adapters` |
| Creating a skill | `/docs/developer-guide/creating-skills` |
| Extending the CLI | `/docs/developer-guide/extending-the-cli` |
| CLI commands (authoritative) | `/docs/reference/cli-commands` |
| Slash commands (authoritative) | `/docs/reference/slash-commands` |
| Profile commands | `/docs/reference/profile-commands` |
| Environment variables (authoritative) | `/docs/reference/environment-variables` |
| Tools reference | `/docs/reference/tools-reference` |
| Toolsets reference | `/docs/reference/toolsets-reference` |
| MCP config reference | `/docs/reference/mcp-config-reference` |
| Model catalog | `/docs/reference/model-catalog` |
| Bundled skills catalog (~90) | `/docs/reference/skills-catalog` |
| Optional skills catalog (~60) | `/docs/reference/optional-skills-catalog` |
| FAQ & troubleshooting | `/docs/reference/faq` |
