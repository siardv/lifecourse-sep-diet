add_style <- function(tbl) {
  tbl_styled <- kableExtra::kable_styling(
    kable_input = kableExtra::kable_paper(tbl),
    bootstrap_options = c("hover", "condensed", "responsive"),
    full_width = FALSE, html_font = "\"Garamond\", serif"
  )
  kableExtra::row_spec(tbl_styled, 0, bold = TRUE)
}
