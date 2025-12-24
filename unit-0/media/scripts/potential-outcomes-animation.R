# Potential Outcomes Animation
# Illustrates the fundamental problem of causal inference
# Creates a GIF showing that we can only observe one potential outcome per unit

library(tidyverse)
library(gganimate)
library(gifski)

set.seed(883)

# Parameters
n_units <- 8  # Number of units to display

# Create potential outcomes data
df <- tibble(
  unit = 1:n_units,
  Y0 = round(rnorm(n_units, mean = 50, sd = 10)),  # Potential outcome under control
  Y1 = Y0 + round(rnorm(n_units, mean = 15, sd = 5)),  # Potential outcome under treatment (true effect ~15)
  tau = Y1 - Y0,  # Individual treatment effect
  Z = rep(c(0, 1), length.out = n_units),  # Treatment assignment (alternating for demo)
  Y_obs = ifelse(Z == 1, Y1, Y0)  # Observed outcome
)

# Long format for animation
df_long <- df %>%
  mutate(
    # State 1: Show both potential outcomes (hypothetical)
    # State 2: Show only observed (based on treatment)
    # State 3: Show the masked/counterfactual
    state = 1
  ) %>%
  bind_rows(
    df %>% mutate(state = 2),
    df %>% mutate(state = 3)
  )

# Create the plot data with proper masking
df_plot <- df %>%
  select(unit, Y0, Y1, Z) %>%
  pivot_longer(cols = c(Y0, Y1), names_to = "potential", values_to = "value") %>%
  mutate(
    treated = (potential == "Y1"),
    observed = (Z == 1 & potential == "Y1") | (Z == 0 & potential == "Y0"),
    label = case_when(
      observed ~ as.character(value),
      TRUE ~ "?"
    ),
    alpha_val = ifelse(observed, 1, 0.3),
    outcome_label = ifelse(potential == "Y1", "Y(1)", "Y(0)")
  )

# Frame 1: Full table with all potential outcomes visible
frame1 <- df %>%
  select(unit, Y0, Y1, tau) %>%
  mutate(
    frame = 1,
    Y0_show = as.character(Y0),
    Y1_show = as.character(Y1),
    tau_show = as.character(tau)
  )

# Frame 2: Mask unobserved based on treatment assignment
frame2 <- df %>%
  select(unit, Y0, Y1, tau, Z) %>%
  mutate(
    frame = 2,
    Y0_show = ifelse(Z == 0, as.character(Y0), "?"),
    Y1_show = ifelse(Z == 1, as.character(Y1), "?"),
    tau_show = "?"
  )

# Combine frames
frames_data <- bind_rows(
  frame1 %>% mutate(Z = NA),
  frame2
)

# Create base table visualization
create_table_frame <- function(data, show_tau = TRUE) {
  # Table header positions
  header_y <- 9
  y_positions <- seq(8, 1, by = -1)

  # Create plotting data
  plot_data <- tibble(
    unit = data$unit,
    y = y_positions[1:nrow(data)],
    Y0_show = data$Y0_show,
    Y1_show = data$Y1_show,
    tau_show = data$tau_show
  )

  p <- ggplot() +
    # Column headers
    annotate("text", x = 1, y = header_y, label = "Unit", fontface = "bold", size = 5) +
    annotate("text", x = 2, y = header_y, label = "Y(0)", fontface = "bold", size = 5) +
    annotate("text", x = 3, y = header_y, label = "Y(1)", fontface = "bold", size = 5) +
    annotate("text", x = 4, y = header_y, label = expression(tau[i]), fontface = "bold", size = 5, parse = TRUE) +
    # Unit numbers
    geom_text(data = plot_data, aes(x = 1, y = y, label = unit), size = 4) +
    # Y(0) values
    geom_text(data = plot_data, aes(x = 2, y = y, label = Y0_show), size = 4,
              color = ifelse(plot_data$Y0_show == "?", "gray50", "black")) +
    # Y(1) values
    geom_text(data = plot_data, aes(x = 3, y = y, label = Y1_show), size = 4,
              color = ifelse(plot_data$Y1_show == "?", "gray50", "black")) +
    # tau values
    geom_text(data = plot_data, aes(x = 4, y = y, label = tau_show), size = 4,
              color = ifelse(plot_data$tau_show == "?", "gray50", "steelblue")) +
    # Styling
    xlim(0.5, 4.5) +
    ylim(0, 10) +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "white", color = NA),
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5, size = 11, color = "gray40")
    )

  return(p)
}

# Animation data for gganimate
anim_data <- frames_data %>%
  group_by(frame) %>%
  mutate(y_pos = 8 - row_number() + 1) %>%
  ungroup() %>%
  pivot_longer(cols = c(Y0_show, Y1_show, tau_show),
               names_to = "column", values_to = "value") %>%
  mutate(
    x_pos = case_when(
      column == "Y0_show" ~ 2,
      column == "Y1_show" ~ 3,
      column == "tau_show" ~ 4
    ),
    is_hidden = (value == "?"),
    text_color = ifelse(is_hidden, "gray60", "black")
  )

# Add unit column separately
unit_data <- frames_data %>%
  group_by(frame) %>%
  mutate(y_pos = 8 - row_number() + 1) %>%
  ungroup() %>%
  select(frame, unit, y_pos) %>%
  mutate(x_pos = 1, value = as.character(unit))

# Combine
plot_data <- bind_rows(
  anim_data %>% select(frame, x_pos, y_pos, value, is_hidden),
  unit_data %>% mutate(is_hidden = FALSE)
)

# Create animated plot
p_anim <- ggplot(plot_data, aes(x = x_pos, y = y_pos)) +
  # Data values
  geom_text(aes(label = value, color = is_hidden), size = 5) +
  scale_color_manual(values = c("TRUE" = "gray60", "FALSE" = "black"), guide = "none") +
  # Column headers (static)
  annotate("text", x = 1, y = 9, label = "Unit", fontface = "bold", size = 6) +
  annotate("text", x = 2, y = 9, label = "Y(0)", fontface = "bold", size = 6) +
  annotate("text", x = 3, y = 9, label = "Y(1)", fontface = "bold", size = 6) +
  annotate("text", x = 4, y = 9, label = "\u03C4\u1D62", fontface = "bold", size = 6) +
  # Header line
  annotate("segment", x = 0.5, xend = 4.5, y = 8.5, yend = 8.5, color = "gray40") +
  # Styling
  xlim(0.5, 4.5) +
  ylim(0, 10) +
  labs(
    title = "The Fundamental Problem of Causal Inference",
    subtitle = "{if(closest_state == 1) 'Potential outcomes (if we could see everything)' else 'Reality: We only observe ONE outcome per unit'}"
  ) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold", margin = margin(b = 5)),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray40", margin = margin(b = 15))
  ) +
  # Animation
  transition_states(frame, transition_length = 2, state_length = 3) +
  ease_aes('cubic-in-out')

# Render animation
anim <- animate(p_anim,
                nframes = 60,
                fps = 10,
                width = 600,
                height = 400,
                renderer = gifski_renderer())

# Save
anim_save("../potential-outcomes-animation.gif", anim)

message("Saved: unit-0/media/potential-outcomes-animation.gif")
