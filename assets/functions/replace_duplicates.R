replace_duplicates <- function(df, col, replace_with = NA) {
  col <- rlang::ensym(col)
  dplyr::mutate(df, `:=`(!!col, as.character(!!col))) %>%
    dplyr::mutate(dup_flag = duplicated(!!col)) %>%
    dplyr::mutate(`:=`(!!col, ifelse(dup_flag, replace_with,
      !!col
    ))) %>%
    dplyr::select(-dup_flag) %>%
    dplyr::mutate(`:=`(
      !!col,
      if (is.factor(dplyr::pull(df, !!col))) {
        factor(!!col)
      } else {
        !!col
      }
    ))
}
