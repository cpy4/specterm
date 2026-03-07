---
description: Generate or regenerate tasks.md from an existing spec's requirements and design docs
argument-hint: [spec-name]
allowed-tools: Read, Write, Glob, Grep
---

Read the full SDD rules from `sdd/RULES.md` (specifically the Phase 3: Tasks section) before proceeding.

Read all steering docs from `.specs/steering/` (if they exist).

The user wants to generate (or regenerate) tasks for this spec:

**$ARGUMENTS**

1. Find the spec in `.specs/specs/`. If the user provided a name, look for a matching directory. If not, list available specs and ask which one.

2. Read the spec's `requirements.md` and `design.md`. Both must exist and be approved before generating tasks.

3. Generate `tasks.md` following these rules:
   - Markdown checkboxes with max two levels of hierarchy
   - Each task is a self-contained coding unit (15-60 min)
   - Order: foundation first, test infrastructure early, inside-out, incremental complexity
   - Every task ends with `_Requirements: X.Y_` tracing to acceptance criteria
   - Every acceptance criterion must be covered by at least one task
   - Include what tests to write alongside implementation
   - Exclude: deployment, docs, user testing, CI/CD, business process tasks
   - End with a Verification section

4. If regenerating (tasks.md already exists), check for tasks marked `- [x]` (complete) and preserve their done status.

5. Present for review before saving.
