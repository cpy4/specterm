# Sync Spec to Issue

Push spec progress or updated requirements back to a linked issue tracker issue.

First, read the full SDD rules from `.speq/RULES.md`.

## Step 1: Load the Spec

The user will provide a spec name alongside this command. If not, list specs in `.specs/specs/` and ask.

Read `requirements.md` (or `bugfix.md`), `design.md`, and `tasks.md` from the spec directory.

## Step 2: Find the Source Issue

Look for `<!-- source: {tracker}:{issue-id} -->` at the top of `requirements.md`. If not found, ask the user for an issue ID to link.

## Step 3: Check MCP Availability

Detect available issue tracker MCP tools (Linear, Jira, GitHub Issues). If none available, output a PM-readable summary the user can paste manually.

## Step 4: Ask What to Sync

Ask what to sync back:
1. **Progress comment** — Task completion summary posted as a comment
2. **Updated description** — Refined requirements translated to PM-readable language
3. **Status change** — Update issue status (In Progress, In Review, Done, etc.)
4. **All of the above**

## Step 5: Execute

- **Progress comment**: Count `- [x]` vs `- [ ]` in tasks.md, summarize coverage, post as comment.
- **Updated description**: Translate EARS notation to natural language, update issue description.
- **Status change**: Ask which status, then update.

When translating to PM language: convert EARS to natural acceptance criteria, group by story, keep it concise for non-technical stakeholders.

Confirm what was synced after completion.
