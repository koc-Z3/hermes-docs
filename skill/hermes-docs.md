---
name: hermes-docs
description: Use when the user (or the agent itself) needs to look up Hermes Agent configuration, commands, env vars, file paths, or setup steps. Picks the cheapest tier that can answer the question.
triggers:
  - "hermes agent config"
  - "hermes configuration"
  - "hermes setup"
  - "how do I configure hermes"
  - "hermes env var"
  - "hermes command"
  - "hermes flag"
  - "how to set up hermes"
  - "where is the hermes config"
  - "hermes config.yaml"
---

# Hermes Agent Documentation Navigator (Adaptive)

When the question is about **Hermes Agent's own configuration, commands, env vars, file paths, or setup**, do not dump full docs into context. Pick a tier, then load only that tier.

This skill is the **router**. Three sub-tiers exist, ordered cheapest → most complete. The router's job is to pick the smallest tier that fully answers the question, and escalate only when the cheaper tier says so.

## The three tiers

| Tier | What it is | When to use it | Cost |
|------|-----------|----------------|------|
| **T1 — Self-config** | `references/*.md` (this skill) | One-fact lookup, env var, flag, file path, current setting, "is X enabled?" | ~5–10 KB per file, no fetch |
| **T2 — Deep** | `hermes-agent/references/*.md` (the bundled `hermes-agent` skill, copied in here) | Multi-step within one system, edge cases, "what does this option do", anything T1 says "see deep" for | ~10–100 KB per file, no fetch |
| **T3 — Live** | `https://hermes-agent.nousresearch.com/docs/<path>` | Multi-system, "set up X for production", tutorials, anything not yet bundled, anything T1/T2 don't cover | ~17 KB index + page weight, requires network |

**Default for agent self-config questions: T1.** The agent's own setup lives there. Only escalate.

## The router (use this every time)

Before answering, run this classification:

### Step 1 — Is the question about the agent's own configuration?

If yes, prefer T1. If no (user is asking how to use Hermes for a task, or wants conceptual explanation), start at T2.

### Step 2 — Within T1, find the right file

T1 is organized by topic. Open `references/INDEX.md` (in this skill) and find the matching topic. Read only that file.

If no T1 file matches, **escalate to T2**.

### Step 3 — Read the file and answer

T1 files end with a "**Escalate to T2 when:**" section. If the user's question matches an escalation trigger, load the T2 file listed. If T2 also says "fetch the live page," escalate to T3.

### Step 4 — If T3 is needed

```
1. Fetch  https://hermes-agent.nousresearch.com/docs/llms.txt  (~17 KB)
2. Scan for the URL path matching the topic  (e.g. /docs/user-guide/configuration)
3. Fetch  https://hermes-agent.nousresearch.com<that-path>  only
4. Read only the relevant section, answer, link the URL in the response
```

**Never** fetch `llms-full.txt` (~1.8 MB) unless the user explicitly asks for a complete documentation dump.

## Difficulty signals (the orchestrator's input)

The agent classifies the question by these signals. The stronger the signal, the higher the tier.

### Use T1 (self-config) when the question is:

- A single fact: "what's the env var for X?", "what flag does Y take?", "where is the config file?"
- A check: "is Y enabled?", "what's my current X setting?"
- A self-modify: "set display.skin to synthwave", "add PROVIDER=openai to my env"
- A path lookup: "where do my sessions live?", "where do logs go?"
- Short, declarative, no procedure requested

### Use T2 (deep) when the question is:

- A multi-step within one system: "add a new OAuth provider", "set up webhooks end-to-end", "configure a fallback chain"
- The T1 file said "see deep reference" or "see references/hermes-agent/..."
- Debugging: "my X is broken, here's the error" (within one system)
- Edge cases / what-ifs: "what happens if two providers both return 429?"

### Use T3 (live) when the question is:

- Multi-system: "set up Telegram + Kanban + cron for a daily briefing"
- A tutorial: "how do I… for production / for our team / at scale"
- A new feature: "I read about X in the release notes, how does it work?"
- Anything T1 and T2 both say "fetch the live page for this"
- The user explicitly wants the live docs: "check the official docs"

### Force T2/T1 (no network) when:

- The user says "offline", "no fetch", "no network", "I have no internet"
- A T3 fetch fails (timeout, 5xx, DNS error) → fall back to T2, then T1

## When NOT to use this skill

- The question is about **using** Hermes to do a non-config task (write code, refactor a repo, answer a domain question). Go straight to the bundled `hermes-agent` skill's general instructions, or to no skill at all.
- The question is about a skill other than Hermes. This skill only covers Hermes Agent itself.

## Self-check before answering

Before sending a configuration answer, verify:

- [ ] I read the right T1/T2 file (or fetched the right T3 page)
- [ ] I cited the source file or URL in my answer
- [ ] If I made a config change, I noted whether a session restart is required (most Hermes config is read once at startup)
- [ ] If the question is about a secret (API key, OAuth token), I noted it goes in `~/.hermes/.env`, not `config.yaml`

## Files in this skill

- `INDEX.md` — topic → tier routing table (read this first when classifying)
- `references/` — T1 self-config files (start here)
- `hermes-agent/` — T2 deep tier (the bundled `hermes-agent` skill, 18 reference files + templates + SKILL.md)
- `examples/` — worked configuration examples
