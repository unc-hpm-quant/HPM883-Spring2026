
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

