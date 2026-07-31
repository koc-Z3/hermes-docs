---
topic: cli-flags
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# CLI Flags (the ones the agent uses)

Short version. The agent invokes Hermes via the `hermes` command; these are the flags that matter for self-config and scripting.

## Global

```bash
hermes [flags] [command]         # no subcommand = interactive chat

  --version, -V                  # version
  -q, --query "TEXT"             # one-shot, prints only the final response (use for scripts)
  -z, --oneshot "TEXT"           # same as -q
  -m, --model MODEL              # override model for this invocation (e.g. openai/gpt-4o)
  --provider P                   # override provider for this invocation
  -t, --toolsets LIST            # comma-separated toolsets (e.g. "fs,git,web")
  --resume, -r SESSION           # resume by ID or title
  --continue, -c [NAME]          # resume by name, or most recent
  --worktree, -w                 # isolated git worktree mode (parallel agents)
  --skills, -s SKILL             # preload skills (comma-separate or repeat)
  --profile, -p NAME             # use a named profile
  --yolo                         # skip dangerous command approval
  --tui / --cli                  # force Ink TUI / classic REPL
  --ignore-rules                 # skip AGENTS.md / SOUL.md / memory / skill injection
  --safe-mode                    # disable ALL customizations (troubleshooting)
  --pass-session-id              # include session ID in system prompt
  --image PATH                   # attach image to a single query
```

## chat subcommand

```bash
hermes chat
  -q, --query TEXT
  --image PATH
  -Q, --quiet                    # suppress banner, spinner, tool previews
  --checkpoints                  # enable filesystem checkpoints
  --max-turns N
  --source TAG                   # default "cli"
```

## Configuration

```bash
hermes setup [section]           # wizard: model | tts | terminal | gateway | tools | agent
hermes model                     # interactive provider/model picker
hermes config show               # show current config (read-only)
hermes config get KEY            # get a single key (e.g. model.name)
hermes config set KEY VAL        # set a single key
hermes config unset KEY          # remove a key
hermes config edit               # open in $EDITOR
hermes config path               # print path to config.yaml
hermes config env-path           # print path to .env
hermes config check              # validate config
hermes config migrate            # migrate from older versions
hermes doctor [--fix]            # dependency + config check
hermes status [--all]            # component status
hermes login / logout            # OAuth sign-in / clear
```

## Self-check

```bash
# What flags are available in this version?
hermes --help
hermes <command> --help          # e.g. hermes chat --help

# Verify a flag is recognised (no-op for unknown)
hermes --version
hermes doctor
```

## Escalate to T2 when:

- You need a full subcommand list (gateway, sessions, cron, profiles, auth, moa, hooks, security, backup, etc.) → `hermes-agent/references/cli-reference.md`
- You're scripting and need the exact flag contract → `hermes-agent/references/cli-reference.md` "Where to Find Things" section
- A flag is rejected and the error message is unclear → T3 `/reference/cli-commands`
- The flag is documented but doesn't behave as documented (drift) → `hermes-agent/references/troubleshooting.md`
