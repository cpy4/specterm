# Create Feature Spec: $FEATURE

You are starting the **Requirements-First** Spec-Driven Development workflow.

First, read the full SDD rules from `.speq/RULES.md`.
Then read all steering docs from `.specs/steering/` (if they exist).

Create a new feature spec for: **$FEATURE**

## Workflow

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case derived from $FEATURE.

2. **Generate and save `requirements.md` to disk immediately** — do NOT ask a series of clarifying questions first. Use EARS notation for all acceptance criteria: `WHEN [trigger] THE SYSTEM SHALL [behavior]`. Include user stories, numbered acceptance criteria, non-functional requirements, out of scope, and open questions. Cover error and edge cases. **Write the file immediately.**

3. Tell the user the file has been saved. Ask: "I've saved `requirements.md` — review it in your IDE or here, then let me know your feedback or say **LGTM** to proceed to Design."

4. **Wait for approval** — do NOT proceed until the user explicitly approves.

5. After approval, **re-read `requirements.md` from disk** (user may have edited it directly), then generate and save `design.md` to disk immediately.

6. After design approval, **re-read `design.md` from disk**, then generate and save `tasks.md` to disk immediately.

Each phase: write the file to disk → ask for review → wait for approval → re-read from disk before advancing.
