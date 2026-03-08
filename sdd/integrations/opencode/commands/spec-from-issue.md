# Create Spec from Issue: $ISSUE_ID

You are starting a **spec seeded from an existing issue tracker issue** using the Spec-Driven Development workflow.

First, read the full SDD rules from `sdd/RULES.md`.
Then read all steering docs from `.specs/steering/` (if they exist).

## Step 1: Fetch the Issue

The issue to fetch: **$ISSUE_ID**

Detect which issue tracker MCP tools are available and use the appropriate one (Linear, Jira, or GitHub Issues). If no MCP tools are available, ask the user to paste the issue title, description, and any acceptance criteria.

Extract: title, description/body, acceptance criteria, comments, labels, priority, and linked issues.

## Step 2: Generate the Spec

1. **Create the spec directory**: `.specs/specs/{feature-name}/` using kebab-case derived from the issue title.

2. **Generate and save `requirements.md` to disk immediately** using the issue content as the seed:
   - Add a metadata block at the top: `<!-- source: {tracker}:{issue-id} -->` (e.g., `<!-- source: linear:ENG-142 -->`)
   - Transform PM-language into structured EARS notation — don't just copy the issue
   - Enrich with technical edge cases the original issue may have missed
   - Use EARS notation: `WHEN [trigger] THE SYSTEM SHALL [behavior]`
   - Include user stories, numbered acceptance criteria, non-functional requirements, out of scope, open questions
   - **Write the file immediately.**

3. Tell the user the file has been saved. Ask: "I've saved `requirements.md` — review it in your IDE or here, then let me know your feedback or say **LGTM** to proceed to Design."

4. **Wait for approval** — do NOT proceed until the user explicitly approves.

5. After approval, **re-read `requirements.md` from disk** (user may have edited it directly), then **offer to sync back**: "Would you like me to update the issue with these refined requirements?" If yes and MCP is available, translate EARS requirements to PM-readable language and update the issue.

6. **Generate and save `design.md`** to disk immediately.

7. After design approval, **re-read `design.md` from disk**, then **generate and save `tasks.md`** to disk immediately.

Each phase: write the file to disk → ask for review → wait for approval → re-read from disk before advancing.
