# HPM 883 Spring 2026 Syllabus Content

**Instructions:** Copy each section below into the corresponding section of the Gillings Word template. Keep all institutional boilerplate from the template.

---

## COURSE IDENTIFICATION

**Course Number:** HPM 883
**Course Title:** Advanced Quantitative Methods for Health Policy and Management
**Semester:** Spring 2026
**Credits:** 3
**Meeting Time:** Monday & Wednesday, 11:15am - 12:30pm
**Location:** Rosenau 228 / Zoom (Hybrid format)
**Prerequisites:** HPM 881, HPM 882, or permission of instructor

---

## INSTRUCTOR INFORMATION

**Instructor:** Sean Sylvia, PhD
**Title:** Associate Professor
**Department:** Health Policy and Management
**Office:** McGavran-Greenberg 1101-D
**Email:** sysylvia@email.unc.edu
**Office Hours:** Wednesday 2:00-4:00pm (in-person or Zoom)
**Additional Support:** Friday 10:00-11:00am (Zoom coding support)

**Teaching Assistant:** Bryan Nice, MPH
**Email:** bnice@email.unc.edu

---

## COURSE DESCRIPTION

HPM 883 is an advanced graduate-level course designed to equip PhD students in Health Policy and Management with sophisticated quantitative research skills. This course is the third installment in the quantitative methods sequence, building on foundations from HPM 881 and HPM 882.

The course integrates experimental design principles with modern causal machine learning methods, following a three-layer framework: **Identification → Estimation → Decision**. Students will learn to design rigorous experiments, estimate treatment effects using cutting-edge methods, and translate findings into actionable policy decisions.

**Focus Areas:**
- Experimental design and randomization inference
- Double/Debiased Machine Learning (DML)
- Heterogeneous treatment effects and causal forests
- Policy learning and optimal treatment rules
- Modern causal inference methods (DiD, synthetic controls)

**Course Format:** This is a hybrid course combining in-person lectures (theory and discussion) with remote Zoom sessions (coding labs and implementation). This format provides face-to-face interaction for conceptual material while offering flexibility for hands-on coding work.

---

## COURSE LEARNING OBJECTIVES

Upon successful completion of this course, students will be able to:

| # | Learning Objective | Assessment Evidence |
|---|-------------------|---------------------|
| 1 | **Design** randomized experiments with appropriate power analysis, randomization strategies, and variance reduction techniques | Design Memo 1, PS 1, Capstone Project |
| 2 | **Implement** Double/Debiased Machine Learning and doubly-robust estimators for causal inference | PS 2, Design Memo 2, Capstone Project |
| 3 | **Estimate** heterogeneous treatment effects using causal forests and meta-learners | PS 3, Capstone Project |
| 4 | **Evaluate** Conditional Average Treatment Effect (CATE) estimates using calibration diagnostics | PS 3, Capstone Project |
| 5 | **Learn** optimal treatment policies from observational data using policy trees | PS 4, Capstone Project |
| 6 | **Apply** modern difference-in-differences and synthetic control methods | PS 5, Capstone Project |
| 7 | **Diagnose** common problems including overlap violations, confounding, and model misspecification | PS 2-5, Design Memos, Capstone Project |
| 8 | **Produce** reproducible research using modern workflow tools (renv, targets, Quarto) | PS 0, All Problem Sets, Capstone Project |

---

## REQUIRED MATERIALS

### Textbooks (Both FREE Online)

1. **Chernozhukov, V., Hansen, C., Kallus, N., Spindler, M., & Syrgkanis, V. (2025)**
   *Applied Causal Inference Powered by ML and AI*
   Available free at: https://causalml-book.org/

2. **Wager, S. (2024)**
   *Causal Inference: A Statistical Learning Approach*
   Available free at: http://web.stanford.edu/~swager/causal_inf_book.pdf

### Software Requirements

- **R** (version 4.3 or higher)
- **RStudio** or **Positron** IDE
- **Key R Packages:** tidyverse, renv, targets, DeclareDesign, estimatr, DoubleML, grf, policytree, did, Synth, cobalt, WeightIt

All software is free and open-source. Detailed installation instructions are provided in the course Setup Guide.

