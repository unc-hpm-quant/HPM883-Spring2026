# ============================================================================
# Problem Set 2: Data Generation Script
# Double Machine Learning
# HPM 883: Advanced Quantitative Methods
# ============================================================================

# Purpose: Generate semi-synthetic Medicaid expansion data
# DGP is fully documented for instructor validation

library(data.table)
library(MASS)  # for mvrnorm
set.seed(883002)

# ============================================================================
# TRUE PARAMETERS (for instructor validation)
# ============================================================================

# Sample size
N <- 10000

# Treatment effect
TRUE_ATE <- 0.6  # 0.6 additional hospital visits from Medicaid enrollment

# Outcome model parameters
OUTCOME_INTERCEPT <- 2.0
OUTCOME_NONLINEAR <- TRUE  # Include nonlinear terms

# Propensity model parameters
PROPENSITY_INTERCEPT <- -0.5  # Approximately 35% treatment rate

# ============================================================================
# GENERATE COVARIATES
# ============================================================================

# Generate 50 covariates with some correlation structure
# First 20: Continuous (demographics, health measures)
# Next 15: Binary (health conditions)
# Last 15: Ordinal/categorical (SES indicators)

# Correlation matrix for continuous variables
p_cont <- 20
Sigma_cont <- diag(p_cont)
# Add some correlation between related variables
for (i in 1:(p_cont-1)) {
  for (j in (i+1):p_cont) {
    if (abs(i - j) <= 2) {
      Sigma_cont[i, j] <- 0.3
      Sigma_cont[j, i] <- 0.3
    }
  }
}

# Generate continuous covariates
X_cont <- mvrnorm(N, mu = rep(0, p_cont), Sigma = Sigma_cont)
colnames(X_cont) <- paste0("X", 1:p_cont)

# Generate binary covariates (health conditions)
p_bin <- 15
X_bin <- matrix(nrow = N, ncol = p_bin)
prevalences <- runif(p_bin, 0.05, 0.3)  # Different prevalences
for (j in 1:p_bin) {
  # Make some conditions correlated with continuous vars
  logit_p <- -2 + 0.3 * X_cont[, min(j, p_cont)] + rnorm(N, 0, 0.5)
  X_bin[, j] <- rbinom(N, 1, plogis(logit_p))
}
colnames(X_bin) <- paste0("X", (p_cont + 1):(p_cont + p_bin))

# Generate ordinal covariates (SES indicators, 1-5 scale)
p_ord <- 15
X_ord <- matrix(nrow = N, ncol = p_ord)
for (j in 1:p_ord) {
  # Correlated with first continuous variable (proxy for SES)
  latent <- X_cont[, 1] * 0.5 + rnorm(N, 0, 1)
  X_ord[, j] <- cut(latent, breaks = c(-Inf, -1.5, -0.5, 0.5, 1.5, Inf),
                    labels = FALSE)
}
colnames(X_ord) <- paste0("X", (p_cont + p_bin + 1):50)

# Combine all covariates
X <- cbind(X_cont, X_bin, X_ord)

# ============================================================================
# GENERATE TREATMENT (PROPENSITY MODEL)
# ============================================================================

# Propensity model: depends on subset of X with some nonlinearity
# Use first 10 continuous vars, first 5 binary vars
propensity_logit <- PROPENSITY_INTERCEPT +
  0.3 * X[, 1] - 0.2 * X[, 2] + 0.15 * X[, 3] +  # Continuous
  0.1 * X[, 4] - 0.1 * X[, 5] + 0.2 * X[, 6] +
  0.05 * X[, 7]^2 +  # Nonlinear term
  0.4 * X[, 21] + 0.3 * X[, 22] - 0.2 * X[, 23] +  # Binary
  0.1 * X[, 24] + 0.15 * X[, 25] +
  0.1 * X[, 1] * X[, 21]  # Interaction

true_propensity <- plogis(propensity_logit)

# Ensure some overlap issues (but not extreme)
# Clip propensity to avoid perfect separation
true_propensity <- pmax(0.02, pmin(0.98, true_propensity))

# Generate treatment
D <- rbinom(N, 1, true_propensity)

cat("Treatment rate:", round(mean(D), 3), "\n")
cat("Propensity range:", round(min(true_propensity), 3), "-",
    round(max(true_propensity), 3), "\n")

# ============================================================================
# GENERATE POTENTIAL OUTCOMES
# ============================================================================

# Outcome model: hospital visits (count, but treated as continuous for simplicity)
# Include treatment effect heterogeneity

