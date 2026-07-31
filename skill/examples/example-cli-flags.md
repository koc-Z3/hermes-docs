---
topic: example-cli-flags
tier: example
audience: agent-self-config
last_verified: 2026-07-31
---

# Example: agent configures its own CLI behaviour

**Scenario:** The agent is about to start a long autonomous task. It wants to (1) cap tool turns, (2) enable checkpoints so it can roll back, (3) skip dangerous-command prompts because this is a known-safe environment.

## What the agent does

```bash
# Read the relevant T1 file
# → skill/references/cli-flags.md   (this skill)
# → skill/references/security.md    (this skill)
# → skill/references/self-check.md  (this skill)

# Verify current state
hermes config get cli.max_turns
hermes config get cli.checkpoints
hermes config get security.approval
hermes doctor
```

The agent finds (from `cli-flags.md`):
- `--max-turns N` caps tool iterations
- `--checkpoints` enables filesystem checkpoints
- `--yolo` skips approval (one-off)

And from `security.md`:
- Most security toggles are read once at session start — `hermes --yolo` is the one-off exception.

## Decision

The agent chooses **one-off flags**, not persistent config changes, because:
1. The behaviour is for a single task
2. Persistent changes would affect future sessions
3. The agent can verify the result with `hermes status` before launching

```bash
# Sanity check the current state
hermes --version
hermes status --all

# Launch with overrides
hermes \
  --max-turns 50 \
  --checkpoints \
  --yolo \
  -q "refactor the auth module, run tests after each change, rollback on test failure"
```

## What to verify after

```bash
hermes sessions list --last 1        # check max-turns was respected
hermes config get checkpoints        # note: NOT persistent, was one-off
hermes status | grep yolo            # should be false (not persistent)
```

## Lessons

- One-off flags (`--yolo`, `--max-turns`, `--checkpoints`) don't persist. The agent's *next* session returns to defaults.
- For persistent changes, use `hermes config set KEY VAL` + restart.
- Checkpoints create a shadow git repo at `$HERMES_HOME/checkpoints/`. They don't bloat your project's real git history.
- The orchestrator picked T1 (the trimmed tier) for every step because the questions were all "what's the flag" and "what's the default" — single-fact lookups. T2 and T3 were never needed.

## Escalate from this example when:

- The user asks "make this persistent" → use `hermes config set` instead of CLI flags
- Checkpoints need to be rolled back → `hermes rollback` or `/rollback`
- The CLI flag isn't accepted → T2 `hermes-agent/references/cli-reference.md` (full subcommand list)
