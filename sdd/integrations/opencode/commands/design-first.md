# Design-First Spec: $FEATURE

You are starting the **Design-First** Spec-Driven Development workflow for: **$FEATURE**

First, read the full SDD rules from `sdd/RULES.md`.
Then read all steering docs from `.specs/steering/` (if they exist).

## Workflow

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case.

2. **Generate `design.md` FIRST**: Validate the user's architectural intent, define components/interfaces/data models, show Mermaid diagrams, include error handling and testing strategy. Use real code signatures.

3. **Present for review**. Ask: "Review the above and let me know your feedback, or say **LGTM** to proceed to Requirements."

4. After approval, **derive `requirements.md` FROM the design** — work backwards so every designed behavior has a testable EARS criterion. Don't add requirements that would force design changes.

5. After requirements approval, **generate `tasks.md`** as normal.

Each phase requires explicit user approval before advancing.
