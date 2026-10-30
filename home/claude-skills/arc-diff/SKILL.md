---
name: arc-diff
description: Create or update a Phabricator Differential revision (arc diff) for MapGears repos on proj.mapgears.com. Use when the user asks to "make a diff", "arc diff", "send for review", "update D12345", or to write a diff summary / test plan in remarkup.
---

# arc diff (Phabricator, proj.mapgears.com)

Diffs are for reviewers: they read the summary, follow the test plan, comment on code.
Keep every section short and straight to the point. Decisions and background live in the
Maniphest task (T#####) and its comments, link instead of repeating.

## Rules

- `arc` runs non-interactively here: **every** arc command needs a trailing `--`
  (`arc diff ... --`, `echo '{...}' | arc call-conduit -- differential.query`).
- Creating/updating a revision publishes it and notifies reviewers. Show the user the full
  message and the exact command, and get explicit approval before running it.
- Commit only the files that belong to the change; check `git status` first.

## Task and reviewers

Branch naming schemes in these repos:
- `T<task>-<Short-Description>` (most common, e.g. `T44442-Documentation-On-importNpmLock`)
- `feature/<desc>` or `feature/T<task>-<desc>` (long-lived features)
- `arcpatch-D<id>` (made by `arc patch`, the revision already exists: update it, don't create)
- `master`, `v<NN>/main`, `v<NN>.<N>` (main/release branches: never commit here, branch first)

Take the task from `T(\d+)` in the branch name. If it isn't there, or reviewers aren't known,
ask the user both in one AskUserQuestion before writing the message. Offer the reviewers seen
in recent commits as options: `git log -20 --format=%B | grep '^Reviewers:' | sort | uniq -c`.

## Workflow

1. If on a main/release branch: `git switch -c T<task>-<Desc>`.
2. Commit (first line = diff title, e.g. `Technical: ...`, `Roles: ...`).
3. Write the message file (format below) in the scratchpad.
4. Create: `arc diff origin/master --create --message-file <file> --`
   Update an existing one: `arc diff origin/master --update D<id> --message-file <file> --`
   (`--draft` to create without notifying; `--nolint --nounit` if the repo has no linters configured).
5. Report the `D#####` URL arc prints. A new revision shows `Draft` until its Harbormaster
   build finishes, then reviewers are notified; if it stays Draft, the user clicks "Request Review".

Read existing revisions: `echo '{"ids":[24943]}' | arc call-conduit -- differential.query`.
Read a task: `echo '{"constraints":{"ids":[44442]}}' | arc call-conduit -- maniphest.search`.
Its comments (the description is often not the whole story):
`echo '{"objectIdentifier":"T44442"}' | arc call-conduit -- transaction.search`.
Check a reviewer username exists:
`echo '{"constraints":{"usernames":["adube"]}}' | arc call-conduit -- user.search`.

## Updating a revision

- `--message-file` is only read on create. On `--update`, give the update comment with
  `-m "<what changed since the last diff>"`, or arc opens an editor (set `EDITOR=true` as a
  fallback so it never hangs).
- arc amends the commit (adds `Differential Revision:`), so the hash changes and files show
  as modified on disk afterwards. Expected; don't redo the commit.
- To re-run lint/unit on the same code (e.g. after fixing the local env), `--update` with the
  unchanged commit is enough; say so in `-m`.

## Stacked diffs

A change that builds on an unlanded one goes on a branch made from that branch, and is
diffed against it, not master: `arc diff <parent-branch> --create ...`. Put
`Depends on D<parent>.` in the Summary so Phabricator links the two.

## Lint and unit (darcee devenv)

- darcee's `.arcconfig` uses `PytestTestEngine`, which calls a bare `pytest`. Outside the
  devenv shell that fails with `pytest: command not found`: run arc inside it,
  `devenv shell -- arc diff ... --`.
- `arc unit` runs the whole unit suite, extensions included (`testpaths = darcee` takes in
  `darcee/modules/extensions/*`). "UNIT ERRORS" does not block the revision but shows on it.
- Before blaming the change for unit errors, check the local env: a broken `data/`
  (`ls -ld data`, e.g. a dangling symlink; `mx-db-load` recreates it) or stale test DBs.
  Get the failing test names with `bin/pytest -q -rfE` inside the shell, show the user the
  cause, and fix it before `--update`.
- Don't run arc's unit tests while another functional run uses the `*_test` databases.

## Message format (fields parsed by arc)

```
<Title>

Summary:
<1-3 lines: what changed and why. Link context instead of explaining it.>

Test Plan:
**Setup**
<what to do before testing: other diffs to apply, commands to run, data to load>

**Test**
- <step>
  - [ ] Expect <behavior / interaction>
- <step>
  - [ ] Expect <behavior / interaction>

Reviewers: <phab usernames, comma separated>

Subscribers: <optional>

Maniphest Tasks: T<task>
```

Size the plan to the change's reach: a low-reach change (tooling, docs, config) gets 1-3
expects, not one per command. If the author already ran the plan, end it with
`Tested on my end, everything worked as expected.` (ask the user if unsure whether they did).
Omit `**Setup**` when nothing is needed. For code-only changes `Test Plan:` can say what to
read (`**Look at code**`) plus the checks you ran. `N/A` only for trivial/automated diffs.

## Remarkup cheatsheet

- `**bold**`, `//italic//`, `` `mono` ``, `__underline__`
- Headers: `= H1 =`, `== H2 ==` (or `####Header` inline as seen in existing diffs)
- Checkbox: `- [ ] item` / `- [x] item`
- Links: `[[ https://url | text ]]`; objects auto-link: `T123`, `D456`, `rMGP<hash>`, `{F123}` embeds a file
- Code block: ```` ```lang=bash ```` ... ```` ``` ````
- Callouts: `NOTE: ...`, `WARNING: ...`, `IMPORTANT: ...`
