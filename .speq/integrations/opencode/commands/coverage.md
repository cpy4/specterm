# Speq Coverage Analysis

Analyze spec coverage to identify gaps between steering docs and feature specs.

## Usage

Run the coverage analysis:

```bash
npx tsx .speq/lib/coverage/coverage.ts
```

Or use `speq coverage` if the CLI is installed.

## Options

- `--html` - Generate HTML report
- `--gaps-only` - Show only gaps
- `--verbose` - Show detailed gap information
- `--output <path>` - Output file path (for HTML)

## What It Checks

The analyzer examines:

1. **Steering Templates** (`.speq/templates/steering/*.md`) - extracts features from `<!-- speq:features -->` blocks
2. **Specs** (`.speq/specs/*/`) - checks for requirements.md, design.md, tasks.md
3. **Gaps** - identifies:
   - Missing specs (features in steering with no corresponding spec)
   - Incomplete specs (specs missing phase files)
   - Empty steering docs

## Action Items

After running coverage, address any gaps:
- Create specs for missing features
- Complete incomplete specs
- Add features to steering docs if they're missing
