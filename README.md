# Speq

A portable, tool-agnostic **Spec-Driven Development (SDD)** system for structured software development with AI assistants. Drop the `.speq/` folder into any project and get a structured spec workflow — inspired by Kiro's spec-driven approach.

## What is SDD?

Spec-Driven Development enforces a **think-before-you-code** discipline: every feature goes through three mandatory phases with human approval gates before any implementation begins.

```
[Prompt or Issue] → Requirements → ✓ → Design → ✓ → Tasks → ✓ → Implementation
```

| Phase | File | What it contains |
|-------|------|-----------------|
| Requirements | `requirements.md` | EARS notation user stories + acceptance criteria |
| Design | `design.md` | Architecture, diagrams, data models, testing strategy |
| Tasks | `tasks.md` | Ordered implementation checklist with requirement traceability |

## Commands

| Command | What it does |
|---------|-------------|
| `/spec` | Create a spec from a freeform description |
| `/spec-from-issue` | Create a spec seeded from a Linear/Jira/GitHub issue |
| `/design-first` | Spec starting from architecture |
| `/bugfix` | Bugfix spec with regression protection |
| `/tasks` | Generate/regenerate tasks from an existing spec |
| `/steering` | Auto-generate steering docs from codebase |
| `/implement` | Load full spec context, then implement a single task |
| `/sync-to-issue` | Push spec state back to the linked issue |

## Supported Tools

| Tool | Slash Commands | Auto-loaded Rules |
|------|---------------|-------------------|
| Claude Code | All 8 commands | Via CLAUDE.md thin pointer |
| Cursor | All 8 commands | Via `.cursor/rules/speq.mdc` (conditional) |
| OpenCode | All 8 commands | Via AGENTS.md snippet or `opencode.json` |
| Copilot (VS Code) | All 8 commands | Via `.github/copilot-instructions.md` |
| Copilot (CLI) | Via `.claude/commands/` | Via AGENTS.md |
| Copilot Coding Agent | No slash commands | Via `.github/copilot-instructions.md` |
| Zed (Claude agent) | Same as Claude Code | Via `.claude/commands/` |
| Zed (native) / Chat LLMs | Natural language | Paste prompts from `.speq/prompts/` |

## Getting Started

### 1. Copy `.speq/` into your project root

If you have this repo cloned locally:

```bash
# One-time copy
cp -r .speq/ /your/project/

# Or use sync.sh (also re-runs setup)
./sync.sh /your/project claude-code
```

Or pull it directly from GitHub:

```bash
git clone --depth=1 https://github.com/cpy4/speq.git /tmp/speq && cp -r /tmp/speq/.speq /your/project/ && rm -rf /tmp/speq
```

### 2. Run setup

```bash
# Interactive — asks which tools you use
./.speq/setup.sh

# Specify tools directly
./.speq/setup.sh claude-code cursor

# Install everything
./.speq/setup.sh --all
```

Setup installs slash commands, rules, and appends a thin (~10 line) SDD pointer to your `CLAUDE.md` / `AGENTS.md`.

### 3. Generate steering docs and create your first spec

```
/steering                                    ← analyze codebase and generate project context
/spec Add user authentication with OAuth2    ← start a feature spec from a description
/spec-from-issue ENG-142                     ← or seed from an issue tracker issue
```

## Architecture: Thin Pointers

`CLAUDE.md` / `AGENTS.md` stay under ~100 lines — they load on every interaction and burn context. SDD uses a **thin-pointer** architecture:

```
CLAUDE.md / AGENTS.md       ← ~20 lines. Tells AI that SDD exists.
   └── reads on demand ──→  .speq/RULES.md    ← Full rules. Only loaded during spec work.
       triggered by ──→  .claude/commands/  ← /spec, /spec-from-issue, /implement, etc.
                          .cursor/rules/    ← Cursor conditional rule
```

## Repository Structure

```
sync.sh                         # Push .speq/ to a local project (for speq developers)
.speq/
├── RULES.md                    # Full SDD rules (read on-demand by AI)
├── setup.sh                    # Setup script for tool integrations
├── update.sh                   # Self-update .speq/ from GitHub (lives in each project)
├── prompts/                    # Standalone prompts for chat-based LLMs
│   ├── 00-steering.md
│   ├── 01-requirements.md
│   ├── 02-design.md
│   ├── 03-tasks.md
│   ├── 04-bugfix.md
│   ├── 05-design-first.md
│   ├── 06-spec-from-issue.md
│   └── 07-sync-to-issue.md
├── templates/steering/         # Steering doc templates
└── integrations/               # Tool-specific configs used by setup.sh
    ├── claude-code/
    ├── cursor/
    ├── opencode/
    ├── copilot/
    └── agents-md/
```

