
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

