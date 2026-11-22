#!/usr/bin/env bash
# =============================================================================
#  Brewly Git Rescue Lab - checker
#  Usage:  ./check.sh 3        check one task
#          ./check.sh 1 2 3    check several
#          ./check.sh all      check everything
# =============================================================================
LAB_DIR="${LAB_DIR:-$HOME/brewly-lab}"
REPO="$LAB_DIR/brewly"
ORIGIN="$LAB_DIR/origin.git"
STATE="$LAB_DIR/.lab-state"
LAST=17
LAB_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ -f "$STATE" ] || { echo "No lab found at $LAB_DIR - run ./setup.sh first."; exit 1; }
# shellcheck disable=SC1090
. "$STATE"
cd "$REPO" || exit 1

# Where is origin? A folder (offline mode) or a URL (real GitHub)?
URL=$(git remote get-url origin 2>/dev/null)
if [ -n "$URL" ] && [ ! -d "$URL" ]; then
  ORIGIN="$LAB_DIR/.origin-cache.git"     # private copy of GitHub, so your own refs aren't touched
  [ -d "$ORIGIN" ] || git init -q --bare "$ORIGIN"
  git --git-dir="$ORIGIN" fetch -q --prune --force "$URL" '+refs/heads/*:refs/heads/*' 2>/dev/null \
    || { echo "Couldn't reach $URL - check your internet / GitHub login."; exit 1; }
elif [ -n "$URL" ]; then
  ORIGIN="$URL"
fi

if [ -t 1 ]; then GREEN=$'\033[32m'; RED=$'\033[31m'; YELLOW=$'\033[33m'; DIM=$'\033[2m'; RESET=$'\033[0m'
else GREEN=""; RED=""; YELLOW=""; DIM=""; RESET=""; fi

why()  { printf '    %s✘ %s%s\n' "$RED" "$1" "$RESET"; OK=1; }
rev()  { git rev-parse -q --verify "$1" 2>/dev/null; }
orev() { git --git-dir="$ORIGIN" rev-parse -q --verify "$1" 2>/dev/null; }
has()  { git cat-file -e "$1" 2>/dev/null; }
ohas() { git --git-dir="$ORIGIN" cat-file -e "$1" 2>/dev/null; }
anc()  { git merge-base --is-ancestor "$1" "$2" 2>/dev/null; }
oanc() { git --git-dir="$ORIGIN" merge-base --is-ancestor "$1" "$2" 2>/dev/null; }
olog() { git --git-dir="$ORIGIN" log main --format=%s 2>/dev/null; }

