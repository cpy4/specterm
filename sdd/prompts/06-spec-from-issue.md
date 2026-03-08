# Prompt: Generate Spec from Issue

Use this prompt to generate a requirements spec seeded from an existing issue tracker issue. Replace `{ISSUE_CONTENT}` with the issue title, description, acceptance criteria, and any comments. Replace `{STEERING_CONTEXT}` with your steering docs content (or remove that section if you don't have steering docs yet).

**Note:** This prompt works best with AI tools that have MCP integration with your issue tracker (Linear, Jira, GitHub Issues). Without MCP, manually paste the issue content below. The core spec output is identical either way.

---

## Prompt

```
You are a requirements analyst helping me turn an issue tracker issue into a proper software feature specification.

PROJECT CONTEXT:
{STEERING_CONTEXT}

ISSUE CONTENT:
{ISSUE_CONTENT}

(Include: title, description, acceptance criteria if any, relevant comments, labels, priority, linked issues)

YOUR TASK:
Generate a complete requirements.md document using this issue as the seed. Follow these rules precisely:

1. Add a source metadata comment on the very first line:
   <!-- source: {tracker}:{issue-id} -->
   For example: <!-- source: linear:ENG-142 --> or <!-- source: jira:PROJ-142 -->

2. Do NOT just copy-paste the issue description. Restructure and enrich it:
   - Transform PM-language bullet points into structured EARS notation
   - Add technical edge cases the original issue may have missed
   - Identify implicit requirements the PM assumed but didn't state

3. Write ALL acceptance criteria using EARS notation:
   - Event-driven: WHEN {event} THE SYSTEM SHALL {response}
   - State-driven: WHILE {state} THE SYSTEM SHALL {behavior}
   - Error handling: IF {condition} THEN THE SYSTEM SHALL {response}
   - Optional: WHERE {feature is enabled} THE SYSTEM SHALL {behavior}
   - Ubiquitous: THE SYSTEM SHALL {behavior}

4. Include sections for: Overview, User Stories with numbered acceptance criteria, Non-Functional Requirements, Out of Scope, Open Questions.

5. Cover error cases, edge cases, and boundary conditions — not just happy paths.

6. Each acceptance criterion must be independently testable.

IMPORTANT:
- Focus ONLY on WHAT the system should do, not HOW.
- Do NOT ask clarifying questions — generate a complete first draft now.
- Be thorough: the PM's one-liner should become a properly defined feature spec.
- If you have file access, save to `.specs/specs/{feature-name}/requirements.md` IMMEDIATELY — don't wait for approval. The user will review the file in their IDE.

After saving (or generating), ask me to review and say "LGTM" when I'm satisfied. If I make edits directly to the file, re-read it from disk before proceeding. Then offer to provide a PM-readable version of the refined requirements that I can paste back into the issue to help the team see the fully defined acceptance criteria.
```

---

## Example Usage

```
ISSUE CONTENT:
Title: ENG-142 - Add product review system
Description: Users should be able to leave reviews on products. Need star ratings and text.
Acceptance criteria: Users can rate 1-5, reviews appear on product page
Labels: feature, customer-facing
Priority: High
Comments:
  - PM: "Moderation needed before reviews go live"
  - Design: "See Figma mockup [link]"
```

## What Good Output Looks Like

- Source metadata linking back to the original issue
- PM's sparse description expanded into 3-6 user stories with 15-30 numbered criteria
- Edge cases the PM didn't mention: duplicate reviews, editing pending reviews, profanity filtering
- Non-functional requirements: pagination, load times, accessibility
- Open questions flagged for PM: "Should anonymous users see reviews?"
- A clean separation between what the PM described and what the engineer added
