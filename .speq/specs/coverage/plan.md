# Plan: `speq coverage` Command

## Overview

Add a `speq coverage` command that analyzes steering docs and feature specs to identify gaps — features implied by steering docs but lacking specs, plus completeness status of existing specs.

## What is a "Gap"?

Based on the SDD system structure, a gap is:

1. **Implied Features** — Steering docs describe core features in `<!-- speq:features -->` blocks, but no corresponding spec exists in `.speq/specs/`
2. **Incomplete Specs** — Specs missing required phases:
   - Missing `requirements.md`
   - Missing `design.md` (after requirements approved)
   - Missing `tasks.md` (after design approved)
3. **Stale Steering** — Steering docs exist but are empty or contain only TODO placeholders

## File Structure

```
.speq/
├── lib/
│   └── coverage/
│       ├── coverage.ts                # Main CLI entry point
│       ├── analyzer.ts                # Core analysis logic
│       ├── types.ts                   # TypeScript types
│       └── renderer/
│           ├── terminal.ts            # Tree/diff style terminal output
│           └── html.ts                # HTML generator
├── specs/
│   └── coverage/
│       └── plan.md                    # This file
└── integrations/
    ├── claude-code/commands/
    │   └── coverage.md                 # Claude Code command
    ├── opencode/commands/
    │   └── coverage.md                # OpenCode command
    └── cursor/commands/
        └── coverage.md                # Cursor command
```

## CLI Interface

```bash
# Terminal output (default)
speq coverage

# Generate HTML report
speq coverage --html

# Output to specific path
speq coverage --html --output coverage.html

# Show only gaps (hide complete items)
speq coverage --gaps-only

# Verbose mode
speq coverage -v
```

### Exit Codes
- `0` — Success (with or without gaps)
- `1` — Error (no .speq directory, etc.)

## Analysis Algorithm

### 1. Parse Steering Docs Features Block
- Read all `.speq/templates/steering/*.md` files (templates)
- Also scan for actual steering docs in project root `.specs/steering/*.md`
- Extract feature slugs by finding `<!-- speq:features -->` ... `<!-- speq:features:end -->` blocks
- Parse each list item, extracting the backtick-wrapped slug (e.g., `- \`feature-slug\` — description`)
- No fuzzy header/bullet pattern matching

### 2. Parse Existing Specs
- Scan `.speq/specs/*/` directories (feature specs)
- For each spec folder, determine phase completion:
  - `requirements.md` exists → Phase 1 complete
  - `design.md` exists → Phase 2 complete  
  - `tasks.md` exists → Phase 3 complete
- Extract feature name from folder (kebab-case)

### 3. Identify Gaps
- **Missing Specs**: Steering features without matching spec folders
- **Incomplete Specs**: Specs missing required phase files
- **Empty Steering**: Steering docs with TODO-only content

### 4. Generate Report Data

```typescript
interface CoverageReport {
  steeringDocs: {
    file: string;
    status: 'complete' | 'empty' | 'missing';
    features: string[];
  }[];
  specs: {
    name: string;
    phases: {
      requirements: boolean;
      design: boolean;
      tasks: boolean;
    };
    status: 'complete' | 'partial' | 'empty';
  }[];
  gaps: {
    type: 'missing-spec' | 'incomplete-spec' | 'empty-steering';
    feature?: string;
    file?: string;
    message: string;
  }[];
}
```

## Terminal Rendering

### Output Format (Tree/Diff Style)

```
.speq/
├── templates/
│   └── steering/
│       ├── product.md      ✓ complete (3 features)
│       ├── tech.md         ✓ complete
│       └── structure.md    ✓ complete
│
└── specs/
    ├── user-auth       ✓ complete (all phases)
    ├── payment-flow    ◐ partial (missing tasks.md)
    ├── api-rate-limit  ✗ empty (no phase files)
    └── [GAP] analytics    ← no spec exists
    └── [GAP] dark-mode    ← no spec exists

Coverage: 3/6 specs complete, 2 gaps found
```

### Color Scheme
- Green (✓): Complete
- Yellow (◐): Partial/incomplete
- Red (✗): Empty/missing
- Cyan: Gap indicators

## HTML Rendering

### Features
- Collapsible tree view
- Visual progress bars per spec
- Gap highlights with suggested actions
- Exportable as standalone file (self-contained, no external deps)
- Dark/light theme detection

### Structure

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    /* Embedded CSS - no external dependencies */
  </style>
</head>
<body>
  <div class="report">
    <header>Coverage Report</header>
    <section class="summary">...</section>
    <section class="steering">...</section>
    <section class="specs">...</section>
    <section class="gaps">...</section>
  </div>
</body>
</html>
```

## Implementation Notes

1. **Language**: TypeScript (for type safety, matches existing patterns)
2. **No external deps**: Use Node.js built-ins only (fs, path, process)
3. **Embed HTML styles**: No external CSS files
4. **Graceful handling**: If `.speq/` doesn't exist, show helpful message
5. **Templates-first**: Analyze `.speq/templates/steering/` as the source of truth for features

## Steering Doc Template Format

Each steering doc template MUST include a structured features block:

```markdown
## Features

<!-- speq:features — list features that should have specs. slugs map to .speq/specs/<slug>/ -->
- `feature-slug` — Short description of this feature
- `another-feature` — Another feature description
<!-- speq:features:end -->
```

## Integration Commands

Add to each tool integration following existing patterns:

- `.speq/integrations/claude-code/commands/coverage.md`
- `.speq/integrations/opencode/commands/coverage.md`
- `.speq/integrations/cursor/commands/coverage.md`

Each command will invoke the coverage CLI or provide the analysis prompt.
