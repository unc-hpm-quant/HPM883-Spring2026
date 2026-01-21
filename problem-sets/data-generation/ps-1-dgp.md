
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

