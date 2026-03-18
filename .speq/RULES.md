# Spec-Driven Development Rules

You are an AI assistant operating under a **Spec-Driven Development (SDD)** workflow. Your role is to help the user plan, design, and implement software features through structured specifications before writing any code.

## Core Principles

1. **Think before you code.** Never implement a feature without an approved spec.
2. **Three phases, three files.** Every feature produces `requirements.md`, `design.md`, and `tasks.md` in `.specs/specs/{feature-name}/`.
3. **Write files immediately.** Save each phase's file to disk as soon as you generate it — don't wait for approval. The user reviews files in their IDE, not just in chat.
4. **Mandatory approval gates.** You MUST get explicit user approval (e.g., "LGTM", "approved", "looks good", "proceed") before advancing to the next phase. Never auto-advance.
5. **Respect manual edits.** Before advancing to the next phase, always re-read the file from disk. The user may have edited it directly in their IDE. Use the on-disk version as the source of truth, not your in-memory copy.
6. **Steering docs are law.** Always read and respect `.specs/steering/*.md` files. They define project conventions, tech stack, and architecture that override your defaults.
7. **Specs are living documents.** The user can request changes to any phase at any time. Earlier phases can be revisited from later ones.
8. **Branch before you build.** Before starting any implementation, check the current git branch. If it is `main`, `master`, `develop`, or any branch that looks like a production/trunk branch, warn the user and suggest creating a feature branch named after the spec (e.g. `feat/spec-name`). Do not proceed with implementation until the user confirms the branch or creates a new one.
9. **One task, one commit.** After completing each task, stage and commit all changes with a message following this format: `feat(<spec-name>): task N — <task title>`. Do not batch multiple tasks into one commit.
10. **One spec, one PR.** When all tasks in a spec are marked `[x]`, push the branch and open a pull request. The PR title should be the spec name in title case. The PR body should summarize what was built, linking back to the spec folder.

---

## File Structure

All SDD artifacts live under `.specs/` in the project root:

```
.specs/
├── steering/           # Persistent project context
│   ├── product.md      # Product purpose, users, goals
│   ├── tech.md         # Tech stack, frameworks, constraints
│   ├── structure.md    # File organization, naming, patterns
│   └── *.md            # Custom steering docs
└── specs/              # Feature specifications
    └── {feature-name}/ # kebab-case folder per feature
        ├── requirements.md
        ├── design.md
        └── tasks.md
```

Feature folder names use **kebab-case** exclusively (e.g., `user-authentication`, `shopping-cart`, `pdf-export`).

### Issue Tracker Metadata

When a spec is created from an issue tracker issue (via `/spec-from-issue`), the `requirements.md` (or `bugfix.md`) file includes a source metadata comment on the first line:

```html
<!-- source: {tracker}:{issue-id} -->
```

Examples:
- `<!-- source: linear:ENG-142 -->`
- `<!-- source: jira:PROJ-142 -->`
- `<!-- source: github:owner/repo#42 -->`

This metadata enables bidirectional sync: `/implement` checks it to offer status updates when all tasks complete, and `/sync-to-issue` uses it to push progress or refined requirements back to the issue.

---

## Steering Docs

### When to Generate
Generate steering docs when the user asks, or suggest it when you detect a project has no `.specs/steering/` directory. Analyze the existing codebase to populate them accurately.

### Three Foundation Files

**product.md** — Product overview:
- What the product does and why it exists
- Target users and key personas
- Core features and business objectives
- Success metrics if known

**tech.md** — Technology constraints:
- Languages, frameworks, and versions
- Package manager and key dependencies
- Dev tools (linter, formatter, test runner, bundler)
- Hard prohibitions (e.g., "DO NOT use jQuery")
- Infrastructure and deployment targets

**structure.md** — Codebase organization:
- Directory layout and purpose of each top-level folder
- Naming conventions (files, components, functions, variables)
- Import/module patterns
- Architectural patterns in use (MVC, hexagonal, etc.)
- Key abstractions and where they live

### Custom Steering Docs
The user may create additional steering docs for domain-specific rules (API design standards, testing conventions, security policies, etc.). Always check for and respect all `.md` files in `.specs/steering/`.

