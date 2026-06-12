pval_str <- function(
  html = TRUE, concatenate = TRUE, use_dot_for_0.1 = FALSE,
  non_sig = FALSE
) {
  p_values <- c(
    "$^{\\ast\\ast\\ast}p \\leq 0.001$", "$^{\\ast\\ast}p \\leq 0.01$",
    "$^{\\ast}p \\leq 0.05$"
  )
  if (use_dot_for_0.1) {
    p_values <- c(p_values, "$^{\\cdot}p \\leq 0.1$")
  }
  if (non_sig) {
    p_values <- c(p_values, "$^{\\text{n.s.}}p > 0.05$")
  }
  if (html) {
    p_values <- md_to_html(p_values)
  }
  if (concatenate) {
    p_values <- toString(p_values)
  }
  return(p_values)
}
