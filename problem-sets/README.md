# HPM 883 Problem Sets

## Overview

This directory contains 7 challenging Problem Sets for HPM 883 (PhD Advanced Quantitative Methods). Problem Sets are distinct from Labs:

| Dimension | Labs | Problem Sets |
|-----------|------|--------------|
| **When** | In-class (Wednesdays) | Homework (1-2 weeks) |
| **Mode** | Guided, instructor-led | Independent or group |
| **Purpose** | Formative — build intuition | Summative — assess application |
| **Focus** | Mechanics, "why it works" | Frameworks, "how to use it" |
| **Scaffolding** | High (blanks, step-by-step) | Minimal (package hints only) |
| **Difficulty** | Doable in 75 min with guidance | Challenging, 6-10 hours |
| **Grading** | Completion/participation | Formal rubric (25% of grade) |

## Assessment Structure

- **7 Problem Sets total**
- **Best 4 count** toward 25% of final grade (drop lowest 3)
- **PS 7 can replace** any lower-scoring PS 1-6 (incentivizes advanced topic exploration)
- Each PS ~4% individually

## Problem Set Schedule

| PS | Unit | Title | Due Date |
|----|------|-------|----------|
| 1 | 1 | Experimental Design & Power | Feb 9 |
| 2 | 2 | Double Machine Learning | Feb 23 |
| 3 | 3 | Causal Forests & HTEs | Mar 25 |
| 4 | 4 | Policy Learning | Apr 8 |
| 5 | 5 | Observational Causal ML | Apr 15 |
| 6 | 6 | Causal ML Integration | Apr 20 |
| 7 | 7 | Advanced Topics (Optional) | Finals Week |

## The St. Null's Hospital Universe

All Problem Sets take place in the **St. Null's Memorial Hospital** universe, featuring recurring characters:

| Character | Role | Methodological Stance |
|-----------|------|----------------------|
| **Dr. P-Hacker** | Eager but misguided analyst | Makes common mistakes students must identify/fix |
| **Nurse Random** | Principled methodologist | Represents sound causal reasoning |
| **Dr. Doub R. Obust** | Doubly-robust expert | Introduces DR/DML approaches |
| **CEO Barnaby Beta** | Results-focused administrator | Cares about decisions, not p-values |
| **Dr. Hetty Geneous** | HTE specialist | Introduced in PS 3 for CATE analysis |
| **Policy Pete** | Decision scientist | Introduced in PS 4 for policy learning |

## Directory Structure

```
problem-sets/
├── README.md                    # This file
├── ps-1-experimental-design.qmd # Student version
├── ps-2-dml.qmd
├── ps-3-causal-forests.qmd
├── ps-4-policy-learning.qmd
├── ps-5-observational.qmd
├── ps-6-integration.qmd
├── ps-7-advanced.qmd
├── data/                        # Datasets (known DGP)
│   ├── ps-1-cluster-rct.csv
│   ├── ps-2-medicaid.csv
│   └── ...
├── data-generation/             # Data generation scripts
│   ├── ps-1-generate.R
│   └── ...
└── solutions/                   # Instructor solutions (private)
    ├── ps-1-solutions.qmd
    └── ...
```

## Design Principles

1. **Challenging** — Require understanding, not code copying
2. **Minimal scaffolding** — R proficiency is prerequisite (no hand-holding)
3. **Conceptual + Computational** — Mix "why" with "how"
4. **Realistic scope** — 6-10 hours of work
5. **Clear deliverables** — Specific outputs expected
6. **Health services research context** — Real-world policy relevance
7. **Known DGP** — All datasets have documented true parameters

## Task Structure (each PS)

```
1. Scenario Setup (narrative framing)
2. Task 1: Conceptual Question (no code required)
3. Task 2: Core Implementation
4. Task 3: Diagnostics/Assumption Checking
5. Task 4: Extension/Alternative Approach
6. Task 5: Written Interpretation (300-500 words)
```

## Grading Rubric

Each task weighted:
- **Conceptual (20%):** Understanding, not just code
- **Implementation (30%):** Correct method application
- **Diagnostics (20%):** Assumption checking, robustness
- **Extension (15%):** Going beyond basic application
- **Interpretation (15%):** Clear communication to non-technical audience

## Key R Packages by Unit

| PS | Primary Packages |
|----|-----------------|
| 1 | `DeclareDesign`, `estimatr`, `fabricatr` |
| 2 | `DoubleML`, `mlr3`, `mlr3learners`, `cobalt` |
| 3 | `grf`, `ranger` |
| 4 | `policytree`, `grf` |
| 5 | `WeightIt`, `cobalt`, `did`, `Synth`, `sensemakr` |
| 6 | All prior + `targets` |
| 7 | Varies by option |