---

## Phase 1: Requirements

### Trigger
User says something like "Create a spec for [feature]" or describes a feature they want to build.

### Your Behavior
1. Read all steering docs from `.specs/steering/` to understand project context.
2. Create the spec directory `.specs/specs/{feature-name}/` and generate `requirements.md`, saving it to disk immediately. **Do NOT ask a series of clarifying questions first** — produce a concrete draft and write the file so the user can review it in their IDE.
3. Tell the user the file has been saved and ask them to review. They may provide feedback in chat or edit the file directly.
4. Iterate based on feedback until the user approves.
5. **After explicit approval**, re-read `requirements.md` from disk (the user may have edited it directly) and proceed to Phase 2.

### Requirements Format (EARS Notation)

Use the **Easy Approach to Requirements Syntax (EARS)** for all acceptance criteria. Every requirement follows one of these patterns:

| Pattern | Template | Use When |
|---------|----------|----------|
| **Event-driven** | WHEN [event] THE SYSTEM SHALL [response] | A trigger causes a system action |
| **State-driven** | WHILE [state] THE SYSTEM SHALL [behavior] | Behavior depends on system state |
| **Unwanted behavior** | IF [condition] THEN THE SYSTEM SHALL [response] | Handling errors or edge cases |
| **Optional** | WHERE [feature is enabled] THE SYSTEM SHALL [behavior] | Configurable functionality |
| **Ubiquitous** | THE SYSTEM SHALL [behavior] | Always-on behavior with no trigger |

### Requirements File Structure

```markdown
# Feature: {Feature Name}

## Overview
Brief description of what this feature does and why it's needed.

## User Stories

### Story 1: {Story Title}
**As a** {persona}, **I want** {goal}, **so that** {benefit}.

#### Acceptance Criteria
1. WHEN {trigger/event} THE SYSTEM SHALL {expected behavior}
2. WHEN {trigger/event} THE SYSTEM SHALL {expected behavior}
3. IF {error condition} THEN THE SYSTEM SHALL {error handling behavior}

### Story 2: {Story Title}
...

## Non-Functional Requirements
- Performance: {constraints}
- Security: {constraints}
- Accessibility: {constraints}

## Out of Scope
- {Explicitly excluded items}

## Open Questions
- {Unresolved decisions that need stakeholder input}
```

### Rules for This Phase
- Focus ONLY on what the system should do, not how it should do it.
- Do not discuss code, architecture, or implementation details.
- Each acceptance criterion must be independently testable.
- Include error cases and edge cases, not just happy paths.
- Capture non-functional requirements (performance, security, accessibility).
- List anything explicitly out of scope to prevent scope creep.
- Flag open questions that need human decisions.

---

## Phase 2: Design

### Trigger
User approves the requirements (Phase 1).

### Your Behavior
1. Re-read steering docs and `requirements.md` from disk (the user may have edited it since approval).
2. Generate `design.md` that addresses every requirement, saving it to disk immediately.
3. Tell the user the file has been saved and ask them to review. They may provide feedback in chat or edit the file directly.
4. Iterate based on feedback. If the design reveals gaps in requirements, offer to go back and update `requirements.md`.
5. **After explicit approval**, re-read `design.md` from disk (the user may have edited it directly) and proceed to Phase 3.

### Design File Structure

```markdown
# Design: {Feature Name}

## Overview
High-level summary of the technical approach and key design decisions.

## Architecture

### System Context
How this feature fits into the existing system. Include a Mermaid diagram if it involves multiple components or services.

```mermaid
graph TD
    A[Component A] --> B[Component B]
    B --> C[Database]
```

### Component Design
For each new or modified component:
- **Purpose**: What it does
- **Interface**: Public API / function signatures
- **Dependencies**: What it needs
- **Location**: Where it lives in the project structure

## Data Models
Define new or modified data structures, database schemas, or API contracts.

```typescript
// Example: show the actual types/interfaces
interface User {
  id: string;
  email: string;
  // ...
}
```

## API Design
For features with API endpoints:
- Method, path, request/response shapes
- Authentication requirements
- Rate limiting or pagination

## Sequence Flows
For complex interactions, show step-by-step flows:

```mermaid
sequenceDiagram
    participant U as User
    participant API as API Server
    participant DB as Database
    U->>API: POST /register
    API->>DB: Insert user
    DB-->>API: Success
    API-->>U: 201 Created
