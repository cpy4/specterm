# Generate Steering Docs

Analyze this project's codebase and generate three steering documents in `.specs/steering/`.

First, read `sdd/RULES.md` (Steering Docs section) and the templates in `sdd/templates/steering/`.

## What to Examine

- `package.json` / `Cargo.toml` / `go.mod` / `requirements.txt` / `build.gradle`
- Config files (tsconfig, eslint, prettier, vite, webpack, etc.)
- Directory structure (top 2-3 levels)
- README and existing docs
- 2-3 sample source files for coding patterns
- Database schemas or migrations if present
- CI/CD configuration if present

## Generate These Files

**`.specs/steering/product.md`** — Product purpose, target users, core features, business objectives.

**`.specs/steering/tech.md`** — Languages, frameworks, versions, dev tools, hard prohibitions, preferred patterns. Be specific with version numbers.

**`.specs/steering/structure.md`** — Directory layout with annotations, naming conventions, import patterns, architectural patterns.

## Rules

- Be specific to THIS project, not generic
- For prohibitions, only list things justified by the codebase
- Mark uncertain items with `<!-- TODO: confirm -->`
- Present all three files for review before saving
