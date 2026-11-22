#!/usr/bin/env bash
# =============================================================================
#  Brewly Git Rescue Lab - setup
#  Builds a deliberately messy Git repo (plus a fake "GitHub" remote) for you
#  to fix. Usage:   ./setup.sh            (first time)
#                   ./setup.sh --force    (wipe and start again)
#  Lab location defaults to ~/brewly-lab  (override: LAB_DIR=/some/path ./setup.sh)
# =============================================================================
set -euo pipefail

LAB_DIR="${LAB_DIR:-$HOME/brewly-lab}"
REPO="$LAB_DIR/brewly"
ORIGIN="$LAB_DIR/origin.git"
STATE="$LAB_DIR/.lab-state"

command -v git >/dev/null 2>&1 || { echo "git is required."; exit 1; }

FORCE=""; GITHUB_URL=""
while [ $# -gt 0 ]; do
  case "$1" in
    --force)  FORCE=1 ;;
    --github) shift; GITHUB_URL="${1:-}"
              [ -n "$GITHUB_URL" ] || { echo "Usage: ./setup.sh --github https://github.com/<you>/brewly.git"; exit 1; } ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

if [ -e "$LAB_DIR" ]; then
  if [ -n "$FORCE" ]; then
    rm -rf "$LAB_DIR"
  else
    echo "$LAB_DIR already exists. Add --force to wipe it and start over."
    exit 1
  fi
fi

if [ -n "$GITHUB_URL" ]; then
  echo "Checking you can reach $GITHUB_URL ..."
  git ls-remote "$GITHUB_URL" >/dev/null 2>&1 || {
    echo "Can't reach $GITHUB_URL"
    echo "  - Did you create the repo on github.com? (empty: no README, no .gitignore)"
    echo "  - Are you logged in? Try: gh auth login   (or use an SSH URL: git@github.com:<you>/brewly.git)"
    exit 1; }
  if [ -n "$(git ls-remote --heads "$GITHUB_URL" 2>/dev/null)" ] && [ -z "$FORCE" ]; then
    echo "That GitHub repo isn't empty. Use a new empty repo, or add --force to overwrite it."
    exit 1
  fi
fi

sha() { if command -v sha256sum >/dev/null 2>&1; then printf '%s' "$1" | sha256sum | cut -d' ' -f1
        else printf '%s' "$1" | shasum -a 256 | cut -d' ' -f1; fi; }

# --- fake team ---------------------------------------------------------------
PRIYA="Priya Shah|priya@brewly.dev"
TOM="Tom Okafor|tom@brewly.dev"
DAN="Dan Mercer|dan@brewly.dev"

T=1761980400   # 1 Nov 2025 07:00 UTC; every commit is 1h later (deterministic history)
G() { git -c commit.gpgsign=false -c tag.gpgsign=false -c core.hooksPath=/dev/null "$@"; }
as() { # as "$WHO" <git args...>
  local who="$1"; shift; T=$((T + 3600))
  GIT_AUTHOR_NAME="${who%%|*}" GIT_AUTHOR_EMAIL="${who##*|}" \
  GIT_COMMITTER_NAME="${who%%|*}" GIT_COMMITTER_EMAIL="${who##*|}" \
  GIT_AUTHOR_DATE="$T +0000" GIT_COMMITTER_DATE="$T +0000" G "$@"
}
commit() { G add -A; as "$1" commit -q -m "$2"; }

mkdir -p "$LAB_DIR"
G init -q --bare "$ORIGIN"
G init -q --bare "$LAB_DIR/backup.git"
G --git-dir="$LAB_DIR/backup.git" symbolic-ref HEAD refs/heads/main
G --git-dir="$ORIGIN" symbolic-ref HEAD refs/heads/main
G init -q "$REPO"
cd "$REPO"
G symbolic-ref HEAD refs/heads/main
G remote add origin "$ORIGIN"

# --- 1. initial project ------------------------------------------------------
cat > README.md <<'EOF'
# Brewly

Order coffee from your terminal.

    python3 app.py               # show the greeting
    python3 app.py total latte   # price including VAT
