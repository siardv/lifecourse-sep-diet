#!/bin/sh
# publish the rendered _site to gh-pages through an isolated worktree.
# render first, then run this; it never renders and never touches main.
set -u
project="$HOME/projects/lifecourse-sep-diet"
cd "$project" || exit 1
[ "$(find "_site" -name "index.html" | wc -l | tr -d ' ')" -gt 10 ] \
  || { echo "abort: _site looks incomplete; run quarto render first"; exit 1; }
git fetch origin gh-pages || exit 1
wt="$(mktemp -d)/site"
git worktree add --detach "$wt" origin/gh-pages || exit 1
rsync -a --delete --exclude ".git" --exclude ".DS_Store" "_site/" "$wt/"
touch "$wt/.nojekyll"
cd "$wt" || exit 1
git add -A
if git diff --cached --quiet; then
  echo "gh-pages already matches _site; nothing to publish"
else
  git commit -m "publish site: $(date +%Y-%m-%d_%H%M)"
  git push origin HEAD:gh-pages || { echo "abort: push refused"; exit 1; }
  echo "published"
fi
cd "$project"
git worktree remove --force "$wt" 2>/dev/null
echo "live in about a minute: https://siardv.github.io/lifecourse-sep-diet/"
