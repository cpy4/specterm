# Specterm

A portable, tool-agnostic **Spec-Driven Development (SDD)** system for structured software development with AI assistants. Drop the `sdd/` folder into any project and get a structured spec workflow — inspired by Kiro's spec-driven approach.

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
| Cursor | All 8 commands | Via `.cursor/rules/sdd.mdc` (conditional) |
| OpenCode | All 8 commands | Via AGENTS.md snippet or `opencode.json` |
| Zed (Claude agent) | Same as Claude Code | Via `.claude/commands/` |
| Zed (native) / Chat LLMs | Natural language | Paste prompts from `sdd/prompts/` |

## Getting Started

### 1. Copy `sdd/` into your project root

If you have this repo cloned locally:

```bash
# One-time copy
cp -r sdd/ /your/project/

# Or use sync.sh (also re-runs setup)
./sync.sh /your/project claude-code
```

Or pull it directly from GitHub:

```bash
git clone --depth=1 https://github.com/cpy4/specterm.git /tmp/specterm && cp -r /tmp/specterm/sdd /your/project/ && rm -rf /tmp/specterm
```

### 2. Run setup

```bash
# Interactive — asks which tools you use
./sdd/setup.sh

# Specify tools directly
./sdd/setup.sh claude-code cursor

# Install everything
./sdd/setup.sh --all
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
   └── reads on demand ──→  sdd/RULES.md    ← Full rules. Only loaded during spec work.
       triggered by ──→  .claude/commands/  ← /spec, /spec-from-issue, /implement, etc.
                          .cursor/rules/    ← Cursor conditional rule
```

## Repository Structure

```
sync.sh                         # Push sdd/ to a local project (for specterm developers)
sdd/
├── RULES.md                    # Full SDD rules (read on-demand by AI)
├── setup.sh                    # Setup script for tool integrations
├── update.sh                   # Self-update sdd/ from GitHub (lives in each project)
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
    └── agents-md/
```

After setup, your project gains:

```
your-project/
├── sdd/                        # This system (commit to repo)
├── .specs/                     # Your generated specs (commit to repo)
│   ├── steering/               # product.md, tech.md, structure.md
│   └── specs/{feature-name}/   # requirements.md, design.md, tasks.md
├── .claude/commands/           # Claude Code + Zed slash commands
├── .cursor/rules/sdd.mdc       # Cursor conditional rule
├── .opencode/commands/         # OpenCode slash commands
└── CLAUDE.md / AGENTS.md       # Thin pointer to sdd/RULES.md
```

## Keeping sdd/ Up to Date

Since `sdd/` is copied into each project, you need a way to pull updates when the system evolves.

### From within a project (self-update from GitHub)

Every project that has `sdd/` includes an update script:

```bash
# Update sdd/ and re-run setup interactively
./sdd/update.sh

# Update and re-run setup for specific tools
./sdd/update.sh claude-code cursor

# Update files only, skip setup
./sdd/update.sh --no-setup
```

This shallow-clones the latest specterm repo from GitHub, replaces `sdd/`, and re-runs setup to refresh slash commands and rules.

### From the specterm repo (local development)

If you're actively developing the SDD system and want to push changes to a local project:

```bash
# Sync sdd/ and re-run setup
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
cp -r sdd/integrations/claude-code/commands/* .claude/commands/
# Append sdd/integrations/claude-code/CLAUDE.md.snippet to your CLAUDE.md
```

**Cursor**
```bash
cp -r sdd/integrations/cursor/commands/* .cursor/commands/
cp -r sdd/integrations/cursor/rules/* .cursor/rules/
```

**OpenCode**
```bash
cp -r sdd/integrations/opencode/commands/* .opencode/commands/
# Append AGENTS.md snippet, or add "instructions": ["sdd/RULES.md"] to opencode.json
```

**Chat-based LLMs** — Paste the relevant prompt from `sdd/prompts/` into your conversation.

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

- **Commit everything** — specs, steering docs, and the `sdd/` folder belong in version control
- **One spec per feature** — keep specs focused and atomic (one issue = one spec at the story level)
- **Edit specs directly** — they're just markdown files
- **Reference specs in chat** — "implement task 3 from the auth spec"
- **Custom steering docs** — add any `.md` to `.specs/steering/` to encode project-specific rules
- **Issue tracker sync** — requires MCP integration with your tracker (Linear, Jira, or GitHub)
