# Prompt: Generate Design

Use this prompt to generate the design phase of a spec. Replace the placeholders with your actual content.

---

## Prompt

```
You are a software architect helping me design a feature implementation.

PROJECT CONTEXT:
{STEERING_CONTEXT}

APPROVED REQUIREMENTS:
{PASTE YOUR requirements.md CONTENT HERE}

YOUR TASK:
Generate a complete design.md document that provides a technical blueprint for implementing every requirement above. Follow these rules precisely:

1. OVERVIEW: Summarize the technical approach in 2-3 sentences. State the key architectural decision upfront.

2. ARCHITECTURE: Show how this feature fits into the existing system.
   - Include a Mermaid diagram (graph, flowchart, or C4-style) showing component relationships.
   - Identify new components vs. modified existing ones.
   - For each component, specify: Purpose, Public Interface, Dependencies, File Location.

3. DATA MODELS: Define all new or modified data structures.
   - Show actual type definitions or schema (TypeScript interfaces, SQL DDL, Prisma schema, etc.) — not pseudocode.
   - Include field types, constraints, defaults, and indexes.
   - Show relationships between entities.

4. API DESIGN (if applicable): For each endpoint:
   - HTTP method, path, request shape, response shape
   - Authentication/authorization requirements
   - Error response codes and shapes

5. SEQUENCE FLOWS: For the 2-3 most complex interactions, include Mermaid sequence diagrams showing the step-by-step flow between components.

6. ERROR HANDLING: For every failure mode identified in the requirements, specify:
   - How it's detected
   - How it's communicated to the user
   - Any recovery/retry logic

7. TESTING STRATEGY:
   - Unit test targets (what to mock, what to test in isolation)
   - Integration test scenarios (what to test across boundaries)
   - Map specific acceptance criteria to test cases

8. DESIGN DECISIONS TABLE:
   | Decision | Choice | Rationale | Alternatives Considered |
   For every significant choice, document why and what you rejected.

9. SECURITY CONSIDERATIONS: Authentication, authorization, input validation, data protection.

IMPORTANT:
- Every requirement from the requirements doc must be addressed.
- Respect the tech stack and patterns defined in the project context.
- Show real code signatures and types, not hand-wavy descriptions.
- Use Mermaid diagrams — don't just describe architecture in prose.
- Justify new dependencies. Prefer what's already in the project.
- If you discover gaps in the requirements during design, list them at the end and offer to update the requirements.

After generating, ask me to review and say "LGTM" when I'm satisfied.
```

---

## What Good Output Looks Like

- Clear architectural overview with Mermaid system diagram
- Concrete type definitions in the project's actual language
- Sequence diagrams for complex flows (auth, data mutation, async processes)
- Error handling that maps 1:1 to requirement failure modes
- Design decisions table with genuine tradeoff analysis
- Testing strategy that references specific acceptance criteria numbers
- No vague hand-waving — every section contains enough detail to implement from
