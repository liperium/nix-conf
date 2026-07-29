#!/usr/bin/env bash
set -euo pipefail

REPO="/home/liperium/nix-conf"
MODE="${1:-plain}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nix-conf-sync-check"
STAMP="$CACHE_DIR/last-fetch"
FETCH_INTERVAL=900

notify() {
  if [ "$MODE" = "notify" ]; then
    command -v notify-send >/dev/null 2>&1 || return 0
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      notify-send "nix-conf" "$1" && return 0
      sleep 1
    done
  else
    echo "nix-conf: $1"
  fi
}

[ -d "$REPO/.git" ] || exit 0
cd "$REPO"
git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1 || exit 0

mkdir -p "$CACHE_DIR"
now=$(date +%s)
last=0
if [ -f "$STAMP" ]; then
  last=$(cat "$STAMP" 2>/dev/null || echo 0)
fi

if [ $(( now - last )) -gt "$FETCH_INTERVAL" ]; then
  if GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=5" \
    timeout 8 git fetch --quiet origin >/dev/null 2>&1; then
    echo "$now" > "$STAMP"
  fi
fi

dirty=$(git status --porcelain)
local_rev=$(git rev-parse HEAD)
remote_rev=$(git rev-parse '@{u}')
base_rev=$(git merge-base HEAD '@{u}')

ahead=0
behind=0
[ "$local_rev" != "$base_rev" ] && ahead=1
[ "$remote_rev" != "$base_rev" ] && behind=1

if [ "$behind" -eq 1 ] && [ "$ahead" -eq 0 ] && [ -z "$dirty" ]; then
  n=$(git rev-list --count "HEAD..@{u}")
  if git pull --ff-only --quiet origin >/dev/null 2>&1; then
    notify "pulled $n new commit(s)"
  else
    notify "remote ahead, pull failed, check manually"
  fi
  exit 0
fi

parts=()
[ -n "$dirty" ] && parts+=("uncommitted changes")
[ "$ahead" -eq 1 ] && parts+=("unpushed commits")
[ "$behind" -eq 1 ] && parts+=("remote ahead")

if [ "${#parts[@]}" -eq 0 ]; then
  notify "in sync"
else
  msg=$(printf '%s, ' "${parts[@]}")
  notify "${msg%, }"
fi
