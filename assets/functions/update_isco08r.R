update_isco08r <- function(col_name, data) {
  values <- unique(na.omit(data[[col_name]]))
  labels <- sapply(values, function(x) {
    isco08_to_jobtitle(x)
  })
  values_named <- setNames(values, labels)
  for (i in seq_along(values_named)) {
    eval.parent(substitute(update_value_label(
      data, col_name,
      as.numeric(values_named[i]), names(values_named)[i]
    )))
  }
}
