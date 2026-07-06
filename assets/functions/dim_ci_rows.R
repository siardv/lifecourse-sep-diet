dim_ci_rows <- function(kbl, df, opacity_level = 0.5) {
  row_indices <- which(suppressWarnings(as.numeric(df$sig_perc)) <
    100)
  opacity_str <- formatC(opacity_level, format = "f", digits = 1)
  kableExtra::row_spec(kbl, row_indices, extra_css = paste0(
    "opacity: ",
    opacity_str, ";"
  ))
}
