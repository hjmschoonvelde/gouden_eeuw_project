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
require_packages(c("dplyr", "ellmer", "jsonlite", "readr"))

library(dplyr)
library(ellmer)
library(jsonlite)
library(readr)

run_flag <- tolower(Sys.getenv("RUN_OPENAI_ANNOTATION", unset = "false"))
if (!run_flag %in% c("true", "1", "yes")) {
  message(
    "Skipping API annotation. Set RUN_OPENAI_ANNOTATION=true and OPENAI_API_KEY ",
    "to run this optional workflow."
  )
  quit(save = "no", status = 0)
}

if (!nzchar(Sys.getenv("OPENAI_API_KEY", unset = ""))) {
  stop("OPENAI_API_KEY is not set. Do not store API keys in this repository.", call. = FALSE)
}

input_file <- Sys.getenv(
  "GE_ANNOTATION_INPUT",
  unset = ge_path("data", "candidate", "df_ge_high.csv")
)
model <- Sys.getenv("OPENAI_MODEL", unset = "o3")
temperature <- as.numeric(Sys.getenv("OPENAI_TEMPERATURE", unset = "0"))
limit <- as.integer(Sys.getenv("GE_ANNOTATION_LIMIT", unset = "0"))
batch_sleep <- as.numeric(Sys.getenv("GE_ANNOTATION_SLEEP", unset = "0"))
max_retries <- as.integer(Sys.getenv("GE_ANNOTATION_MAX_RETRIES", unset = "3"))

system_prompt <- read_file(ge_path("prompts", "annotation_prompt.txt"))
candidate_speeches <- read_csv(input_file, show_col_types = FALSE)
check_columns(candidate_speeches, c("speech_id", "text"), basename(input_file))

if (!is.na(limit) && limit > 0) {
  candidate_speeches <- candidate_speeches %>% slice_head(n = limit)
}

query_one <- function(text, system_prompt, model, temperature, max_retries) {
  chat <- ellmer::chat_openai(
    system_prompt = system_prompt,
    model = model,
    params = ellmer::params(temperature = temperature)
  )

  attempt <- 0L
  while (attempt <= max_retries) {
    attempt <- attempt + 1L
    response <- tryCatch(chat$chat(text), error = function(e) e)

    if (!inherits(response, "error")) {
      if (is.character(response)) {
        return(response)
      }
      if (!is.null(response$text)) {
        return(as.character(response$text))
      }
      return(as.character(response))
    }

    message <- conditionMessage(response)
    transient <- grepl(
      "429|rate|timeout|temporar|overload|503|502|504",
      message,
      ignore.case = TRUE
    )
    if (attempt <= max_retries && transient) {
      Sys.sleep(2^(attempt - 1L))
    } else {
      return(paste0("ERROR: ", message))
    }
  }

  NA_character_
}

parse_output <- function(raw_output) {
  if (is.na(raw_output) || startsWith(raw_output, "ERROR:")) {
    return(list(
      include_for_coding = NA,
      temporal_grammar_code = NA_character_,
      symbolic_work_code = NA_character_,
      notes = raw_output
    ))
  }

  cleaned <- raw_output
  cleaned <- sub("^```json[[:space:]]*", "", cleaned)
  cleaned <- sub("^```[[:space:]]*", "", cleaned)
  cleaned <- sub("[[:space:]]*```$", "", cleaned)

  parsed <- tryCatch(jsonlite::fromJSON(cleaned), error = function(e) NULL)
  if (is.null(parsed)) {
    return(list(
      include_for_coding = NA,
      temporal_grammar_code = NA_character_,
      symbolic_work_code = NA_character_,
      notes = "Could not parse model output as JSON."
    ))
  }

  list(
    include_for_coding = parsed$include_for_coding %||% NA,
    temporal_grammar_code = parsed$temporal_grammar$code %||% NA_character_,
    symbolic_work_code = parsed$symbolic_work$primary$code %||% NA_character_,
    notes = parsed$notes %||% NA_character_
  )
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0) {
    y
  } else {
    x
  }
}

raw_outputs <- character(nrow(candidate_speeches))

for (i in seq_len(nrow(candidate_speeches))) {
  raw_outputs[[i]] <- query_one(
    text = candidate_speeches$text[[i]],
    system_prompt = system_prompt,
    model = model,
    temperature = temperature,
    max_retries = max_retries
  )

  if (batch_sleep > 0) {
    Sys.sleep(batch_sleep)
  }

  if (i %% 10 == 0 || i == nrow(candidate_speeches)) {
    message("Annotated ", i, " / ", nrow(candidate_speeches), " speeches.")
  }
}

parsed <- lapply(raw_outputs, parse_output)

results <- candidate_speeches %>%
  transmute(speech_id, text) %>%
  mutate(
    model = model,
    temperature = temperature,
    raw_output = raw_outputs,
    include_for_coding = vapply(parsed, `[[`, logical(1), "include_for_coding"),
    temporal_grammar_code = vapply(parsed, `[[`, character(1), "temporal_grammar_code"),
    symbolic_work_code = vapply(parsed, `[[`, character(1), "symbolic_work_code"),
    notes = vapply(parsed, `[[`, character(1), "notes")
  )

out_dir <- ensure_dir("outputs", "llm_coding")
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
out_file <- file.path(out_dir, paste0("llm_outputs_", timestamp, ".csv"))
write_csv(results, out_file)

message("Wrote API annotation outputs to: ", out_file)
