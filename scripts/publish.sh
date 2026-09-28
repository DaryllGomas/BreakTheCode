#!/usr/bin/env bash
# Publish main to both homes of the site.
#   public  = DaryllGomas/BreakTheCode  -> https://breakthecode.daryllgomas.com  (serves `main`, CNAME in main)
#   origin  = Namkuzu-da-OS/BreakTheCode -> https://breakthecode.meatball-labs.com (serves `pages-meatball`)
# `pages-meatball` is always rebuilt as main + one commit that swaps CNAME, so the
# two repos run identical code with different domains.
set -euo pipefail
cd "$(dirname "$0")/.."

[ "$(git rev-parse --abbrev-ref HEAD)" = main ] || { echo "run from main"; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "working tree not clean"; exit 1; }
node scripts/verify-content.mjs

gh auth switch -u DaryllGomas >/dev/null
git push public main
gh auth switch -u Namkuzu-da-OS >/dev/null
git push origin main

git checkout -q -B pages-meatball main
printf "breakthecode.meatball-labs.com\n" > CNAME
git commit -q -am "pages: meatball-labs domain for the R&D mirror"
git push -f origin pages-meatball
git checkout -q main
gh api -X POST repos/Namkuzu-da-OS/BreakTheCode/pages/builds >/dev/null
echo "published: https://breakthecode.daryllgomas.com  +  https://breakthecode.meatball-labs.com"
