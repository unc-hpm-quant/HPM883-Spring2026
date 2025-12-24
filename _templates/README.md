# HPM 883 Content Templates

Standardized templates for course content generation. Use these templates when creating new units, sessions, code-alongs, and labs.

## Template Location

```
_templates/
├── README.md                    ← This file
└── unit-template/
    ├── unit-X.qmd               ← Unit overview/index page
    ├── session-X-Y-slides.qmd   ← Lecture slides (reveal.js)
    ├── code-along-X-Y.qmd       ← Interactive coding exercise
    ├── lab-X.qmd                ← Lab assignment
    ├── media/                   ← Images, diagrams
    └── data/                    ← Unit-specific datasets
```

## Standard Unit Structure

Each unit directory should contain:

```
unit-N/
├── unit-N.qmd                   # Unit overview with objectives, readings, schedule
├── session-N-1-slides.qmd       # Session 1 lecture slides
├── session-N-2-slides.qmd       # Session 2 lecture slides (if applicable)
├── code-along-N-*.qmd           # Code-along notebooks (1+ per unit)
├── media/                       # Images, diagrams, screenshots
└── data/                        # Unit-specific datasets (small)
```

**Labs** go in the central `labs/` directory (not inside unit folders):

```
labs/
├── lab-N-[topic].qmd            # Student version
├── lab-N-[topic]-sols.qmd       # Solution key (instructor only)
└── data/                        # Shared lab datasets
```

## Component Descriptions

### 1. Unit Overview (`unit-X.qmd`)

The landing page for each unit. Contains:

- **Overview:** 1-2 paragraph unit description
- **Learning Objectives:** 3-5 measurable objectives
- **Sessions Table:** Links to all session materials
- **Required Readings:** Primary textbook assignments
- **Key Concepts:** Definitions of core terms
- **R Packages:** Packages used in the unit
- **Assessment:** Lab and participation requirements
- **Course Arc:** Connections to previous/next units

### 2. Lecture Slides (`session-X-Y-slides.qmd`)

Quarto reveal.js presentations. Include:

- **Learning Objectives:** Session-specific goals
- **Content Sections:** 2-4 major sections
- **Code Examples:** Executable R chunks
- **Speaker Notes:** Using `::: notes` blocks
- **Accessibility:** Alt-text for all images
- **Wrap-Up:** Key takeaways, next steps
- **Appendix:** Remedial and advanced resources

**Naming Convention:** `session-{unit}-{session}-slides.qmd`
- Example: `session-2-1-slides.qmd` = Unit 2, Session 1

### 3. Code-Along (`code-along-X-Y.qmd`)

Interactive coding exercises. **MUST include all 5 components:**

| Component | Purpose |
|-----------|---------|
| **1. Concept Illustration** | What the method does, key assumptions |
| **2. Success Case** | Demonstrate when/why method works |
| **3. Failure Case** | Show assumption violations and breakdown |
| **4. Step-by-Step Analysis** | Complete worked example |
| **5. AI Guidance Notes** | When to use AI, what to watch for |

Plus:
- Exercises for students to try
- Summary and resources

### 4. Lab Assignment (`lab-X.qmd`)

Independent practice assignments. Design principles:

- **Challenging:** Require understanding, not code copying
- **Minimal Scaffolding:** R proficiency is prerequisite
- **Conceptual Questions:** Mix computation with understanding
- **Narrative Elements:** Use scenarios (e.g., "St. Null's Memorial Hospital")
- **AI Documentation:** Require students to document AI use
- **Clear Rubric:** Point values for each task

Structure:
1. Learning objectives
2. Setup and data loading
3. Analysis tasks (Parts 1-3)
4. Conceptual questions (Part 4)
5. Reflection
6. Submission checklist
7. AI usage documentation

## Naming Conventions

| Component | Pattern | Example |
|-----------|---------|---------|
| Unit overview | `unit-{N}.qmd` | `unit-2.qmd` |
| Slides | `session-{N}-{M}-slides.qmd` | `session-2-1-slides.qmd` |
| Code-along | `code-along-{N}-{M}-{topic}.qmd` | `code-along-2-1-dml.qmd` |
| Lab | `lab-{N}-{topic}.qmd` | `lab-2-power.qmd` |
| Lab solutions | `lab-{N}-{topic}-sols.qmd` | `lab-2-power-sols.qmd` |

## Creating a New Unit

1. **Copy template directory:**
   ```bash
   cp -r _templates/unit-template unit-N
   ```

2. **Rename files:**
   ```bash
   cd unit-N
   mv unit-X.qmd unit-N.qmd
   mv session-X-Y-slides.qmd session-N-1-slides.qmd
   mv code-along-X-Y.qmd code-along-N-1-topic.qmd
   mv lab-X.qmd ../labs/lab-N-topic.qmd
   ```

3. **Update placeholders:**
   - Replace `[UNIT TITLE]`, `[TOPIC]`, `[DATE]`
   - Replace `X` and `Y` with actual unit/session numbers
   - Add content specific to the unit

4. **Add to navigation:**
   - Update `_quarto.yml` sidebar

## Quality Checklist

Before publishing any content:

### Slides
- [ ] Learning objectives stated
- [ ] Speaker notes for key slides
- [ ] Alt-text for all images
- [ ] Code examples are executable
- [ ] Wrap-up with takeaways

### Code-Alongs
- [ ] All 5 required components present
- [ ] Success case shows method working
- [ ] Failure case shows breakdown
- [ ] AI guidance notes included
- [ ] Exercises for students

### Labs
- [ ] Clear point values
- [ ] Mix of computation and conceptual
- [ ] AI documentation section
- [ ] Submission checklist
- [ ] Solutions file created

### Accessibility
- [ ] Alt-text for visualizations
- [ ] Semantic headings (H1 > H2 > H3)
- [ ] Color not sole information carrier
- [ ] Code chunks have labels

## Pedagogical Principles

### "AI in the Loop" Teaching

Sequence for each topic:
1. **Theory** — Conceptual foundations
2. **Math & Logic** — Underlying mechanics
3. **AI Implementation** — Using tools effectively
4. **Critical Evaluation** — Recognizing AI errors

### Differentiated Learning

| Layer | Purpose | Example |
|-------|---------|---------|
| Core | Main content for all | Lecture slides, required readings |
| Remedial | Foundation refreshers | "See Wooldridge Ch. 2 if unfamiliar with OLS" |
| Advanced | Optional deeper dives | Recent papers, extensions |

## Related Resources

- **Course repo:** `/Users/sysylvia/Documents/Repos/HPM883-Spring2026/`
- **Lab template:** https://github.com/unc-hpm-quant/hpm883-lab-template
- **Capstone template:** https://github.com/unc-hpm-quant/hpm883-capstone-template
- **Skill documentation:** `.claude/skills/quant-methods-teaching/`
