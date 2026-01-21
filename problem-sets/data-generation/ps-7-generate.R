# ============================================================================
# Problem Set 7: Data Generation Script
# Advanced Topics - Three Options
# ============================================================================

library(data.table)
set.seed(883007)

# ============================================================================
# OPTION A: NETWORK INTERFERENCE
# ============================================================================

N_units <- 50
N_per_unit <- 40
N_A <- N_units * N_per_unit

network_data <- data.table(
  unit_id = rep(1:N_units, each = N_per_unit),
  id = 1:N_A
)

# Randomize treatment at unit level (cluster RCT with varying saturation)
unit_saturation <- data.table(
  unit_id = 1:N_units,
  saturation = sample(c(0, 0.25, 0.5, 0.75, 1), N_units, replace = TRUE,
                      prob = c(0.2, 0.2, 0.2, 0.2, 0.2))
)
network_data <- merge(network_data, unit_saturation, by = "unit_id")

# Assign individual treatment based on unit saturation
network_data[, W := rbinom(.N, 1, saturation)]
network_data[, unit_treated_frac := mean(W), by = unit_id]

# Covariates
network_data[, X1 := rnorm(.N)]
network_data[, X2 := rnorm(.N)]

# Outcomes with spillover
DIRECT_EFFECT <- 2.0
SPILLOVER_EFFECT <- 1.0
network_data[, Y := 10 + DIRECT_EFFECT * W + SPILLOVER_EFFECT * (unit_treated_frac - W/(N_per_unit)) +
               0.5 * X1 + rnorm(.N, 0, 2)]

fwrite(network_data[, .(id, unit_id, Y, W, unit_treated_frac, X1, X2)],
       "../data/ps-7-network.csv")

# ============================================================================
# OPTION B: INSTRUMENTAL VARIABLES
# ============================================================================

N_B <- 10000

iv_data <- data.table(
  # Distance to specialist (instrument)
  Z1 = rexp(N_B, 0.05),  # Miles
  Z2 = rnorm(N_B),       # Local capacity
  Z3 = rnorm(N_B),       # Weak instrument
  Z4 = rnorm(N_B),       # Weak instrument
  Z5 = rnorm(N_B)        # Irrelevant
)

# Covariates
for (j in 1:30) {
  iv_data[, paste0("X", j) := rnorm(N_B)]
}

# Unobserved confounder
iv_data[, U := rnorm(N_B)]

# Treatment (endogenous)
iv_data[, D_star := -0.03 * Z1 + 0.2 * Z2 + 0.05 * Z3 + 0.3 * X1 + 0.5 * U + rnorm(N_B)]
iv_data[, D := as.integer(D_star > 0)]

# Outcome
TRUE_LATE <- 5.0
iv_data[, Y := 20 + TRUE_LATE * D + 0.3 * X1 + 0.2 * X2 + 0.8 * U + rnorm(N_B, 0, 3)]

iv_data[, c("D_star", "U") := NULL]
fwrite(iv_data, "../data/ps-7-iv.csv")

# ============================================================================
# OPTION C: TRANSPORTABILITY
# ============================================================================

N_rct_C <- 3000
N_target <- 10000

# RCT (source) - urban hospital
rct_transport <- data.table(
  X1 = rnorm(N_rct_C, 50, 10),  # Age - younger in urban
  X2 = rnorm(N_rct_C, 70, 15),  # Health score - healthier urban
  X3 = sample(1:5, N_rct_C, replace = TRUE, prob = c(0.05, 0.1, 0.3, 0.35, 0.2)),  # Higher tech
  S = 1  # In RCT
)

# Random treatment in RCT
rct_transport[, W := rbinom(.N, 1, 0.5)]

# CATE depends on tech literacy
rct_transport[, tau := 2 + 1.5 * (X3 >= 4)]
rct_transport[, Y := 20 + 0.2 * X1 + 0.3 * X2 + tau * W + rnorm(.N, 0, 5)]
rct_transport[, tau := NULL]

# Target population - rural affiliates (different covariate distribution)
target_transport <- data.table(
  X1 = rnorm(N_target, 55, 12),   # Older rural
  X2 = rnorm(N_target, 60, 18),   # Less healthy rural
  X3 = sample(1:5, N_target, replace = TRUE, prob = c(0.2, 0.25, 0.35, 0.15, 0.05)),  # Lower tech
  S = 0,  # Not in RCT
  W = NA_integer_,
  Y = NA_real_
)

fwrite(rct_transport[, .(X1 = round(X1, 1), X2 = round(X2, 1), X3, W, Y = round(Y, 2))],
       "../data/ps-7-transport-rct.csv")
fwrite(target_transport[, .(X1 = round(X1, 1), X2 = round(X2, 1), X3)],
       "../data/ps-7-transport-target.csv")

cat("\nPS 7 data exported:\n")
cat("Option A (Network): N =", nrow(network_data), "\n")
cat("Option B (IV): N =", N_B, "\n")
cat("Option C (Transport): RCT =", N_rct_C, ", Target =", N_target, "\n")

dgp <- '
# Problem Set 7: Data Generating Process

## Option A: Network Interference
- Direct effect: 2.0
- Spillover effect: 1.0
- Cluster RCT with varying saturation (0%, 25%, 50%, 75%, 100%)
- Expected: Naive estimate ignoring spillover is biased

## Option B: IV
- True LATE: 5.0
- Strong instruments: Z1 (distance), Z2 (capacity)
- Weak instruments: Z3, Z4
- Irrelevant: Z5
- Confounding from U
- Expected: OLS biased upward, 2SLS/Lasso-IV ~5.0

## Option C: Transportability
- True SATE: ~2.75 (source population higher tech literacy)
- True PATE: ~2.25 (target population lower tech literacy)
- Expected: IPSW should adjust for covariate shift
'
writeLines(dgp, "ps-7-dgp.md")
