# Implement Spec Task: $SPEC_NAME Task $TASK_NUMBER

You are implementing a specific task from an existing spec. First, read the full SDD rules from `.speq/RULES.md`.

## Strict Load Order (Do This Before Writing Any Code)

**0. Branch check** — Run `git branch --show-current`. If the branch is `main`, `master`, `develop`, `trunk`, or any production/shared base branch, warn the user and suggest creating a feature branch: `git checkout -b feat/$SPEC_NAME`. Do not proceed until the user confirms or switches branches.

**1. Load steering context** — Read all files in `.specs/steering/` (if it exists). These define project-wide conventions, tech stack, and architecture.

**2. Load spec context** — Read all three spec files in order:
   - `.specs/specs/$SPEC_NAME/requirements.md`
   - `.specs/specs/$SPEC_NAME/design.md`
   - `.specs/specs/$SPEC_NAME/tasks.md`

If `$SPEC_NAME` is not set, list available specs in `.specs/specs/` and ask the user to choose. If `$TASK_NUMBER` is not set, show the task list and ask which task.

**3. Confirm scope** — Before writing any code, state:
   - Which task you are implementing (title and number)
   - Which requirement(s) it maps to (from the `_Requirements: X.Y_` reference)
   - Which files you expect to create or modify

## Implementation Rules

- Implement only the specified task — do not implement adjacent tasks even if they seem related
- Follow the design in `design.md` exactly
- Write tests alongside the implementation as specified in the task
- After completion, mark the task `- [x]` in `tasks.md`
- **Commit after each task:** `git add -A && git commit -m "feat($SPEC_NAME): task N — <task title>"`
- **When all tasks are `[x]`:** push the branch (`git push -u origin <branch>`) and open a PR using `gh pr create` with the spec name as the title and a summary as the body. If `gh` is unavailable, print the push command and instruct the user to open a PR manually.
- Check if `requirements.md` has a `<!-- source: {tracker}:{issue-id} -->` metadata comment. If so and all tasks are now complete, offer to update the linked issue status via MCP. If tasks remain, suggest the next incomplete task.
- If no source metadata or no MCP available, simply suggest the next incomplete task
