col_to_fct <- function(df, cols, exclude = NULL, inplace = FALSE) {
  if (missing(cols)) {
    warning("No columns specified. All columns will be converted to factors.")
    cols <- names(df)
  }
  to_convert <- na.omit(setdiff(names(df[cols]), exclude))
  df_copy <- df
  df_copy[to_convert] <- lapply(df_copy[to_convert], function(x) {
    lvls <- attr(x, "labels")
    if (!is.null(lvls)) {
      factor(x, levels = unname(lvls), labels = names(lvls))
    } else {
      factor(x)
    }
  })
  if (inplace) {
    assign(deparse(substitute(df)), df_copy, envir = parent.frame())
  } else {
    df_copy
  }
}
