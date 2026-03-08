#!/bin/bash
# Self-update sdd/ from GitHub and re-run setup
# Place this inside your project's sdd/ directory. It replaces itself with the latest version.
#
# Usage: ./sdd/update.sh [tool ...] [--no-setup]
#
# Examples:
#   ./sdd/update.sh                    # update sdd/, re-run setup interactively
#   ./sdd/update.sh claude-code         # update sdd/, re-run setup for claude-code
#   ./sdd/update.sh --all               # update sdd/, re-run setup for all tools
#   ./sdd/update.sh --no-setup          # update sdd/ only, skip setup
set -e

REPO_URL="https://github.com/cpy4/specterm.git"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDD_DIR="$PROJECT_ROOT/sdd"
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
echo "║   SDD Self-Update                         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Project: $PROJECT_ROOT"
echo "Source:  $REPO_URL"
echo ""

# Shallow clone the latest
echo "Fetching latest sdd/ from GitHub..."
git clone --depth=1 --quiet "$REPO_URL" "$TMP_DIR"

if [[ ! -d "$TMP_DIR/sdd" ]]; then
    echo "Error: sdd/ not found in the cloned repo"
    exit 1
fi

# Sync the new sdd/ over the existing one
echo "Updating sdd/..."
rsync -av --delete \
    --exclude='.DS_Store' \
    "$TMP_DIR/sdd/" "$SDD_DIR/"

echo ""
echo "✓ Updated sdd/ to latest version"

# Re-run setup unless --no-setup
if $no_setup; then
    echo ""
    echo "Skipped setup (--no-setup). Run manually if needed:"
    echo "  ./sdd/setup.sh"
else
    echo ""
    echo "── Re-running setup ──"
    (cd "$PROJECT_ROOT" && bash ./sdd/setup.sh "${setup_args[@]}")
fi

echo ""
echo "✓ Done! sdd/ is up to date."
