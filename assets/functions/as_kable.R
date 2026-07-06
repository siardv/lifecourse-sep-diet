as_kable <- function(
  tbl, cols = NULL, format = "html", row.names = FALSE,
  digits = 2, align = "l", escape = FALSE, omit_leading_zero = TRUE,
  sci_threshold = FALSE, ...
) {
  col_nms <- get0("col_names", envir = parent.frame(), inherits = TRUE)
  cols <- if (ncol(tbl) == length(col_nms)) {
    cols %||% col_nms %||% names(tbl)
  } else {
    cols %||% names(tbl)
  }
  tbl_formatted <- tbl %>% dplyr::mutate(dplyr::across(
    where(is.numeric),
    ~ {
      x <- as.numeric(.x)
      is_na <- is.na(x)
      result <- character(length(x))
      result[is_na] <- NA_character_
      non_na <- !is_na
      if (sci_threshold) {
        sci_cond <- (x != 0) & (abs(x) < 10^-digits) &
          non_na
        result[sci_cond] <- sci_to_tex(x[sci_cond])
        non_na <- non_na & !sci_cond
      }
      int_cond <- (x %% 1 == 0) & non_na
      result[int_cond] <- as.character(x[int_cond])
      remaining <- non_na & !int_cond
      formatted <- formatC(x[remaining],
        digits = digits,
        format = "f", drop0trailing = TRUE
      )
      if (omit_leading_zero) {
        formatted <- sub("^(-?)0\\.", "\\1.", formatted)
      }
      result[remaining] <- formatted
      result
    }
  ))
  if (any(grepl("\\$|\\\\", cols))) {
    cols <- vapply(cols, function(col) {
      if (!grepl("\\$|\\\\", col)) {
        return(col)
      }
      col <- gsub("\\\\bar", "\\\\overline", col)
      sprintf("<span class='math inline'>%s</span>", col)
    }, character(1)) %>% md_to_html()
  }
  knitr::kable(
    x = tbl_formatted, format = format, row.names = row.names,
    align = align, col.names = cols, escape = escape, ...
  )
}
