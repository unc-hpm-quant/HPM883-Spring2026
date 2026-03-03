# Fallback Outputs

Pre-rendered outputs for PS2 progressive fallback system. Students who get stuck
on computational tasks can reference these images to verify their understanding
and continue with the problem set.

## How to Generate

Render the solutions key — it saves all fallback PNGs automatically:

```bash
cd problem-sets/solutions
quarto render ps-2-solutions.qmd
```

The solutions code includes `ggsave()` and `save_table_png()` calls that write
to this directory.

## Expected Files

- `task-2-1-plr-results.png` — ATE table (estimate, SE, CI)
- `task-2-2-forest-plot.png` — 3-learner comparison forest plot
- `task-2-3-irm-comparison.png` — PLR vs IRM comparison table
- `task-3-1a-propensity-histogram.png` — Overlapping histograms by treatment
- `task-3-1b-trimming-results.png` — Before/after trimming table
- `task-3-1c-overlap-weights.png` — Overlap weighting results
- `task-3-1d-dimensionality.png` — 10 vs 50 covariate propensity comparison
- `task-3-2-love-plot.png` — Love plot + balance assessment
- `task-4-aipw-results.png` — AIPW estimate + comparison to PLR/IRM