After setup, your project gains:

```
your-project/
├── .speq/                        # This system (commit to repo)
├── .specs/                     # Your generated specs (commit to repo)
│   ├── steering/               # product.md, tech.md, structure.md
│   └── specs/{feature-name}/   # requirements.md, design.md, tasks.md
├── .claude/commands/           # Claude Code + Zed + Copilot CLI slash commands
├── .cursor/rules/speq.mdc       # Cursor conditional rule
├── .opencode/commands/         # OpenCode slash commands
├── .github/
│   ├── prompts/               # Copilot VS Code prompt files
│   └── copilot-instructions.md # Copilot Coding Agent instructions
└── CLAUDE.md / AGENTS.md       # Thin pointer to .speq/RULES.md
```

## Keeping .speq/ Up to Date

Since `.speq/` is copied into each project, you need a way to pull updates when the system evolves.

### From within a project (self-update from GitHub)

Every project that has `.speq/` includes an update script:

```bash
# Update .speq/ and re-run setup interactively
./.speq/update.sh

# Update and re-run setup for specific tools
./.speq/update.sh claude-code cursor

# Update files only, skip setup
./.speq/update.sh --no-setup
```

This shallow-clones the latest speq repo from GitHub, replaces `.speq/`, and re-runs setup to refresh slash commands and rules.

### From the speq repo (local development)

If you're actively developing the SDD system and want to push changes to a local project:

```bash
# Sync .speq/ and re-run setup
./sync.sh ~/Code/my-app claude-code

# Sync to multiple projects
./sync.sh ~/Code/app-one --all
./sync.sh ~/Code/app-two --all

# Sync files only, skip setup
./sync.sh ~/Code/my-app --no-setup
```

## Manual Setup

**Claude Code / Zed (Claude agent)**
```bash
cp -r .speq/integrations/claude-code/commands/* .claude/commands/
# Append .speq/integrations/claude-code/CLAUDE.md.snippet to your CLAUDE.md
```

**Cursor**
```bash
cp -r .speq/integrations/cursor/commands/* .cursor/commands/
cp -r .speq/integrations/cursor/rules/* .cursor/rules/
```

**OpenCode**
```bash
cp -r .speq/integrations/opencode/commands/* .opencode/commands/
# Append AGENTS.md snippet, or add "instructions": [".speq/RULES.md"] to opencode.json
```

**GitHub Copilot (VS Code)**
```bash
mkdir -p .github/prompts
cp -r .speq/integrations/copilot/prompts/* .github/prompts/
# Append .speq/integrations/copilot/copilot-instructions.md.snippet to .github/copilot-instructions.md
```

**GitHub Copilot (CLI)** — Uses `.claude/commands/` directly. Set up Claude Code integration above.

**Chat-based LLMs** — Paste the relevant prompt from `.speq/prompts/` into your conversation.

## Issue Tracker Integration

SDD supports bidirectional sync with issue trackers (Linear, Jira, GitHub Issues) via MCP. This is optional — the core workflow is pure-files and works without any tracker.

**Inbound: Issue → Spec**
```
/spec-from-issue ENG-142
```
Pulls the issue from your tracker, uses it as the seed for requirements generation. The engineer refines it into proper EARS notation, then can optionally write the enriched criteria back to the issue.

**Outbound: Spec → Issue**
```
/sync-to-issue user-reviews
```
Pushes progress or updated requirements back to the linked issue. Options: progress comment, updated description (translated to PM-readable language), or status change.

**During implementation**, `/implement` checks for the source metadata and offers to update the issue status when all tasks complete.

**Graceful degradation**: No MCP? Commands fall back to "paste the issue details" for inbound and output a copy-pasteable summary for outbound.

## Tips

- **Commit everything** — specs, steering docs, and the `.speq/` folder belong in version control
- **One spec per feature** — keep specs focused and atomic (one issue = one spec at the story level)
- **Edit specs directly** — they're just markdown files
- **Reference specs in chat** — "implement task 3 from the auth spec"
- **Custom steering docs** — add any `.md` to `.specs/steering/` to encode project-specific rules
- **Issue tracker sync** — requires MCP integration with your tracker (Linear, Jira, or GitHub)
