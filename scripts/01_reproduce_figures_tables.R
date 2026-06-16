args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script_dir <- if (length(file_arg) > 0) {
  dirname(normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = TRUE))
} else {
  getwd()
}
root_dir <- normalizePath(file.path(script_dir, ".."), mustWork = TRUE)
Sys.setenv(GE_PROJECT_ROOT = root_dir)

source(file.path(root_dir, "R", "project_paths.R"))
require_packages(c("dplyr", "ggplot2", "readr", "tidyr"))

library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

fig_dir <- ensure_dir("outputs", "figures")
table_dir <- ensure_dir("outputs", "tables")

df_final <- read_csv(
  ge_path("data", "derived", "ge_final_45_24.csv"),
  show_col_types = FALSE
)

required_columns <- c(
  "speech_id",
  "year",
  "party_ref",
  "include_for_coding",
  "temporal_grammar_code",
  "symbolic_work_code"
)
check_columns(df_final, required_columns, "ge_final_45_24.csv")

df_base <- df_final %>%
  mutate(
    year = as.integer(year),
    include_for_coding = as.logical(include_for_coding),
    party = sub("^nl\\.p\\.", "", party_ref)
  ) %>%
  filter(
    include_for_coding,
    !is.na(temporal_grammar_code),
    temporal_grammar_code != "TG5",
    !is.na(symbolic_work_code)
  )

summary_table <- tibble(
  measure = c(
    "analytic_speeches",
    "first_year",
    "last_year",
    "temporal_grammar_categories",
    "symbolic_work_categories"
  ),
  value = c(
    nrow(df_base),
    min(df_base$year, na.rm = TRUE),
    max(df_base$year, na.rm = TRUE),
    paste(sort(unique(df_base$temporal_grammar_code)), collapse = ", "),
    paste(sort(unique(df_base$symbolic_work_code)), collapse = ", ")
  )
)
write_csv(summary_table, file.path(table_dir, "analysis_summary.csv"))

tg_levels <- c("TG1", "TG2", "TG3", "TG4")
sw_levels <- c("SW1", "SW2", "SW3", "SW4", "SW5")

tg_sw_long <- df_base %>%
  count(temporal_grammar_code, symbolic_work_code, name = "n") %>%
  complete(
    temporal_grammar_code = tg_levels,
    symbolic_work_code = sw_levels,
    fill = list(n = 0)
  ) %>%
  mutate(
    percent_total = 100 * n / sum(n),
    label = ifelse(n == 0, "0", sprintf("%d\n(%.1f%%)", n, percent_total))
  )

write_csv(tg_sw_long, file.path(table_dir, "tg_sw_matrix_long.csv"))

tg_sw_wide <- tg_sw_long %>%
  select(temporal_grammar_code, symbolic_work_code, n) %>%
  pivot_wider(
    names_from = symbolic_work_code,
    values_from = n
  ) %>%
  arrange(match(temporal_grammar_code, tg_levels))

write_csv(tg_sw_wide, file.path(table_dir, "tg_sw_matrix_wide.csv"))

tg_totals <- df_base %>%
  count(temporal_grammar_code, name = "n") %>%
  mutate(
    percent = 100 * n / sum(n),
    axis_label = sprintf("%s\n%.1f%%", temporal_grammar_code, percent)
  )

sw_totals <- df_base %>%
  count(symbolic_work_code, name = "n") %>%
  mutate(
    percent = 100 * n / sum(n),
    axis_label = sprintf("%s\n%.1f%%", symbolic_work_code, percent)
  )

tg_labels <- setNames(tg_totals$axis_label, tg_totals$temporal_grammar_code)
sw_labels <- setNames(sw_totals$axis_label, sw_totals$symbolic_work_code)

