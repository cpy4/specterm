#!/bin/bash
# SDD Setup Script — installs integrations for your AI coding tool
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"

echo "╔══════════════════════════════════════════╗"
echo "║   Spec-Driven Development Setup          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Create .specs directory structure
mkdir -p "$PROJECT_ROOT/.specs/steering"
mkdir -p "$PROJECT_ROOT/.specs/specs"
echo "✓ Created .specs/ directory structure"

# Detect which tools to set up
setup_claude_code=false
setup_cursor=false
setup_opencode=false
setup_agents_md=false
setup_copilot=false

if [[ "$1" == "--all" ]]; then
    setup_claude_code=true
    setup_cursor=true
    setup_opencode=true
    setup_agents_md=true
    setup_copilot=true
elif [[ -n "$1" ]]; then
    for tool in "$@"; do
        case "$tool" in
            claude-code|claude) setup_claude_code=true ;;
            cursor)            setup_cursor=true ;;
            opencode|oc)       setup_opencode=true ;;
            zed|agents)        setup_agents_md=true ;;
            copilot|gh-copilot) setup_copilot=true ;;
            *)                 echo "Unknown tool: $tool (use: claude-code, cursor, opencode, zed, copilot)" ;;
        esac
    done
else
    echo "Which tools do you use? (space-separated, or 'all')"
    echo "  Options: claude-code  cursor  opencode  zed  copilot"
    echo ""
    read -p "> " tools
    for tool in $tools; do
        case "$tool" in
            claude-code|claude|cc) setup_claude_code=true ;;
            cursor)                setup_cursor=true ;;
            opencode|oc)           setup_opencode=true ;;
            zed|agents)            setup_agents_md=true ;;
            copilot|gh-copilot)    setup_copilot=true ;;
        esac
    done
    [[ "$tools" == "all" ]] && setup_claude_code=true && setup_cursor=true && setup_opencode=true && setup_agents_md=true && setup_copilot=true
fi

# Claude Code integration
if $setup_claude_code; then
    echo ""
    echo "── Claude Code ──"
    mkdir -p "$PROJECT_ROOT/.claude/commands"
    cp "$SCRIPT_DIR/integrations/claude-code/commands/"*.md "$PROJECT_ROOT/.claude/commands/"
    echo "✓ Installed slash commands: /spec, /spec-from-issue, /implement, /design-first, /bugfix, /tasks, /steering, /sync-to-issue"

    if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
        if grep -q "Spec-Driven Development" "$PROJECT_ROOT/CLAUDE.md" 2>/dev/null; then
            echo "⊘ CLAUDE.md already contains SDD section — skipped"
        else
            echo "" >> "$PROJECT_ROOT/CLAUDE.md"
            cat "$SCRIPT_DIR/integrations/claude-code/CLAUDE.md.snippet" >> "$PROJECT_ROOT/CLAUDE.md"
            echo "✓ Appended SDD section to CLAUDE.md"
        fi
    else
        cp "$SCRIPT_DIR/integrations/claude-code/CLAUDE.md.snippet" "$PROJECT_ROOT/CLAUDE.md"
        echo "✓ Created CLAUDE.md with SDD section"
    fi
fi

# Cursor integration
if $setup_cursor; then
    echo ""
    echo "── Cursor ──"
    mkdir -p "$PROJECT_ROOT/.cursor/rules"
    cp "$SCRIPT_DIR/integrations/cursor/rules/"*.mdc "$PROJECT_ROOT/.cursor/rules/"
    echo "✓ Installed conditional rule: .cursor/rules/speq.mdc"

    mkdir -p "$PROJECT_ROOT/.cursor/commands"
    cp "$SCRIPT_DIR/integrations/cursor/commands/"*.md "$PROJECT_ROOT/.cursor/commands/"
    echo "✓ Installed slash commands: /spec, /spec-from-issue, /implement, /design-first, /bugfix, /tasks, /steering, /sync-to-issue"
fi

# OpenCode integration
if $setup_opencode; then
    echo ""
    echo "── OpenCode ──"
    mkdir -p "$PROJECT_ROOT/.opencode/commands"
    cp "$SCRIPT_DIR/integrations/opencode/commands/"*.md "$PROJECT_ROOT/.opencode/commands/"
    echo "✓ Installed commands: /spec, /spec-from-issue, /implement, /design-first, /bugfix, /tasks, /steering, /sync-to-issue"

    # Set up AGENTS.md (OpenCode's primary rules file)
    if [ -f "$PROJECT_ROOT/AGENTS.md" ]; then
        if grep -q "Spec-Driven Development" "$PROJECT_ROOT/AGENTS.md" 2>/dev/null; then
            echo "⊘ AGENTS.md already contains SDD section — skipped"
        else
            echo "" >> "$PROJECT_ROOT/AGENTS.md"
            cat "$SCRIPT_DIR/integrations/agents-md/AGENTS.md.snippet" >> "$PROJECT_ROOT/AGENTS.md"
            echo "✓ Appended SDD section to AGENTS.md"
        fi
    else
        cp "$SCRIPT_DIR/integrations/agents-md/AGENTS.md.snippet" "$PROJECT_ROOT/AGENTS.md"
        echo "✓ Created AGENTS.md with SDD section"
    fi

    # Hint about opencode.json instructions field
    if [ -f "$PROJECT_ROOT/opencode.json" ]; then
        if grep -q ".speq/RULES.md" "$PROJECT_ROOT/opencode.json" 2>/dev/null; then
            echo "⊘ opencode.json already references .speq/RULES.md — skipped"
        else
            echo "⚠ Tip: Add \".speq/RULES.md\" to the \"instructions\" array in opencode.json"
            echo "  This auto-loads SDD rules into context. See: .speq/integrations/opencode/opencode.json.snippet"
        fi
    else
        echo "⚠ Tip: Create opencode.json with {\"instructions\": [\".speq/RULES.md\"]} to auto-load SDD rules"
        echo "  See: .speq/integrations/opencode/opencode.json.snippet"
    fi
