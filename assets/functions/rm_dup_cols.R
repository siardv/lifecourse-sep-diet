rm_dup_cols <- function(df, keep = "first") {
  if (!is.data.frame(df)) {
    stop("Input must be a data frame.")
  }
  col_cont <- apply(df, 2, function(col) paste(col, collapse = "\r"))
  uniq_cols <- unique(col_cont)
  col_inds <- lapply(uniq_cols, function(x) {
    which(col_cont ==
      x)
  })
  sel_cols <- sapply(col_inds, function(inds) {
    if (keep == "last") {
      return(tail(inds, 1))
    } else {
      return(head(inds, 1))
    }
  })
  df[, sel_cols, drop = FALSE]
}
