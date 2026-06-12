update_brc14 <- function(col_name, data, mapping) {
  values <- unique(na.omit(data[[col_name]]))
  labels <- sapply(values, function(x) {
    unique(mapping$BRC2014beroepsgroep_label[as.numeric(mapping$BRC2014beroepsgroep) ==
      x])
  })
  values_named <- setNames(values, labels)
  for (i in seq_along(values_named)) {
    eval.parent(substitute(update_value_label(
      data, col_name,
      as.numeric(values_named[i]), names(values_named)[i]
    )))
  }
}
