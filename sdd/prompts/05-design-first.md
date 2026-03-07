# Prompt: Design-First Workflow

Use this prompt when you already know the architectural approach and want to start from technical design rather than requirements. This is ideal when building on existing infrastructure, working within strict performance/scaling constraints, or extending a well-defined system.

---

## Phase 1: Design (replaces Requirements as first phase)

```
You are a software architect helping me design a feature where the technical approach is already partially known.

PROJECT CONTEXT:
{STEERING_CONTEXT}

FEATURE + ARCHITECTURAL INTENT:
{DESCRIBE WHAT YOU WANT TO BUILD AND THE TECHNICAL APPROACH YOU WANT TO TAKE}

YOUR TASK:
Generate a complete design.md document as the FIRST phase of this spec. Since we're starting design-first, focus on:

1. Validate and flesh out the architectural approach I've described
2. Define concrete components, interfaces, and data models
3. Show system/sequence diagrams in Mermaid
4. Address error handling and edge cases at the architectural level
5. Include a testing strategy
6. Document design decisions and tradeoffs

Follow the standard design.md format (Overview, Architecture, Components, Data Models, API Design, Sequence Flows, Error Handling, Testing Strategy, Design Decisions, Security).

Use real code signatures and types from the project's language.
Respect the established patterns in the project context.

After I approve this design, we'll DERIVE requirements from it (ensuring every designed behavior has a testable criterion), then generate tasks.

Present the design and ask me to review. Say "LGTM" when satisfied.
```

## Phase 2: Derive Requirements from Approved Design

```
The design for {feature-name} has been approved. Now derive a requirements.md from it.

APPROVED DESIGN:
{PASTE OR REFERENCE design.md}

YOUR TASK:
Work BACKWARDS from the design to create requirements.md:

1. For every component behavior in the design, write an EARS-format acceptance criterion
2. For every error handling path, write an IF/THEN criterion
3. For every API endpoint, write WHEN/SHALL criteria for success and failure cases
4. Group criteria into logical User Stories
5. Add Non-Functional Requirements based on the design's architectural constraints
6. Add Out of Scope based on what the design explicitly excludes

The requirements must be 100% achievable given the approved design. Do not add requirements that would force design changes.

Number all acceptance criteria for traceability. Present for review.
```

## Phase 3: Tasks (standard)
After requirements are approved, use the standard tasks prompt (`03-tasks.md`).

---

## When to Use Design-First

- You're extending an existing system with well-defined extension points
- You have hard non-functional constraints (latency < 50ms, must use existing message queue)
- The "what" is simple but the "how" is complex (e.g., "add caching" — simple goal, many design decisions)
- You're building infrastructure or platform features where architecture IS the feature
- You've already made key tech decisions and want the spec to reflect them
