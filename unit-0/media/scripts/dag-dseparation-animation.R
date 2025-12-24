# DAG d-Separation Visualization
# Shows how conditioning blocks/opens paths in causal graphs
# Uses ggdag for DAG visualization

library(tidyverse)
library(ggdag)
library(dagitty)
library(patchwork)

# Set theme
theme_set(theme_dag())

# --- 1. CONFOUNDING (Fork) ---
# X -> Z, X -> Y, Z -> Y
# Path Z <- X -> Y is open (creates spurious association)
# Conditioning on X blocks the path

dag_confounding <- dagify(
  Y ~ Z + X,
  Z ~ X,
  exposure = "Z",
  outcome = "Y",
  coords = list(
    x = c(X = 1, Z = 0, Y = 2),
    y = c(X = 1, Z = 0, Y = 0)
  )
)

# Unadjusted
p_conf_open <- ggdag_paths(dag_confounding) +
  labs(title = "Confounding: Open Backdoor Path",
       subtitle = "Z \u2190 X \u2192 Y creates spurious association") +
  theme(plot.title = element_text(face = "bold"),
        legend.position = "none")

# Adjusted
p_conf_closed <- ggdag_adjustment_set(dag_confounding) +
  labs(title = "Confounding: Block by Conditioning on X",
       subtitle = "Adjusting for X closes the backdoor") +
  theme(plot.title = element_text(face = "bold"))

# --- 2. MEDIATOR (Chain) ---
# Z -> M -> Y
# Path through M is causal - DO NOT CONDITION

dag_mediator <- dagify(
  Y ~ M,
  M ~ Z,
  exposure = "Z",
  outcome = "Y",
  coords = list(
    x = c(Z = 0, M = 1, Y = 2),
    y = c(Z = 0, M = 0, Y = 0)
  )
)

p_mediator <- ggdag(dag_mediator, text = TRUE, use_labels = "name") +
  labs(title = "Mediator: Don't Condition!",
       subtitle = "Z \u2192 M \u2192 Y is the causal path") +
  theme(plot.title = element_text(face = "bold"))

# --- 3. COLLIDER ---
# Z -> C <- Y, Z -> Y
# Path Z -> C <- Y is blocked naturally
# Conditioning on C OPENS the path (collider bias!)

dag_collider <- dagify(
  C ~ Z + Y,
  Y ~ Z,
  exposure = "Z",
  outcome = "Y",
  coords = list(
    x = c(Z = 0, C = 1, Y = 2),
    y = c(Z = 0, C = -1, Y = 0)
  )
)

p_collider_closed <- ggdag(dag_collider, text = TRUE, use_labels = "name") +
  labs(title = "Collider: Path Naturally Blocked",
       subtitle = "Z \u2192 C \u2190 Y is blocked (don't condition on C!)") +
  theme(plot.title = element_text(face = "bold"))

# --- 4. Hospital Selection Bias Example ---
# Classic example: Treatment appears harmful in hospital data

dag_hospital <- dagify(
  H ~ D + T,  # Hospital admission depends on disease and treatment
  Y ~ D + T,  # Outcome depends on disease and treatment
  exposure = "T",
  outcome = "Y",
  labels = c(T = "Treatment", D = "Disease\nSeverity",
             H = "Hospital\nAdmission", Y = "Outcome"),
  coords = list(
    x = c(T = 0, D = 2, H = 1, Y = 1),
    y = c(T = 1, D = 1, H = 0, Y = 2)
  )
)

p_hospital <- ggdag(dag_hospital, text = TRUE, use_labels = "label") +
  labs(title = "Hospital Selection Bias (Collider)",
       subtitle = "Conditioning on admission biases treatment-outcome relationship") +
  theme(plot.title = element_text(face = "bold", size = 12),
        plot.subtitle = element_text(size = 10))

# --- SAVE INDIVIDUAL PLOTS ---

# Save confounding comparison
ggsave("../dag-confounding-open.png", p_conf_open, width = 6, height = 4, dpi = 150)
ggsave("../dag-confounding-closed.png", p_conf_closed, width = 6, height = 4, dpi = 150)

# Combined confounding plot
p_conf_combined <- p_conf_open + p_conf_closed +
  plot_annotation(
    title = "d-Separation: Blocking the Backdoor Path",
    theme = theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 14))
  )
ggsave("../dag-confounding-combined.png", p_conf_combined, width = 12, height = 5, dpi = 150)

# Save mediator
ggsave("../dag-mediator.png", p_mediator, width = 6, height = 4, dpi = 150)

# Save collider
ggsave("../dag-collider.png", p_collider_closed, width = 6, height = 4, dpi = 150)

# Save hospital example
ggsave("../dag-hospital-selection.png", p_hospital, width = 7, height = 5, dpi = 150)

# --- COMPREHENSIVE SUMMARY PLOT ---

p_summary <- (p_conf_open | p_mediator) /
             (p_collider_closed | p_hospital) +
  plot_annotation(
    title = "d-Separation Rules: When Paths Are Open vs. Blocked",
    subtitle = "Understanding when conditioning helps (forks) vs. hurts (colliders)",
    theme = theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
      plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray40")
    )
  )

ggsave("../dag-dseparation-summary.png", p_summary, width = 14, height = 10, dpi = 150)

message("Saved DAG visualizations to unit-0/media/:")
message("  - dag-confounding-open.png")
message("  - dag-confounding-closed.png")
message("  - dag-confounding-combined.png")
message("  - dag-mediator.png")
message("  - dag-collider.png")
message("  - dag-hospital-selection.png")
message("  - dag-dseparation-summary.png")
