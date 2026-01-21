# ============================================================================
# Problem Set 3: Data Generation Script
# Causal Forests & Heterogeneous Treatment Effects
# HPM 883: Advanced Quantitative Methods
# ============================================================================

library(data.table)
library(MASS)
set.seed(883003)

# ============================================================================
# TRUE PARAMETERS (for instructor validation)
# ============================================================================

N <- 5000

# TRUE CATE FUNCTION:
# tau(X) = 2.5 + 0.1*(age - 50) - 0.05*(100 - health_score) + 1.5*I(tech_lit >= 4)
#          - 1.0*I(severity == 3) + 0.02*age*tech_lit
#
# This creates heterogeneity driven by:
# - Age (positive effect increases with age)
# - Baseline health (positive effect when healthier)
# - Tech literacy (large positive effect for high tech literacy)
# - Severity (negative effect for severe cases)
# - Age × Tech literacy interaction

TRUE_ATE <- 2.5  # Average effect
TRUE_CATE_FORMULA <- "tau(X) = 2.5 + 0.1*(age-50) - 0.05*(100-health) + 1.5*I(tech>=4) - 1.0*I(sev==3) + 0.02*age*tech"

# ============================================================================
# GENERATE COVARIATES
# ============================================================================

# X1: Age (25-75, roughly uniform)
X1 <- round(runif(N, 25, 75), 0)

# X2: Baseline health score (40-100, skewed toward healthy)
X2 <- round(rbeta(N, 5, 2) * 60 + 40, 0)

# X3: Tech literacy (1-5, correlated with age negatively)
X3_latent <- 3.5 - 0.02 * (X1 - 50) + rnorm(N, 0, 0.8)
X3 <- pmin(5, pmax(1, round(X3_latent)))

# X4: Social support (1-5, roughly uniform)
X4 <- sample(1:5, N, replace = TRUE, prob = c(0.1, 0.2, 0.35, 0.25, 0.1))

# X5: Disease severity (1, 2, 3)
X5 <- sample(1:3, N, replace = TRUE, prob = c(0.4, 0.4, 0.2))

# X6-X10: Continuous confounders (not effect moderators)
X6 <- rnorm(N, 0, 1)
X7 <- rnorm(N, 0, 1)
X8 <- rnorm(N, 0, 1)
X9 <- 0.3 * X6 + rnorm(N, 0, 0.9)
X10 <- -0.2 * X7 + rnorm(N, 0, 0.95)

# X11-X15: Binary indicators (some spurious)
X11 <- rbinom(N, 1, 0.3)
X12 <- rbinom(N, 1, 0.5)
X13 <- rbinom(N, 1, 0.4)
X14 <- rbinom(N, 1, 0.25)
X15 <- rbinom(N, 1, 0.6)

# X16-X20: Ordinal (1-5, some spurious)
X16 <- sample(1:5, N, replace = TRUE)
X17 <- sample(1:5, N, replace = TRUE)
X18 <- sample(1:5, N, replace = TRUE)
X19 <- sample(1:5, N, replace = TRUE)
X20 <- sample(1:5, N, replace = TRUE)

# ============================================================================
# GENERATE TREATMENT (RCT - 50/50 randomization)
# ============================================================================

W <- rbinom(N, 1, 0.5)
cat("Treatment rate:", round(mean(W), 3), "\n")

# ============================================================================
# GENERATE TRUE CATE AND POTENTIAL OUTCOMES
# ============================================================================

# True CATE function
tau_true <- 2.5 +
            0.1 * (X1 - 50) +
            -0.05 * (100 - X2) +
            1.5 * (X3 >= 4) +
            -1.0 * (X5 == 3) +
            0.02 * X1 * X3 / 5  # Scaled interaction

# Baseline outcome (control potential outcome)
mu0 <- 20 +
       0.2 * X1 +
       0.3 * X2 +
       0.5 * X4 +
       -3 * (X5 == 2) - 6 * (X5 == 3) +
       0.5 * X6 + 0.3 * X7 +
       2 * X11 + 1 * X12

# Add noise
epsilon <- rnorm(N, 0, 5)

