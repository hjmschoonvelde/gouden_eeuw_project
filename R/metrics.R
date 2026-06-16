normalise_binary <- function(x) {
  if (is.logical(x)) {
    return(x)
  }
  y <- tolower(trimws(as.character(x)))
  out <- rep(NA, length(y))
  out[y %in% c("1", "true", "t", "yes", "y")] <- TRUE
  out[y %in% c("0", "false", "f", "no", "n")] <- FALSE
  out
}

normalise_code <- function(x, prefix = NULL) {
  y <- toupper(trimws(as.character(x)))
  y[y %in% c("", "NA", "N/A", "NULL", "NONE")] <- NA_character_

  if (!is.null(prefix) && prefix == "TG") {
    y <- sub("^G([0-9]+)$", "TG\\1", y)
  }

  if (!is.null(prefix) && prefix == "SW") {
    y <- sub("^W([0-9]+)$", "SW\\1", y)
  }

  y
}

binary_metrics <- function(truth, prediction, positive = TRUE) {
  truth <- normalise_binary(truth)
  prediction <- normalise_binary(prediction)

  keep <- !is.na(truth)
  truth <- truth[keep]
  prediction <- prediction[keep]

  tp <- sum(truth == positive & prediction == positive, na.rm = TRUE)
  fp <- sum(truth != positive & prediction == positive, na.rm = TRUE)
  fn <- sum(truth == positive & prediction != positive, na.rm = TRUE)
  tn <- sum(truth != positive & prediction != positive, na.rm = TRUE)

  precision <- if ((tp + fp) == 0) NA_real_ else tp / (tp + fp)
  recall <- if ((tp + fn) == 0) NA_real_ else tp / (tp + fn)
  f1 <- if (is.na(precision) || is.na(recall) || (precision + recall) == 0) {
    NA_real_
  } else {
    2 * precision * recall / (precision + recall)
  }
  accuracy <- if ((tp + fp + fn + tn) == 0) NA_real_ else (tp + tn) / (tp + fp + fn + tn)

  data.frame(
    class = as.character(positive),
    true_positive = tp,
    false_positive = fp,
    false_negative = fn,
    true_negative = tn,
    precision = precision,
    recall = recall,
    f1 = f1,
    accuracy = accuracy,
    stringsAsFactors = FALSE
  )
}

one_vs_rest_metrics <- function(truth, prediction, classes) {
  do.call(
    rbind,
    lapply(classes, function(class) {
      truth_pos <- truth == class
      prediction_pos <- prediction == class
      out <- binary_metrics(truth_pos, prediction_pos, positive = TRUE)
      out$class <- class
      out
    })
  )
}
