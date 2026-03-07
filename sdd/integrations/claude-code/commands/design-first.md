---
description: Create a spec starting from technical design (Design → Requirements → Tasks). Use when you know the architecture.
argument-hint: [feature + architectural intent]
allowed-tools: Read, Write, Glob, Grep
---

Read the full SDD rules from `sdd/RULES.md` before proceeding.

Read all steering docs from `.specs/steering/` (if they exist) to understand project context.

You are starting the **Design-First** spec workflow for this feature:

**$ARGUMENTS**

Follow these rules exactly:

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case.

2. **Generate `design.md` FIRST** (this is the design-first variant):
   - Validate and flesh out the architectural approach the user described
   - Define concrete components, interfaces, and data models
   - Show system/sequence diagrams in Mermaid
   - Include error handling, testing strategy, and design decisions table
   - Use real code signatures and types from the project's language

3. **Present the design** and ask: "Review the above and let me know your feedback, or say **LGTM** to proceed to Requirements."

4. After approval, **derive `requirements.md` FROM the design**:
   - Work backwards — every designed behavior becomes a testable EARS criterion
   - Requirements must be 100% achievable given the approved design
   - Do not add requirements that would force design changes

5. After requirements approval, **generate `tasks.md`** following the tasks phase rules.

Each phase requires explicit user approval before advancing.
