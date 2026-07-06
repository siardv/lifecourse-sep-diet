update_value_label <- function(data, column_name, value, label) {
  eval.parent(substitute(labelled::val_label(
    data[[column_name]],
    value
  ) <- label))
}
