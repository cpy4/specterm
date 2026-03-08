# Prompt: Generate Bugfix Spec

Use this prompt when you need to fix a bug with the same rigor as a feature spec. The key differentiator is the **Unchanged Behavior** section that explicitly protects existing functionality from regressions.

---

## Prompt

```
You are a software engineer helping me create a structured bug fix specification.

PROJECT CONTEXT:
{STEERING_CONTEXT}

BUG REPORT:
{DESCRIBE THE BUG — what happens, what should happen, how to reproduce it}

YOUR TASK:
Generate a complete bugfix.md document that precisely defines the bug, its fix, and what must NOT change. Follow this structure:

## 1. Current Behavior
Describe exactly what the system does now (the buggy behavior). Be precise — include specific values, error messages, or states observed.

## 2. Expected Behavior
Describe exactly what the system should do instead. Use EARS notation:
- WHEN {trigger} THE SYSTEM SHALL {correct behavior}

## 3. Reproduction Steps
Numbered steps to consistently reproduce the bug:
1. Start from {state}
2. Do {action}
3. Observe {buggy result}

Include any preconditions (data state, user role, browser, etc.)

## 4. Unchanged Behavior (CRITICAL)
List behaviors that MUST NOT change during the fix, using EARS notation:
- WHEN {condition} THE SYSTEM SHALL CONTINUE TO {existing correct behavior}
- WHEN {condition} THE SYSTEM SHALL CONTINUE TO {existing correct behavior}

This section prevents regressions. Think about:
- Adjacent features that share code paths
- Other user roles that use the same components
- Edge cases that currently work correctly
- Performance characteristics that should be preserved

## 5. Root Cause Analysis
Identify or hypothesize the technical cause:
- Which component/function contains the bug?
- Why does the current code produce the wrong behavior?
- Is this a logic error, data issue, race condition, missing validation, etc.?

## 6. Affected Components
List specific files, functions, modules, and database tables involved.

## 7. Fix Approach
Brief description of the intended fix strategy (1-3 sentences).

## 8. Test Cases
Define tests that:
- Verify the bug is fixed (regression test for the exact reproduction steps)
- Verify unchanged behaviors still work (regression tests for each item in section 4)
- Cover edge cases near the fix

IMPORTANT:
- The Unchanged Behavior section is the MOST important section. Be thorough — a regression is worse than the original bug.
- If you need to examine code to fill in Root Cause Analysis, say so and I'll provide the relevant files.
- Don't start coding the fix yet — this is the spec phase.
- If you have file access, save to `.specs/specs/{bugfix-name}/bugfix.md` IMMEDIATELY — don't wait for approval. The user will review the file in their IDE.

After saving (or generating), ask me to review and say "LGTM", then I'll ask you to generate design.md and tasks.md for the fix. If I make edits directly to the file, re-read it from disk before proceeding.
```

---

## What Good Output Looks Like

- Precise current vs. expected behavior (not vague descriptions)
- 5-15 "unchanged behavior" items covering adjacent functionality
- Root cause that points to specific code, not just symptoms
- Test cases that would catch a regression if the bug were reintroduced
- Fix approach is scoped — no feature creep hiding in a bug fix
