# Lab 0: Reproducible Research Workflow — Outline

**Course:** HPM 883 - Quantitative Methods for Health Policy Research
**Session:** 0.2 (January 12, 2026)
**Duration:** 75 minutes (live coding together)
**Grading:** Not graded; commit/push for personal reference

---

## Learning Objectives

By the end of this lab, students will be able to:
1. Navigate and use GitHub Codespaces with RStudio Server
2. Understand project organization principles for reproducible research
3. Use Git for version control (clone, stage, commit, push)
4. Load and explore data using R and tidyverse
5. Perform basic regression analysis with robust standard errors
6. Render Quarto documents and submit via GitHub

---

## Lab Structure

### Part 0: Getting Started (10 min)

**Content:**
- Accept GitHub Classroom assignment (instructor shows on screen)
- Wait for repo creation
- Click "Open in Codespace"
- Tour of RStudio interface (Source, Console, Environment, Git panes)
- Verify files present (analysis.qmd, data/, renv.lock)

**Checkpoint:**
> "You should see RStudio Server running in your browser with `analysis.qmd` open in the Source pane. The Files pane should show a `data/` folder and `renv.lock` file."

**Estimated time:** 8-10 min (allow buffer for slow Codespace boots)

---

### Part 1: Project Organization (15 min)

**Concepts to cover:**
1. **Why project organization matters** — Reproducibility, collaboration, future-you
2. **Standard folder structure:**
   - `data/` — Raw and processed data (never modify raw!)
   - `code/` or `R/` — R scripts and functions
   - `output/` — Results, figures, tables
   - `docs/` — Documentation, reports
3. **Relative paths** — Why not absolute paths?
   - Bad: `/Users/sean/Documents/project/data/file.csv`
   - Good: `data/file.csv`
4. **Numbered file naming** — Execution order clarity
   - `01_data_import.R`
   - `02_data_cleaning.R`
   - `03_analysis.R`

::: {.callout-tip}
## Five Habits for Reproducible Code

1. **Use relative paths** — `data/file.csv` not `/Users/me/project/data/file.csv`
2. **Number your scripts** — `01_import.R`, `02_clean.R`, `03_analyze.R` shows execution order
3. **Never modify raw data** — Keep originals in `data/raw/`, save processed versions separately
4. **Commit often** — Small, meaningful commits with descriptive messages
5. **Start fresh sessions** — Restart R frequently to ensure code works from scratch

*Adapted from Gentzkow & Shapiro, "Code and Data for the Social Sciences"*

For a deeper dive, see the [Reproducible Research Guide](/reproducible-research.qmd).
:::

**Code to demonstrate:**
```r
# Check your working directory
getwd()

# List files in the data folder
list.files("data/")

# This will FAIL (absolute path)
# read_csv("/Users/someone/data/file.csv")

# This will WORK (relative path)
# read_csv("data/file.csv")
```

**Checkpoint:**
> "Run `getwd()` and `list.files('data/')`. You should see the Codespace path and `lab0_rct_data.csv` in your data folder."

---

### Part 2: Version Control with Git (20 min)

**Concepts to cover:**
1. **What is version control?**
   - Analogy: "Imagine if Dropbox and 'Track Changes' in Word had a baby"
   - Track changes to files over time
   - Collaborate without overwriting each other's work

2. **Git vs. GitHub**
   - Git = tool that runs on your computer (or Codespace)
   - GitHub = website that hosts your repositories online

3. **Core workflow: Clone → Edit → Stage → Commit → Push**
   - **Clone:** Copy a repo from GitHub to your computer
   - **Edit:** Make changes to files
   - **Stage:** Select which changes to save (git add)
   - **Commit:** Save a snapshot with a message (git commit)
   - **Push:** Upload to GitHub (git push)

4. **RStudio Git pane walkthrough:**
   - Location of Git pane
   - Status icons (M = modified, A = added, ? = untracked)
   - Staging checkbox
   - Commit button
   - Push/Pull buttons

**PRACTICE: Your First Commit (5 min)**
```
Instructions:
1. In analysis.qmd, add your name after "author:" in the YAML header
2. Save the file (Cmd+S or Ctrl+S)
3. Look at the Git pane — you should see analysis.qmd with an "M"
4. Check the box next to analysis.qmd to stage it
5. Click "Commit"
6. Write a message: "Add my name to author field"
7. Click "Commit"
8. Click "Push"
```

**Checkpoint:**
> "Go to GitHub and refresh your repo page. You should see your commit with the message 'Add my name to author field'."

---

### Part 3: R Environment & Packages (10 min)

