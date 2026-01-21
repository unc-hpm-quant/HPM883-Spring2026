
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

