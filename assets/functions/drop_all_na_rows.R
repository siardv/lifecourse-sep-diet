drop_all_na_rows <- function(x) {
  x[rowSums(!is.na(x)) > 0, , drop = FALSE]
}
