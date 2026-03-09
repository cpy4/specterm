---
description: Implement a specific task from an existing spec
agent: agent
tools: ['editFiles', 'search', 'read', 'runInTerminal']
---

Read the full SDD rules from [.speq/RULES.md](../../../RULES.md) before proceeding.

The user wants to implement a task from this spec:

**${input:specName:Spec name (folder name in .specs/specs/)}** — Task **${input:taskNumber:Task number to implement}**

Follow this strict load order before writing any code:

## Step 1: Load Steering Context

Read all files in `.specs/steering/` (if the directory exists). These define project-wide conventions, tech stack, and architecture that must be respected.

## Step 2: Load Spec Context

Read all three spec files in order:
1. `.specs/specs/${input:specName}/requirements.md`
2. `.specs/specs/${input:specName}/design.md`
3. `.specs/specs/${input:specName}/tasks.md`

## Step 3: Confirm Scope

Before writing any code, state:
- Which task you are implementing (title and number)
- Which requirement(s) it maps to (from the `_Requirements: X.Y_` reference)
- Which files you expect to create or modify

## Step 4: Implement

Implement only the specified task. Follow the design exactly. Do not implement other tasks, even if they seem related.

Write tests alongside the implementation as specified in the task.

## Step 5: Mark Complete

After implementation, mark the task `- [x]` in `tasks.md`.

## Step 6: Issue Tracker Sync (if applicable)

Check if `requirements.md` (or `bugfix.md`) contains a source metadata comment: `<!-- source: {tracker}:{issue-id} -->`.

If a source issue is linked and issue tracker MCP tools are available:
- If **this was the last task** (all tasks are now `- [x]`): Offer to update the issue status to indicate completion (e.g., "In Review" or "Done"). Ask the user: "All tasks complete! Want me to update {issue-id} status?"
- If **tasks remain**: Suggest the next incomplete task as usual.

If no source metadata or no MCP tools are available, simply suggest the next incomplete task.
