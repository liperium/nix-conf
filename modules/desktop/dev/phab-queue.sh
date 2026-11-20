# My open Phabricator revisions, bucketed like the Differential dashboard.
# Read-only. Usage: phab-queue [--json]
# Columns: bucket, revision, build status, repo, local clone (or -), title.

clones="${PHAB_CLONES:-$HOME/Programming/MapGears}"

conduit() {
  arc --config phabricator.uri=https://proj.mapgears.com/ call-conduit -- "$1" \
    | jq -e '.response' 2>/dev/null || { echo "phab-queue: $1 failed" >&2; exit 1; }
}

me=$(echo '{}' | conduit user.whoami | jq -r .phid)

revs=$(jq -n --arg me "$me" '{constraints:{authorPHIDs:[$me],
    statuses:["needs-review","needs-revision","changes-planned","accepted","draft"]}}' \
    | conduit differential.revision.search | jq '.data')
reviews=$(jq -n --arg me "$me" '{constraints:{reviewerPHIDs:[$me],statuses:["needs-review"]}}' \
  | conduit differential.revision.search | jq --arg me "$me" '[.data[] | select(.fields.authorPHID != $me)]')
all=$(jq -n --argjson a "$revs" --argjson b "$reviews" '$a + $b')

repos=$(echo "$all" | jq '{constraints:{phids:([.[].fields.repositoryPHID] | unique | map(select(.)))}}' \
  | conduit diffusion.repository.search \
  | jq '.data | map({(.phid): ((.fields.shortName // .fields.name) | ascii_downcase)}) | add // {}')
builds=$(echo "$all" | jq '{constraints:{objectPHIDs:[.[].fields.diffPHID]}}' \
  | conduit harbormaster.buildable.search \
  | jq '.data | map({(.fields.objectPHID): .fields.buildableStatus.value}) | add // {}')

rows=$(echo "$all" | jq --arg me "$me" --arg clones "$clones" \
  --argjson repos "$repos" --argjson builds "$builds" '
  [.[] | .fields as $f | {
    bucket: (if $f.authorPHID != $me then "must-review"
             else {"needs-revision":"ready-to-update","changes-planned":"ready-to-update",
                   "accepted":"ready-to-land"}[$f.status.value] // "waiting" end),
    id: "D\(.id)",
    status: $f.status.value,
    build: ($builds[$f.diffPHID] // "none"),
    repo: ($repos[$f.repositoryPHID] // "-"),
    title: $f.title
  } | .clone = (if .repo == "-" then "-" else "\($clones)/\(.repo)" end)]
  | sort_by(.bucket as $b | ["ready-to-update","ready-to-land","must-review","waiting"] | index($b))')

# Drop clone paths that don't exist locally.
for c in $(echo "$rows" | jq -r '[.[].clone] | unique[] | select(. != "-")'); do
  [ -d "$c" ] || rows=$(echo "$rows" | jq --arg c "$c" 'map(if .clone == $c then .clone = "-" end)')
done

if [ "${1:-}" = "--json" ]; then
  echo "$rows"
else
  echo "$rows" | jq -r '.[] | [.bucket, .id, .build, .repo, .clone, .title] | @tsv'
fi