# Potential outcomes
Y0 <- mu0 + epsilon
Y1 <- mu0 + tau_true + epsilon

# Observed outcome
Y <- W * Y1 + (1 - W) * Y0

# Verify
cat("True ATE:", round(mean(tau_true), 3), "\n")
cat("Observed ATE:", round(mean(Y[W == 1]) - mean(Y[W == 0]), 3), "\n")
cat("CATE range:", round(min(tau_true), 3), "-", round(max(tau_true), 3), "\n")
cat("CATE SD:", round(sd(tau_true), 3), "\n")

# ============================================================================
# CREATE FINAL DATASET
# ============================================================================

data <- data.table(
  Y = round(Y, 2),
  W = W,
  X1 = X1, X2 = X2, X3 = X3, X4 = X4, X5 = X5,
  X6 = round(X6, 3), X7 = round(X7, 3), X8 = round(X8, 3),
  X9 = round(X9, 3), X10 = round(X10, 3),
  X11 = X11, X12 = X12, X13 = X13, X14 = X14, X15 = X15,
  X16 = X16, X17 = X17, X18 = X18, X19 = X19, X20 = X20
)

# Save true CATE for validation (instructor only)
data_instructor <- copy(data)
data_instructor[, tau_true := round(tau_true, 3)]

# ============================================================================
# EXPORT DATA
# ============================================================================

fwrite(data, "../data/ps-3-app-rct.csv")
fwrite(data_instructor, "../data/ps-3-app-rct-with-truth.csv")  # Instructor only

cat("\nData exported to data/ps-3-app-rct.csv\n")
cat("N:", N, "\n")

# ============================================================================
# DGP DOCUMENTATION
# ============================================================================

dgp_doc <- '
# Problem Set 3: Data Generating Process

## True Parameters

| Parameter | Value |
|-----------|-------|
| N | 5,000 |
| True ATE | 2.5 days |
| Design | Individual RCT (50/50) |
| CATE SD | ~2.0 days |

## True CATE Function

tau(X) = 2.5 + 0.1*(age - 50) - 0.05*(100 - health) + 1.5*I(tech >= 4) - 1.0*I(severity == 3) + 0.02*age*tech/5

Effect moderators:
1. **X1 (Age)**: Older patients benefit more (+0.1 per year above 50)
2. **X2 (Health)**: Healthier patients benefit more (-0.05 per point below 100)
3. **X3 (Tech literacy)**: High tech literacy (4-5) adds +1.5 days
4. **X5 (Severity)**: Severe cases (3) lose 1.0 days of benefit
5. **Age × Tech interaction**: Small positive interaction

Non-moderators (included to test variable importance):
- X4 (Social support): In outcome model but NOT in CATE
- X6-X10: Continuous noise
- X11-X15: Binary noise (X11, X12 in outcome model)
- X16-X20: Ordinal noise

## Outcome Model

Y(0) = 20 + 0.2*age + 0.3*health + 0.5*social - 3*I(sev==2) - 6*I(sev==3) + 0.5*X6 + 0.3*X7 + 2*X11 + X12 + epsilon

epsilon ~ N(0, 5^2)

## Expected Variable Importance

Top 5 should be: X1 (age), X3 (tech), X2 (health), X5 (severity), and possibly their interactions.
X4, X6-X20 should have low importance.

## Expected Results

- Causal forest ATE: ~2.4-2.6
- CATE distribution: Unimodal, range roughly [-1, 7]
- High tech literacy subgroup: ATE ~4.0
- Severe cases subgroup: ATE ~1.5
- BLP test should show significant heterogeneity (beta2 > 0)

## Subgroup True Effects

- Young (<40): ATE ≈ 1.5
- Middle (40-60): ATE ≈ 2.5
- Older (>60): ATE ≈ 3.5
- Mild severity: ATE ≈ 2.8
- Moderate severity: ATE ≈ 2.8
- Severe severity: ATE ≈ 1.5
- Low tech (1-2): ATE ≈ 1.5
- High tech (4-5): ATE ≈ 4.0
'

writeLines(dgp_doc, "../data-generation/ps-3-dgp.md")
cat("\nDGP documentation written to data-generation/ps-3-dgp.md\n")
