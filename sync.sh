#!/bin/bash
# Sync .speq/ from this repo to a target project (for local development)
# Usage: ./sync.sh /path/to/your-project [tool ...]
#
# Examples:
#   ./sync.sh ~/Code/my-app                    # sync .speq/, re-run setup interactively
#   ./sync.sh ~/Code/my-app claude-code         # sync .speq/, re-run setup for claude-code
#   ./sync.sh ~/Code/my-app --all               # sync .speq/, re-run setup for all tools
#   ./sync.sh ~/Code/my-app --no-setup          # sync .speq/ only, skip setup
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDD_SOURCE="$SCRIPT_DIR/.speq"

if [[ -z "$1" ]]; then
    echo "Usage: ./sync.sh <project-path> [tool ...] [--no-setup]"
    echo ""
    echo "Syncs .speq/ from this repo into the target project."
    echo ""
    echo "Options:"
    echo "  <project-path>   Path to the target project"
    echo "  [tool ...]       Tools to set up (claude-code, cursor, opencode, zed, --all)"
    echo "  --no-setup       Only sync files, don't re-run setup.sh"
    echo ""
    echo "Examples:"
    echo "  ./sync.sh ~/Code/my-app"
    echo "  ./sync.sh ~/Code/my-app claude-code cursor"
    echo "  ./sync.sh ~/Code/my-app --all"
    echo "  ./sync.sh ~/Code/my-app --no-setup"
    exit 1
fi

TARGET="$1"
shift

if [[ ! -d "$TARGET" ]]; then
    echo "Error: $TARGET is not a directory"
    exit 1
fi

if [[ ! -d "$SDD_SOURCE" ]]; then
    echo "Error: .speq/ not found at $SDD_SOURCE"
    exit 1
fi

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
echo "║   Speq Sync                                ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Source: $SDD_SOURCE"
echo "Target: $TARGET/.speq/"
echo ""

# Sync .speq/ to target, excluding .DS_Store
rsync -av --delete \
    --exclude='.DS_Store' \
    "$SDD_SOURCE/" "$TARGET/.speq/"

echo ""
echo "✓ Synced .speq/ to $TARGET/.speq/"

# Re-run setup unless --no-setup
if $no_setup; then
    echo ""
    echo "Skipped setup (--no-setup). Run manually if needed:"
    echo "  cd $TARGET && ./.speq/setup.sh"
else
    echo ""
    echo "── Re-running setup ──"
    (cd "$TARGET" && bash ./.speq/setup.sh "${setup_args[@]}")
fi

echo ""
echo "✓ Done!"
