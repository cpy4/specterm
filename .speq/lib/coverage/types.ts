export interface SteeringDoc {
  file: string;
  path: string;
  status: 'complete' | 'empty' | 'missing';
  features: Feature[];
}

export interface Feature {
  slug: string;
  description: string;
}

export interface SpecPhase {
  requirements: boolean;
  design: boolean;
  tasks: boolean;
}

export interface Spec {
  name: string;
  path: string;
  phases: SpecPhase;
  status: 'complete' | 'partial' | 'empty';
}

export interface Gap {
  type: 'missing-spec' | 'incomplete-spec' | 'empty-steering';
  feature?: string;
  file?: string;
  message: string;
}

export interface CoverageReport {
  steeringDocs: SteeringDoc[];
  specs: Spec[];
  gaps: Gap[];
  totals: {
    steeringDocsTotal: number;
    specsTotal: number;
    specsComplete: number;
    gapsCount: number;
  };
}

export interface CoverageOptions {
  gapsOnly: boolean;
  verbose: boolean;
  html: boolean;
  output?: string;
}

export type Status = 'complete' | 'partial' | 'empty' | 'missing';
