empty_to_na <- function(x) {
  if (is.character(x)) {
    ifelse(x == "", NA_character_, x)
  } else {
    x
  }
}
