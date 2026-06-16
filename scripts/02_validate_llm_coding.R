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
source(file.path(root_dir, "R", "metrics.R"))
require_packages(c("dplyr", "readr"))

library(dplyr)
library(readr)

table_dir <- ensure_dir("outputs", "tables")

validation <- read_csv(
  ge_path("data", "validation", "human_o3_validation_44.csv"),
  show_col_types = FALSE
)

required_columns <- c(
  "speech_id",
  "include_for_coding",
  "temporal_grammar_code",
  "symbolic_work_code",
  "include_for_coding_final",
  "temporal_grammar_code_final",
  "symbolic_work_code_final"
)
check_columns(validation, required_columns, "human_o3_validation_44.csv")

validation <- validation %>%
  mutate(
    include_for_coding = normalise_binary(include_for_coding),
    include_for_coding_final = normalise_binary(include_for_coding_final),
    temporal_grammar_code = normalise_code(temporal_grammar_code, prefix = "TG"),
    temporal_grammar_code_final = normalise_code(temporal_grammar_code_final, prefix = "TG"),
    symbolic_work_code = normalise_code(symbolic_work_code, prefix = "SW"),
    symbolic_work_code_final = normalise_code(symbolic_work_code_final, prefix = "SW")
  )

inclusion_metrics <- binary_metrics(
  truth = validation$include_for_coding,
  prediction = validation$include_for_coding_final,
  positive = TRUE
) %>%
  mutate(task = "include_for_coding", .before = 1)

write_csv(inclusion_metrics, file.path(table_dir, "validation_inclusion_metrics.csv"))

positive_rows <- validation %>%
  filter(include_for_coding, include_for_coding_final)

tg_metrics <- one_vs_rest_metrics(
  truth = positive_rows$temporal_grammar_code,
  prediction = positive_rows$temporal_grammar_code_final,
  classes = c("TG1", "TG2", "TG3", "TG4")
) %>%
  mutate(task = "temporal_grammar", .before = 1)

sw_metrics <- one_vs_rest_metrics(
  truth = positive_rows$symbolic_work_code,
  prediction = positive_rows$symbolic_work_code_final,
  classes = c("SW1", "SW2", "SW3", "SW4", "SW5")
) %>%
  mutate(task = "symbolic_work", .before = 1)

write_csv(tg_metrics, file.path(table_dir, "validation_temporal_grammar_metrics.csv"))
write_csv(sw_metrics, file.path(table_dir, "validation_symbolic_work_metrics.csv"))
write_csv(
  bind_rows(inclusion_metrics, tg_metrics, sw_metrics),
  file.path(table_dir, "validation_metrics_all.csv")
)

message("Validation metrics written to: ", table_dir)
