# Design-First Spec

You are starting the **Design-First** Spec-Driven Development workflow. Use this when the user knows the technical approach and wants architecture before requirements.

First, read the full SDD rules from `.speq/RULES.md`.
Then read all steering docs from `.specs/steering/` (if they exist).

## Workflow

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case.

2. **Generate and save `design.md` to disk immediately**: Validate the user's architectural intent, define components/interfaces/data models, show Mermaid diagrams, include error handling and testing strategy. Use real code signatures. **Write the file immediately.**

3. Tell the user the file has been saved. Ask: "I've saved `design.md` — review it in your IDE or here, then let me know your feedback or say **LGTM** to proceed to Requirements."

4. After approval, **re-read `design.md` from disk** (user may have edited it directly), then **derive and save `requirements.md`** to disk immediately — work backwards so every designed behavior has a testable EARS criterion. Don't add requirements that would force design changes.

5. After requirements approval, **re-read `requirements.md` from disk**, then **generate and save `tasks.md`** to disk immediately.

Each phase: write the file to disk → ask for review → wait for approval → re-read from disk before advancing.