### Computing Access

- **Posit Cloud:** Backup computing environment (free tier available)
- **GitHub:** Version control and assignment submission via GitHub Classroom

---

## COURSE STRUCTURE

The course is organized into 8 units over 14 weeks:

| Unit | Topic                                  | Weeks | Content Focus               |
| ---- | -------------------------------------- | ----- | --------------------------- |
| 0    | Foundations: Potential Outcomes & DAGs | 1     | Framework foundations       |
| 1    | Experimental Design & Randomization    | 2-3   | Design-based inference      |
| 2    | Double/Debiased Machine Learning       | 4-6   | Semiparametric estimation   |
| 3    | HTE & Causal Forests                   | 7-8   | Treatment heterogeneity     |
| 4    | Policy Learning                        | 9     | Optimal decisions           |
| 5    | Observational Causal ML                | 10    | Weighting and balance       |
| 6    | DiD & Synthetic Controls               | 11    | Panel methods               |
| 7    | Advanced Topics                        | 12    | Student choice              |
| 8    | Integration & Capstone                 | 13-14 | Synthesis and presentations |

---

## ASSESSMENT AND GRADING

### Grade Composition

| Component | Weight | Description |
|-----------|--------|-------------|
| Problem Sets | 30% | ~7 assignments, drop 3 lowest |
| Design Memos | 20% | 2 written memos (10% each) |
| Capstone Project | 45% | Paper + code + presentation |
| Peer Review | 5% | Review of one peer's project |
| **Total** | **100%** | |

### Grading Scale

