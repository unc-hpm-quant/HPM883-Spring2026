# ============================================================================
# Problem Set 6: Data Generation Script
# Causal ML Integration - Both RCT and Observational Data
# ============================================================================

library(data.table)
set.seed(883006)

# ============================================================================
# TRUE PARAMETERS (same for both datasets)
# ============================================================================

TRUE_ATE <- 2.5

# CATE function (same as PS 3)
cate_function <- function(X1, X2, X3, X5) {
  2.5 + 0.1 * (X1 - 50) - 0.05 * (100 - X2) + 1.5 * (X3 >= 4) - 1.0 * (X5 == 3)
}

# ============================================================================
# GENERATE RCT DATA (N = 5,000 - same as PS 3)
# ============================================================================

N_rct <- 5000

rct <- data.table(
  X1 = round(runif(N_rct, 25, 75), 0),
  X2 = round(rbeta(N_rct, 5, 2) * 60 + 40, 0),
  X3 = pmin(5, pmax(1, round(3.5 + rnorm(N_rct, 0, 0.8))))
)
rct[, X4 := sample(1:5, N_rct, replace = TRUE)]
rct[, X5 := sample(1:3, N_rct, replace = TRUE, prob = c(0.4, 0.4, 0.2))]

# Add noise covariates
for (j in 6:20) {
  rct[, paste0("X", j) := round(rnorm(N_rct, 0, 1), 2)]
}

# Random treatment
rct[, W := rbinom(N_rct, 1, 0.5)]

# Generate outcomes
rct[, tau := cate_function(X1, X2, X3, X5)]
rct[, Y := 20 + 0.2*X1 + 0.3*X2 + tau*W + rnorm(N_rct, 0, 5)]
rct[, tau := NULL]  # Remove true CATE
rct[, data_source := "RCT"]

# ============================================================================
# GENERATE OBSERVATIONAL DATA (N = 50,000)
# ============================================================================

N_obs <- 50000

obs <- data.table(
  X1 = round(runif(N_obs, 25, 75), 0),
  X2 = round(rbeta(N_obs, 5, 2) * 60 + 40, 0),
  X3 = pmin(5, pmax(1, round(3.5 + rnorm(N_obs, 0, 0.8))))
)
obs[, X4 := sample(1:5, N_obs, replace = TRUE)]
obs[, X5 := sample(1:3, N_obs, replace = TRUE, prob = c(0.4, 0.4, 0.2))]

for (j in 6:20) {
  obs[, paste0("X", j) := round(rnorm(N_obs, 0, 1), 2)]
}

# Selection into treatment (confounded!)
obs[, propensity := plogis(-1 + 0.02*X1 + 0.03*X2 + 0.3*(X3-3) - 0.5*(X5==3))]
obs[, W := rbinom(N_obs, 1, propensity)]
obs[, propensity := NULL]

# Generate outcomes (same CATE function)
obs[, tau := cate_function(X1, X2, X3, X5)]
obs[, Y := 20 + 0.2*X1 + 0.3*X2 + tau*W + rnorm(N_obs, 0, 5)]
obs[, tau := NULL]
obs[, data_source := "Observational"]

# ============================================================================
# EXPORT
# ============================================================================

fwrite(rct[, -"data_source", with=FALSE], "../data/ps-6-rct.csv")
fwrite(obs[, -"data_source", with=FALSE], "../data/ps-6-observational.csv")

cat("PS 6 RCT data exported: N =", nrow(rct), "\n")
cat("PS 6 Observational data exported: N =", nrow(obs), "\n")
cat("True ATE:", TRUE_ATE, "\n")
cat("RCT treatment rate:", round(mean(rct$W), 3), "\n")
cat("Obs treatment rate:", round(mean(obs$W), 3), "\n")
cat("RCT naive ATE:", round(mean(rct[W==1]$Y) - mean(rct[W==0]$Y), 3), "\n")
cat("Obs naive ATE:", round(mean(obs[W==1]$Y) - mean(obs[W==0]$Y), 3), "(biased!)\n")

dgp <- '
# Problem Set 6: Data Generating Process

## True Parameters
- True ATE: 2.5
- Same CATE function as PS 3

## RCT Data (N = 5,000)
- Random 50/50 treatment
- Unbiased naive estimate

## Observational Data (N = 50,000)
- Confounded treatment selection
- Positive selection: older, healthier, higher tech literacy more likely to receive treatment
- Naive estimate biased upward

## Expected Results
- RCT ATE: ~2.5 (unbiased)
- Observational naive: ~3.0-3.5 (biased upward)
- Observational DML: ~2.4-2.6 (debiased)
- Estimates should agree after proper adjustment
'
writeLines(dgp, "ps-6-dgp.md")
