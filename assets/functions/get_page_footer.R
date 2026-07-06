get_page_footer <- function() {
  cat("  page-footer: |\n")
  tab <- strrep(" ", 4)
  cat(tab, R.version.string, "<br>\n", sep = "")
  cat(tab, "Platform: ", R.version$platform, "<br>\n", sep = "")
  cat(tab, "Running under: ", utils::sessionInfo()$running, "<br>\n", sep = "")
  cat(tab, "Quarto ", system2("quarto", "--version", stdout = TRUE), "<br>\n", sep = "")
}