fi

# Zed / AGENTS.md integration
if $setup_agents_md; then
    echo ""
    echo "── Zed / AGENTS.md ──"

    # If using Claude Code as Zed's agent, the .claude/commands/ already work.
    # Check if Claude Code commands were already installed.
    if [ -d "$PROJECT_ROOT/.claude/commands" ] && [ -f "$PROJECT_ROOT/.claude/commands/spec.md" ]; then
        echo "✓ Zed + Claude Code agent: .claude/commands/ already installed (slash commands will work)"
    else
        echo "⚠ Tip: If using Claude Code as Zed's agent, also run: ./.speq/setup.sh claude-code"
    fi

    # For Zed's first-party agent, install AGENTS.md
    if [ -f "$PROJECT_ROOT/AGENTS.md" ]; then
        if grep -q "Spec-Driven Development" "$PROJECT_ROOT/AGENTS.md" 2>/dev/null; then
            echo "⊘ AGENTS.md already contains SDD section — skipped"
        else
            echo "" >> "$PROJECT_ROOT/AGENTS.md"
            cat "$SCRIPT_DIR/integrations/agents-md/AGENTS.md.snippet" >> "$PROJECT_ROOT/AGENTS.md"
            echo "✓ Appended SDD section to AGENTS.md (for Zed first-party agent)"
        fi
    else
        cp "$SCRIPT_DIR/integrations/agents-md/AGENTS.md.snippet" "$PROJECT_ROOT/AGENTS.md"
        echo "✓ Created AGENTS.md with SDD section (for Zed first-party agent)"
    fi
fi

# GitHub Copilot integration
if $setup_copilot; then
    echo ""
    echo "── GitHub Copilot ──"

    # VS Code prompt files
    mkdir -p "$PROJECT_ROOT/.github/prompts"
    cp "$SCRIPT_DIR/integrations/copilot/prompts/"*.prompt.md "$PROJECT_ROOT/.github/prompts/"
    echo "✓ Installed VS Code prompt files: /spec, /spec-from-issue, /implement, /design-first, /bugfix, /tasks, /steering, /sync-to-issue"

    # copilot-instructions.md for Copilot Coding Agent (remote)
    if [ -f "$PROJECT_ROOT/.github/copilot-instructions.md" ]; then
        if grep -q "Spec-Driven Development" "$PROJECT_ROOT/.github/copilot-instructions.md" 2>/dev/null; then
            echo "⊘ .github/copilot-instructions.md already contains SDD section — skipped"
        else
            echo "" >> "$PROJECT_ROOT/.github/copilot-instructions.md"
            cat "$SCRIPT_DIR/integrations/copilot/copilot-instructions.md.snippet" >> "$PROJECT_ROOT/.github/copilot-instructions.md"
            echo "✓ Appended SDD section to .github/copilot-instructions.md"
        fi
    else
        cp "$SCRIPT_DIR/integrations/copilot/copilot-instructions.md.snippet" "$PROJECT_ROOT/.github/copilot-instructions.md"
        echo "✓ Created .github/copilot-instructions.md with SDD section"
    fi

    # Copilot CLI uses .claude/commands/ — hint if not installed
    if [ -d "$PROJECT_ROOT/.claude/commands" ] && [ -f "$PROJECT_ROOT/.claude/commands/spec.md" ]; then
        echo "✓ Copilot CLI: .claude/commands/ already installed (slash commands will work in CLI too)"
    else
        echo "⚠ Tip: Copilot CLI reads .claude/commands/ — also run: ./.speq/setup.sh claude-code"
    fi
fi

echo ""
echo "════════════════════════════════════════════"
echo "Done! Next steps:"
echo "  1. Run /steering to generate steering docs from your codebase"
echo "  2. Review and commit the generated .specs/steering/ files"
echo "  3. Start your first spec with /spec [feature description]"
echo "     Or seed from an issue: /spec-from-issue [issue-id]"
echo ""
echo "To update .speq/ later:  ./.speq/update.sh [tool ...]"
echo ""
echo "Note: In Cursor, type /spec then add your description in the same message."
echo "      In Zed with first-party agent, use natural language instead of slash commands."
echo "      Issue tracker sync (/spec-from-issue, /sync-to-issue) requires MCP integration."
echo "════════════════════════════════════════════"
