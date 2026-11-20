---
name: phab-queue
description: List my open Phabricator revisions on proj.mapgears.com by what they need from me (Ready to Update, Ready to Land, Must Review, Waiting), with build status and local clone. Use when the user asks "what diffs need me", "ready to update", "my queue", "what's waiting on me", or before working through several diffs.
---

# phab-queue

Run `phab-queue` (read-only, works from any dir). `phab-queue --json` for structured rows.
Columns: bucket, revision, Harbormaster build (`passed`/`failed`/`building`/`none`), repo,
local clone (`-` if not cloned under `~/Programming/MapGears/<repo>`), title.

Buckets:
- `ready-to-update`: mine, `needs-revision` / `changes-planned` → **arc-revise** skill.
- `ready-to-land`: mine, accepted → **arc-diff** skill, "Landing" section (the author lands).
- `must-review`: someone else's, `needs-review`, I'm a reviewer.
- `waiting`: mine, `needs-review` / `draft`. A `failed` build here still needs me →
  **phab-ci** skill.

Summarize as a short list grouped by bucket, `failed` builds called out, then offer the next
step per bucket. Don't act on any diff until the user picks.

Diffs with no local clone: say so; cloning is the user's call
(clone URIs: `diffusion.repository.search` with `"attachments":{"uris":true}`, use the `ssh://git@proj.mapgears.com/...` one).
