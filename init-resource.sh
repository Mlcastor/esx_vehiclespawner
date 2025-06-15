#!/usr/bin/env bash
# init-resource.sh — scaffold & migrate a legacy ESX resource
set -euo pipefail

TEMPLATE_REPO_URL="https://github.com/Mlcastor/esx_resource_template.git"

usage() {
  echo "Usage: $0 <legacy-resource-path> [-n \"Resource Name\"] [-a \"Author\"] [-d \"Description\"]"
  exit 1
}

# ---------------- Parse CLI ----------------
LEGACY_PATH=""
NEW_NAME=""
AUTHOR="${GIT_AUTHOR_NAME:-}"
DESC=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)   NEW_NAME="$2"; shift 2 ;;
    -a|--author) AUTHOR="$2";  shift 2 ;;
    -d|--desc)   DESC="$2";    shift 2 ;;
    -*|--*)      usage ;;
    *)           LEGACY_PATH="$1"; shift ;;
  esac
done

[[ -z "$LEGACY_PATH" ]] && usage
[[ -d "$LEGACY_PATH" ]] || { echo "❌ Legacy path not found"; exit 1; }

LEGACY_PATH="$(realpath "$LEGACY_PATH")"
NEW_NAME="${NEW_NAME:-$(basename "$LEGACY_PATH")}"
AUTHOR="${AUTHOR:-$(git config user.name || echo 'Unknown')}"
DESC="${DESC:-"Modernised $NEW_NAME resource"}"
VERSION="0.1.0"

echo "➡️  Migrating '$LEGACY_PATH'  ->  '$NEW_NAME'"

# ---------------- Clone template ----------------
git clone --depth 1 "$TEMPLATE_REPO_URL" "$NEW_NAME"
cd "$NEW_NAME"
rm -rf .git    # we’ll start fresh history

# ---------------- Copy legacy code ----------------
rsync -av --exclude='.git' "$LEGACY_PATH"/ ./  >/dev/null

# ---------------- Token replacement ----------------
# Note: add extra template files if needed
FILES_TO_PATCH=$(grep -rl 'esx_vehiclespawner' .)

for file in $FILES_TO_PATCH; do
  sed -i \
    -e "s/esx_vehiclespawner/$NEW_NAME/g" \
    -e "s/Mlcastor/$AUTHOR/g" \
    -e "s/Modern ESX vehicle spawner module/$DESC/g" \
    -e "s/0.1.0/$VERSION/g" \
    "$file"
done

# ---------------- Initialise new git repo ----------------
git init -b main
git add .
git commit -m "feat($NEW_NAME): migrate legacy resource into template skeleton"

echo "✅  $NEW_NAME ready. Next:"
echo "   cd $NEW_NAME"
echo "   git remote add origin git@github.com:<your-org>/$NEW_NAME.git"
echo "   git push -u origin main"