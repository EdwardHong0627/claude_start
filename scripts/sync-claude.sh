#!/usr/bin/env bash
#
# sync-claude.sh — sync Claude Code agents & skills between this repo and ~/.claude
#
# The active config Claude Code uses lives in ~/.claude/{agents,skills}.
# This repo keeps a version-controlled copy under .claude/{agents,skills}.
#
# Usage:
#   ./scripts/sync-claude.sh push    # ~/.claude  ->  repo   (stage your local edits for commit)
#   ./scripts/sync-claude.sh pull    # repo       ->  ~/.claude (apply the repo's versions locally)
#   ./scripts/sync-claude.sh status  # show what differs, change nothing
#
# Add --dry-run to push/pull to preview without writing.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="$HOME/.claude"
DIRS=(agents skills)

DIRECTION="${1:-}"
DRY_RUN=""
[[ "${2:-}" == "--dry-run" ]] && DRY_RUN="--dry-run"

# rsync flags: archive, verbose, delete files not present in source, with a sane filter.
RSYNC_OPTS=(-a --delete --itemize-changes --exclude '.DS_Store')
[[ -n "$DRY_RUN" ]] && RSYNC_OPTS+=(--dry-run)

sync_dir() {
  local src="$1" dst="$2" name="$3"
  if [[ ! -d "$src" ]]; then
    echo "  (skip $name — no source at $src)"
    return
  fi
  mkdir -p "$dst"
  echo "  $name:"
  rsync "${RSYNC_OPTS[@]}" "$src/" "$dst/" | sed 's/^/    /' || true
}

case "$DIRECTION" in
  push)
    echo "Syncing ~/.claude  ->  repo${DRY_RUN:+ (dry run)}"
    for d in "${DIRS[@]}"; do sync_dir "$HOME_DIR/$d" "$REPO_DIR/.claude/$d" "$d"; done
    echo "Done. Review with 'git status', then commit."
    ;;
  pull)
    echo "Syncing repo  ->  ~/.claude${DRY_RUN:+ (dry run)}"
    for d in "${DIRS[@]}"; do sync_dir "$REPO_DIR/.claude/$d" "$HOME_DIR/$d" "$d"; done
    echo "Done. Run /agents or restart Claude Code to reload."
    ;;
  status)
    echo "Differences (repo vs ~/.claude); '<' = only/newer in repo side shown by diff:"
    for d in "${DIRS[@]}"; do
      echo "  $d:"
      diff -rq "$REPO_DIR/.claude/$d" "$HOME_DIR/$d" 2>/dev/null | sed 's/^/    /' || true
    done
    echo "(no output under a dir = in sync)"
    ;;
  *)
    grep '^#' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
