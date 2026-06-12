copy_labels <- function(source, target) {
  common_names <- intersect(names(target), names(source))
  unique_names <- setdiff(names(target), names(source))
  target_reformatted <- purrr::map2_df(
    target[common_names],
    common_names, ~ {
      src <- source[[.y]]
      tgt <- .x
      if (is.numeric(src) && is.factor(tgt)) {
        as.numeric(as.character(tgt))
      } else {
        fun_name <- paste0("as.", typeof(src))
        getFunction(fun_name)(tgt)
      }
    }
  )
  target_reformatted <- labelled::copy_labels(source, target_reformatted)
  target_reformatted <- cbind(target_reformatted, target[unique_names])
  target_reformatted <- target_reformatted[, names(target)]
  if (any(grepl("tbl", class(source)))) {
    tibble::as_tibble(target_reformatted)
  } else {
    target_reformatted
  }
}