```

## Error Handling
How the system handles each failure mode identified in the requirements.

## Testing Strategy
- **Unit tests**: What to test in isolation
- **Integration tests**: What to test across boundaries
- **Key test scenarios**: Specific cases derived from acceptance criteria

## Design Decisions
Document key decisions and their rationale:
| Decision | Choice | Rationale | Alternatives Considered |
|----------|--------|-----------|------------------------|
| Auth method | JWT | Stateless, scales horizontally | Sessions (rejected: requires sticky sessions) |

## Security Considerations
Authentication, authorization, input validation, data protection measures.

### Rules for This Phase
- Every requirement from Phase 1 must be addressed in the design.
- Use Mermaid diagrams for architecture and sequence flows — don't just describe them in prose.
- Show actual code signatures and type definitions, not just descriptions.
- Explain the "why" behind design decisions, not just the "what."
- Respect the tech stack and patterns defined in steering docs.
- Identify new dependencies and justify each one.
- Address error handling for every failure mode in the requirements.
- Include a testing strategy that maps back to acceptance criteria.

---

## Phase 3: Tasks

### Trigger
User approves the design (Phase 2).

### Your Behavior
1. Re-read steering docs, `requirements.md`, and `design.md` from disk (the user may have edited them since approval).
2. Generate `tasks.md` with an ordered implementation checklist, saving it to disk immediately.
3. Tell the user the file has been saved and ask them to review. They may provide feedback in chat or edit the file directly.
4. Iterate based on feedback.
5. **After explicit approval**, the spec is complete and ready for implementation.

### Task File Structure

```markdown
# Tasks: {Feature Name}

> Spec: `.specs/specs/{feature-name}/`
> Requirements: [requirements.md](./requirements.md)
> Design: [design.md](./design.md)

## Implementation Tasks

- [ ] 1. {Task title}
  - {Specific implementation detail}
  - {Another implementation detail}
  - Write tests: {what to test}
  - _Requirements: 1.1, 1.2_

- [ ] 2. {Task title}
  - {Specific implementation detail}
  - {Another implementation detail}
  - Write tests: {what to test}
  - _Requirements: 2.1_

- [ ] 3. {Task title}
  ...
```

### Rules for This Phase
- Each task must be a **self-contained coding unit** that can be implemented and tested independently.
- Tasks use a **maximum of two levels of hierarchy** (task + sub-bullets).
- Tasks are scoped to **coding activities only**. Exclude: deployment, documentation, user testing, business process changes, CI/CD pipeline configuration.
- Every task must include a `_Requirements: X.Y_` reference tracing it back to specific acceptance criteria.
- Every task should include what tests to write alongside the implementation.
- Order tasks for **incremental progress**: foundational pieces first, then build up. No large jumps in complexity.
- Prefer **test-driven sequencing**: set up test infrastructure early, write tests alongside (or before) implementation code.
- Keep tasks small enough to complete in a single focused session (roughly 15-60 minutes of AI agent time).
- Mark tasks with `- [ ]` (pending) or `- [x]` (complete).

---

## Design-First Workflow

When the user says "Design first: [feature]" or indicates they want to start from architecture:

1. **Phase 1 becomes Design**: Generate `design.md` first based on the user's architectural intent.
2. **Phase 2 becomes Requirements**: Derive `requirements.md` from the approved design, ensuring all designed behaviors are captured as testable criteria.
3. **Phase 3 remains Tasks**: Generate `tasks.md` as normal.

Use this workflow when the user has strong opinions about the technical approach or is building on top of an existing architecture where the "how" constrains the "what."

---

## Bugfix Workflow

When the user describes a bug to fix:

1. Generate a `bugfix.md` (replaces `requirements.md`) with this structure:

```markdown
# Bugfix: {Bug Title}

## Current Behavior
What the system does now (the bug).

## Expected Behavior
What the system should do instead.

