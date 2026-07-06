summarize_na <- function(x) {
  if (all(c("n_miss", "pct_miss") %in% names(x))) {
    mvs <- x
  } else {
    mvs <- naniar::miss_var_summary(x, order = TRUE, add_cumsum = FALSE) %>%
      dplyr::mutate(n_miss = as.numeric(n_miss), pct_miss = pct_miss)
  }
  return(mvs)
}
