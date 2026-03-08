# Prompt: Sync Spec to Issue

Use this prompt to generate a PM-readable summary from an existing spec that you can paste back into your issue tracker. Replace `{SPEC_CONTENT}` with the contents of your spec files.

**Note:** With AI tools that have MCP integration (Linear, Jira, GitHub), the `/sync-to-issue` command can push updates directly. Without MCP, use this prompt to generate the content manually.

---

## Prompt

```
You are helping me sync a software specification back to an issue tracker for non-technical stakeholders.

SPEC CONTENT:
{SPEC_CONTENT}

(Paste the contents of requirements.md and tasks.md from the spec)

YOUR TASK:
Generate three outputs I can paste into my issue tracker:

1. PROGRESS COMMENT:
   Summarize the current state of the spec in 3-5 sentences:
   - How many tasks total, how many complete
   - Which requirements are covered by completed tasks
   - What's currently in progress or blocked
   Format as a brief comment suitable for posting on the issue.

2. UPDATED ISSUE DESCRIPTION:
   Translate the EARS requirements back into PM-readable acceptance criteria:
   - Convert "WHEN [trigger] THE SYSTEM SHALL [behavior]" to natural language
   - Group by user story or feature area
   - Include non-functional requirements and out-of-scope items
   - Keep it concise and scannable for non-technical stakeholders
   - Do NOT include raw EARS notation — this is for the PM and team

3. SUGGESTED STATUS:
   Based on task completion, suggest the appropriate issue status:
   - No tasks started → "To Do" / "Backlog"
   - Some tasks complete → "In Progress"
   - All tasks complete → "In Review" or "Done"

IMPORTANT:
- Write for non-technical stakeholders — avoid jargon and implementation details.
- Keep the progress comment brief — PMs don't want a wall of text.
- The updated description should be a clear, well-structured replacement for the original issue description.
```

---

## Example Usage

```
SPEC CONTENT:
[paste contents of .specs/specs/user-reviews/requirements.md]
[paste contents of .specs/specs/user-reviews/tasks.md]
```

## What Good Output Looks Like

- Progress comment: "Spec finalized with 14 implementation tasks. 3/14 complete (database schema, API models, review creation endpoint). Currently implementing moderation queue. Covers all 4 user stories and 23 acceptance criteria."
- Updated description: Natural language acceptance criteria grouped by story, with clear "must have" vs "nice to have" vs "out of scope" sections
- Suggested status: "In Progress" with reasoning