# Baseline outcome model (control potential outcome)
outcome_control <- OUTCOME_INTERCEPT +
  0.5 * X[, 1] + 0.3 * X[, 2] - 0.2 * X[, 3] +
  0.15 * X[, 4] + 0.1 * X[, 5] +
  0.2 * X[, 1]^2 +  # Nonlinear
  0.8 * X[, 21] + 0.6 * X[, 22] + 0.5 * X[, 23] +  # Binary (health conditions)
  0.3 * X[, 24] + 0.4 * X[, 25] +
  0.15 * X[, 36] + 0.1 * X[, 37]  # Ordinal (SES)

# Add some noise
noise <- rnorm(N, 0, 1.5)

# Potential outcomes (constant treatment effect for simplicity)
Y0 <- outcome_control + noise
Y1 <- outcome_control + TRUE_ATE + noise

# Ensure non-negative (hospital visits)
Y0 <- pmax(0, Y0)
Y1 <- pmax(0, Y1)

# Observed outcome
Y <- D * Y1 + (1 - D) * Y0

# Generate pre-treatment outcome (correlated with post-treatment)
Y_pre <- 0.6 * outcome_control + rnorm(N, 0, 1)
Y_pre <- pmax(0, Y_pre)

cat("Mean Y (control):", round(mean(Y[D == 0]), 3), "\n")
cat("Mean Y (treatment):", round(mean(Y[D == 1]), 3), "\n")
cat("Naive difference:", round(mean(Y[D == 1]) - mean(Y[D == 0]), 3), "\n")
cat("True ATE:", TRUE_ATE, "\n")

# ============================================================================
# CREATE FINAL DATASET
# ============================================================================

data <- data.table(
  Y = round(Y, 2),
  D = D,
  Y_pre = round(Y_pre, 2)
)

# Add covariates
for (j in 1:50) {
  data[, paste0("X", j) := round(X[, j], 3)]
}

# ============================================================================
# EXPORT DATA
# ============================================================================

fwrite(data, "../data/ps-2-medicaid.csv")

cat("\nData exported to data/ps-2-medicaid.csv\n")
cat("N:", N, "\n")
cat("Treatment rate:", round(mean(D), 3), "\n")
cat("Naive ATE:", round(mean(Y[D == 1]) - mean(Y[D == 0]), 3), "\n")
cat("True ATE:", TRUE_ATE, "\n")

# ============================================================================
# DGP DOCUMENTATION
# ============================================================================

dgp_doc <- '
# Problem Set 2: Data Generating Process

## True Parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| True ATE | 0.6 | Additional hospital visits from Medicaid |
| Sample size | 10,000 | |
| Treatment rate | ~35% | |
| Confounders | 50 | 20 continuous + 15 binary + 15 ordinal |

## Propensity Model

logit(P(D=1|X)) = -0.5 + 0.3*X1 - 0.2*X2 + 0.15*X3 + 0.1*X4 - 0.1*X5 + 0.2*X6
                 + 0.05*X7^2 + 0.4*X21 + 0.3*X22 - 0.2*X23 + 0.1*X24 + 0.15*X25
                 + 0.1*X1*X21

Propensity includes:
- Linear terms (X1-X6)
- Quadratic term (X7^2)
- Binary indicators (X21-X25)
- Interaction (X1*X21)

## Outcome Model

Y(0) = 2.0 + 0.5*X1 + 0.3*X2 - 0.2*X3 + 0.15*X4 + 0.1*X5
       + 0.2*X1^2 + 0.8*X21 + 0.6*X22 + 0.5*X23 + 0.3*X24 + 0.4*X25
       + 0.15*X36 + 0.1*X37 + epsilon

Y(1) = Y(0) + 0.6 (constant treatment effect)

epsilon ~ N(0, 1.5^2)

## Covariate Structure

- X1-X20: Continuous, correlated (r ≈ 0.3 for adjacent)
- X21-X35: Binary health conditions (5-30% prevalence)
- X36-X50: Ordinal SES indicators (1-5 scale)

## Key Features

1. **Confounding**: Treatment depends on X1-X6, X21-X25; outcome depends on overlapping set
2. **Nonlinearity**: Both models include X^2 and interaction terms
3. **Moderate overlap**: Propensity bounded [0.02, 0.98]
4. **Pre-treatment outcome**: Y_pre correlated with Y for covariate adjustment

## Expected Results

- Naive difference-in-means: ~0.75-0.85 (biased upward due to positive confounding)
- DML with Lasso: ~0.55-0.65
- DML with RF/XGBoost: ~0.58-0.65 (may capture nonlinearity better)
- True ATE: 0.6

## Validation

Students should find:
- DML estimates close to 0.6
- Random Forest/XGBoost may slightly outperform Lasso due to nonlinearity
- Some overlap issues in propensity tails
- Trimming removes ~2-5% of observations
'

writeLines(dgp_doc, "../data-generation/ps-2-dgp.md")
cat("\nDGP documentation written to data-generation/ps-2-dgp.md\n")
