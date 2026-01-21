# ============================================================================
# Problem Set 5: Data Generation Script
# Observational Causal ML - Staggered Telehealth Adoption
# ============================================================================

library(data.table)
set.seed(883005)

# ============================================================================
# TRUE PARAMETERS
# ============================================================================

N_counties <- 200
N_years <- 8  # 2016-2023
TRUE_ATT <- 15  # 15 additional visits per 1,000 from telehealth

# Adoption cohorts
# 40 counties: 2018, 40: 2019, 40: 2020, 30: 2021, 20: 2022, 30: Never
cohort_sizes <- c(40, 40, 40, 30, 20, 30)
cohort_years <- c(2018, 2019, 2020, 2021, 2022, NA)

# ============================================================================
# GENERATE DATA
# ============================================================================

# Assign counties to cohorts
county_cohorts <- rep(cohort_years, cohort_sizes)
county_ids <- 1:N_counties

# County-level characteristics (time-invariant confounders)
X <- data.table(
  county_id = county_ids,
  cohort = county_cohorts,
  # Urban (affects both adoption timing and outcomes)
  X1_urban = rbinom(N_counties, 1, prob = ifelse(is.na(county_cohorts), 0.3,
                                                   0.8 - 0.1*(county_cohorts - 2018))),
  # Population (log scale)
  X2_log_pop = rnorm(N_counties, 12, 1),
  # Median income
  X3_income = rnorm(N_counties, 50, 15),
  # Healthcare infrastructure (drives adoption)
  X4_infra = rnorm(N_counties, 0, 1),
  # Elderly population share
  X5_elderly = rbeta(N_counties, 2, 8)
)

# Early adopters have better infrastructure
X[!is.na(cohort), X4_infra := X4_infra + (2022 - cohort) * 0.3]

# Add more covariates
for (j in 6:15) {
  X[, paste0("X", j) := rnorm(.N, 0, 1)]
}

# Expand to panel
panel <- X[, .(year = 2016:2023), by = county_id]
panel <- merge(panel, X, by = "county_id")

# Treatment indicator
panel[, treated := ifelse(is.na(cohort), 0, as.integer(year >= cohort))]
panel[, first_treat_year := cohort]

# Generate outcomes
# Baseline: depends on county characteristics + time trend
panel[, Y_base := 200 +
        20 * X1_urban +
        5 * (X2_log_pop - 12) +
        0.5 * X3_income +
        10 * X4_infra +
        -50 * X5_elderly +
        3 * (year - 2016) +  # Time trend
        rnorm(.N, 0, 20)]  # Noise

# Add treatment effect (dynamic: grows over time since treatment)
panel[, time_since_treat := ifelse(treated == 1, year - cohort, 0)]
panel[, tau := ifelse(treated == 1, TRUE_ATT + 2 * time_since_treat, 0)]

panel[, Y := round(Y_base + tau + rnorm(.N, 0, 10), 1)]

# Keep relevant columns
final <- panel[, .(county_id, year, treated, first_treat_year, Y,
                   X1 = X1_urban, X2 = round(X2_log_pop, 2),
                   X3 = round(X3_income, 1), X4 = round(X4_infra, 2),
                   X5 = round(X5_elderly, 3),
                   X6 = round(X6, 2), X7 = round(X7, 2), X8 = round(X8, 2),
                   X9 = round(X9, 2), X10 = round(X10, 2),
                   X11 = round(X11, 2), X12 = round(X12, 2),
                   X13 = round(X13, 2), X14 = round(X14, 2), X15 = round(X15, 2))]

fwrite(final, "../data/ps-5-telehealth.csv")

cat("PS 5 data exported\n")
cat("N observations:", nrow(final), "\n")
cat("True ATT:", TRUE_ATT, "(plus dynamic effects)\n")
cat("Adoption cohorts:", paste(cohort_years[!is.na(cohort_years)], collapse = ", "), "\n")

# DGP doc
dgp <- '
# Problem Set 5: Data Generating Process

## True Parameters
- True ATT (at adoption): 15 visits per 1,000
- Dynamic effect: +2 per year since adoption
- N counties: 200
- Years: 2016-2023

## Adoption Cohorts
- 2018: 40 counties (early adopters, better infrastructure)
- 2019: 40 counties
- 2020: 40 counties
- 2021: 30 counties
- 2022: 20 counties
- Never: 30 counties

## Confounding Structure
- X1 (urban) affects both adoption timing and outcomes
- X4 (infrastructure) correlates with earlier adoption
- This creates selection bias: early adopters have higher baseline Y

## Expected Results
- Naive DiD: ~18-20 (upward biased due to selection)
- Callaway-Sant Anna ATT: ~15-17
- TWFE: biased due to staggered adoption
'
writeLines(dgp, "ps-5-dgp.md")
