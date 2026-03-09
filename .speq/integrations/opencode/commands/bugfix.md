# Bugfix Spec: $BUG

You are creating a **Bugfix Spec** with regression protection for: **$BUG**

First, read the full SDD rules from `.speq/RULES.md` (specifically the Bugfix Workflow section).
Then read all steering docs from `.specs/steering/` (if they exist).

## Workflow

1. **Create the spec directory**: `.specs/specs/{bugfix-name}/` using kebab-case.

2. **Generate and save `bugfix.md` to disk immediately** with these sections:
   - **Current Behavior**: Exactly what the system does now (the bug)
   - **Expected Behavior**: What it should do instead (EARS notation)
   - **Reproduction Steps**: Numbered steps
   - **Unchanged Behavior** (CRITICAL): `WHEN [condition] THE SYSTEM SHALL CONTINUE TO [existing behavior]` — list everything that must NOT break
   - **Root Cause Analysis**: Suspected cause
   - **Affected Components**: Specific files and modules
   - **Test Cases**: Regression tests for the fix + tests for unchanged behaviors
   - **Write the file immediately.**

3. The **Unchanged Behavior** section is the most important part. Be thorough.

4. Tell the user the file has been saved and ask for review. After approval, **re-read `bugfix.md` from disk** (user may have edited it directly), then save `design.md` to disk immediately. After design approval, **re-read from disk**, then save `tasks.md` to disk immediately.

Each phase: write the file to disk → ask for review → wait for approval → re-read from disk before advancing.
