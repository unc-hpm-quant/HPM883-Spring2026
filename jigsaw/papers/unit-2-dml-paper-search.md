# Unit 2 DML Paper Search Results

**Date:** 2026-02-23
**Purpose:** Literature search to select 4 papers for Jigsaw 2 (Double Machine Learning)

## Selected Papers (Final 4)

| # | Citation | Method Variant | Domain |
|---|----------|---------------|--------|
| P1 | Knaus (2022), *Econometrics Journal* 25(3), 602-627 | Standard DML with GATEs, BLP-CATE | Labor market policy |
| P2 | Jiang et al. (2025), *Statistics in Medicine*, DOI: 10.1002/sim.70025 | DML doubly-robust, test-negative design | COVID-19 vaccine effectiveness |
| P3 | Dube et al. (2020), *AER: Insights* 2(1), 33-46 | Standard DML | Labor supply elasticities |
| P4 | Cilliers, Elashmawy & McKenzie (2024), World Bank WP #10931 | Post-Double-Selection LASSO | Meta-evaluation across RCTs |

## Verified Papers (Not Selected)

| Citation | Status | Method | Notes |
|----------|--------|--------|-------|
| Chernozhukov et al. (2018), *Econometrics Journal* 21(1), C1-C68 | Verified | Foundational DML | Was fallback for P2 slot. Excellent but very long/technical for students. |
| D'Amour et al. (2021), *Journal of Econometrics* 221(2), 644-654 | Verified | Overlap analysis | Important methodological concern for DML. Recommended as supplemental reading. |

## Fabricated Papers Found During Search

| Claimed Citation | Issue |
|-----------------|-------|
| Rose, Ash, Ellis & Zaslavsky (2020), *HSR* 55(4), 608-617 | Does not exist. No such paper in HSR volume 55. |
| Marsja & Sundmacher (2025), "Health shocks and health behavior" | Misattributed. Actual paper: Bunnings, Simankova & Tauchmann (2025), *EJHE* 26(8), 1293-1332. Does NOT use DML. |

## Elicit Search Results (Partial — ~24 of 34 papers)

Source: https://elicit.com/agent/a70754c0-bd61-4bcd-9d0b-5ced51da1fc0

### DML Papers (Non-Causal-Forest)

1. **"Double Machine Learning for Causal Inference in High-Dimensional EHR"**
   - Method: Offset-DML
   - Data: UK CPRD GOLD, OMOP CDM, 5,277 covariates
   - Year: 2025 (medRxiv preprint, DOI: 10.1101/2025.07.21.25331944)

2. **"A Double Machine Learning Approach for the Evaluation of COVID-19 Vaccine Effectiveness Under the Test-Negative Design"**
   - Authors: Jiang et al.
   - Method: DML doubly-robust (TNDDR estimator)
   - Data: Quebec administrative data, community-dwelling 60+
   - Year: 2025 (*Statistics in Medicine*, PubMed: 39985144)
   - **SELECTED as P2**

3. **"Double machine learning to estimate effects of multiple treatments and their interactions"**
   - Method: DML extended for multiple treatments
   - Data: HIV cohort, northern Nigeria, 2,455 participants
   - Year: 2025 (arXiv: 2505.12617, not yet peer-reviewed)

4. **"DML reanalysis of EARLYDRAIN trial"**
   - Method: DML with CausalForestDML (EconML)
   - Domain: Neurosurgery RCT reanalysis
   - Note: Uses causal forests variant, not pure DML

5. **"DML for time-varying effects using digital phenotypes"**
   - Method: DML for temporal effects
   - Data: Parkinson's mHealth data

### Causal Forest / Other Methods (Not DML for This Unit)

Papers using causal forests, TMLE, or other non-DML methods were also found in the Elicit search. These are relevant for Unit 3 (Causal Forests) and later units. Full list was not completely extracted due to table virtualization.

## Search Notes

- Standard DML applied to health data in peer-reviewed journals is genuinely rare
- Most health ML causal inference uses causal forests (GRF) or TMLE
- The economics literature has more standard DML applications
- PDS-LASSO (Belloni, Chernozhukov, Hansen 2014) is a closely related but distinct method worth including for pedagogical variety
