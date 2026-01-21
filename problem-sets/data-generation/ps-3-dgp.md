
# Problem Set 3: Data Generating Process

## True Parameters

| Parameter | Value |
|-----------|-------|
| N | 5,000 |
| True ATE | 2.5 days |
| Design | Individual RCT (50/50) |
| CATE SD | ~2.0 days |

## True CATE Function

tau(X) = 2.5 + 0.1*(age - 50) - 0.05*(100 - health) + 1.5*I(tech >= 4) - 1.0*I(severity == 3) + 0.02*age*tech/5

Effect moderators:
1. **X1 (Age)**: Older patients benefit more (+0.1 per year above 50)
2. **X2 (Health)**: Healthier patients benefit more (-0.05 per point below 100)
3. **X3 (Tech literacy)**: High tech literacy (4-5) adds +1.5 days
4. **X5 (Severity)**: Severe cases (3) lose 1.0 days of benefit
5. **Age × Tech interaction**: Small positive interaction

Non-moderators (included to test variable importance):
- X4 (Social support): In outcome model but NOT in CATE
- X6-X10: Continuous noise
- X11-X15: Binary noise (X11, X12 in outcome model)
- X16-X20: Ordinal noise

## Outcome Model

Y(0) = 20 + 0.2*age + 0.3*health + 0.5*social - 3*I(sev==2) - 6*I(sev==3) + 0.5*X6 + 0.3*X7 + 2*X11 + X12 + epsilon

epsilon ~ N(0, 5^2)

## Expected Variable Importance

Top 5 should be: X1 (age), X3 (tech), X2 (health), X5 (severity), and possibly their interactions.
X4, X6-X20 should have low importance.

## Expected Results

- Causal forest ATE: ~2.4-2.6
- CATE distribution: Unimodal, range roughly [-1, 7]
- High tech literacy subgroup: ATE ~4.0
- Severe cases subgroup: ATE ~1.5
- BLP test should show significant heterogeneity (beta2 > 0)

## Subgroup True Effects

- Young (<40): ATE ≈ 1.5
- Middle (40-60): ATE ≈ 2.5
- Older (>60): ATE ≈ 3.5
- Mild severity: ATE ≈ 2.8
- Moderate severity: ATE ≈ 2.8
- Severe severity: ATE ≈ 1.5
- Low tech (1-2): ATE ≈ 1.5
- High tech (4-5): ATE ≈ 4.0