# ---------------------------------------------------------------------------
check_1() {
  [ -n "$(git log --format=%h "$INITIAL_MAIN..main" -- TEAM.md 2>/dev/null)" ] \
                                                  || why "No new commit on main that changes TEAM.md"
  [ "$(git show main:TEAM.md 2>/dev/null | grep -c '^- ')" -ge 3 ] || why "Add yourself as a new line starting with '- ' in TEAM.md"
  git ls-files -m | grep -qx TEAM.md              && why "TEAM.md has changes that aren't committed yet"
}
check_2() {
  [ -n "$(git --git-dir="$ORIGIN" log --format=%h "$INITIAL_MAIN..main" -- TEAM.md 2>/dev/null)" ] \
                                                  || why "origin doesn't have your TEAM.md commit yet"
}
check_3() {
  [ -n "$(git stash list 2>/dev/null)" ]          || { why "Your stash is empty"; return; }
  found=""
  for s in $(git stash list --format=%gd); do
    git stash show --name-only "$s" 2>/dev/null | grep -qx menu.py && found=1
  done
  [ -n "$found" ]                                 || why "No stash contains your menu.py change"
  [ "$(rev main:menu.py)" = "$(rev "$INITIAL_MAIN:menu.py")" ] || why "menu.py change was committed - it should be stashed"
}
check_4() {
  [ "$(git log -1 --format=%s feature/receipts 2>/dev/null)" = "Add receipt printing" ] \
                                                  || why "Last commit on feature/receipts should say 'Add receipt printing'"
  [ "$(rev feature/receipts~1)" = "$RECEIPT_BASE" ] || why "You added a new commit - fix the existing one instead"
  [ "$(rev 'feature/receipts^{tree}')" = "$RECEIPT_TREE" ] || why "Files changed - only the message should change"
}
check_5() {
  b=feature/student-discount
  rev "$b" >/dev/null                             || { why "Branch $b doesn't exist"; return; }
  anc "$INITIAL_MAIN" "$b"                        || why "$b should be created from main"
  [ "$(git rev-list --count "main..$b" 2>/dev/null)" -ge 1 ] 2>/dev/null || why "$b needs a commit of its own"
  [ "$(orev "$b")" = "$(rev "$b")" ]              || why "origin doesn't have your latest $b commit"
  [ "$(git rev-parse --abbrev-ref "$b@{upstream}" 2>/dev/null)" = "origin/$b" ] \
                                                  || why "$b isn't tracking origin (push it with -u)"
}
check_6() {
  url=$(git remote get-url backup 2>/dev/null)
  [ -n "$url" ]                                   || { why "No remote called 'backup' (git remote -v to see your remotes)"; return; }
  b="$LAB_DIR/backup.git"
  bm=$(git --git-dir="$b" rev-parse -q --verify main 2>/dev/null)
  [ -n "$bm" ]                                    || { why "backup doesn't have a main branch yet - push main to it"; return; }
  git --git-dir="$b" merge-base --is-ancestor "$INITIAL_MAIN" main 2>/dev/null || why "backup's main isn't a copy of our main"
  git --git-dir="$b" log main --format=%s -- TEAM.md 2>/dev/null | grep -q . || why "backup's main is missing your TEAM.md commit"
}
check_7() {
  b=feature/opening-hours
  oanc "$HOURS_TIP" "$b"                          || { why "Tom's original commit is missing on origin - don't force-push"; return; }
  [ "$(orev "$b")" != "$HOURS_TIP" ]              || why "origin/$b has no new commit from you yet (commit, then push)"
  git --git-dir="$ORIGIN" show "$b:hours.txt" 2>/dev/null | grep -q '^Sat' || why "hours.txt on origin/$b needs a line starting with 'Sat'"
  [ "$(git rev-parse --abbrev-ref "$b@{upstream}" 2>/dev/null)" = "origin/$b" ] || why "Your local $b isn't tracking origin/$b"
}
check_8() {
  [ "$(rev main:prices.csv)" = "$PRICES_BLOB" ]   || why "main doesn't have the original prices.csv committed"
}
check_9() {
  anc "$LOYALTY_TIP" main                         || { why "feature/loyalty is not merged into main"; return; }
  git show main:app.py | grep -qF 'GREETING = "Welcome back to Brewly, loyalty member!"' \
                                                  || why "app.py on main should have the loyalty greeting"
  git show main:app.py | grep -qE '^(<<<<<<<|=======|>>>>>>>)' && why "Conflict markers (<<<<<<< ======= >>>>>>>) were committed"
  [ -f .git/MERGE_HEAD ]                          && why "The merge isn't finished - add the file and commit"
}
check_10() {
  [ "$(orev main:banner.txt)" = "$ORIG_BANNER_BLOB" ] || why "origin still shows the CLOSED banner (did you push?)"
  oanc "$BANNER_COMMIT" main                      || why "The bad commit was deleted from history - use revert instead"
  olog | grep -q '^Revert "Update banner text"'   || why "No revert commit found on origin/main"
}
check_11() {
  [ "$(rev main:footer.txt)" = "$FOOTER_FIXED_BLOB" ] || why "footer.txt on main still says 'chosing'"
  has main:crazy_idea.py                          && why "crazy_idea.py is on main - only copy the ONE fix commit"
  anc "$DAN_TIP" main                             && why "You merged all of dan/experiments - copy just one commit"
}
check_12() {
  [ "$(rev feature/reports)" = "$REPORT_GOOD" ]   || why "feature/reports should end on 'Add weekly report'"
}
check_13() {
  [ "$(git rev-list --count "$SEARCH_BASE..feature/search" 2>/dev/null)" = "1" ] || why "feature/search should have exactly 1 commit"
  [ "$(rev feature/search~1)" = "$SEARCH_BASE" ]  || why "The commit should sit where the branch started"
  [ "$(git log -1 --format=%s feature/search 2>/dev/null)" = "Add menu search" ] || why "Message should be 'Add menu search'"
  [ "$(rev 'feature/search^{tree}')" = "$SEARCH_TREE" ] || why "The code changed - squashing should keep the files the same"
}
check_14() {
  ohas main:discount.py                           && why "origin/main still contains discount.py"
  oanc "$DISCOUNT_MERGE" main                     || why "The merge was deleted from history - revert it instead"
  olog | grep -q '^Revert "Merge'                 || why "No revert-of-merge commit on origin/main"
}
check_15() {
  has main:hot_chocolate.py                       || { why "hot_chocolate.py isn't on main yet (rebase, then merge into main)"; return; }
  c=$(git log --first-parent --format='%H %s' main | grep ' Add marshmallow topping$' | head -1 | cut -d' ' -f1)
  [ -n "$c" ]                                     || why "main got a merge commit - rebase first so the merge is a fast-forward"
  [ "$c" = "$HOT_TIP" ]                           && why "feature/hot-chocolate was never rebased onto main"
}
check_16() {
  anc "$ICED_TIP" main                            || { why "feature/iced-coffee is not merged into main"; return; }
  ok=""
  for m in $(git rev-list --merges main); do [ "$(rev "$m^2")" = "$ICED_TIP" ] && ok=1; done
  [ -n "$ok" ]                                    || why "No merge commit for iced-coffee - merge it WITHOUT rebasing"
}
check_17() {
  git -C "$LAB_REPO" rev-parse --git-dir >/dev/null 2>&1 || { why "Clone YOUR GitHub copy of the lab (don't download a zip)"; return; }
  git -C "$LAB_REPO" fetch -q origin 2>/dev/null  || why "Couldn't reach your GitHub repo (check your internet / login)"
  git -C "$LAB_REPO" log origin/main --format=%s 2>/dev/null | grep -q '^Merge pull request #' \
                                                  || why "No merged pull request on your GitHub main yet"
  [ "$(git -C "$LAB_REPO" show origin/main:GRADUATES.md 2>/dev/null | grep -c '^- ')" -ge 1 ] \
                                                  || why "GRADUATES.md on GitHub main doesn't have your name yet"
  [ "$(git -C "$LAB_REPO" rev-parse main 2>/dev/null)" = "$(git -C "$LAB_REPO" rev-parse origin/main 2>/dev/null)" ] \
                                                  || why "Your local main is behind GitHub - switch to main and git pull"
}