EOF
cat > config.py <<'EOF'
# Brewly configuration
CURRENCY = "GBP"
VAT_RATE = 0.20   # UK standard rate
EOF
cat > menu.py <<'EOF'
PRICES = {
    "espresso": 2.20,
    "latte": 3.00,
}
EOF
cat > app.py <<'EOF'
import sys

from config import VAT_RATE
from menu import PRICES

GREETING = "Welcome to Brewly!"


def total(item):
    return round(PRICES[item] * (1 + VAT_RATE), 2)


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "total":
        print(f"{total(sys.argv[2]):.2f}")
    else:
        print(GREETING)
EOF
echo "Fresh coffee, served fast." > banner.txt
echo "Thank you for chosing Brewly!" > footer.txt
printf '# Brewly team\n\n- Priya Shah (CTO)\n- Tom Okafor\n' > TEAM.md
mkdir -p tests
cat > tests/test_prices.sh <<'EOF'
#!/bin/sh
# A latte costs 3.00 + 20% VAT = 3.60
result=$(python3 -B app.py total latte)
if [ "$result" = "3.60" ]; then
  echo "PASS: latte costs $result"
else
  echo "FAIL: expected 3.60, got $result"
  exit 1
fi
EOF
chmod +x tests/test_prices.sh
commit "$PRIYA" "Initial commit"

printf 'item,price\nespresso,2.20\nlatte,3.00\n' > prices.csv
commit "$PRIYA" "Add prices.csv export"

cat > menu.py <<'EOF'
PRICES = {
    "espresso": 2.20,
    "latte": 3.00,
    "cappuccino": 3.10,
    "mocha": 3.40,
}
EOF
commit "$TOM" "Add more menu items"
as "$TOM" tag -a v1.0 -m "Release 1.0 - prices verified"
V1=$(G rev-parse HEAD)

# --- dan/experiments (cherry-pick source) ------------------------------------
G switch -q -c dan/experiments
echo "# idea: coffee by drone" > crazy_idea.py
commit "$DAN" "Start crazy drone idea"
echo "Thank you for choosing Brewly!" > footer.txt
commit "$DAN" "Fix typo in receipt footer"
FOOTER_FIXED_BLOB=$(G rev-parse HEAD:footer.txt)
echo "DRONE_SPEED = 9000" >> crazy_idea.py
commit "$DAN" "Make drones faster"
echo "Loyalty points on the blockchain?!" > blockchain.md
commit "$DAN" "Try blockchain loyalty"
DAN_TIP=$(G rev-parse HEAD)
G switch -q main

# --- more main history (bisect range) ----------------------------------------
cat >> README.md <<'EOF'

## Opening hours
Mon-Fri 07:00-18:00
EOF
commit "$TOM" "Add opening hours to README"

cat > menu.py <<'EOF'
PRICES = {
    "espresso": 2.20,
    "latte": 3.00,
    "cappuccino": 3.10,
    "mocha": 3.40,
    "flat white": 3.20,
}
EOF
commit "$PRIYA" "Add flat white to menu"
DISCOUNT_BASE=$(G rev-parse HEAD)

cat > config.py <<'EOF'
# ---- Brewly configuration ----
CURRENCY = "GBP"
VAT_RATE = 0.20
EOF
commit "$DAN" "Tidy up config formatting"

cat > menu.py <<'EOF'
PRICES = {
    "espresso": 2.20,
    "latte": 3.00,
    "cappuccino": 3.10,
    "mocha": 3.40,
    "flat white": 3.20,
    "cortado": 2.90,
}
EOF
commit "$TOM" "Add cortado to menu"
BRANCH_POINT=$(G rev-parse HEAD)

# discount-codes: merged into main, later found to break checkout
G switch -q -c feature/discount-codes "$DISCOUNT_BASE"
cat > discount.py <<'EOF'
CODES = {"FREECOFFEE": 1.00}   # 100% off everything... oops


def apply(code, amount):
    return amount * (1 - CODES.get(code, 0))
EOF
commit "$DAN" "Add discount codes"
G switch -q main
as "$DAN" merge -q --no-ff --no-edit feature/discount-codes
DISCOUNT_MERGE=$(G rev-parse HEAD)
G branch -q -D feature/discount-codes