**Concepts to cover:**
1. **What is renv?**
   - Package manager that ensures reproducibility
   - `renv.lock` = snapshot of all packages and versions
   - When you share your project, others can recreate exact environment

2. **Key commands:**
   - `renv::restore()` — Install packages from lockfile
   - `renv::snapshot()` — Update lockfile with current packages

3. **Loading packages:**
   - `library()` loads a package for use
   - Order matters: load packages at top of script

**Code to run together:**
```r
# Check R version
R.version$version.string

# Load packages (already installed via renv)
library(tidyverse)    # Data manipulation and visualization
library(estimatr)     # Robust standard errors
library(gt)           # Nice tables

# Verify packages loaded
search()  # Shows loaded packages
```

**Checkpoint:**
> "All three `library()` calls should complete without error. If you see 'there is no package called X', run `renv::restore()` first."

---

### Part 4: Basic Analysis Workflow (15 min)

**Concepts to cover:**
1. **Load data** — `read_csv()` with relative path
2. **Explore data** — `glimpse()`, `summary()`, `head()`
3. **Analyze data** — `lm_robust()` for regression with robust SEs
4. **Visualize data** — `ggplot2` for plots

**Code to run together:**

```r
# 1. Load data
df <- read_csv("data/lab0_rct_data.csv")

# 2. Explore: What's in the data?
glimpse(df)     # Variable names and types
summary(df)     # Summary statistics
count(df, treatment)  # How many in each group?

# 3. Analyze: Treatment effect
# Simple difference in means (unadjusted)
model1 <- lm_robust(outcome_score ~ treatment, data = df)
summary(model1)

# With covariate adjustment
model2 <- lm_robust(outcome_score ~ treatment + baseline_score, data = df)
summary(model2)

# 4. Visualize: Outcome by treatment
ggplot(df, aes(x = factor(treatment), y = outcome_score)) +
  geom_boxplot(fill = c("#E69F00", "#56B4E9")) +
  labs(
    x = "Treatment Group",
    y = "Outcome Score",
    title = "Treatment Effect on Outcome Score"
  ) +
  scale_x_discrete(labels = c("Control", "Treatment")) +
  theme_minimal()
```

**PRACTICE: Modify the Plot (5 min)**
```
Instructions:
1. Change the boxplot to a violin plot using geom_violin()
2. Add individual points on top using geom_jitter()
3. Save your changes
```

**Expected result:**
- Treatment effect should be ~12-15 points (positive)
- Adjusted model should have smaller SE than unadjusted

**Checkpoint:**
> "Your model output should show a positive treatment coefficient around 12-15. The plot should show clear separation between treatment and control groups."

---

### Part 5: Render & Submit (5 min)

**Steps:**
1. **Render to HTML:**
   - Click "Render" button in RStudio (or Cmd+Shift+K)
   - Wait for document to compile
   - Preview should open in Viewer pane

2. **Final commit and push:**
   - Stage all changes (analysis.qmd + analysis.html)
   - Commit with message: "Complete Lab 0"
   - Push to GitHub

3. **Verify on GitHub:**
   - Go to your repo on GitHub
   - You should see analysis.html file
   - Your commit history should show multiple commits

**Checkpoint:**
> "Your GitHub repo should show `analysis.html` and at least 2 commits. You're done!"

---

## Common Issues & Troubleshooting

| Issue | Solution |
|-------|----------|
| Codespace takes >10 min to load | Normal for first time; subsequent loads are faster |
| "Package not found" error | Run `renv::restore()` in Console |
| Git push fails | Make sure you committed first; check for merge conflicts |
| Render fails | Check for R errors in Console; fix code, try again |
| Can't see Git pane | View → Show Git |

---

## Key Takeaways

1. **Reproducibility starts with organization** — Folder structure, relative paths, numbered files
2. **Git is your safety net** — Commit early, commit often
3. **renv ensures package consistency** — Lock your dependencies
4. **Quarto combines code + narrative** — One document, reproducible results

---

## Next Steps

- **Due:** January 19, 2026 (end of Week 1)
- **Submission:** Just commit and push — we'll see your work on GitHub
- **Solutions:** Available after class session ends

---

## Dataset Description

**File:** `data/lab0_rct_data.csv`

| Variable | Description |
|----------|-------------|
| `id` | Participant identifier (1-50) |
| `treatment` | Treatment assignment (0=Control, 1=Treatment) |
| `age` | Age in years |
| `education_years` | Years of education |
| `baseline_score` | Pre-intervention score (scale 0-100) |
| `outcome_score` | Post-intervention score (scale 0-100) |

**Design:** Simple two-arm RCT with 50 participants (25 per arm)

---

*Outline created: January 10, 2026*
*For Sean's review before drafting full Lab 0 content*