TITLES=( ""
  "Your first commit" "Push to origin" "Stash unfinished work"
  "Fix a commit message" "Create and push a branch" "Push to a second remote"
  "Finish a teammate's branch" "Bring back a deleted file"
  "Fix a merge conflict" "Undo a pushed commit" "Copy one commit"
  "Throw away local commits" "Squash messy commits" "Undo a merge"
  "Rebase, then merge" "Merge without rebase" "Your first pull request" )

[ $# -eq 0 ] && { echo "Usage: ./check.sh <task number(s)> | all"; exit 1; }
[ "$1" = "all" ] && set -- $(seq 1 $LAST)

for f in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
  [ -f ".git/$f" ] && printf '%s! Heads up: something is still in progress (%s). Finish or abort it first.%s\n' "$YELLOW" "$f" "$RESET"
done

passed=0; total=0
for n in "$@"; do
  case "$n" in ''|*[!0-9]*) echo "Not a task number: $n"; continue;; esac
  [ "$n" -ge 1 ] && [ "$n" -le $LAST ] || { echo "No task $n"; continue; }
  total=$((total + 1))
  out=$(OK=0; check_"$n"; echo "__OK=$OK")
  OK=${out##*__OK=}; out=${out%__OK=*}
  if [ "$OK" = "0" ]; then
    printf '%s✔ Task %2d  %s%s\n' "$GREEN" "$n" "${TITLES[$n]}" "$RESET"; passed=$((passed + 1))
  else
    printf '%s✘ Task %2d  %s%s\n%s' "$RED" "$n" "${TITLES[$n]}" "$RESET" "$out"
  fi
done
[ "$total" -gt 1 ] && printf '\n%s%d / %d passed%s\n' "$DIM" "$passed" "$total" "$RESET"
[ "$passed" = "$LAST" ] && printf '\n☕  All %d done. Brewly is saved!\n' "$LAST"
exit 0