matrix_plot <- ggplot(
  tg_sw_long,
  aes(x = temporal_grammar_code, y = symbolic_work_code)
) +
  geom_tile(aes(fill = n), color = "white", linewidth = 0.5) +
  geom_text(aes(label = label), size = 3.8, lineheight = 0.95) +
  scale_x_discrete(labels = tg_labels, drop = FALSE) +
  scale_y_discrete(labels = sw_labels, drop = FALSE) +
  scale_fill_gradient(low = "#f4f4f4", high = "#b08a00") +
  labs(x = NULL, y = NULL, fill = "Count") +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    legend.position = "right"
  )

ggsave(
  filename = file.path(fig_dir, "tg_sw_matrix.png"),
  plot = matrix_plot,
  width = 8,
  height = 5,
  dpi = 300,
  bg = "white"
)

periods <- df_base %>%
  mutate(
    period = case_when(
      year >= 1945 & year <= 1970 ~ "1945-1970",
      year >= 1971 & year <= 1990 ~ "1971-1990",
      year >= 1991 & year <= 2010 ~ "1991-2010",
      year >= 2011 & year <= 2024 ~ "2011-2024",
      TRUE ~ NA_character_
    ),
    combo = paste(temporal_grammar_code, symbolic_work_code, sep = "-")
  ) %>%
  filter(!is.na(period))

top3_by_period <- periods %>%
  count(period, combo, name = "n") %>%
  group_by(period) %>%
  slice_max(n, n = 3, with_ties = FALSE) %>%
  ungroup() %>%
  arrange(period, desc(n))

write_csv(top3_by_period, file.path(table_dir, "top3_tg_sw_by_period.csv"))

top3_plot <- top3_by_period %>%
  mutate(combo = reorder(combo, n)) %>%
  ggplot(aes(x = n, y = combo, fill = combo)) +
  geom_col(width = 0.7, show.legend = FALSE) +
  geom_text(aes(label = n), hjust = -0.15, size = 3.4) +
  facet_wrap(~ period, scales = "free_y") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.18))) +
  labs(x = "Speeches", y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave(
  filename = file.path(fig_dir, "top3_tg_sw_by_period.png"),
  plot = top3_plot,
  width = 9,
  height = 5,
  dpi = 300,
  bg = "white"
)

annual_counts <- df_base %>%
  count(year, temporal_grammar_code, name = "n") %>%
  complete(
    year = seq(min(df_base$year, na.rm = TRUE), max(df_base$year, na.rm = TRUE)),
    temporal_grammar_code = tg_levels,
    fill = list(n = 0)
  )

write_csv(annual_counts, file.path(table_dir, "annual_temporal_grammar_counts.csv"))

annual_plot <- ggplot(
  annual_counts,
  aes(x = year, y = n, color = temporal_grammar_code)
) +
  geom_line(linewidth = 0.5) +
  geom_point(size = 0.8, alpha = 0.6) +
  labs(x = NULL, y = "Speeches", color = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave(
  filename = file.path(fig_dir, "annual_temporal_grammar_counts.png"),
  plot = annual_plot,
  width = 9,
  height = 5,
  dpi = 300,
  bg = "white"
)

party_counts <- df_base %>%
  filter(!is.na(party), party != "") %>%
  count(party, temporal_grammar_code, name = "n") %>%
  group_by(party) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  filter(total >= 5)

write_csv(party_counts, file.path(table_dir, "party_temporal_grammar_counts.csv"))

party_order <- party_counts %>%
  distinct(party, total) %>%
  arrange(total) %>%
  pull(party)

party_plot <- party_counts %>%
  mutate(party = factor(party, levels = party_order)) %>%
  ggplot(aes(x = n, y = party, fill = temporal_grammar_code)) +
  geom_col(width = 0.75) +
  labs(x = "Speeches", y = NULL, fill = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave(
  filename = file.path(fig_dir, "party_temporal_grammar_counts.png"),
  plot = party_plot,
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)

message("Wrote reproduction outputs to: ", ge_path("outputs"))
