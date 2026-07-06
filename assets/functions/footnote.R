footnote <- function(tbl, text, ...) {
  if (missing(text)) {
    text <- get0("footnote_text", envir = parent.frame())
    if (is.null(text)) {
      warning("No footnote text provided, returning the table without a footnote.")
      return(tbl)
    }
  }
  text <- paste0(text, collapse = " ")
  text <- stringr::str_squish(text)
  if (any(grepl("\\$|\\\\", text))) {
    text <- sapply(text, function(x) {
      if (grepl("\\$|\\\\", x)) {
        x <- gsub("\\\\bar", "\\\\overline", x)
        sprintf(
          "<span class='math inline'>%s</span>",
          x
        )
      } else {
        x
      }
    })
  }
  kableExtra::footnote(
    kable_input = tbl, general = md_to_html(text),
    escape = FALSE, footnote_as_chunk = TRUE, ...
  )
}