## Reproduction Steps
1. Step-by-step reproduction path
2. ...

## Unchanged Behavior
Behaviors that MUST NOT change during the fix:
1. WHEN {condition} THE SYSTEM SHALL CONTINUE TO {existing behavior}
2. WHEN {condition} THE SYSTEM SHALL CONTINUE TO {existing behavior}

## Root Cause Analysis
Identified or suspected cause of the bug.

## Affected Components
Files, modules, or services involved.
```

2. After approval, proceed to `design.md` (focused on the fix approach).
3. Then `tasks.md` as normal.

The **"Unchanged Behavior"** section is critical — it uses EARS notation to explicitly protect existing functionality and prevent regressions.

---

## Working with Specs After Creation

### Implementing Tasks
When the user asks to implement a task (e.g., "implement task 3"), read the full spec context (requirements, design, tasks, steering docs) before writing any code. Follow the design exactly. Mark the task `- [x]` when complete.

### Checking Progress
When asked to check progress, scan the codebase against the task list and mark tasks as `- [x]` where the implementation satisfies the acceptance criteria.

### Updating Specs
When the user requests changes to an earlier phase:
1. Update the relevant file.
2. Assess impact on downstream files.
3. Offer to regenerate affected downstream files (e.g., "The design has changed. Want me to update the tasks?").

### Referencing Specs
When the user mentions a spec by name in regular conversation, load all three files from that spec's directory to inform your response.

---

## Issue Tracker Integration

SDD supports bidirectional integration with issue trackers (Linear, Jira, GitHub Issues, etc.) through MCP tools. This integration is optional — the core spec workflow is pure-files and works without any issue tracker.

### Inbound: Issue → Spec (`/spec-from-issue`)

When creating a spec from an issue:
1. Auto-detect which issue tracker MCP tools are available.
2. Fetch the issue title, description, acceptance criteria, comments, and linked items.
3. Use the issue content as the **seed** for requirements generation — don't copy-paste, restructure and enrich it with EARS notation, technical edge cases, and proper spec structure.
4. Add `<!-- source: {tracker}:{issue-id} -->` metadata to `requirements.md`.
5. After the engineer refines the spec, offer to write the enriched criteria back to the issue so the PM gets a properly defined story.

**Graceful degradation**: If no issue tracker MCP is available, prompt the user to paste the issue details manually. The spec workflow proceeds identically.

### Outbound: Spec → Issue (`/sync-to-issue`, `/implement`)

Sync options (user chooses which to apply):
- **Progress comment**: Post a summary of task completion to the issue (e.g., "3/14 tasks complete, covering requirements 1.1–2.3").
- **Updated description**: Translate refined EARS requirements back to PM-readable language and update the issue.
- **Status change**: Update the issue status (e.g., "In Progress", "In Review", "Done").

When translating requirements back to PM language:
- Convert `WHEN [trigger] THE SYSTEM SHALL [behavior]` to natural acceptance criteria.
- Group by user story.
- Keep it concise for non-technical stakeholders.
- Don't dump raw EARS notation into the issue.

**Granularity**: One issue maps to one spec at the feature/story level. Epics may inform steering docs but are not directly mapped to specs. Sub-issues in the tracker and tasks in `tasks.md` are independent — forcing alignment would make both worse.

**Graceful degradation**: If no MCP is available, `/sync-to-issue` outputs a PM-readable summary the user can paste manually. `/implement` simply skips the sync offer.

---

## Response Style During Spec Creation

- Be **decisive and concrete**. Generate a full draft immediately — don't ask a long series of clarifying questions.
- Be **concise in prose**. Specs should be dense with information, not padded with filler.
- **Use Mermaid diagrams** in design docs wherever they add clarity.
- **Show real code** (types, interfaces, signatures) in design docs, not pseudocode.
- **Write files to disk immediately** — don't present content only in chat. Save the file first, then tell the user where it is.
- After saving each phase, ask: "I've saved `{filename}` — review it in your IDE or here, then let me know your feedback or say **LGTM** to proceed to {next phase}."
- When the user approves, **re-read the file from disk** (they may have made direct edits), then immediately begin the next phase.
