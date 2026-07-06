standardize <- function(data, vars_to_standardize = NULL) {
  if (is.null(vars_to_standardize)) {
    vars_to_standardize <- names(data)[sapply(data, function(x) {
      is.numeric(x) &&
        length(unique(x)) > 2
    })]
  }
  for (var in vars_to_standardize) {
    if (is.numeric(data[[var]])) {
      data[[var]] <- (data[[var]] - mean(data[[var]], na.rm = TRUE)) / stats::sd(data[[var]],
        na.rm = TRUE
      )
    }
  }
  data
}
