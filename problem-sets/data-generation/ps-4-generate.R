# ============================================================================
# Problem Set 4: Data Generation Script
# Policy Learning — Standalone DGP
# HPM 883: Advanced Quantitative Methods
# ============================================================================

library(data.table)
library(grf)
set.seed(883004)

N <- 5000

# ============================================================================
# GENERATE COVARIATES (same distributions as PS 3)
# ============================================================================

X1 <- round(runif(N, 25, 75), 0)                          # Age
X2 <- round(rbeta(N, 5, 2) * 60 + 40, 0)                  # Health score
X3_latent <- 3.5 - 0.02 * (X1 - 50) + rnorm(N, 0, 0.8)
X3 <- pmin(5, pmax(1, round(X3_latent)))                   # Tech literacy
X4 <- sample(1:5, N, replace = TRUE,
             prob = c(0.1, 0.2, 0.35, 0.25, 0.1))          # Social support
X5 <- sample(1:3, N, replace = TRUE,
             prob = c(0.4, 0.4, 0.2))                       # Severity

# Continuous noise
X6  <- rnorm(N, 0, 1)
X7  <- rnorm(N, 0, 1)
X8  <- rnorm(N, 0, 1)
X9  <- 0.3 * X6 + rnorm(N, 0, 0.9)
X10 <- -0.2 * X7 + rnorm(N, 0, 0.95)

# Binary noise
X11 <- rbinom(N, 1, 0.3)
X12 <- rbinom(N, 1, 0.5)
X13 <- rbinom(N, 1, 0.4)
X14 <- rbinom(N, 1, 0.25)
X15 <- rbinom(N, 1, 0.6)

# Ordinal noise
X16 <- sample(1:5, N, replace = TRUE)
X17 <- sample(1:5, N, replace = TRUE)
X18 <- sample(1:5, N, replace = TRUE)
X19 <- sample(1:5, N, replace = TRUE)
X20 <- sample(1:5, N, replace = TRUE)

# ============================================================================
# TREATMENT (RCT — 50/50)
# ============================================================================

W <- rbinom(N, 1, 0.5)

# ============================================================================
# TRUE CATE — designed so ~25-30% of patients have negative effects
#
# tau(X) = 0.5 + 0.05*(age - 50)
#              - 0.03*(100 - health)
#              + 1.2*I(tech >= 4)
#              - 2.0*I(severity == 3)
#              - 0.8*I(severity == 2 & tech <= 2)
#
# Key subgroups:
#   - High-tech, non-severe: large positive (~1.7+)
#   - Severe + low-tech: negative (~-2.3)
#   - Moderate severity + low-tech: near zero (~-0.3)
# ============================================================================

tau_true <- 0.5 +
  0.05 * (X1 - 50) +
  -0.03 * (100 - X2) +
  1.2 * (X3 >= 4) +
  -2.0 * (X5 == 3) +
  -0.8 * (X5 == 2 & X3 <= 2)

cat("True ATE:", round(mean(tau_true), 3), "\n")
cat("True CATE range:", round(min(tau_true), 3), "to", round(max(tau_true), 3), "\n")
cat("Fraction with negative CATE:", round(mean(tau_true < 0), 3), "\n")

# ============================================================================
# POTENTIAL OUTCOMES
# ============================================================================

mu0 <- 20 +
  0.2 * X1 +
  0.3 * X2 +
  0.5 * X4 +
  -3 * (X5 == 2) - 6 * (X5 == 3) +
  0.5 * X6 + 0.3 * X7 +
  2 * X11 + X12

epsilon <- rnorm(N, 0, 5)
Y0 <- mu0 + epsilon
Y1 <- mu0 + tau_true + epsilon
Y  <- W * Y1 + (1 - W) * Y0

# ============================================================================
# FIT CAUSAL FOREST AND EXTRACT tau_hat
# ============================================================================

X <- cbind(X1, X2, X3, X4, X5, X6, X7, X8, X9, X10,
           X11, X12, X13, X14, X15, X16, X17, X18, X19, X20)

cf <- causal_forest(X, Y, W, W.hat = 0.5, num.trees = 2000, seed = 883)
tau_hat <- predict(cf)$predictions

cat("\nForest ATE:", round(mean(tau_hat), 3), "\n")
cat("tau_hat range:", round(min(tau_hat), 3), "to", round(max(tau_hat), 3), "\n")
cat("Fraction tau_hat < 0:", round(mean(tau_hat < 0), 3), "\n")
cat("Cor(tau_hat, tau_true):", round(cor(tau_hat, tau_true), 3), "\n")

# ============================================================================
# EXPORT
# ============================================================================

data <- data.table(
  Y = round(Y, 2),
  W = W,
  X1 = X1, X2 = X2, X3 = X3, X4 = X4, X5 = X5,
  X6 = round(X6, 3), X7 = round(X7, 3), X8 = round(X8, 3),
  X9 = round(X9, 3), X10 = round(X10, 3),
  X11 = X11, X12 = X12, X13 = X13, X14 = X14, X15 = X15,
  X16 = X16, X17 = X17, X18 = X18, X19 = X19, X20 = X20,
  tau_hat = round(tau_hat, 4)
)

fwrite(data, "../data/ps-4-policy-data.csv")
cat("\nPS 4 data exported:", N, "rows,", ncol(data), "columns\n")
