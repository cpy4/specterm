# Generate Tasks: $SPEC_NAME

Generate or regenerate `tasks.md` from the spec: **$SPEC_NAME**

First, read the full SDD rules from `sdd/RULES.md` (specifically Phase 3: Tasks).
Then read all steering docs from `.specs/steering/` (if they exist).

## Workflow

1. Find the spec in `.specs/specs/$SPEC_NAME/`. If not found, list available specs and ask which one.

2. Read the spec's `requirements.md` and `design.md`. Both must exist.

3. Generate `tasks.md`:
   - Markdown checkboxes, max two levels deep
   - Each task is self-contained (15-60 min of work)
   - Order: foundation first, test infrastructure early, incremental complexity
   - Every task ends with `_Requirements: X.Y_` tracing to acceptance criteria
   - Include what tests to write alongside implementation
   - Exclude: deployment, docs, user testing, CI/CD tasks
   - End with a Verification section

4. If regenerating, preserve `- [x]` (completed) status on existing tasks.

5. Present for review before saving.
