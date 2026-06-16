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
require_packages(c("data.table", "dplyr", "quanteda", "readr", "word2vec"))

library(data.table)
library(dplyr)
library(quanteda)
library(readr)
library(word2vec)

raw_1945_2012 <- Sys.getenv(
  "GE_RAW_1945_2012",
  unset = ge_path("data", "raw", "df_speeches_1945_2012_non_semanticized.csv")
)
raw_2013_2024 <- Sys.getenv(
  "GE_RAW_2013_2024",
  unset = ge_path("data", "raw", "df_speeches_2013_2024_non_semanticized.csv")
)

if (!file.exists(raw_1945_2012) || !file.exists(raw_2013_2024)) {
  stop(
    "Raw corpus files are not included in this repository. Place them at:\n",
    "  data/raw/df_speeches_1945_2012_non_semanticized.csv\n",
    "  data/raw/df_speeches_2013_2024_non_semanticized.csv\n",
    "or set GE_RAW_1945_2012 and GE_RAW_2013_2024 to their file paths.",
    call. = FALSE
  )
}

seed_terms <- c(
  "gouden eeuw",
  "17e eeuw",
  "zeventiende eeuw",
  "zeventiende eeuwse",
  "17de eeuw",
  "17de eeuws",
  "17de eeuwse",
  "zeventiende-eeuwse",
  "oost-indische compagnie",
  "oostindische compagnie",
  "synode van dordrecht",
  "statenbijbel",
  "adriaanszoon de ruyter",
  "admiraal de ruijter",
  "voc",
  "admiraal de ruyter",
  "michiel de ruyter",
  "dordtsche"
)

df1 <- data.table::fread(raw_1945_2012, encoding = "UTF-8")
df2 <- data.table::fread(raw_2013_2024, encoding = "UTF-8")
df_speeches <- data.table::rbindlist(list(df1, df2), fill = TRUE)

check_columns(df_speeches, c("speech_id", "text", "date", "role"), "raw corpus")

df_speeches <- df_speeches %>%
  filter(is.na(role) | role != "chair") %>%
  mutate(
    date = as.Date(date),
    year = as.integer(format(date, "%Y"))
  )

tokens_speech <- corpus(df_speeches$text) %>%
  tokens(
    what = "word",
    remove_punct = TRUE,
    padding = TRUE,
    remove_symbols = TRUE,
    remove_numbers = FALSE,
    remove_url = TRUE,
    remove_separators = TRUE,
    split_hyphens = FALSE
  ) %>%
  tokens_remove(stopwords("nl")) %>%
  tokens_tolower()

seed_phrases <- quanteda::phrase(seed_terms)
tokens_speech <- tokens_compound(tokens_speech, pattern = seed_phrases, concatenator = "_")

seed_terms_compounded <- gsub(" +", "_", tolower(seed_terms))
seed_terms_compounded <- unique(seed_terms_compounded)

model <- word2vec::word2vec(
  x = as.list(tokens_speech),
  type = "skip-gram",
  dim = 200,
  window = 8,
  iter = 10,
  lr = 0.025,
  negative = 10,
  min_count = 5,
  threads = parallel::detectCores()
)

nearest_to_seed_average <- function(model, seeds, top_n = 500) {
  matrix <- as.matrix(model)
  seeds <- unique(seeds)
  seeds_in <- seeds[seeds %in% rownames(matrix)]

  if (length(seeds_in) == 0) {
    stop("None of the seed terms are present in the word2vec vocabulary.", call. = FALSE)
  }

  centroid <- colMeans(matrix[seeds_in, , drop = FALSE])
  similarities <- as.numeric(
    (matrix %*% centroid) / (sqrt(rowSums(matrix^2)) * sqrt(sum(centroid^2)))
  )
  names(similarities) <- rownames(matrix)
  similarities <- sort(similarities, decreasing = TRUE)
  similarities <- similarities[!names(similarities) %in% seeds_in]
  similarities <- head(similarities, top_n)

  data.frame(
    term = names(similarities),
    similarity = as.numeric(similarities),
    seed_set = paste(seeds_in, collapse = ", "),
    stringsAsFactors = FALSE
  )
}

nearest_neighbours <- nearest_to_seed_average(model, seed_terms_compounded, top_n = 500)

retrieval_dir <- ensure_dir("outputs", "retrieval")
write_csv(nearest_neighbours, file.path(retrieval_dir, "nearest_neighbours_gouden_eeuw.csv"))

dictionary_terms <- unique(c(seed_terms_compounded, head(nearest_neighbours$term, 100)))
dictionary_terms <- dictionary_terms[!is.na(dictionary_terms) & nzchar(dictionary_terms)]
dict_gouden_eeuw <- dictionary(list(gouden_eeuw = dictionary_terms))
dfm_speech <- dfm(tokens_speech)
dfm_gouden_eeuw <- dfm_lookup(dfm_speech, dictionary = dict_gouden_eeuw)

df_speeches$gouden_eeuw_raw <- as.numeric(dfm_gouden_eeuw[, "gouden_eeuw"])
df_speeches$gouden_eeuw <- (df_speeches$gouden_eeuw_raw / ntoken(dfm_speech)) * 1000

candidate_speeches <- df_speeches %>%
  filter(gouden_eeuw_raw >= 1)

write_csv(candidate_speeches, file.path(retrieval_dir, "candidate_speeches_recomputed.csv"))
message("Wrote retrieval outputs to: ", retrieval_dir)
