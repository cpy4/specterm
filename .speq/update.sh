#!/bin/bash
# Self-update .speq/ from GitHub and re-run setup
# Place this inside your project's .speq/ directory. It replaces itself with the latest version.
#
# Usage: ./.speq/update.sh [tool ...] [--no-setup]
#
# Examples:
#   ./.speq/update.sh                    # update .speq/, re-run setup interactively
#   ./.speq/update.sh claude-code         # update .speq/, re-run setup for claude-code
#   ./.speq/update.sh --all               # update .speq/, re-run setup for all tools
#   ./.speq/update.sh --no-setup          # update .speq/ only, skip setup
set -e

REPO_URL="https://github.com/cpy4/speq.git"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDD_DIR="$PROJECT_ROOT/.speq"
TMP_DIR=$(mktemp -d)

# Clean up temp directory on exit
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Check for --no-setup flag
no_setup=false
setup_args=()
for arg in "$@"; do
    if [[ "$arg" == "--no-setup" ]]; then
        no_setup=true
    else
        setup_args+=("$arg")
    fi
done

echo "╔══════════════════════════════════════════╗"
echo "║   Speq Self-Update                         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Project: $PROJECT_ROOT"
echo "Source:  $REPO_URL"
echo ""

# Shallow clone the latest
echo "Fetching latest .speq/ from GitHub..."
git clone --depth=1 --quiet "$REPO_URL" "$TMP_DIR"

if [[ ! -d "$TMP_DIR/.speq" ]]; then
    echo "Error: .speq/ not found in the cloned repo"
    exit 1
fi

# Sync the new .speq/ over the existing one
echo "Updating .speq/..."
rsync -av --delete \
    --exclude='.DS_Store' \
    "$TMP_DIR/.speq/" "$SDD_DIR/"

echo ""
echo "✓ Updated .speq/ to latest version"

# Re-run setup unless --no-setup
if $no_setup; then
    echo ""
    echo "Skipped setup (--no-setup). Run manually if needed:"
    echo "  ./.speq/setup.sh"
else
    echo ""
    echo "── Re-running setup ──"
    (cd "$PROJECT_ROOT" && bash ./.speq/setup.sh "${setup_args[@]}")
fi

echo ""
echo "✓ Done! .speq/ is up to date."
