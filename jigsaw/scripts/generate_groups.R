# HPM 883 Jigsaw Group Generator
# Generates random expert groups and teaching group reshuffles

library(tidyverse)

# ============================================================================
# CONFIGURATION
# ============================================================================

# Student roster (update as needed)
# Note: Bryan Nice is TA, not included in jigsaw assignments
students <- c(
  "Haiyi Chen",
  "Raquel Davis",
  "Yumeng Du",
  "Oguz Eren",
  "Lillian Feingold",
  "Aniruddhan Ganesaraman",
  "Tarini Goyal",
  "Takhona Hlatshwako",
  "Doyoung Kim",
  "Cristina Lee",
  "Jose Lopez",
  "Camille Murray",
  "Korie Rice",
  "Mario Rojas",
  "Nicolle Wagner Gutierrez",
  "Audrey Yao"
)

# Number of papers per jigsaw (typically 4)
num_papers <- 4

# Jigsaw session seeds (for reproducibility)
jigsaw_seeds <- c(
  jigsaw_1 = 20260128,  # Jan 28
  jigsaw_2 = 20260218,  # Feb 18
  jigsaw_3 = 20260311,  # Mar 11
  jigsaw_4 = 20260325,  # Mar 25
  jigsaw_5 = 20260408   # Apr 8
)

# ============================================================================
# FUNCTIONS
# ============================================================================

#' Generate expert groups for a jigsaw session
#' @param students Character vector of student names
#' @param num_papers Number of papers (groups)
#' @param seed Random seed for reproducibility
#' @return Tibble with student assignments
generate_expert_groups <- function(students, num_papers = 4, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n <- length(students)
  shuffled <- sample(students)

  # Calculate group sizes (some groups may have +1)
  base_size <- n %/% num_papers
  remainder <- n %% num_papers

  # Create group assignments
  assignments <- tibble(
    student = shuffled,
    paper = rep(1:num_papers, times = c(
      rep(base_size + 1, remainder),
      rep(base_size, num_papers - remainder)
    ))
  ) |>
    arrange(paper, student)

  return(assignments)
}

#' Create teaching groups from expert groups
#' @param expert_groups Tibble from generate_expert_groups
#' @return Tibble with teaching group assignments
create_teaching_groups <- function(expert_groups) {
  # Get list of students per paper
  papers <- expert_groups |>
    group_by(paper) |>
    summarize(students = list(student), .groups = "drop")

  # Find maximum group size
  max_size <- max(sapply(papers$students, length))

  # Create teaching groups using round-robin
  teaching_groups <- tibble()

  for (i in 1:max_size) {
    group_members <- papers |>
      mutate(member = map_chr(students, ~{
        if (i <= length(.x)) .x[i] else NA_character_
      })) |>
      filter(!is.na(member)) |>
      select(paper, student = member)

    group_members$teaching_group <- i
    teaching_groups <- bind_rows(teaching_groups, group_members)
  }

  return(teaching_groups)
}

#' Format groups as markdown for Quarto
#' @param expert_groups Expert group tibble
#' @param teaching_groups Teaching group tibble
#' @param jigsaw_num Jigsaw session number
#' @param date Session date
#' @param topic Session topic
#' @return Character string of markdown
format_groups_markdown <- function(expert_groups, teaching_groups,
                                    jigsaw_num, date, topic) {

  # Expert groups table
  expert_md <- expert_groups |>
    group_by(paper) |>
    summarize(students = paste(student, collapse = ", "), .groups = "drop") |>
    mutate(paper = paste("Paper", paper)) |>
    knitr::kable(col.names = c("Paper", "Students"), format = "markdown")

  # Teaching groups table
  teaching_md <- teaching_groups |>
    mutate(student_paper = paste0(student, " (P", paper, ")")) |>
    group_by(teaching_group) |>
    summarize(members = paste(student_paper, collapse = ", "), .groups = "drop") |>
    mutate(teaching_group = paste("Group", LETTERS[teaching_group])) |>
    knitr::kable(col.names = c("Group", "Members (Paper Assignment)"), format = "markdown")

  # Combine into full document
  yaml <- paste0(
    "---\n",
    "title: \"Jigsaw ", jigsaw_num, " Groups\"\n",
    "subtitle: \"", topic, " (", date, ")\"\n",
    "date: \"Generated: ", Sys.time(), "\"\n",
    "draft: true\n",
    "---\n\n"
  )

  content <- paste0(
    "## Expert Groups (Phase 1)\n\n",
    paste(expert_md, collapse = "\n"), "\n\n",
    "## Teaching Groups (Phase 2)\n\n",
    paste(teaching_md, collapse = "\n"), "\n"
  )

  return(paste0(yaml, content))
}

# ============================================================================
# GENERATE ALL JIGSAW GROUPS
# ============================================================================

# Jigsaw metadata
jigsaw_info <- tibble(
  num = 1:5,
  date = c("Jan 28", "Feb 18", "Mar 11", "Mar 25", "Apr 8"),
  topic = c("Experimental Design", "Double ML", "Causal Forests",
            "Policy Learning", "Quasi-Experimental ML")
)

# Generate groups for each jigsaw
for (i in 1:5) {
  seed <- jigsaw_seeds[i]

  # Generate groups
  expert <- generate_expert_groups(students, num_papers, seed)
  teaching <- create_teaching_groups(expert)

  # Format as markdown
  md_content <- format_groups_markdown(
    expert, teaching,
    jigsaw_info$num[i],
    jigsaw_info$date[i],
    jigsaw_info$topic[i]
  )

  # Write to file
  output_file <- paste0("jigsaw/groups/jigsaw-", i, "-groups.qmd")
  writeLines(md_content, output_file)
  cat("Generated:", output_file, "\n")
}

# ============================================================================
# SUMMARY REPORT
# ============================================================================

cat("\n=== Group Generation Summary ===\n")
cat("Students:", length(students), "\n")
cat("Papers per jigsaw:", num_papers, "\n")
cat("Expert group size:", length(students) %/% num_papers, "-",
    length(students) %/% num_papers + 1, "students\n")
cat("Teaching groups:", ceiling(length(students) / num_papers), "\n")
cat("\nFiles generated:\n")
for (i in 1:5) {
  cat("  - jigsaw/groups/jigsaw-", i, "-groups.qmd\n", sep = "")
}
