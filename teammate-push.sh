#!/usr/bin/env bash
# =============================================================================
#  Pretend to be Priya: push a new commit to main on origin while you're busy.
#  Used in Task 15.   Usage:  ./teammate-push.sh
# =============================================================================
set -euo pipefail
LAB_DIR="${LAB_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/brewly-lab}"
REPO="$LAB_DIR/brewly"
STATE="$LAB_DIR/.lab-state"
[ -f "$STATE" ] || { echo "No lab found - run ./setup.sh first."; exit 1; }
# shellcheck disable=SC1090
. "$STATE"

URL=$(git -C "$REPO" remote get-url origin)
if [ -n "${TEAMMATE_COMMIT:-}" ]; then
  echo "Priya already pushed her commit ($TEAMMATE_COMMIT). Carry on with Task 15!"
  exit 0
fi

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
echo "📡 Priya is cloning origin..."
git clone -q -b main "$URL" "$TMP/priya"
cd "$TMP/priya"
cat > seasonal.py <<'PY'
SEASONAL = {"pumpkin spice latte": 3.80, "gingerbread latte": 3.70}
PY
git add seasonal.py
GIT_AUTHOR_NAME="Priya Shah" GIT_AUTHOR_EMAIL="priya@brewly.dev" \
GIT_COMMITTER_NAME="Priya Shah" GIT_COMMITTER_EMAIL="priya@brewly.dev" \
  git -c commit.gpgsign=false commit -q -m "Add seasonal menu"
git push -q origin main
C=$(git rev-parse HEAD)
echo "TEAMMATE_COMMIT=$C" >> "$STATE"

cat <<MSG

  📣 Priya (on Slack): "Just pushed 'Add seasonal menu' to main 🎃"

  Your laptop doesn't know about it yet. Go back to Task 15, step 2.

MSG
