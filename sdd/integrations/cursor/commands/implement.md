# Implement Spec Task

You are implementing a specific task from an existing spec. First, read the full SDD rules from `sdd/RULES.md`.

The user will provide a spec name and task number alongside this command.

## Strict Load Order (Do This Before Writing Any Code)

**1. Load steering context** — Read all files in `.specs/steering/` (if it exists). These define project-wide conventions, tech stack, and architecture.

**2. Load spec context** — Read all three spec files in order:
   - `.specs/specs/{spec-name}/requirements.md`
   - `.specs/specs/{spec-name}/design.md`
   - `.specs/specs/{spec-name}/tasks.md`

If the spec name was not provided, list available specs in `.specs/specs/` and ask which one. If no task number was given, show the task list and ask which task.

**3. Confirm scope** — Before writing any code, state:
   - Which task you are implementing (title and number)
   - Which requirement(s) it maps to (from the `_Requirements: X.Y_` reference)
   - Which files you expect to create or modify

## Implementation Rules

- Implement only the specified task — do not implement adjacent tasks even if they seem related
- Follow the design in `design.md` exactly
- Write tests alongside the implementation as specified in the task
- After completion, mark the task `- [x]` in `tasks.md`
- Check if `requirements.md` has a `<!-- source: {tracker}:{issue-id} -->` metadata comment. If so, and all tasks are now complete (`- [x]`), offer to update the linked issue status via MCP (e.g., "All tasks complete! Want me to update {issue-id} status?"). If tasks remain, suggest the next incomplete task.
- If no source metadata or no MCP available, simply suggest the next incomplete task
