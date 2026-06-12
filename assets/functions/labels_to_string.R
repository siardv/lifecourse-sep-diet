labels_to_string <- function(data, column) {
  labels <- attr(data[[column]], "labels")
  if (is.null(labels) || length(labels) == 0) {
    "No labels in original data."
  } else {
    paste(purrr::imap_chr(labels, ~ paste0(
      dQuote(.y, FALSE),
      " = ", .x
    )), collapse = ", ")
  }
}
