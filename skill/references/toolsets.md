---
topic: toolsets
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Tools & Toolsets (what the agent can call)

The agent's tool surface. Short version.

## Find what's enabled

```bash
hermes tools                          # interactive tool browser
hermes tools list                     # list enabled tools
hermes tools enable NAME              # enable a tool by name
hermes tools disable NAME             # disable
hermes config get toolsets            # current toolset config
```

## In-session

```bash
/tools                                # show currently enabled tools
```

## What toolsets exist

Hermes ships with these core toolsets (combinable):

| Toolset | Includes |
|---|---|
| `fs` | `read_file`, `write_file`, `patch`, `search_files` |
| `terminal` | `terminal` (sandbox-aware) |
| `web` | `web_fetch`, `web_search` |
| `git` | `git_status`, `git_diff`, `git_commit`, etc. |
| `hermes-docs` | This skill's router |
| `memory` | Memory read/write |
| `cron` | Cron job control |
| `webhook` | Webhook subscribe/manage |
| `gateway` | Messaging gateway control |
| `delegate` | `delegate_task` (spawn child agent) |
| `mcp` | MCP server control |
| `media` | Image gen, vision, TTS, voice |
| `code-exec` | Python code execution (RPC) |

Set the default toolset:

```bash
hermes config set toolsets '["fs","terminal","web","git"]'
hermes -t fs,web,git -q "..."         # one-off override
```

## Per-platform

Different surfaces enable different toolsets by default (e.g. Telegram has a smaller tool surface than CLI). Configure per-platform:

```bash
hermes skills config                  # enable/disable per platform
hermes config get platforms.<name>.toolsets
```

## Self-check

```bash
hermes tools list
hermes --toolsets fs,web -q "list my tools"  # sanity check
```

## Escalate to T2 when:

- Adding a new built-in tool (registration, handler, schema) → T3 `/docs/developer-guide/adding-tools`
- A tool fails to load → `hermes-agent/references/troubleshooting.md`
- Need the full toolset reference (composite, platform, dynamic) → T3 `/docs/reference/toolsets-reference`
- Need a per-tool schema (parameters, return shape) → T3 `/docs/reference/tools-reference`
- Configuring per-platform toolsets → `hermes-agent/references/configuration.md`
