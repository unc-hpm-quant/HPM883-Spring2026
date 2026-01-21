# ============================================================================
# Problem Set 4: Data Generation Script
# Policy Learning (uses PS 3 data + adds CATE estimates)
# ============================================================================

library(data.table)
library(grf)
set.seed(883004)

# Load PS 3 data
app_data <- fread("../data/ps-3-app-rct.csv")

# Fit causal forest to get CATE estimates
X <- as.matrix(app_data[, paste0("X", 1:20), with = FALSE])
Y <- app_data$Y
W <- app_data$W

cf <- causal_forest(X, Y, W, num.trees = 2000)

# Add CATE estimates
app_data$tau_hat <- predict(cf)$predictions

# Export
fwrite(app_data, "../data/ps-4-policy-data.csv")

cat("PS 4 data exported with CATE estimates\n")
cat("True ATE from PS 3:", round(mean(Y[W==1]) - mean(Y[W==0]), 3), "\n")
cat("Forest ATE:", round(mean(app_data$tau_hat), 3), "\n")

# DGP doc
dgp <- '
# Problem Set 4: Data Generating Process

Uses PS 3 data with causal forest CATE estimates added.

## True Parameters (from PS 3)
- True ATE: ~2.5 days
- CATE varies by age, tech literacy, severity

## Added Variables
- tau_hat: Causal forest CATE predictions

## Expected Results
- Depth-2 tree should split on tech literacy and age/severity
- Policy value under 40% budget: ~4.0 (targeting high-CATE patients)
- Value of treat-all: ~2.5 (the ATE)
'
writeLines(dgp, "ps-4-dgp.md")
