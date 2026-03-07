# Prompt: Generate Steering Docs

Use this prompt to have an AI analyze your existing project and generate the three foundation steering docs. This works best when the AI has access to your codebase (via Claude Code, Cursor, Copilot, etc.), but you can also paste key files manually.

---

## Prompt (for tools with codebase access)

```
Analyze this project's codebase and generate three steering documents for the .specs/steering/ directory. These documents will guide all future AI-assisted development on this project.

Examine:
- package.json / Cargo.toml / go.mod / requirements.txt / build.gradle (dependencies and scripts)
- Configuration files (tsconfig, eslint, prettier, vite, webpack, etc.)
- Directory structure and file organization patterns
- README and existing documentation
- Sample source files to understand coding patterns
- Database schemas or migrations if present
- CI/CD configuration if present

Generate these three files:

1. **product.md** — Product overview:
   - What the product does (infer from README, route structure, UI)
   - Target users (infer from features and UI patterns)
   - Core features (infer from route/page/component structure)
   - Business objectives (infer from README or documentation)

2. **tech.md** — Technology stack:
   - Languages and versions (from config files)
   - Frameworks and key libraries (from dependency files)
   - Dev tools: linter, formatter, test runner, bundler (from config files and scripts)
   - Infrastructure/deployment (from CI/CD config, Dockerfiles, serverless configs)
   - Hard prohibitions (infer from linter rules, existing patterns — e.g., if no class components exist, prohibit them)
   - Preferred patterns (infer from consistent usage in the codebase)

3. **structure.md** — Project structure:
   - Directory layout with purpose annotations
   - Naming conventions (infer from existing file/function/variable names)
   - Import patterns (infer from existing imports)
   - Architectural patterns (infer from folder structure and abstractions)
   - Component patterns (infer from existing components)
   - State management approach (infer from existing state usage)
   - Error handling patterns (infer from existing error handling)

RULES:
- Be specific, not generic. Reference actual files and patterns you find.
- Include version numbers where available.
- For "Hard Prohibitions," only list things you can justify from the codebase (e.g., no test files use enzyme → "DO NOT use enzyme").
- If you can't confidently determine something, mark it with <!-- TODO: confirm --> rather than guessing.
- Save to .specs/steering/product.md, .specs/steering/tech.md, .specs/steering/structure.md.
```

---

## Prompt (for chat-based LLMs without codebase access)

```
I need help creating steering documents for my project. These are markdown files that guide AI-assisted development. I'll provide key information and you'll generate three structured docs.

Here's my project info:

PRODUCT:
- Name: {name}
- Purpose: {what it does}
- Users: {who uses it}
- Key features: {main capabilities}

TECH STACK:
- Language: {language and version}
- Framework: {framework and version}
- Database: {database}
- Key libraries: {important deps}
- Dev tools: {linter, formatter, test runner}
- Hosting: {where it runs}

PROJECT STRUCTURE:
{paste your directory tree or describe your folder organization}

CODING CONVENTIONS:
{describe any strong preferences — naming, patterns, things to avoid}

Generate three documents: product.md, tech.md, and structure.md following the templates in sdd/templates/steering/.
```

---

## After Generation

1. Review each file carefully — AI-inferred conventions might be wrong
2. Add any prohibitions or preferences the AI missed
3. Fill in any `<!-- TODO: confirm -->` markers
4. Commit to `.specs/steering/` in version control
5. These files will be read automatically during all future spec creation
