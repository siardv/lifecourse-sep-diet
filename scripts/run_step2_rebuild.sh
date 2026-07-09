#!/bin/sh
# rebuild runner for step 2: backs up main_corrected.sav, renders only the
# preparation notebook, then runs the acceptance verifier against the backup.
# usage: scripts/run_step2_rebuild.sh   (from anywhere; paths are absolute)

set -u
project="$HOME/projects/gh/lifecourse-sep-diet"
cd "$project" || exit 1

qmd="analysis/data/preparation/index.qmd"
sav="assets/data/saved/main_corrected.sav"

# the rebuilt notebook must already be deployed
grep -q "Coding Review Outcomes" "$qmd" || {
  echo "abort: $qmd is not the rebuilt notebook; deploy it first"
  exit 1
}

# pre-render backup; the verifier proves the regenerated file matches it
[ -f "$sav" ] || { echo "abort: $sav not found"; exit 1; }
ts="$(date +%Y%m%d_%H%M%S)"
backup="assets/data/saved/main_corrected_prerender_$ts.sav"
cp -p "$sav" "$backup" || { echo "abort: backup failed"; exit 1; }
echo "pre-render backup: $backup"

# targeted render: only step 2 re-executes; all other pages stay untouched
quarto render "$qmd" || { echo "abort: quarto render failed"; exit 1; }

# acceptance verification: dataset equivalence, ledger invariants, evidence presence
Rscript "scripts/verify_step2_rebuild.R" "$backup" "$project" || {
  echo "verification FAILED; the pre-render backup is untouched at $backup"
  exit 1
}

echo ""
echo "step 2 rebuilt and verified."
echo "  page:   _site/analysis/data/preparation/index.html"
echo "  backup: $backup (safe to delete once the page has been reviewed)"
