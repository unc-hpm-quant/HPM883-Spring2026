# DML Partialling-Out Animation (v2)
# HPM 883 Unit 2: Double Machine Learning
# 6-stage pedagogical animation showing FWL/partialling-out process
#
# Points colored by confounder X throughout (blue=low, red=high).
# Students see color clustering disappear as confounding is removed.
#
# Stages:
#   1: Raw D vs Y (confounded, steep slope)
#   2: Partial out X from D (points slide horizontally)
#   3: D-tilde vs Y (intermediate, Y still confounded)
#   4: Partial out X from Y (points slide vertically)
#   5: D-tilde vs Y-tilde (DML estimate, correct slope)
#   6: Final comparison with both estimates annotated

library(tidyverse)
library(gganimate)

set.seed(883)

# ── DGP ──────────────────────────────────────────────────────────────────────
n <- 200
X <- rnorm(n)                              # confounder
D <- 0.5 * X + rnorm(n, sd = 0.5)         # treatment (confounded by X)
Y <- 1.5 * D + 2 * X + rnorm(n, sd = 0.5) # outcome (true effect = 1.5)

df <- tibble(id = 1:n, X = X, D = D, Y = Y)

# ── Estimates ────────────────────────────────────────────────────────────────
naive_coef <- round(coef(lm(Y ~ D, data = df))["D"], 2)

# Residualize D on X
D_tilde <- residuals(lm(D ~ X, data = df))

# Residualize Y on X
Y_tilde <- residuals(lm(Y ~ X, data = df))

# DML estimate
dml_coef <- round(coef(lm(Y_tilde ~ D_tilde))["D_tilde"], 2)

cat("Naive estimate:", naive_coef, "(biased)\n")
cat("DML estimate:  ", dml_coef, "(true = 1.5)\n")

# ── Build 6-stage animation data ────────────────────────────────────────────
# Each stage has different x_plot/y_plot for the same points (id tracks them).
# gganimate tweens between stages, so:
#   1 -> 2: points slide horizontally (D -> D_tilde)
#   2 -> 3: no movement (pause on intermediate)
#   3 -> 4: points slide vertically (Y -> Y_tilde)
#   4 -> 5: no movement (pause on final)
#   5 -> 6: no movement (comparison annotation)

df_anim <- bind_rows(
  # Stage 1: Raw scatter
  df |> mutate(stage = 1L, x_plot = D, y_plot = Y),
  # Stage 2: D residualized, Y still raw
  df |> mutate(stage = 2L, x_plot = D_tilde, y_plot = Y),
  # Stage 3: Pause on D-tilde vs Y (same as 2)
  df |> mutate(stage = 3L, x_plot = D_tilde, y_plot = Y),
  # Stage 4: Both residualized
  df |> mutate(stage = 4L, x_plot = D_tilde, y_plot = Y_tilde),
  # Stage 5: Pause on final (same as 4)
  df |> mutate(stage = 5L, x_plot = D_tilde, y_plot = Y_tilde),
  # Stage 6: Comparison (same positions, different annotation)
  df |> mutate(stage = 6L, x_plot = D_tilde, y_plot = Y_tilde)
)

# ── Stage labels ─────────────────────────────────────────────────────────────
stage_titles <- c(
  "1" = "Raw Data: D vs Y (Confounded)",
  "2" = "Step 1: Remove X\u2019s Influence on D",
  "3" = "After Purging D: \u0044\u0303 vs Y",
  "4" = "Step 2: Remove X\u2019s Influence on Y",
  "5" = "DML Estimate: \u0044\u0303 vs \u0059\u0303 (Deconfounded!)",
  "6" = "Partialling Out Removes Confounding"
)

stage_subtitles <- c(
  "1" = paste0("Naive \u03b8\u0302 = ", naive_coef, " \u2014 but true effect is 1.5!"),
  "2" = "\u0044\u0303 = D \u2212 m\u0302(X) \u2014 only 'clean' treatment variation remains",
  "3" = "Better, but Y still carries X\u2019s influence\u2026",
  "4" = "\u0059\u0303 = Y \u2212 g\u0302(X) \u2014 only 'clean' outcome variation remains",
  "5" = paste0("\u03b8\u0302_DML = ", dml_coef, " (true = 1.5) \u2713"),
  "6" = paste0("Naive: ", naive_coef, " (biased) \u2192 DML: ", dml_coef, " (true = 1.5)")
)

# ── Plot ─────────────────────────────────────────────────────────────────────
p <- ggplot(df_anim, aes(x = x_plot, y = y_plot, group = id)) +
  geom_point(aes(color = X), alpha = 0.6, size = 2) +
  scale_color_gradient2(
    low = "#3b82f6", mid = "#94a3b8", high = "#ef4444",
    midpoint = 0, name = "X (confounder)"
  ) +
  geom_smooth(
    aes(group = 1),
    method = "lm", formula = y ~ x,
    se = FALSE, color = "#1e293b", linewidth = 1.3
  ) +
  labs(
    title = "{stage_titles[as.character(closest_state)]}",
    subtitle = "{stage_subtitles[as.character(closest_state)]}",
    x = "Treatment (D or \u0044\u0303)",
    y = "Outcome (Y or \u0059\u0303)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(
      size = 17, face = "bold", color = "#1e293b",
      margin = margin(b = 2)
    ),
    plot.subtitle = element_text(
      size = 13, color = "#dc2626",
      margin = margin(b = 10)
    ),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    plot.margin = margin(15, 15, 10, 10),
    legend.position = "bottom",
    legend.key.width = unit(1.5, "cm")
  ) +
  transition_states(stage, transition_length = 2, state_length = 3) +
  ease_aes("cubic-in-out") +
  view_follow(fixed_x = FALSE, fixed_y = FALSE)

# ── Render ───────────────────────────────────────────────────────────────────
output_path <- here::here("unit-2", "media", "dml_partialling_out_v2.gif")

animate(
  p,
  nframes = 200,
  fps = 15,
  width = 900,
  height = 600,
  renderer = gifski_renderer(output_path)
)

cat("Animation saved to:", output_path, "\n")
