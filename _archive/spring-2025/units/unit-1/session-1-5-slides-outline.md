# Session 5: Statistical Conclusion Validity & Power

**Date:** January 21, 2026
**Duration:** 75 minutes
**Format:** In-Person

---

## Slide Outline (Condensed from lec-1-2.qmd, 480 lines)

### Part 1: Statistical Conclusion Validity (~15 min)

**Slide 1: What is Statistical Conclusion Validity?**
- Can we trust our statistical conclusions?
- Sources of uncertainty: sampling, variance, measurement
- Link: Internal validity ≠ Statistical conclusion validity

**Slide 2: Data Strategy DAG**
```
[Include figure-8-1.svg from unit-1/media/]
```
- S (sampling), Z (assignment), Q (measurement)
- Researcher-controlled nodes vs endogenous variables
- Four exclusion restrictions

**Slide 3: Sampling Frameworks**
| Framework | What's Random? | Estimand |
|-----------|---------------|----------|
| Super-population | Sample + Assignment | E[Y(1) - Y(0)] |
| Finite-population | Assignment only | τ_fp = (1/N)Σ[Y_i(1) - Y_i(0)] |

- Super-population: generalizable inference
- Finite-population: internal validity focus

---

### Part 2: Hypothesis Testing & Power (~20 min)

**Slide 4: The Difference-in-Means Estimator**
$$\hat{\tau} = \bar{Y}_1 - \bar{Y}_0$$
- Unbiased under random assignment
- But: Point estimate ≠ Certainty

**Slide 5: Hypothesis Testing Framework**
- $H_0: \tau = 0$ (null hypothesis)
- $H_A: \tau \neq 0$ (alternative)
- Test statistic: $t = \frac{\hat{\tau}}{SE(\hat{\tau})}$

**Slide 6: Type I and Type II Errors**
```
[Include HypothesisTesting.png from unit-1/media/]
```
| Error | Definition | Probability |
|-------|------------|-------------|
| Type I | Reject true null | α (significance level) |
| Type II | Fail to reject false null | β |

**Slide 7: Statistical Power**
$$\text{Power} = 1 - \beta = P(\text{reject } H_0 \mid H_A \text{ true})$$

Factors affecting power:
- Effect size (τ): Larger → More power
- Sample size (N): Larger → More power
- Variance (σ²): Lower → More power
- Significance level (α): Higher → More power (but more Type I errors)

**Slide 8: Power Calculation by Simulation**
```r
# Simulate experiment 1,000 times
# Count rejections at α = 0.05
# Power = rejections / 1000
```
- Why simulation? Handles complex designs
- Preview: DeclareDesign makes this systematic

---

### Part 3: The MIDA Framework (~15 min)

**Slide 9: Research Design as a System**
```
[Include MIDA.svg from unit-1/media/]
```
- M: Model (data generating process)
- I: Inquiry (estimand)
- D: Data strategy (sampling, assignment, measurement)
- A: Answer strategy (estimator)

**Slide 10: Elements of Research Design**
```
[Include RDElements.png from unit-1/media/]
```
- Theoretical: Model + Inquiry
- Empirical: Data strategy + Answer strategy
- Design connects theory to evidence

**Slide 11: Diagnosing Designs with Simulation**
```
[Include MIDA-Simulation.svg from unit-1/media/]
```
Key diagnosands:
- **Bias**: E[â] - τ
- **Variance**: Var(â)
- **Power**: P(reject H₀ | H₁ true)
- **Coverage**: P(CI contains τ)

**Slide 12: DeclareDesign Introduction**
```r
library(DeclareDesign)

design <-
  declare_model(N = 100, U = rnorm(N),
                Y_0 = U, Y_1 = Y_0 + 0.5) +
  declare_inquiry(ATE = mean(Y_1 - Y_0)) +
  declare_assignment(Z = complete_ra(N)) +
  declare_measurement(Y = if_else(Z == 1, Y_1, Y_0)) +
  declare_estimator(Y ~ Z, inquiry = "ATE")

diagnose_design(design)
```

---

### Part 4: Variance Reduction with Lin (2013) (~10 min)

**Slide 13: Why Adjust for Covariates?**
- Pre-treatment covariates explain outcome variance
- Lower variance → More power → Lower MDE
- But: Must adjust correctly!

**Slide 14: Lin (2013) Regression Adjustment**
The right way to adjust:
$$Y_i = \alpha + \tau D_i + \beta(X_i - \bar{X}) + \gamma D_i(X_i - \bar{X}) + \epsilon_i$$

Key insight: Center covariates, include interactions with treatment

**Slide 15: Why Lin (2013) Works**
- Center covariates: $(X_i - \bar{X})$
- Include treatment × covariate interaction
- Result: Guaranteed variance reduction (never hurts!)
- Valid inference without assuming linear model

---

### Part 5: Multiple Testing (~15 min)

**Slide 16: The Multiple Testing Problem**
- Testing k hypotheses at α = 0.05 each
- FWER = 1 - (1 - α)^k
- 5 tests → 23% chance of at least one false positive
- 20 tests → 64% chance!

**Slide 17: Correction Methods**
| Method | Approach | Trade-off |
|--------|----------|-----------|
| Bonferroni | α* = α/k | Simple but conservative |
| Holm | Sequential adjustment | Better power |
| FDR (Benjamini-Hochberg) | Control false discovery rate | Best for many tests |

**Slide 18: Pre-registration & Primary Outcomes**
- Specify primary outcome(s) in advance
- Distinguish exploratory vs. confirmatory
- Register analysis plan before data collection

---

## Live Coding (~10 min)

**Demo: Power Simulation with DeclareDesign**
- Declare a simple RCT design
- Diagnose: Check bias, power, coverage
- Redesign: Vary sample size, see power curves

---

## Source Content Mapping

| 2026 Slide | Source from lec-1-2.qmd |
|------------|-------------------------|
| 1-3 | Lines 27-163 (SCV, sampling frameworks) |
| 4-8 | Lines 164-332 (hypothesis testing, power) |
| 9-12 | Lines 334-376 (MIDA framework) |
| 13-15 | NEW (Lin 2013 - not fully in lec-1-2) |
| 16-18 | Lines 377-476 (multiple testing) |

---

## Content to Add/Update

1. **Lin (2013) slides** — Expand from brief mention in lec-1-2.qmd
2. **DeclareDesign live coding** — Create demo script
3. **Pre-registration slide** — Add practical guidance

## Content to Keep

1. All existing diagrams (MIDA.svg, HypothesisTesting.png, etc.)
2. Power simulation code examples
3. Multiple testing examples

## Content for Readings/Lab

- Detailed derivations of SE formulas → Readings (Chernozhukov Ch 3)
- Extended simulation examples → Lab 1
- FWER correction code → Lab 1 appendix
