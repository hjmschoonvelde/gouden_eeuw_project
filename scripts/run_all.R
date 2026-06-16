args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script_dir <- if (length(file_arg) > 0) {
  dirname(normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = TRUE))
} else {
  getwd()
}
root_dir <- normalizePath(file.path(script_dir, ".."), mustWork = TRUE)
Sys.setenv(GE_PROJECT_ROOT = root_dir)

scripts <- c(
  "00_check_environment.R",
  "01_reproduce_figures_tables.R",
  "02_validate_llm_coding.R"
)

for (script in scripts) {
  message("\n== Running ", script, " ==")
  source(file.path(root_dir, "scripts", script), local = new.env(parent = globalenv()))
}

message("\nAll default reproduction steps completed.")
