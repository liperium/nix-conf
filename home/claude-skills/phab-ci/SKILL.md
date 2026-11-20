---
name: phab-ci
description: Find why the Harbormaster / Jenkins build failed on a Phabricator revision (proj.mapgears.com) and whether the change or the CI broke it. Use when the user asks "why did the build fail on D12345", "CI is red", "check the build", or a diff shows a failed build in phab-queue.
---

# phab-ci

`conduit` = `arc --config phabricator.uri=https://proj.mapgears.com/ call-conduit --`
(trailing `--` is required). Jenkins logs: `jenkins-get <path>` only (read-only, allowlisted).

## 1. Find the failed build

Fastest: Jenkins posts a comment on the revision, newest first:
```
echo '{"objectIdentifier":"D<id>"}' | conduit transaction.search \
  | jq -r '.data[] | select(.type=="comment") | .comments[0].content.raw
           | select(test("Build has FAILED")) | capture("Link to build: (?<u>\\S+)").u' | head -1
```
→ `https://jenkins3.mapgears.com/job/<job>/<n>/`. Make sure it's for the latest diff (compare
the comment date with the last update) before reading it.

No comment (e.g. the arc lint/unit build, or Jenkins never reported): go through Harbormaster.
1. Latest diff: `differential.revision.search` `{"constraints":{"ids":[<id>]}}` →
   `.fields.diffPHID`.
2. `harbormaster.buildable.search` `{"constraints":{"objectPHIDs":["<diffPHID>"]}}` → buildable
   PHID, status, `uri` (`B#####`).
3. `harbormaster.build.search` `{"constraints":{"buildables":["<PHID-HMBB>"]}}` → builds
   (`Jenkins evVue`, `Jenkins Darcee Nix CI`, `arc lint + arc unit`, ...) and status.
4. `harbormaster.target.search` `{"constraints":{"buildPHIDs":["<PHID-HMBD>"]}}` → failed
   target PHIDs.
5. The `jenkins.uri` artifact has no URL over conduit. Instead, the Jenkins build has the
   target PHID as its `PHID` parameter; search the `*-ci-nix` jobs (`darcee-ci-nix`,
   `evvue-ci-nix`, ...):
   ```
   jenkins-get 'job/<job>/api/json?tree=builds[number,result,actions[parameters[name,value]]]{0,50}' \
     | jq -r --arg t <PHID-HMBT> '.builds[] | select(any(.actions[]?.parameters[]?;
         .name=="PHID" and .value==$t)) | "\(.number) \(.result)"'
   ```

`Arcanist Lint Results` / `Arcanist Unit Results` targets failed: those came from the
author's local `arc lint` / `arc unit` at `arc diff` time. Re-run them locally (arc-diff
"Checks before sending"); no Jenkins log exists.

## 2. Read the log

`jenkins-get job/<job>/<n>/consoleText`; it can be long: `grep -nE 'FAILED|ERROR|Error|error:|Traceback|✖'`
and read around the first real failure (the last `ERROR: script returned exit code` is just
the pipeline giving up). Pipelines with stages: `job/<job>/<n>/wfapi/describe` lists stage
status, to find which stage failed first.

## 3. Classify and report

- **CI/infra**, not the change: `Could not parse object <hash>` (diff base not on origin, see
  arc-diff "Base branch"), agent/node/disk/network errors, timeouts, failures in tests
  unrelated to the touched files that also fail on master's latest build
  (`job/<job>/lastCompletedBuild/`).
- **The change**: failing test or lint in/near touched files: name the test, file:line, and
  the assertion/error.

Report: build link, failing stage, 2-5 lines of the relevant log, verdict. Then offer: fix it
(arc-revise flow), or re-trigger after an infra fix (arc-diff: rebase + `--update -m "rebase
onto master"`). Don't re-trigger or update without approval.
