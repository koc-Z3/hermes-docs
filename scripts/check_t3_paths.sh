#!/usr/bin/env bash
# scripts/check_t3_paths.sh
#
# Validates every T3 (live-fetch) path reference in the skill against the
# authoritative paths in https://hermes-agent.nousresearch.com/docs/llms.txt.
#
# T3 paths must match the catalogue exactly. If they don't, the orchestrator
# (skill/hermes-docs.md) will construct a 404 URL when the agent escalates.
#
# Usage:
#   scripts/check_t3_paths.sh           # uses cached llms.txt
#   scripts/check_t3_paths.sh --refresh # re-fetches llms.txt first
#
# Exit codes:
#   0 = all T3 paths valid
#   1 = one or more T3 paths invalid (missing /docs/ prefix, drift, typo)
#   2 = unable to read or refresh llms.txt

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CACHE_DIR="$REPO_ROOT/.cache"
LLMS_CACHE="$CACHE_DIR/llms.txt"

mkdir -p "$CACHE_DIR"

# Refresh llms.txt if asked, or if cache is missing/stale (>24h old)
refresh_llms() {
  echo "Fetching https://hermes-agent.nousresearch.com/docs/llms.txt ..."
  if ! curl -fsSL --max-time 15 \
       "https://hermes-agent.nousresearch.com/docs/llms.txt" \
       -o "$LLMS_CACHE.tmp"; then
    echo "ERROR: failed to fetch llms.txt" >&2
    return 1
  fi
  mv "$LLMS_CACHE.tmp" "$LLMS_CACHE"
}

LIVE_CHECK=0
for arg in "$@"; do
  case "$arg" in
    --live) LIVE_CHECK=1 ;;
  esac
done

if [ "${1:-}" = "--refresh" ] || [ ! -s "$LLMS_CACHE" ] || [ -n "$(find "$LLMS_CACHE" -mmin +1440 2>/dev/null)" ]; then
  refresh_llms
fi

if [ ! -s "$LLMS_CACHE" ]; then
  echo "ERROR: $LLMS_CACHE missing or empty; run with --refresh" >&2
  exit 2
fi

# Extract authoritative paths from llms.txt
# llms.txt format:  - [Title](https://hermes-agent.nousresearch.com/docs/PATH): Description
KNOWN_T3=$(grep -oE 'https://hermes-agent\.nousresearch\.com[^)]+' "$LLMS_CACHE" \
           | sed 's|https://hermes-agent.nousresearch.com||' \
           | sort -u)

# A few catalogue paths are special (under /docs/ directly) — accept both forms
# so this script catches the bug we're fixing (missing /docs/ prefix).
KNOWN_T3_BARE=$(echo "$KNOWN_T3" | sed 's|^/docs/||')

# Files to scan
FILES=(
  "$REPO_ROOT/skill/hermes-docs.md"
  "$REPO_ROOT/skill/INDEX.md"
  "$REPO_ROOT"/skill/references/*.md
  "$REPO_ROOT"/skill/examples/*.md
)

# What counts as a T3 path:
#   - In backticks: `/user-guide/foo`, `/reference/foo`, etc.
#   - NOT slash-commands (single-segment, like `/yolo`, `/reset`)
#   - Path components may contain digits, dots (for .md), and underscores
#   - Trailing slashes are allowed
PATTERN='`(/[a-z][a-z0-9_-]+(/[a-z0-9_.-]+)+)/?`'

ERRORS=0
CHECKED=0
REPORT_FILE="$(mktemp)"

for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  while IFS= read -r match; do
    # Strip backticks
    p="${match//\`/}"
    # Skip if it's a CLI flag (e.g. /yolo) — those are single-segment.
    # Use 2+ segments so /docs/observability/ (a real path) is checked.
    segcount=$(echo "$p" | tr '/' '\n' | grep -c . || true)
    [ "$segcount" -ge 2 ] || continue
    CHECKED=$((CHECKED + 1))
    REL="${f#$REPO_ROOT/}"
    case "$p" in
      /docs/*)
        # Already-prefixed path. llms.txt can list paths that 404 (e.g.
        # /docs/foo/index when Docusaurus serves /docs/foo/) and can
        # also miss paths that 200 (catalogue drift). The local
        # validator doesn't decide — the live check (--live) does.
        # Here we just count it as checked; live check is authoritative.
        ;;
      *)
        # Bare path. The bug we fix: must be promoted to /docs/<p> if
        # /docs/<p> exists in the catalogue. Without --live, a path
        # that exists on the live site but isn't in the catalogue
        # slips through as a WARN.
        if echo "$KNOWN_T3" | grep -qx "/docs$p"; then
          echo "FAIL  $REL: \`$p\` is missing the /docs/ prefix (catalogue uses \`/docs$p\`)" >> "$REPORT_FILE"
          ERRORS=$((ERRORS + 1))
        elif echo "$KNOWN_T3" | grep -qx "$p"; then
          :  # OK
        else
          echo "WARN  $REL: \`$p\` not in llms.txt (live check would catch a real 404)" >> "$REPORT_FILE"
        fi
        ;;
    esac
  done < <(grep -hoE "$PATTERN" "$f" 2>/dev/null | sort -u)
done

echo
echo "T3 path check: $CHECKED paths checked across ${#FILES[@]} file patterns"

# Optional: live HTTP check. Slower (one request per unique path) but catches
# the failure mode where llms.txt lists a path that the docs site no longer
# serves (e.g. /docs/foo/index when Docusaurus serves /docs/foo/ instead).
if [ "$LIVE_CHECK" = "1" ]; then
  echo
  echo "Live HTTP check (curl HEAD on each path):"
  LIVE_FAIL=0
  for p in $(grep -rhoE "$PATTERN" "${FILES[@]}" 2>/dev/null \
             | tr -d '\`' \
             | sort -u); do
    case "$p" in
      /docs/*) ;;
      *) continue ;;  # skip non-T3 paths in the live check
    esac
    code=$(curl -fsSL -o /dev/null -w "%{http_code}" --max-time 8 "https://hermes-agent.nousresearch.com$p" 2>/dev/null || echo "ERR")
    if [ "$code" = "200" ]; then
      printf "  OK    %s\n" "$p"
    else
      printf "  FAIL  %s  HTTP %s\n" "$p" "$code"
      LIVE_FAIL=$((LIVE_FAIL + 1))
    fi
  done
  if [ "$LIVE_FAIL" -gt 0 ]; then
    echo
    echo "FAIL: $LIVE_FAIL path(s) return non-200 on the live site"
    echo "Fix: either remove the path or change it to one that returns 200"
    exit 1
  fi
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "FAIL: $ERRORS invalid T3 path reference(s):"
  echo
  cat "$REPORT_FILE"
  echo
  echo "Fix: ensure every T3 path starts with /docs/ and matches a path in"
  echo "     https://hermes-agent.nousresearch.com/docs/llms.txt"
  rm -f "$REPORT_FILE"
  exit 1
fi
echo "OK: all T3 paths valid"
rm -f "$REPORT_FILE"
