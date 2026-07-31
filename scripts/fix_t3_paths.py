#!/usr/bin/env python3
"""
Fix T3 path references in the skill: add /docs/ prefix to bare paths.

A T3 path is a backtick-wrapped path in skill/hermes-docs.md, skill/INDEX.md,
skill/references/*.md, or skill/examples/*.md. Paths already prefixed with
/docs/ are left alone. CLI slash-commands (single-segment like `/yolo`) are
left alone — those aren't T3 paths.

This script:
  1. Loads the authoritative path list from .cache/llms.txt
  2. Walks every T1/INDEX/examples file
  3. For each backtick-wrapped path with 2+ segments:
     - If it matches a known /docs/... path, leave it
     - If it matches a known path when prefixed with /docs/, add the prefix
     - Otherwise, leave it (the validator will flag it)
  4. Reports what changed
"""
import os
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CACHE = REPO / ".cache" / "llms.txt"
TARGETS = [
    REPO / "skill" / "hermes-docs.md",
    REPO / "skill" / "INDEX.md",
    *sorted((REPO / "skill" / "references").glob("*.md")),
    *sorted((REPO / "skill" / "examples").glob("*.md")),
]

# Backtick-wrapped path with 2+ segments (excludes /yolo, /reset etc.)
PATH_RE = re.compile(r"`(/[a-z][a-z-]+(?:/[a-z][a-z0-9_.-]+)+)`")


def load_known():
    if not CACHE.exists():
        print(f"ERROR: {CACHE} missing — run scripts/check_t3_paths.sh --refresh first", file=sys.stderr)
        sys.exit(1)
    known_full = set()
    for line in CACHE.read_text().splitlines():
        m = re.search(r"https://hermes-agent\.nousresearch\.com(/docs/[^)\s]+)", line)
        if m:
            known_full.add(m.group(1).rstrip("/"))
    known_bare = {"/" + p.replace("/docs/", "", 1) for p in known_full if p.startswith("/docs/")}
    return known_full, known_bare


def fix_file(path: Path, known_full: set, known_bare: set) -> int:
    text = path.read_text()
    changes = 0

    def repl(m):
        nonlocal changes
        full = m.group(1).rstrip("/")
        if full in known_full:
            return m.group(0)  # already correct
        if full in known_bare:
            changes += 1
            return f"`/docs{full}`"
        return m.group(0)  # unknown — leave for validator to flag

    new = PATH_RE.sub(repl, text)
    if changes:
        path.write_text(new)
    return changes


def main():
    known_full, known_bare = load_known()
    print(f"Loaded {len(known_full)} catalogue paths, {len(known_bare)} bare forms")
    print()
    total = 0
    for f in TARGETS:
        if not f.exists():
            continue
        n = fix_file(f, known_full, known_bare)
        if n:
            rel = f.relative_to(REPO)
            print(f"  fixed {n:3d} paths  {rel}")
            total += n
    print()
    print(f"Total: {total} paths prefixed with /docs/")


if __name__ == "__main__":
    main()