Final course grades will be determined using the following [UNC Graduate School grading scale](https://handbook.unc.edu/grading.html).  The relative weight of each course component is shown in the Graded Assignments section.

·       **H**—High Pass (93-100): Clear excellence
·       **P**—Pass (80-92): Entirely satisfactory graduate work
·       **L**—Low Pass (70-79): Inadequate graduate work
·       **F**—Fail (0-69)
### Assignment Descriptions

**Problem Sets (30%):** Take-home assignments where students independently apply course methods to data analysis problems. Approximately 7 problem sets throughout the semester (roughly one every two weeks). **The 3 lowest problem set grades will be dropped**, allowing flexibility for challenging weeks or unexpected circumstances.

**In-Class Code-Alongs:** During Zoom lab sessions, the instructor will guide students through code implementations that illustrate unit concepts. These are instructional and not graded—students follow along and can use these as reference for problem sets.

**Design Memos (20%):** Two written memos (3-5 pages each):
- Memo 1: Experimental design plan with power analysis
- Memo 2: DML analysis plan with estimator specification

**Capstone Project (45%):** A substantial independent project demonstrating mastery of course methods. Options include:
1. Pre-Analysis Plan (PAP) for proposed research
2. Replication + Extension of published study
3. Methods comparison using simulation or real data

Deliverables: 15-20 page paper, full replication code, 20-minute presentation

**Peer Review (5%):** Written review of one classmate's capstone project, providing constructive methodological feedback.

---

## COURSE SCHEDULE AND KEY DATES

### Weekly Topics

| Week | Dates | Topics | Deliverables |
|------|-------|--------|--------------|
| 1 | Jan 7, 12, 14 | Course Overview, Reproducible Research, Potential Outcomes | |
| 2 | Jan 19 (MLK), 21 | Randomization & Design-Based Inference | PS 0 due (Jan 19) |
| 3 | Jan 26, 28 | DeclareDesign, Variance Reduction | |
| 4 | Feb 2, 4 | Influence Functions (async), Guest Lecture | PS 1 due (Feb 2) |
| 5 | Feb 9 (WB), 11 | Neyman Orthogonality & Cross-Fitting | |
| 6 | Feb 16, 18 | Double ML, Doubly-Robust Estimation | Memo 1 due (Feb 16) |
| 7 | Feb 23, 25 | Causal Forests, GRF Implementation | PS 2 due (Feb 23) |
| 8 | Mar 2, 4 | Meta-Learners, CATE Calibration | Memo 2 due (Mar 9) |
| 9 | Mar 9, 11 | Policy Learning, Off-Policy Evaluation | PS 3 due (Mar 11) |
| — | Mar 13-22 | **SPRING BREAK** | |
| 10 | Mar 23, 25 | Observational Causal ML | PS 4 due (Mar 25) |
| 11 | Mar 30, Apr 1 | Modern DiD, Synthetic Controls | PS 5 due (Apr 8) |
| 12 | Apr 6, 8 | Advanced Topics Survey | |
| 13 | Apr 13, 15 | Capstone Presentations (Round 1-2) | PS 6 due, Proposal due (Apr 13) |
| 14 | Apr 20, 22 | Final Presentations, Course Wrap-Up | Peer Review due (Apr 22) |
| Finals | May 1 | | Capstone due (May 1) |

### Important Dates

- **First Day of Class:** Wednesday, January 7, 2026
- **MLK Day (No Class):** Monday, January 19
- **Well-Being Day (No Class):** Monday, February 9
- **Spring Break:** March 13-22 (No Classes)
- **Well-Being Day (No Class):** Thursday, April 2
- **Last Day of Class:** Monday, April 27
- **Capstone Project Due:** Friday, May 1, 2026

---

## COURSE POLICIES

### Attendance and Participation

Regular attendance is expected for both in-person and Zoom sessions. The hybrid format requires active engagement:
- **In-person sessions:** Theory, discussion, and collaborative problem-solving
- **Zoom sessions:** Coding labs, implementation, and troubleshooting

If you must miss a class, please notify the instructor in advance when possible.

### Late Work Policy

Assignments are due by 11:59pm on the due date unless otherwise specified.
- Late submissions: -10% per 24 hours
- After 48 hours: No credit without prior arrangement
- Extensions may be granted for documented circumstances if requested before the deadline

### Academic Integrity

All work submitted must be your own. Collaboration is encouraged on labs, but each student must write their own code and responses. For the capstone project and memos, work must be entirely your own.

Citation of sources is required for all external material, including code adapted from online sources.

### AI Use Policy

The use of AI tools (such as ChatGPT, GitHub Copilot, or Claude) is **permitted and encouraged** for:
- Debugging code
- Understanding error messages
- Learning syntax and package functions
- Generating code snippets for adaptation

However:
- You are responsible for all code you submit—AI-generated code must be understood, tested, and verified
- Conceptual understanding cannot be outsourced; you must be able to explain your methods
- AI use should be acknowledged in your work (e.g., "Code structure suggested by ChatGPT and modified")
- On written components (memos, capstone paper), AI may assist with editing but substantive content must be your own

The goal is to prepare you for a world where AI tools are standard practice while ensuring you develop genuine methodological understanding.

### Communication

- **Primary:** Course Slack workspace for questions, discussion, and announcements
- **Email:** For private matters (grades, accommodations, personal circumstances)
- **Office Hours:** For detailed questions, project guidance, and coding help
- **Canvas:** Grade posting and official announcements

Response times: Slack/email within 24-48 hours on weekdays; longer on weekends.

---

## RESOURCES AND SUPPORT

### Course Website
https://unc-hpm-quant.github.io/HPM883-Spring2026

### GitHub Organization
https://github.com/unc-hpm-quant

### Supplementary Readings

Additional papers and tutorials will be assigned throughout the semester, including:
- Hernán & Robins (2020): *Causal Inference: What If*
- Cunningham (2021): *Causal Inference: The Mixtape*
- Huntington-Klein (2022): *The Effect*
- Original methodology papers (Athey, Wager, Chernozhukov, etc.)

All supplementary materials are freely available online.

---

## INSTITUTIONAL POLICIES

[Keep all Gillings boilerplate from the template, including:]

- Honor Code and Academic Integrity
- Accessibility Resources and Accommodations (ARS)
- Counseling and Psychological Services (CAPS)
- Title IX and Interpersonal Violence Resources
- Diversity and Inclusion Statement
- Gillings School Community Standards
- Non-Discrimination Policy

---

## DISCLAIMER

The instructor reserves the right to make changes to the syllabus as needed. Students will be notified of any changes via Canvas announcement and Slack.

---

*Last Updated: December 21, 2025*
