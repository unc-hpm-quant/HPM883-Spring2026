# ============================================================================
# Problem Set 1: Data Generation Script
# Experimental Design & Power
# HPM 883: Advanced Quantitative Methods
# ============================================================================

# Purpose: Generate baseline clinic-level data for PS 1
# DGP is fully documented for instructor validation

library(data.table)
set.seed(883001)  # Reproducible for course

# ============================================================================
# TRUE PARAMETERS (for instructor validation)
# ============================================================================

# Treatment effect
TRUE_ATE <- -0.5  # 0.5% reduction in HbA1c

# Variance components
BETWEEN_CLINIC_SD <- 0.5   # SD of clinic-level effects
WITHIN_CLINIC_SD <- 1.0    # SD of individual-level noise
TRUE_ICC <- BETWEEN_CLINIC_SD^2 / (BETWEEN_CLINIC_SD^2 + WITHIN_CLINIC_SD^2)
# TRUE_ICC = 0.25 / (0.25 + 1.0) = 0.20

# Baseline parameters
BASELINE_HBA1C_MEAN <- 8.5
BASELINE_HBA1C_SD <- 1.2

# ============================================================================
# GENERATE CLINIC-LEVEL DATA
# ============================================================================

n_clinics <- 30

clinic_data <- data.table(
  clinic_id = 1:n_clinics,

  # Number of eligible patients (varies by clinic size)
  n_eligible = round(runif(n_clinics, 15, 45)),

  # Clinic-level mean HbA1c (some clinics have sicker populations)
  clinic_effect = rnorm(n_clinics, mean = 0, sd = BETWEEN_CLINIC_SD)
)

# Generate observable clinic characteristics (correlated with clinic effects)
# Step 1: Generate urban status first
clinic_data[, urban := rbinom(.N, 1, prob = 0.6)]

# Step 2: Generate other characteristics
clinic_data[, `:=`(
  # Medicare percentage (correlated with severity)
  pct_medicare = round(pnorm(clinic_effect/BETWEEN_CLINIC_SD) * 30 +
                        runif(.N, 10, 30), 1),

  # Observable mean HbA1c (includes clinic effect + urban adjustment)
  mean_hba1c = round(BASELINE_HBA1C_MEAN + clinic_effect +
                       ifelse(urban == 0, 0.2, 0), 2),

  # Within-clinic SD (fairly stable across clinics)
  sd_hba1c = round(WITHIN_CLINIC_SD + rnorm(.N, 0, 0.15), 2)
)]

# Ensure reasonable bounds
clinic_data[, mean_hba1c := pmax(7.5, pmin(10.0, mean_hba1c))]
clinic_data[, sd_hba1c := pmax(0.7, pmin(1.4, sd_hba1c))]
clinic_data[, pct_medicare := pmax(10, pmin(60, pct_medicare))]

# Remove internal clinic_effect column before export
clinic_data[, clinic_effect := NULL]

# ============================================================================
# EXPORT DATA
# ============================================================================

# Create data directory if needed
dir.create("../data", showWarnings = FALSE)

# Export clinic data
fwrite(clinic_data, "../data/ps-1-clinic-data.csv")

cat("Clinic data exported to data/ps-1-clinic-data.csv\n")
cat("N clinics:", n_clinics, "\n")
cat("Mean eligible patients:", round(mean(clinic_data$n_eligible), 1), "\n")
cat("Urban clinics:", sum(clinic_data$urban), "\n")

# ============================================================================
# DGP DOCUMENTATION
# ============================================================================

dgp_doc <- '
# Problem Set 1: Data Generating Process

## True Parameters

| Parameter | Symbol | Value | Notes |
|-----------|--------|-------|-------|
| True ATE | tau | -0.5 | 0.5% HbA1c reduction |
| Between-clinic SD | sigma_b | 0.5 | |
| Within-clinic SD | sigma_w | 1.0 | |
| True ICC | rho | 0.20 | sigma_b^2 / (sigma_b^2 + sigma_w^2) |
| Baseline HbA1c mean | mu | 8.5 | |
| Baseline HbA1c SD | sigma | 1.2 | Total SD (not used in DGP) |

## Outcome Model

For patient i in clinic j:

Y_ij(0) = 8.5 + gamma_j + epsilon_ij
Y_ij(1) = 8.5 + tau + gamma_j + epsilon_ij

Where:
- gamma_j ~ N(0, 0.5^2) is clinic random effect
- epsilon_ij ~ N(0, 1.0^2) is individual noise
- tau = -0.5 is the constant treatment effect (no heterogeneity)

## Assumptions Satisfied

- [x] SUTVA: No interference between clinics
- [x] Constant treatment effect (no HTE)
- [x] Exchangeability within treatment arms
- [x] All variance from clinic + individual components

## Clinic Characteristics

Observable clinic characteristics are:
- urban: Binary, ~60% urban
- pct_medicare: 10-60%, weakly correlated with clinic severity
- mean_hba1c: 7.5-10.0, includes clinic effect
- sd_hba1c: 0.7-1.4, approximately 1.0 on average

## Budget Parameters (for Task 4)

- Budget: $150,000
- Cost per patient: $500
- Clinic startup cost: $2,000
- Constraint: 2000*K + 500*K*m <= 150000
  where K = clinics, m = patients per clinic

## Validation

Students should find:
- With 20 clinics, 20 patients/clinic, ICC=0.20:
  - Unadjusted power: ~65-70%
  - Lin-adjusted power: ~75-80%
- Power drops below 80% around ICC=0.12-0.15 (unadjusted)
- Optimal allocation under budget: ~22 clinics, ~20 patients/clinic
'

writeLines(dgp_doc, "../data-generation/ps-1-dgp.md")
cat("\nDGP documentation written to data-generation/ps-1-dgp.md\n")