# loyalty branches from here
G branch feature/loyalty "$BRANCH_POINT"

G rm -q prices.csv
as "$DAN" commit -q -m "Clean up old files"
CLEANUP_COMMIT=$(G rev-parse HEAD)
PRICES_BLOB=$(G rev-parse "$CLEANUP_COMMIT~1:prices.csv")

ORIG_BANNER_BLOB=$(G rev-parse HEAD:banner.txt)
echo "BREWLY IS CLOSED. GO HOME." > banner.txt
commit "$DAN" "Update banner text"
BANNER_COMMIT=$(G rev-parse HEAD)

sed 's/GREETING = "Welcome to Brewly!"/GREETING = "Welcome to Brewly - the best coffee in town!"/' app.py > app.tmp && mv app.tmp app.py
commit "$PRIYA" "Update greeting"

cat > CONTRIBUTING.md <<'EOF'
# Contributing
1. Branch off main
2. Open a pull request
3. Never force-push main
EOF
commit "$TOM" "Add contributing guide"

# --- feature branches --------------------------------------------------------
G switch -q feature/loyalty
sed 's/GREETING = "Welcome to Brewly!"/GREETING = "Welcome back to Brewly, loyalty member!"/' app.py > app.tmp && mv app.tmp app.py
cat > loyalty.py <<'EOF'
STAMPS_FOR_FREE_COFFEE = 9
EOF
commit "$TOM" "Add loyalty stamps and greeting"
LOYALTY_TIP=$(G rev-parse HEAD)

G switch -q main
MAIN_PUSHED=$(G rev-parse HEAD)

G switch -q -c feature/receipts
cat > receipt.py <<'EOF'
TEMPLATE = "Brewly receipt\n--------------\n{lines}\nTotal: {total}"
EOF
commit "$PRIYA" "Add receipt template"
RECEIPT_BASE=$(G rev-parse HEAD)

# push everything that "is on GitHub"
G push -q origin main feature/loyalty dan/experiments feature/receipts v1.0 2>/dev/null
for b in main feature/loyalty dan/experiments feature/receipts; do
  G branch -q --set-upstream-to="origin/$b" "$b"
done

# teammates' branches that exist ONLY on origin (you need git fetch to see them)
remote_only() { # remote_only <branch> <who> <file> <content> <message>
  G switch -q -c "$1" "$MAIN_PUSHED"; printf '%s\n' "$4" > "$3"; commit "$2" "$5"
  G push -q origin "$1" 2>/dev/null; G switch -q feature/receipts; G branch -q -D "$1"
  G update-ref -d "refs/remotes/origin/$1"
}
remote_only feature/opening-hours "$TOM"   hours.txt      "Mon-Fri 07:00-18:00"      "Add opening hours file"
HOURS_TIP=$(G --git-dir="$ORIGIN" rev-parse feature/opening-hours)
remote_only feature/menu-art      "$TOM"   menu_art.txt   "(coffee cup ASCII art coming soon)" "Add menu art placeholder"
remote_only bugfix/footer-spacing "$PRIYA" footer_note.md "Footer needs more spacing" "Note footer spacing bug"

# unpushed typo commit on feature/receipts
cat >> receipt.py <<'EOF'


def print_receipt(lines, total):
    print(TEMPLATE.format(lines="\n".join(lines), total=total))
EOF
commit "$PRIYA" "Add recipt printing"
RECEIPT_TREE=$(G rev-parse HEAD^{tree})

# feature/search: 4 messy commits (local only)
G switch -q -c feature/search main
SEARCH_BASE=$(G rev-parse HEAD)
echo "def search(term):" > search.py
commit "$TOM" "add search"
echo "    pass  # wip" >> search.py
commit "$TOM" "wip"
cat > search.py <<'EOF'
from menu import PRICES


def search(term):
    return [i for i in PRICES if term in i]
EOF
commit "$TOM" "fix"
echo "" >> search.py
echo "# usage: search('latte')" >> search.py
commit "$TOM" "actually works now"
SEARCH_TREE=$(G rev-parse HEAD^{tree})

# feature/reports: good commit + 2 junk debug commits (local only)
G switch -q -c feature/reports main
cat > reports.py <<'EOF'
def weekly_report(sales):
    return sum(sales)
