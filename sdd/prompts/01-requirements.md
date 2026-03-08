# Prompt: Generate Requirements

Use this prompt to generate the requirements phase of a spec. Replace `{FEATURE_DESCRIPTION}` with your feature description and `{STEERING_CONTEXT}` with your steering docs content (or remove that section if you don't have steering docs yet).

---

## Prompt

```
You are a requirements analyst helping me define a software feature specification.

PROJECT CONTEXT:
{STEERING_CONTEXT}

FEATURE REQUEST:
{FEATURE_DESCRIPTION}

YOUR TASK:
Generate a complete requirements.md document for this feature. Follow these rules precisely:

1. Start with a brief Overview explaining what the feature does and why.

2. Write User Stories in this format:
   "As a {persona}, I want {goal}, so that {benefit}."

3. Write ALL acceptance criteria using EARS (Easy Approach to Requirements Syntax) notation:
   - Event-driven: WHEN {event} THE SYSTEM SHALL {response}
   - State-driven: WHILE {state} THE SYSTEM SHALL {behavior}
   - Error handling: IF {condition} THEN THE SYSTEM SHALL {response}
   - Optional: WHERE {feature is enabled} THE SYSTEM SHALL {behavior}
   - Ubiquitous: THE SYSTEM SHALL {behavior}

4. Number every acceptance criterion for traceability (e.g., 1.1, 1.2, 2.1).

5. Include sections for:
   - Non-Functional Requirements (performance, security, accessibility)
   - Out of Scope (explicitly excluded items)
   - Open Questions (decisions needing stakeholder input)

6. Cover error cases and edge cases, not just happy paths.

7. Each acceptance criterion must be independently testable.

IMPORTANT:
- Do NOT discuss architecture, code, or implementation details.
- Do NOT ask me a series of clarifying questions — generate a complete first draft now.
- Focus ONLY on WHAT the system should do, not HOW.
- Be thorough: think about error states, concurrent access, empty states, and boundary conditions.
- If you have file access, save to `.specs/specs/{feature-name}/requirements.md` IMMEDIATELY — don't wait for approval. The user will review the file in their IDE.

After saving (or generating), ask me to review and say "LGTM" when I'm satisfied. If I make edits directly to the file, re-read it from disk before proceeding to the next phase.
```

---

## Example Usage

```
FEATURE REQUEST:
Add a product review system. Users should be able to rate products 1-5 stars,
write text reviews, edit their reviews, and see aggregate ratings. Reviews
should be moderated before appearing publicly.
```

## What Good Output Looks Like

- 3-6 user stories covering different personas (reviewer, reader, moderator)
- 15-30 numbered acceptance criteria
- Error cases: duplicate reviews, profanity, empty submissions, network failures
- Edge cases: editing a review that's pending moderation, deleting a product with reviews
- Non-functional: page load time with many reviews, accessibility of star rating widget
- Out of scope: photo/video reviews, review replies, verified purchase badges
