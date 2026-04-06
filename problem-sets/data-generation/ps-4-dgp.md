# Problem Set 4: Data Generating Process

Standalone DGP designed for policy learning. Same covariate structure as PS 3
but with a lower baseline ATE so ~25-30% of patients have negative CATEs.

## True Parameters

| Parameter | Value |
|-----------|-------|
| N | 5,000 |
| True ATE | ~0.18 |
| Design | Individual RCT (50/50) |
| CATE SD | ~1.2 |
| Fraction tau_true < 0 | ~39% |
| Fraction tau_hat < 0 | ~34% |

## True CATE Function

tau(X) = 0.5 + 0.05*(age - 50) - 0.03*(100 - health) + 1.2*I(tech >= 4) - 2.0*I(severity == 3) - 0.8*I(severity == 2 & tech <= 2)

## Effect Moderators

1. **X1 (Age)**: Older patients benefit more (+0.05 per year above 50)
2. **X2 (Health)**: Healthier patients benefit more (-0.03 per point below 100)
3. **X3 (Tech literacy)**: High tech literacy (4-5) adds +1.2
4. **X5 (Severity)**: Severe cases (3) lose 2.0 — often harmful
5. **Severity × Tech interaction**: Moderate severity (2) + low tech (<=2) loses 0.8

## Key Subgroups

- High-tech, non-severe: strong positive (~+1.7)
- Severe + low-tech: negative (~-2.3, app is harmful)
- Moderate severity + low-tech: near zero (~-0.3)
- Average patient: slight positive (~+0.2)

## tau_hat (Causal Forest Estimates)

- Range: -1.41 to 1.26
- Cor(tau_hat, tau_true): 0.67
- Provides meaningful spread across zero for policy learning

## Expected Results

- Depth-2 tree should split on tech literacy and severity
- "CATE > 0" policy treats ~66% (distinct from treat-all)
- Depth-2 tree treats ~71%
- Policy value ordering: Tree > CATE>0 > Treat All > Treat None
- Budget 40% threshold: ~0.23, selects high-tech non-severe patients
