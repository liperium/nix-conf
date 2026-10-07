# Check out a Phabricator revision on the branch name Phabricator already
# has for it, tracking origin/master, so the next `arc diff` keeps that name.
# Usage: arc-checkout D1234

id="${1:-}"
id="${id#D}"
if ! [[ "$id" =~ ^[0-9]+$ ]]; then
  echo "usage: arc-checkout D<id>" >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "arc-checkout: working tree not clean; commit or stash first" >&2
  exit 1
fi

branch=$(echo "{\"ids\":[$id]}" \
  | arc call-conduit -- differential.query \
  | jq -r '.response[0].branch // empty')
branch="${branch:-arcpatch-D$id}"

git fetch origin

backup=""
if git show-ref --verify --quiet "refs/heads/$branch"; then
  if [ "$(git branch --show-current)" = "$branch" ]; then
    git checkout --quiet --detach origin/master
  fi
  backup="$branch.bak"
  git branch -M "$branch" "$backup"
fi

git checkout -b "$branch" origin/master
arc patch --nobranch "D$id"

echo
echo "On $branch (tracking origin/master)."
if [ -n "$backup" ]; then
  echo "Previous local branch kept as $backup."
fi
