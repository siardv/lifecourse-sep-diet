format_numeric <- function(df, digits = 3) {
  dplyr::mutate(df, dplyr::across(
    dplyr::where(is.numeric),
    ~ format(round(., digits), nsmall = 0, trim = TRUE)
  ))
}
