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
Prefer two or more reviewers (multi-select): one reviews, the other can land it, so a
diff doesn't wait on a single person.

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
- <verb-first bullet: what changed, as behavior>
- <...>

NOTE: requires D<id> on `<repo>`

Test Plan:
**Set up**
- <step: other diffs to apply, commands to run, data to create>

**Test**
- <step>
- [ ] expect <behavior>
- <step>
- [ ] expect <behavior>

**Clean up**
- <undo the setup>

Reviewers: <phab usernames, comma separated>

Subscribers: <optional>

Maniphest Tasks: T<task>
```

### Title

`<Area>: <Description>`, imperative. `Technical:` for anything not user-facing (most diffs);
otherwise the product area (`Process:`, `Map Editor:`, `Accounts:`), combinable
(`Process, i18n:`). Reverts keep git's `Revert "..."` title.

### Summary

- Default: short lowercase verb-first bullets (`add ...`, `fix ...`, `make sure ...`), each
  one behavior a reviewer can check, not a file-by-file changelog. Big diffs: number the
  groups (`1. build the table columns ...`) with bullets under each.
- Small change: 1-2 sentences of prose instead, with the why when it isn't obvious
  ("Validation is not needed here: values come from server-side drop-downs").
- Callouts go after the bullets: `NOTE: requires D24907 on \`darcee\`` (cross-repo or
  stacked dependency), `NOTE:` for what is deliberately kept or left out, and the follow-up
  ticket for it (`{Q126} has been created to address this topic.`, `See Q131`).
- `Revert` diffs keep git's "This reverts commit <hash>." line.

### Test Plan

- Steps are lowercase imperatives against real routes and UI: `open /library`,
  ``click `Save` ``, ``in `Primary Group`, type ...``. Backticks for UI labels, buttons,
  fields; quotes for data names; real URLs/online resources to paste.
- Each step's checkbox sits right after it, same indent: `- [ ] expect ...`. Several
  expects per step are fine. Include negative/edge expects: buttons disabled at the last
  page, error on an unsupported type, `expect no ... error in the console`.
- Use existing fixture data by name (`"T2 - Many features 100k Points"`). Data the test
  creates is named after the task (`"T44258 - Process"`) and deleted in `**Clean up**`.
- Commands go in code blocks labelled with where to run them:
  ```` ```name=override.ini ```` / ```` ```name=~/proj/evvue ````.
  Use `NOTE:` for environment traps ("test from Darcee, not Vite") and `!!text!!` to
  highlight a crucial word.
- Backend-only change covered by tests: the test plan is just the command,
  `` `make test_functional_core` `` (or `make test_functional`).
- `N/A` is normal for refactors, renames, dependency upgrades, i18n text, build config and
  docs: changes with no new behavior to click through.
- Paired diffs (same change in evvue + darcee): put the full plan on one, `See D<id>.` on
  the other, and `requires D<id>` in each Summary.

Size the plan to the change's reach: a low-reach change (tooling, docs, config) gets 1-3
expects, not one per command. If the author already ran the plan, end it with
`Tested on my end, everything worked as expected.` (ask the user if unsure whether they did).
Omit `**Set up**`/`**Clean up**` when nothing is needed.

## Remarkup cheatsheet

- `**bold**`, `//italic//`, `` `mono` ``, `__underline__`, `!!highlight!!`
- Headers: `= H1 =`, `== H2 ==` (or `####Header` inline as seen in existing diffs)
- Checkbox: `- [ ] item` / `- [x] item`
- Links: `[[ https://url | text ]]`; objects auto-link: `T123`, `D456`, `rMGP<hash>`, `{F123}` embeds a file
- Code block: ```` ```lang=bash ```` ... ```` ``` ````; `name=<label>` titles it (file or dir)
- Callouts: `NOTE: ...`, `WARNING: ...`, `IMPORTANT: ...`
