# Prompt: Generate Tasks

Use this prompt to generate the tasks phase of a spec. Replace the placeholders with your actual content.

---

## Prompt

```
You are a technical project planner helping me break down a feature into implementable coding tasks.

PROJECT CONTEXT:
{STEERING_CONTEXT}

APPROVED REQUIREMENTS:
{PASTE YOUR requirements.md CONTENT HERE — or if you have file access, re-read requirements.md from disk as the user may have edited it directly}

APPROVED DESIGN:
{PASTE YOUR design.md CONTENT HERE — or if you have file access, re-read design.md from disk as the user may have edited it directly}

YOUR TASK:
Generate a complete tasks.md document — an ordered implementation checklist that a developer (or AI coding agent) can follow sequentially to build this feature. Follow these rules precisely:

1. FORMAT: Use markdown checkboxes with exactly two levels of hierarchy:
   ```
   - [ ] 1. {Task title}
     - {Specific implementation detail}
     - {Another detail}
     - Write tests: {what to test}
     - _Requirements: X.Y, X.Z_
   ```

2. ORDERING PRINCIPLES:
   - Foundation first: data models, schemas, types before business logic
   - Test infrastructure early: set up test utilities and fixtures before feature tests
   - Inside-out: core logic before UI, backend before frontend
   - Incremental complexity: each task builds on the previous, no large jumps
   - Each task should produce a working (even if incomplete) state

3. TASK SCOPE:
   - Each task is a self-contained coding unit (15-60 min of focused work)
   - Every task must be independently testable
   - Include what tests to write alongside (or before) implementation
   - Include the specific files to create or modify
   - Reference the design doc's component names and interfaces exactly

4. TRACEABILITY:
   - Every task MUST end with _Requirements: X.Y_ referencing the acceptance criteria it satisfies
   - Every acceptance criterion from requirements.md must be covered by at least one task

5. EXCLUSIONS — do NOT include tasks for:
   - Deployment or CI/CD pipeline changes
   - Documentation writing (README, API docs)
   - User acceptance testing
   - Business process changes
   - Project management activities

6. TASK COUNT GUIDANCE:
   - Small features: 5-10 tasks
   - Medium features: 10-20 tasks
   - Large features: 20-30 tasks (consider splitting into multiple specs if >30)

IMPORTANT:
- Think of each task as a self-contained prompt for a code-generation AI. It should contain enough context to implement without re-reading the full spec.
- Prioritize test-driven sequencing: test setup → test writing → implementation → verification.
- Use the exact component names, function signatures, and file paths from the design doc.
- After the task list, add a "Verification" section listing how to confirm the full feature works end-to-end.
- If you have file access, save to `.specs/specs/{feature-name}/tasks.md` IMMEDIATELY — don't wait for approval. The user will review the file in their IDE.

After saving (or generating), ask me to review and say "LGTM" when I'm satisfied.
```

---

## What Good Output Looks Like

- 10-25 well-ordered tasks with clear dependencies
- Each task references specific files and function signatures from the design
- Test-writing is embedded in tasks, not deferred to the end
- Every acceptance criterion from requirements.md appears in at least one `_Requirements:_` reference
- A final verification section with manual or automated steps to confirm the feature works
- Tasks are small enough that if one fails, you don't lose much progress
