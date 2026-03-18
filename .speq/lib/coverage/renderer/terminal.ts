import type { CoverageReport, CoverageOptions } from '../types.js';

const RESET = '\x1b[0m';
const GREEN = '\x1b[32m';
const YELLOW = '\x1b[33m';
const RED = '\x1b[31m';
const CYAN = '\x1b[36m';
const BOLD = '\x1b[1m';
const DIM = '\x1b[2m';

function checkMark(status: string): string {
  switch (status) {
    case 'complete': return GREEN + '✓' + RESET;
    case 'partial': return YELLOW + '◐' + RESET;
    case 'empty': 
    case 'missing': return RED + '✗' + RESET;
    default: return '?';
  }
}

function statusText(status: string, extra?: string): string {
  switch (status) {
    case 'complete': return GREEN + 'complete' + RESET + (extra ? ` (${extra})` : '');
    case 'partial': return YELLOW + 'partial' + RESET + (extra ? ` (${extra})` : '');
    case 'empty': return RED + 'empty' + RESET;
    case 'missing': return RED + 'missing' + RESET;
    default: return status;
  }
}

function gapIndicator(): string {
  return CYAN + '[GAP]' + RESET;
}

function formatSteeringDoc(doc: { file: string; status: string; features: { slug: string }[] }): string {
  const icon = checkMark(doc.status);
  const featureCount = doc.features.length;
  const extra = featureCount > 0 ? `${featureCount} features` : undefined;
  return `│   ├── ${doc.file}      ${icon} ${statusText(doc.status, extra)}`;
}

function formatSpec(spec: { name: string; status: string; phases: { requirements: boolean; design: boolean; tasks: boolean } }): string {
  const icon = checkMark(spec.status);
  let extra = '';
  
  if (spec.status === 'complete') {
    extra = 'all phases';
  } else if (spec.status === 'partial') {
    const missing: string[] = [];
    if (!spec.phases.requirements) missing.push('requirements');
    if (!spec.phases.design) missing.push('design');
    if (!spec.phases.tasks) missing.push('tasks');
    extra = `missing ${missing.join(', ')}`;
  } else if (spec.status === 'empty') {
    extra = 'no phase files';
  }
  
  return `│   ├── ${spec.name.padEnd(20)} ${icon} ${statusText(spec.status, extra)}`;
}

function formatGap(gap: { type: string; feature?: string; file?: string; message: string }): string {
  let prefix = '';
  
  if (gap.type === 'missing-spec') {
    prefix = `${gapIndicator()} ${gap.feature}`;
  } else if (gap.type === 'incomplete-spec') {
    prefix = `${gapIndicator()} ${gap.feature}`;
  } else if (gap.type === 'empty-steering') {
    prefix = `${gapIndicator()} ${gap.file}`;
  }
  
  return `│   └── ${prefix.padEnd(25)} ← ${gap.message}`;
}

export function renderTerminal(report: CoverageReport, options: CoverageOptions): string {
  const lines: string[] = [];
  
  lines.push(BOLD + '.speq/' + RESET);
  lines.push('├── templates/');
  lines.push('│   └── steering/');
  
  if (report.steeringDocs.length === 0) {
    lines.push('│       (no steering templates found)');
  } else {
    for (let i = 0; i < report.steeringDocs.length; i++) {
      const doc = report.steeringDocs[i];
      const isLast = i === report.steeringDocs.length - 1 && report.specs.length === 0 && report.gaps.length === 0;
      lines.push(formatSteeringDoc(doc).replace('├──', isLast ? '└──' : '├──'));
    }
  }
  
  if (report.specs.length > 0 || report.gaps.length > 0) {
    lines.push('│');
    lines.push('└── specs/');
    
    const allItems = [...report.specs];
    
    const missingFeatureGaps = report.gaps.filter(g => g.type === 'missing-spec');
    for (const gap of missingFeatureGaps) {
      allItems.push({ name: gap.feature!, status: 'missing', phases: { requirements: false, design: false, tasks: false } });
    }
    
    for (let i = 0; i < allItems.length; i++) {
      const spec = allItems[i];
      const isLast = i === allItems.length - 1 && report.gaps.filter(g => g.type !== 'missing-spec').length === 0;
      lines.push(formatSpec(spec).replace('├──', isLast ? '└──' : '├──'));
    }
    
    const otherGaps = report.gaps.filter(g => g.type !== 'missing-spec');
    if (otherGaps.length > 0) {
      for (let i = 0; i < otherGaps.length; i++) {
        const gap = otherGaps[i];
        const isLast = i === otherGaps.length - 1;
        lines.push(formatGap(gap).replace('└──', isLast ? '└──' : '├──'));
      }
    }
  }
  
  lines.push('');
  
  const { specsComplete, specsTotal, gapsCount } = report.totals;
  const coveragePct = specsTotal > 0 ? Math.round((specsComplete / specsTotal) * 100) : 0;
  
  lines.push(`${BOLD}Coverage:${RESET} ${specsComplete}/${specsTotal} specs complete (${coveragePct}%)${gapsCount > 0 ? `, ${gapsCount} gaps found` : ''}`);
  
  if (options.verbose && report.gaps.length > 0) {
    lines.push('');
    lines.push(BOLD + 'Gaps:' + RESET);
    for (const gap of report.gaps) {
      lines.push(`  • ${gap.message}`);
    }
  }
  
  return lines.join('\n');
}