EOF
commit "$PRIYA" "Add weekly report"
REPORT_GOOD=$(G rev-parse HEAD)
cat > reports.py <<'EOF'
def weekly_report(sales):
    print("DEBUG", sales)
    return sum(sales)
EOF
commit "$DAN" "debug: print everything"
echo "DEBUG DEBUG DEBUG" > debug.log
commit "$DAN" "more debug"

# feature/hot-chocolate + feature/iced-coffee: both start from an OLD main (local only)
G switch -q -c feature/hot-chocolate "$BRANCH_POINT"
echo 'HOT_CHOCOLATE = 3.20' > hot_chocolate.py
commit "$TOM" "Add hot chocolate"
echo 'TOPPINGS = ["marshmallow", "cream"]' >> hot_chocolate.py
commit "$TOM" "Add marshmallow topping"
HOT_TIP=$(G rev-parse HEAD)
G switch -q -c feature/iced-coffee "$BRANCH_POINT"
echo 'ICED_COFFEE = 3.30' > iced_coffee.py
commit "$PRIYA" "Add iced coffee"
echo 'ICE_LEVELS = ["light", "normal", "extra"]' >> iced_coffee.py
commit "$PRIYA" "Add ice options"
ICED_TIP=$(G rev-parse HEAD)

# one unpushed commit on main
G switch -q main
cat >> README.md <<'EOF'

## Team
Priya, Tom, Dan
EOF
commit "$DAN" "Update README"
INITIAL_MAIN=$(G rev-parse HEAD)

cat > "$STATE" <<EOF
V1=$V1
INITIAL_MAIN=$INITIAL_MAIN
MAIN_PUSHED=$MAIN_PUSHED
FOOTER_FIXED_BLOB=$FOOTER_FIXED_BLOB
DAN_TIP=$DAN_TIP
DISCOUNT_MERGE=$DISCOUNT_MERGE
CLEANUP_COMMIT=$CLEANUP_COMMIT
PRICES_BLOB=$PRICES_BLOB
ORIG_BANNER_BLOB=$ORIG_BANNER_BLOB
BANNER_COMMIT=$BANNER_COMMIT
LOYALTY_TIP=$LOYALTY_TIP
RECEIPT_BASE=$RECEIPT_BASE
RECEIPT_TREE=$RECEIPT_TREE
SEARCH_BASE=$SEARCH_BASE
SEARCH_TREE=$SEARCH_TREE
REPORT_GOOD=$REPORT_GOOD
HOT_TIP=$HOT_TIP
HOURS_TIP=$HOURS_TIP
ICED_TIP=$ICED_TIP
EOF

# --- real GitHub mode: copy everything up and point origin at GitHub --------
WHERE="$ORIGIN   (a stand-in GitHub on your laptop)"
if [ -n "$GITHUB_URL" ]; then
  echo "Pushing Brewly's history to GitHub (you may be asked to log in)..."
  G --git-dir="$ORIGIN" push -q --force "$GITHUB_URL" 'refs/heads/*:refs/heads/*' 'refs/tags/*:refs/tags/*'
  for r in $(G ls-remote --heads "$GITHUB_URL" | awk '{print $2}'); do   # remove leftovers from an old run
    G --git-dir="$ORIGIN" show-ref -q --verify "$r" || G push -q "$GITHUB_URL" ":$r"
  done
  G remote set-url origin "$GITHUB_URL"
  G fetch -q --prune origin
  for b in feature/opening-hours feature/menu-art bugfix/footer-spacing; do   # you discover these in Task 7
    G update-ref -d "refs/remotes/origin/$b"
  done
  rm -rf "$ORIGIN"
  WHERE="$GITHUB_URL   (real GitHub)"
fi

cat <<EOF

  ☕  Brewly Git Rescue Lab is ready.

  Your repo:        $REPO
  origin:           $WHERE
  Backup remote:    $LAB_DIR/backup.git   (you'll need this in Task 6)
  Cheat sheet:      CHEATSHEET.md

  Next:   cd $REPO
          git status
  Then open TASKS.md and start at Task 1.
  Check your work any time:   ./check.sh 1    (or ./check.sh all)

EOF
