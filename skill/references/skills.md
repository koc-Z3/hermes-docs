---
topic: skills
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Skills (where they live, how to list them)

The agent's own skill system. Short version.

## Where skills live

```
$HERMES_HOME/skills/                  # user-installed skills (this skill is here)
~/.claude/skills/                     # cross-compatible (Claude Code / Hermes)
```

The agent loads skills from these directories. Bundled skills ship with Hermes in `hermes-agent/skills/` but are copied to `$HERMES_HOME/skills/` on first install.

## Find your skills

```bash
hermes skills list                    # all installed
hermes skills search QUERY            # search by name/description
hermes skills inspect ID              # show metadata + frontmatter
hermes skills browse                  # open the Skills Hub (interactive)
hermes skills check                   # verify all skills load
hermes skills update                  # update from source
```

## In-session

```bash
/skills                               # list loaded in this session
/skill <name>                         # load a specific skill
/skills browse                        # hub
/skills search QUERY
```

## Install / uninstall

```bash
hermes skills install ID              # hub ID, or direct URL to a SKILL.md
hermes skills uninstall ID
hermes skills tap add REPO            # add a GitHub repo as a skill source
hermes bundles                        # list skill bundles
hermes skills config                  # enable/disable per platform
```

## Skill structure (what one looks like)

```
skill-name/
  SKILL.md            # required: frontmatter + body
  references/         # optional: progressive-disclosure files
  templates/          # optional: starter files
  scripts/            # optional: helper scripts
```

Required `SKILL.md` frontmatter:

```yaml
---
name: skill-name
description: One-paragraph description (used for routing)
version: 1.0.0
author: ...
license: MIT
---
```

## Preload a skill for one command

```bash
hermes -s hermes-docs -q "what's my skin"
hermes --skills hermes-docs,git-workflow -q "..."
```

## Self-check

```bash
hermes skills list | wc -l            # how many installed
hermes skills check                   # any broken?
hermes skills inspect hermes-docs     # this skill's metadata
```

## Escalate to T2 when:

- Authoring a new skill (full SKILL.md format, routing tables) → `hermes-agent/SKILL.md` "Routing Table" section + T3 `/docs/developer-guide/creating-skills`
- Need the full bundled-skills catalog (~90 skills) → T3 `/docs/reference/skills-catalog`
- Need the optional / installable skills catalog (~60) → T3 `/docs/reference/optional-skills-catalog`
- A skill fails to load → `hermes-agent/references/troubleshooting.md`
- Need the curator (background maintenance) details → T3 `/docs/user-guide/features/curator`
