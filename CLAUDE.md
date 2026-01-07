# CLAUDE.md

Instructions for Claude Code when working in this repository.

## Repository Overview

This is the **HPM 883: Advanced Quantitative Methods** course website for Spring 2026, built with Quarto.

- **Site URL:** https://hpm883.ssylvia.io
- **Deployment:** GitHub Actions → Netlify (auto-deploy on push to main)
- **Primary language:** R (with Quarto for documents)

## Quarto Formatting Rules

### Lists Require Blank Lines

**CRITICAL:** In Quarto/Markdown, always put a blank line before bullet lists or numbered lists. Without the blank line, the list will not render properly.

**Correct:**
```markdown
Here is some text.

- Item 1
- Item 2
- Item 3
```

**Wrong (will not render as a list):**
```markdown
Here is some text.
- Item 1
- Item 2
- Item 3
```

This applies to:
- Bullet lists (`-` or `*`)
- Numbered lists (`1.`, `2.`, etc.)
- Nested lists
- Lists after headings, paragraphs, or callouts

## Key Files

| File | Purpose |
|------|---------|
| `_quarto.yml` | Site configuration, navigation, theme |
| `schedule.qmd` | Course schedule with session details |
| `course-syllabus.qmd` | Full syllabus |
| `unit-*/` | Unit content directories |
| `labs/` | Lab assignments |

## R Package Management

This project uses `renv` for reproducible R environments. Key packages:
- DeclareDesign, estimatr, randomizr, fabricatr
- DoubleML, grf, policytree
- tidyverse, ggplot2

## Build Commands

```bash
# Preview locally
quarto preview

# Render site
quarto render

# Check R dependencies
Rscript -e "renv::status()"
```

## Deployment

Push to `main` triggers GitHub Actions workflow which:
1. Installs Quarto and R
2. Restores renv dependencies
3. Renders the site
4. Deploys to Netlify

No manual deployment needed.
