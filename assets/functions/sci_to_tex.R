sci_to_tex <- function(x) {
  sci <- format(x, scientific = TRUE)
  m <- as.numeric(strsplit(sci, "e")[[1]][1])
  exp <- as.numeric(strsplit(sci, "e")[[1]][2])
  sci <- sprintf("$%.2f \\times 10^{%d}$", m, exp)
  md_to_html(sci)
}
