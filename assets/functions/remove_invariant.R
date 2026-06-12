remove_invariant <- function(df) {
  df[vapply(
    df, function(x) length(na.omit(unique(x))) > 1,
    logical(1)
  )]
}
