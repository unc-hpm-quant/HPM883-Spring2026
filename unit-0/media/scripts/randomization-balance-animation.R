# Randomization Balance Animation
# Shows how random assignment creates comparable groups
# Creates a GIF demonstrating covariate balance under randomization

library(tidyverse)
library(gganimate)
library(gifski)
library(patchwork)

set.seed(883)

# Parameters
n_total <- 100
n_sims <- 5  # Number of randomization draws to show

# Create population with covariates
population <- tibble(
  id = 1:n_total,
  age = round(rnorm(n_total, 50, 10)),
  severity = round(rnorm(n_total, 5, 2), 1),
  prior_visits = rpois(n_total, 3)
)

# Function to create randomization
randomize <- function(pop, seed) {
  set.seed(seed)
  pop %>%
    mutate(treatment = sample(rep(c(0, 1), each = n() / 2)))
}

# Generate multiple randomizations
randomizations <- map_dfr(1:n_sims, function(i) {
  randomize(population, seed = i * 100) %>%
    mutate(sim = i)
})

# Calculate means by treatment for each simulation
balance_stats <- randomizations %>%
  group_by(sim, treatment) %>%
  summarise(
    mean_age = mean(age),
    mean_severity = mean(severity),
    mean_visits = mean(prior_visits),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = starts_with("mean_"),
               names_to = "variable",
               values_to = "mean") %>%
  mutate(
    variable = str_remove(variable, "mean_"),
    variable = case_when(
      variable == "age" ~ "Age",
      variable == "severity" ~ "Severity",
      variable == "visits" ~ "Prior Visits"
    ),
    group = ifelse(treatment == 1, "Treatment", "Control")
  )

# Add initial "Before Randomization" frame (population means)
pop_means <- population %>%
  summarise(
    mean_age = mean(age),
    mean_severity = mean(severity),
    mean_visits = mean(prior_visits)
  ) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "mean") %>%
  mutate(
    variable = str_remove(variable, "mean_"),
    variable = case_when(
      variable == "age" ~ "Age",
      variable == "severity" ~ "Severity",
      variable == "visits" ~ "Prior Visits"
    )
  )

# Animation: Show individual randomization outcomes
p_balance <- ggplot(balance_stats, aes(x = variable, y = mean, fill = group)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7, alpha = 0.8) +
  geom_hline(data = pop_means, aes(yintercept = mean),
             linetype = "dashed", color = "gray40", linewidth = 0.5) +
  scale_fill_manual(values = c("Control" = "#4BACC6", "Treatment" = "#9BBB59")) +
  facet_wrap(~variable, scales = "free_y", nrow = 1) +
  labs(
    title = "Randomization Creates Balanced Groups",
    subtitle = "Randomization #{closest_state}",
    x = NULL,
    y = "Mean Value",
    fill = NULL,
    caption = "Dashed line = population mean"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray40"),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 11),
    panel.grid.major.x = element_blank()
  ) +
  transition_states(sim, transition_length = 1, state_length = 2) +
  ease_aes('cubic-in-out')

# Render
anim_balance <- animate(p_balance,
                        nframes = 60,
                        fps = 10,
                        width = 700,
                        height = 400,
                        renderer = gifski_renderer())

# Save
anim_save("../randomization-balance-animation.gif", anim_balance)

message("Saved: unit-0/media/randomization-balance-animation.gif")

# --- Alternative: Dot plot showing unit assignment ---

# Create animation showing dots moving to treatment/control
dot_data <- randomizations %>%
  filter(sim <= 3) %>%  # Just show 3 randomizations
  select(id, age, severity, treatment, sim) %>%
  mutate(
    x_pos = ifelse(treatment == 1, 2, 1),
    group = ifelse(treatment == 1, "Treatment", "Control")
  )

# Add initial state (all together)
initial_state <- population %>%
  mutate(
    sim = 0,
    treatment = NA,
    x_pos = 1.5,
    group = "Unassigned"
  )

dot_anim_data <- bind_rows(initial_state, dot_data)

p_dots <- ggplot(dot_anim_data, aes(x = x_pos, y = age, color = group)) +
  geom_point(alpha = 0.6, size = 2) +
  scale_color_manual(values = c("Control" = "#4BACC6", "Treatment" = "#9BBB59",
                                 "Unassigned" = "gray60")) +
  scale_x_continuous(breaks = c(1, 1.5, 2), labels = c("Control", "Pool", "Treatment"),
                     limits = c(0.5, 2.5)) +
  labs(
    title = "Random Assignment",
    subtitle = "{if(closest_state == 0) 'Initial pool' else paste('Randomization', closest_state)}",
    x = NULL,
    y = "Age",
    color = NULL
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray40"),
    legend.position = "none",
    panel.grid.major.x = element_blank()
  ) +
  transition_states(sim, transition_length = 2, state_length = 2) +
  ease_aes('cubic-in-out')

# Render
anim_dots <- animate(p_dots,
                     nframes = 80,
                     fps = 10,
                     width = 500,
                     height = 400,
                     renderer = gifski_renderer())

# Save alternative version
anim_save("../randomization-dots-animation.gif", anim_dots)

message("Saved: unit-0/media/randomization-dots-animation.gif")
