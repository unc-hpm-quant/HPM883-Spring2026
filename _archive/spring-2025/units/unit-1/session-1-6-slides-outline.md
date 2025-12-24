# Session 6: Optimal Experimental Design & MIDA Framework

**Date:** January 26, 2026
**Duration:** 75 minutes
**Format:** In-Person

---

## Slide Outline (Condensed from 2,000+ lines of 2025 content)

### Part 1: The Optimization Framework (~20 min)

**Slide 1: Experimental Design as Optimization**
- We're in control: design to maximize learning
- Objective: Maximize power (or minimize MDE)
- Constraints: Budget, logistics, ethics

**Slide 2: The Optimization Problem**
- Maximize: Statistical power
- Subject to: Budget constraint
- Decision variables: Sample sizes, allocation ratio, design choices

**Slide 3: Key Elements for Sample Size**
```
[Concept map from lec-2-1.qmd lines 48-85]
```
- Significance level (α)
- Desired power (1-β)
- Minimum Detectable Effect (MDE)
- Budget and treatment costs
- Analysis approach
- Pre-treatment covariates

**Slide 4: MDE ≠ Expected Effect Size**
- MDE: Smallest effect you can *detect* with desired power
- Expected effect: Your best guess of the *true* effect
- Rule of thumb: MDE ≤ Expected effect (leave room for uncertainty)

**Slide 5: The MDE Formula (Simple Case)**
$$MDE = (t_{1-\alpha/2} + t_{1-\beta}) \times \sqrt{\frac{\sigma^2}{n_T} + \frac{\sigma^2}{n_C}}$$

**Slide 6: Optimal Allocation**
- Equal allocation (50/50) when costs are equal
- Unequal allocation when treatment is more expensive
- Formula: $\frac{n_T}{n_C} = \sqrt{\frac{c_C}{c_T}}$

---

### Part 2: Variance Reduction Techniques (~25 min)

**Slide 7: Why Reduce Variance?**
- Lower variance → Lower MDE → More power
- Three main approaches:
  1. Blocking/Stratification
  2. Covariate adjustment (Lin regression)
  3. Pre-treatment outcomes (CUPED)

**Slide 8: Blocking & Stratification**
- Group similar units, randomize within groups
- Reduces between-group variance
- Must analyze respecting the blocking structure

**Slide 9: Lin (2013) Regression Adjustment** [Review from Session 5]
- Center covariates, include interactions with treatment
- Guarantees variance reduction (never hurts)
- Valid inference without assuming linear model

**Slide 10: CUPED (Controlled-Experiment Using Pre-Experiment Data)**
- Use pre-treatment outcome $Y_{pre}$ to reduce variance
- Adjusted outcome: $\tilde{Y} = Y - \theta(Y_{pre} - \bar{Y}_{pre})$
- Variance reduction: $1 - \rho^2$ (where $\rho$ = correlation)
- Common in tech experiments (Microsoft, Netflix)

**Slide 11: Variance Reduction Comparison**
| Method | Variance Reduction | When to Use |
|--------|-------------------|-------------|
| Blocking | Moderate | Discrete covariates, small # strata |
| Lin regression | Guaranteed improvement | Any continuous/discrete covariates |
| CUPED | Potentially large | Pre-treatment outcome available |

---

### Part 3: Design Extensions (~15 min)

**Slide 12: Cluster Randomization**
- When: Ethical/practical reasons to randomize clusters
- Trade-off: Fewer effective observations
- Design effect: $DE = 1 + (m-1) \times ICC$
- More clusters > more units per cluster

**Slide 13: Cluster Sample Size Formula**
$$n_{clusters} = \frac{(t_{1-\alpha/2} + t_{1-\beta})^2 \times 2\sigma^2 \times DE}{m \times MDE^2}$$
- m = units per cluster
- ICC = intraclass correlation
- Plan for ICC = 0.05-0.10 in health settings

**Slide 14: Randomization Techniques (Overview)**
*[One slide summary — details in appendix]*

| Technique | Description | Use When |
|-----------|-------------|----------|
| Simple/Bernoulli | Coin flip for each unit | Large samples, simplicity |
| Complete | Fixed # to each arm | Exact balance on N |
| Stratified/Blocked | Randomize within strata | Important covariates |
| Matched Pairs | Match similar units, randomize | Small samples |
| Re-randomization | Reject imbalanced allocations | Very small samples |

→ See Appendix for implementation details

---

### Part 4: Practical Application (~15 min)

**Slide 15: Design Decisions Flowchart**
```
1. What's your budget? → Determines total N
2. Individual or cluster? → Affects effective N
3. Key covariates available? → Blocking strategy
4. Pre-treatment outcomes? → CUPED potential
5. Treatment cost differential? → Allocation ratio
```

**Slide 16: Interactive Demo: OED Shiny App**
- Link to [Optimal Experiment Design App](/unit-2/shiny-oed-app.qmd)
- Explore power curves, cost trade-offs
- Compare designs

**Slide 17: Problem Set 1 Preview**
- Design an RCT using DeclareDesign
- Compare blocked vs. simple randomization
- Power analysis with realistic constraints
- Due: February 2

---

## Appendix Slides (Reference — Not Presented)

### A1-A5: Randomization Implementation Details
- Bernoulli trials: `rbinom(n, 1, 0.5)`
- Complete randomization: `sample()` or `randomizr::complete_ra()`
- Stratified: `randomizr::block_ra()`
- Re-randomization: balance criteria and iteration

### A6-A8: Balance Verification
- Baseline balance tables
- F-test for joint significance
- When imbalance happens (and what to do)

### A9-A10: Multiple Arms
- Extending to 3+ treatment arms
- Factorial designs (briefly)

---

## Source Content Mapping

| 2026 Slide | Source from 2025 |
|------------|------------------|
| 1-6 | `unit-2/lec-2-1.qmd` §1-3 |
| 7-9 | `unit-1/lec-1-2.qmd` §Lin + new MIDA |
| 10 | NEW (CUPED) |
| 11-13 | `unit-2/lec-2-1.qmd` §5-6 |
| 14 | `unit-2/lec-2-2.qmd` (condensed) |
| 15-17 | NEW |
| Appendix | `unit-2/lec-2-2.qmd` (full details) |

---

## Content Not Included (Moved to Readings/Appendix)

- Detailed randomization code examples → Appendix
- Formal derivations of MDE formulas → Readings
- Balance verification procedures → Appendix
- Complex experimental designs (factorial, stepped-wedge) → Optional readings
- Ethical considerations → Brief mention, readings

---

## New Content to Create

1. **CUPED slides** — Not in 2025 content, need to add
2. **Variance reduction comparison table**
3. **Design decisions flowchart**
4. **Appendix slides** from lec-2-2.qmd

## Content to Migrate

1. Optimization framework (lec-2-1.qmd §1-4) → Slides 1-6
2. Cluster randomization (lec-2-1.qmd §5) → Slides 12-13
3. Randomization overview (lec-2-2.qmd) → Slide 14 + Appendix
