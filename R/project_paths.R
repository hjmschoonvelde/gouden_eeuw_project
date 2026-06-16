project_root <- function() {
  env_root <- Sys.getenv("GE_PROJECT_ROOT", unset = "")
  if (nzchar(env_root)) {
    return(normalizePath(env_root, mustWork = TRUE))
  }

  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)

  if (length(file_arg) > 0) {
    script_file <- sub("^--file=", "", file_arg[[1]])
    script_dir <- dirname(normalizePath(script_file, mustWork = TRUE))
    return(normalizePath(file.path(script_dir, ".."), mustWork = TRUE))
  }

  normalizePath(getwd(), mustWork = TRUE)
}

ge_path <- function(...) {
  file.path(project_root(), ...)
}

ensure_dir <- function(...) {
  path <- ge_path(...)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path
}

require_packages <- function(packages) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    stop(
      "Install the required R package(s) before running this script: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

check_columns <- function(data, columns, data_name = deparse(substitute(data))) {
  missing <- setdiff(columns, names(data))
  if (length(missing) > 0) {
    stop(
      data_name, " is missing required column(s): ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  invisible(TRUE)
}
