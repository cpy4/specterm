#!/usr/bin/env node

import * as fs from 'fs';
import { analyze } from './analyzer.js';
import { renderTerminal } from './renderer/terminal.js';
import { renderHtml } from './renderer/html.js';
import type { CoverageOptions } from './types.js';

function parseArgs(): CoverageOptions {
  const args = process.argv.slice(2);
  const options: CoverageOptions = {
    gapsOnly: false,
    verbose: false,
    html: false,
    output: undefined
  };
  
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    
    switch (arg) {
      case '--html':
      case '-h':
        options.html = true;
        break;
      case '--gaps-only':
      case '-g':
        options.gapsOnly = true;
        break;
      case '--verbose':
      case '-v':
        options.verbose = true;
        break;
      case '--output':
      case '-o':
        options.output = args[++i];
        break;
      case '--help':
        printHelp();
        process.exit(0);
    }
  }
  
  return options;
}

function printHelp(): void {
  console.log(`
speq coverage - Analyze spec coverage

Usage: speq coverage [options]

Options:
  --html, -h         Generate HTML report
  --gaps-only, -g    Show only gaps
  --verbose, -v      Show detailed gap information
  --output, -o <path> Output file path (for HTML)
  --help             Show this help message
`.trim());
}

function main(): void {
  const options = parseArgs();
  const report = analyze();
  
  if (!report) {
    process.exit(1);
  }
  
  if (options.html) {
    const html = renderHtml(report);
    
    if (options.output) {
      fs.writeFileSync(options.output, html);
      console.log(`HTML report written to: ${options.output}`);
    } else {
      console.log(html);
    }
  } else {
    const output = renderTerminal(report, options);
    console.log(output);
  }
  
  process.exit(0);
}

main();
