---
description: Create a bugfix spec with regression protection (Bugfix → Design → Tasks)
argument-hint: [bug description]
allowed-tools: Read, Write, Glob, Grep
---

Read the full SDD rules from `sdd/RULES.md` (specifically the Bugfix Workflow section) before proceeding.

Read all steering docs from `.specs/steering/` (if they exist).

You are creating a **Bugfix Spec** for:

**$ARGUMENTS**

Follow these rules exactly:

1. **Create the spec directory**: `.specs/specs/{bugfix-name}/` using kebab-case.

2. **Generate `bugfix.md`** (replaces requirements.md) with these sections:
   - **Current Behavior**: Exactly what the system does now (the bug)
   - **Expected Behavior**: What it should do instead (EARS notation)
   - **Reproduction Steps**: Numbered steps to reproduce
   - **Unchanged Behavior** (CRITICAL): EARS-format list of existing correct behaviors that MUST NOT change: `WHEN [condition] THE SYSTEM SHALL CONTINUE TO [existing behavior]`
   - **Root Cause Analysis**: Identified or suspected cause
   - **Affected Components**: Specific files and modules
   - **Test Cases**: Regression test for the fix + tests for unchanged behaviors

3. The **Unchanged Behavior** section is the most important. Be thorough — a regression is worse than the original bug. Think about adjacent features, other user roles, and edge cases that currently work.

4. **Present for review**. After approval, proceed to `design.md` (focused on fix approach), then `tasks.md`.

Each phase requires explicit user approval before advancing.
