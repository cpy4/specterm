---
description: Create a new feature spec using the Spec-Driven Development workflow (Requirements → Design → Tasks)
argument-hint: [feature description]
allowed-tools: Read, Write, Glob, Grep
---

Read the full SDD rules from `sdd/RULES.md` before proceeding.

Read all steering docs from `.specs/steering/` (if they exist) to understand project context.

You are starting the **Requirements-First** spec workflow for this feature:

**$ARGUMENTS**

Follow these rules exactly:

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case derived from the feature description.

2. **Generate `requirements.md`** as the first phase:
   - Generate a complete draft IMMEDIATELY — do NOT ask a series of clarifying questions first.
   - Use EARS notation for all acceptance criteria: `WHEN [trigger] THE SYSTEM SHALL [behavior]`
   - Include: User Stories with numbered acceptance criteria, Non-Functional Requirements, Out of Scope, Open Questions
   - Cover error cases and edge cases, not just happy paths
   - Focus ONLY on WHAT the system should do, not HOW

3. **Present the requirements** and ask: "Review the above and let me know your feedback, or say **LGTM** to proceed to Design."

4. **Wait for approval** — do NOT proceed to design until the user explicitly approves.

5. After approval, **generate `design.md`** following the design phase rules in `sdd/RULES.md`.

6. After design approval, **generate `tasks.md`** following the tasks phase rules in `sdd/RULES.md`.

Each phase requires explicit user approval before advancing.
