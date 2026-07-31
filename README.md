# Hermes Docs (Adaptive Skill)

<div align="right">

**English** | [简体中文](./README.zh-CN.md)

</div>

A **documentation navigator** for [Hermes Agent](https://hermes-agent.nousresearch.com/docs) that uses a three-tier adaptive router to pick the cheapest source that can answer a configuration question.

## What It Solves

1. Lets the `hermes-docs` skill help Hermes Agent answer any questions about its own configuration, commands, env vars, file paths, or setup.
2. Reduces model hallucinations during configuration by routing to authoritative sources instead of guessing.
3. Reduces token cost by preferring local bundled files over network fetches when possible.

## How It Works — the three tiers

When the agent has a Hermes question, the orchestrator (`skill/hermes-docs.md`) routes it to one of three tiers:

| Tier | What it is | When | Cost |
|------|-----------|------|------|
| **T1 — Self-config** | `skill/references/*.md` — 21 short files (~50 KB total) for the agent's own setup | One-fact lookups: env vars, flags, paths, current settings | Instant, no fetch |
| **T2 — Deep** | `skill/hermes-agent/` — the full `hermes-agent` skill copied in (18 reference files, ~100 KB) | Multi-step within one system, edge cases | Instant, no fetch |
| **T3 — Live** | `https://hermes-agent.nousresearch.com/docs/<path>` | Multi-system, tutorials, anything not bundled | Network fetch (~17 KB index + page) |

**Default for agent self-config: T1.** The orchestrator escalates only when T1 says so or no T1 file matches.

## Key Benefits

- **Adaptive routing** — picks the cheapest tier that can answer, per question. Simple questions stay fast, complex questions get the full docs.
- **No duplication of sources** — T1 and T2 cover different scopes (T1 = agent self-config, T2 = general user-facing reference). T3 is the live, always-current fallback.
- **Offline-capable** — T1 and T2 work without network. T3 is the only tier that requires connectivity.
- **Self-improving target** — designed to make the agent better at configuring its own settings, not just helping users.

## Repository Layout

```
hermes-docs/
├── README.md                  ← this file
├── README.zh-CN.md            ← 中文版
└── skill/
    ├── hermes-docs.md         ← the orchestrator (router logic)
    ├── INDEX.md               ← topic → tier routing table
    ├── references/            ← T1: agent self-config (21 files, ~50 KB)
    │   ├── paths.md
    │   ├── env-vars.md
    │   ├── providers.md
    │   ├── ... (17 more)
    ├── hermes-agent/          ← T2: deep tier (the bundled hermes-agent skill)
    │   ├── SKILL.md
    │   ├── references/        (18 files)
    │   └── templates/         (3 files)
    └── examples/              ← worked configuration examples
        ├── example-cli-flags.md
        ├── example-messaging-setup.md
        └── example-self-config.md
```

## How an Agent Uses This

1. **Read `skill/hermes-docs.md`** — this is the orchestrator. It defines the routing rules.
2. **Read `skill/INDEX.md`** — find the topic, get the tier assignment.
3. **Load the file** — T1 file in `references/`, T2 file in `hermes-agent/references/`, or T3 URL from the catalogue.
4. **Answer** — cite the source file or URL in the response.

## Maintenance

The bundled `hermes-agent/` tier is a verbatim copy of [NousResearch/hermes-agent's `skills/autonomous-ai-agents/hermes-agent/`](https://github.com/NousResearch/hermes-agent/tree/main/skills/autonomous-ai-agents/hermes-agent). It is intended to be **re-synced** when that upstream changes.

The T1 `references/` tier is maintained here and is intentionally focused on **agent self-config** — not a general-purpose Hermes reference. The general reference lives in T2 (and the live docs in T3).

### Re-syncing T2 (the deep tier) from upstream

```bash
# From the repo root
cd "$(mktemp -d)"                              # extract into a temp dir to avoid polluting cwd
curl -fsSL "https://codeload.github.com/NousResearch/hermes-agent/tar.gz/refs/heads/main" \
  | tar -xz --strip-components=4 \
      "hermes-agent-main/skills/autonomous-ai-agents/hermes-agent"
rm -rf skill/hermes-agent
mv hermes-agent skill/hermes-agent             # move the extracted subtree into the repo
```

This pulls the latest `SKILL.md`, `references/`, and `templates/` from NousResearch's `main` branch. After syncing, run the validation (below) to make sure the T1 routing table still lines up.

> **Why a temp dir?** `tar --strip-components=N` rewrites the path inside the archive; the result lands in the current working directory. Extracting into a temp dir keeps your repo clean of stray `SKILL.md` / `references/` files at the top level.

### Validating T3 path references

Every T1 file may reference live docs paths in T3 (the form `https://hermes-agent.nousresearch.com/docs/...`). These drift: pages get renamed, restructured, removed. Two scripts catch drift:

```bash
# Fast offline check (~1s). Validates paths against the cached llms.txt.
bash scripts/check_t3_paths.sh

# Slower live check (~30s). Actually fetches each URL and verifies 200.
bash scripts/check_t3_paths.sh --live

# Force-refresh the llms.txt cache (it auto-refreshes if >24h stale).
bash scripts/check_t3_paths.sh --refresh
```

The check runs in CI on every push and PR (see `.github/workflows/check.yml`). The live HTTP check runs nightly and on manual dispatch to catch paths that the catalogue lists but the docs site no longer serves.

### Fixing path drift

If the validator reports missing or broken paths, two options:

- **Repair by hand** for a small number of paths — update the T1 file or `INDEX.md`, re-run the validator.
- **Auto-fix** for many paths at once — `scripts/fix_t3_paths.py` is a one-shot fixer that promotes bare paths to `/docs/...` form when the catalogue has them. Review the diff before committing; the script doesn't change the meaning of any path, only the prefix.

## See also

- The live docs: https://hermes-agent.nousresearch.com/docs
- The bundled `hermes-agent` skill: https://github.com/NousResearch/hermes-agent/tree/main/skills/autonomous-ai-agents/hermes-agent
- Worked examples: `skill/examples/`
- CI status: `.github/workflows/check.yml`
- Validation scripts: `scripts/check_t3_paths.sh`, `scripts/fix_t3_paths.py`
