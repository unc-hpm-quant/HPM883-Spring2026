
# Problem Set 2: Data Generating Process

## True Parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| True ATE | 0.6 | Additional hospital visits from Medicaid |
| Sample size | 10,000 | |
| Treatment rate | ~35% | |
| Confounders | 50 | 20 continuous + 15 binary + 15 ordinal |

## Propensity Model

logit(P(D=1|X)) = -0.5 + 0.3*X1 - 0.2*X2 + 0.15*X3 + 0.1*X4 - 0.1*X5 + 0.2*X6
                 + 0.05*X7^2 + 0.4*X21 + 0.3*X22 - 0.2*X23 + 0.1*X24 + 0.15*X25
                 + 0.1*X1*X21

Propensity includes:
- Linear terms (X1-X6)
- Quadratic term (X7^2)
- Binary indicators (X21-X25)
- Interaction (X1*X21)

## Outcome Model

Y(0) = 2.0 + 0.5*X1 + 0.3*X2 - 0.2*X3 + 0.15*X4 + 0.1*X5
       + 0.2*X1^2 + 0.8*X21 + 0.6*X22 + 0.5*X23 + 0.3*X24 + 0.4*X25
       + 0.15*X36 + 0.1*X37 + epsilon

Y(1) = Y(0) + 0.6 (constant treatment effect)

epsilon ~ N(0, 1.5^2)

## Covariate Structure

- X1-X20: Continuous, correlated (r ≈ 0.3 for adjacent)
- X21-X35: Binary health conditions (5-30% prevalence)
- X36-X50: Ordinal SES indicators (1-5 scale)

## Key Features

1. **Confounding**: Treatment depends on X1-X6, X21-X25; outcome depends on overlapping set
2. **Nonlinearity**: Both models include X^2 and interaction terms
3. **Moderate overlap**: Propensity bounded [0.02, 0.98]
4. **Pre-treatment outcome**: Y_pre correlated with Y for covariate adjustment

## Expected Results

- Naive difference-in-means: ~0.75-0.85 (biased upward due to positive confounding)
- DML with Lasso: ~0.55-0.65
- DML with RF/XGBoost: ~0.58-0.65 (may capture nonlinearity better)
- True ATE: 0.6

## Validation

Students should find:
- DML estimates close to 0.6
- Random Forest/XGBoost may slightly outperform Lasso due to nonlinearity
- Some overlap issues in propensity tails
- Trimming removes ~2-5% of observations

