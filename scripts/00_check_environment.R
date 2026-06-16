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

required_packages <- c(
  "dplyr",
  "ggplot2",
  "readr",
  "tidyr"
)

optional_packages <- c(
  "data.table",
  "ellmer",
  "jsonlite",
  "quanteda",
  "quanteda.textstats",
  "stringr",
  "word2vec"
)

required_missing <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

optional_missing <- optional_packages[
  !vapply(optional_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(required_missing) > 0) {
  stop(
    "Required package(s) missing: ",
    paste(required_missing, collapse = ", "),
    call. = FALSE
  )
}

message("Required packages available: ", paste(required_packages, collapse = ", "))

if (length(optional_missing) > 0) {
  message(
    "Optional packages not installed: ",
    paste(optional_missing, collapse = ", "),
    ". These are only needed for API annotation or full-corpus retrieval."
  )
} else {
  message("Optional packages available: ", paste(optional_packages, collapse = ", "))
}
