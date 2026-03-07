# Specter

A portable, tool-agnostic **Spec-Driven Development (SDD)** system for structured software development with AI assistants. Drop the `sdd/` folder into any project and get a structured spec workflow — inspired by Kiro's spec-driven approach.

## What is SDD?

Spec-Driven Development enforces a **think-before-you-code** discipline: every feature goes through three mandatory phases with human approval gates before any implementation begins.

```
[Prompt] → Requirements → ✓ → Design → ✓ → Tasks → ✓ → Implementation
```

| Phase | File | What it contains |
|-------|------|-----------------|
| Requirements | `requirements.md` | EARS notation user stories + acceptance criteria |
| Design | `design.md` | Architecture, diagrams, data models, testing strategy |
| Tasks | `tasks.md` | Ordered implementation checklist with requirement traceability |

## Supported Tools

| Tool | Slash Commands | Auto-loaded Rules |
|------|---------------|-------------------|
| Claude Code | `/spec`, `/design-first`, `/bugfix`, `/tasks`, `/steering` | Via CLAUDE.md thin pointer |
| Cursor | Same commands | Via `.cursor/rules/sdd.mdc` (conditional) |
| OpenCode | Same commands | Via AGENTS.md snippet or `opencode.json` |
| Zed (Claude agent) | Same as Claude Code | Via `.claude/commands/` |
| Zed (native) / Chat LLMs | Natural language | Paste prompts from `sdd/prompts/` |

## Getting Started

### 1. Copy `sdd/` into your project root

If you already have this repo cloned:

```bash
cp -r sdd/ /your/project/
```

Or pull it directly from GitHub without cloning the full repo:

```bash
git clone --depth=1 https://github.com/cjpye/specter.git /tmp/specter && cp -r /tmp/specter/sdd /your/project/ && rm -rf /tmp/specter
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
/spec Add user authentication with OAuth2    ← start a feature spec
```

## Architecture: Thin Pointers

`CLAUDE.md` / `AGENTS.md` stay under ~100 lines — they load on every interaction and burn context. SDD uses a **thin-pointer** architecture:

```
CLAUDE.md / AGENTS.md       ← ~20 lines. Tells AI that SDD exists.
   └── reads on demand ──→  sdd/RULES.md    ← Full rules. Only loaded during spec work.
       triggered by ──→  .claude/commands/  ← /spec, /design, /tasks, /bugfix, /steering
                          .cursor/rules/    ← Cursor conditional rule
```

## Repository Structure

```
sdd/
├── RULES.md                    # Full SDD rules (read on-demand by AI)
├── setup.sh                    # Setup script for tool integrations
├── prompts/                    # Standalone prompts for chat-based LLMs
│   ├── 00-steering.md
│   ├── 01-requirements.md
│   ├── 02-design.md
│   ├── 03-tasks.md
│   ├── 04-bugfix.md
│   └── 05-design-first.md
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

## Tips

- **Commit everything** — specs, steering docs, and the `sdd/` folder belong in version control
- **One spec per feature** — keep specs focused and atomic
- **Edit specs directly** — they're just markdown files
- **Reference specs in chat** — "implement task 3 from the auth spec"
- **Custom steering docs** — add any `.md` to `.specs/steering/` to encode project-specific rules
