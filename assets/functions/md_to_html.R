md_to_html <- function(markdown_input) {
  if (!is.character(markdown_input)) {
    warning("Input set to character vector.")
    markdown_input <- as.character(markdown_input)
  }
  convert_to_html <- function(md_text) {
    temp_md <- tempfile(fileext = ".md")
    temp_html <- tempfile(fileext = ".html")
    writeLines(md_text, temp_md)
    on.exit(unlink(c(temp_md, temp_html)), add = TRUE)
    rmarkdown::pandoc_convert(
      input = temp_md, to = "html",
      from = "markdown+tex_math_dollars+tex_math_single_backslash",
      output = temp_html, options = c("--mathml")
    )
    paste0(readLines(temp_html, warn = FALSE), collapse = " ")
  }
  html_results <- vapply(markdown_input, convert_to_html, character(1),
    USE.NAMES = FALSE
  )
  html_results <- stringr::str_squish(html_results)
  html_results <- gsub("^<p>(.*)<\\/p>$", "\\1", html_results)
  if (length(html_results) == 1) {
    html_results[1]
  } else {
    html_results
  }
}
