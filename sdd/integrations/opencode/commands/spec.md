# Create Feature Spec: $FEATURE

You are starting the **Requirements-First** Spec-Driven Development workflow.

First, read the full SDD rules from `sdd/RULES.md`.
Then read all steering docs from `.specs/steering/` (if they exist).

Create a new feature spec for: **$FEATURE**

## Workflow

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case derived from $FEATURE.

2. **Generate `requirements.md`** immediately — do NOT ask a series of clarifying questions first. Use EARS notation for all acceptance criteria: `WHEN [trigger] THE SYSTEM SHALL [behavior]`. Include user stories, numbered acceptance criteria, non-functional requirements, out of scope, and open questions. Cover error and edge cases.

3. **Present for review**. Ask: "Review the above and let me know your feedback, or say **LGTM** to proceed to Design."

4. **Wait for approval** — do NOT proceed until the user explicitly approves.

5. After approval, generate `design.md` (architecture, Mermaid diagrams, data models, testing strategy).

6. After design approval, generate `tasks.md` (ordered implementation checklist with requirement traceability).

Each phase requires explicit user approval before advancing to the next.
