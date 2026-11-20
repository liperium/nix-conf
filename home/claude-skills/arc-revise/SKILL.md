---
name: arc-revise
description: Address review feedback on my Phabricator revisions (proj.mapgears.com) that are "Ready to Update" / needs-revision. Pulls unresolved inline and top-level comments, checks out the revision, fixes them, then updates the diff. Use when the user asks to "address the comments on D12345", "work through ready to update", "fix review feedback", or "update my diffs".
---

# arc-revise

Every arc command needs a trailing `--`. Outside a repo, put
`--config phabricator.uri=https://proj.mapgears.com/` before `call-conduit`.
Below, `conduit` = `arc --config phabricator.uri=https://proj.mapgears.com/ call-conduit --`.

## Which diffs

- One revision: the `D<id>` the user gave.
- "All" / "ready to update": `phab-queue --json | jq '.[] | select(.bucket=="ready-to-update")'`.
  Show the list with a 1-line feedback summary per diff first, then do them **one at a time**,
  each with its own approval for the update.

## 1. Gather the feedback

Unresolved comments from others (my PHID: `echo '{}' | conduit user.whoami`):
```
echo '{"objectIdentifier":"D<id>"}' | conduit transaction.search | jq -r --arg me <my-phid> '
  .data[] | select((.type=="inline" or .type=="comment") and .authorPHID != $me)
  | (.fields | if type == "object" then . else {} end) as $f | select($f.isDone != true)
  | "\(.type) \($f.path // "-"):\($f.line // "-") diff=\($f.diff.id // "-")\n  \(.comments[0].content.raw)"'
```
- Results come newest first and are paged (`cursor.after`); pass `"after"` for more.
- `fields` is an object only on inlines (`path`, `line`, `length`, `diff.id`,
  `replyToCommentPHID`, `isDone`); on `comment` it's an array.
- "Build has FAILED / Link to build: <jenkins url>" comments are CI, not review: hand them
  to the **phab-ci** skill.
- An inline on an older `diff.id` may already be fixed: check the current code before acting.
- Prefixes reviewers use: `issue:` must fix; `suggestion:` / `nit:` / `question:` are the
  user's call; `(pre-existing)` = not introduced by this diff, ask before widening scope.
- Task context if needed: `maniphest.search` + `transaction.search` on `T<id>` (see arc-diff).

Show the user the list, grouped: will fix / needs their decision (questions, pre-existing,
disagreements). Don't answer reviewer questions or push back on their behalf.

## 2. Check out

In the clone (`phab-queue` column 5; none → say so and stop): clean tree required, then
`arc-checkout D<id>` unless already on the revision's branch (`git log -1` shows
`Differential Revision: .../D<id>`).

## 3. Fix

One commit amend (or a fixup commit squashed before sending) per diff; keep fixes to what the
comments ask. Track comment → change for the update message.

## 4. Update

Hand off to the **arc-diff** skill (rebase, checks, approval, `--update D<id>`). The `-m`
message lists what changed per comment, short:
`address review: bind nom_user as a parameter; run FeatureGroup selects through the session`.

Inline comments aren't marked done over conduit: tell the user which ones to tick
"Done" in the UI before submitting.
