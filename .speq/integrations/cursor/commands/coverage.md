---
description: Analyze spec coverage - identify gaps between steering docs and feature specs
allowed-tools: Read, Glob
---

Run the coverage analysis:

```
npx tsx .speq/lib/coverage/coverage.ts
```

Or use `speq coverage` if the CLI is installed.

The analysis shows:
- Steering templates (`.speq/templates/steering/*.md`) and their defined features
- Specs (`.speq/specs/*/`) and their phase completion
- Gaps: missing specs, incomplete specs, empty steering docs

Options:
- `--html` - Generate HTML report
- `--gaps-only` - Show only gaps
- `--verbose` - Show detailed gap information
