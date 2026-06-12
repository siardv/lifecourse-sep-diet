suppress_output <- function(expr) {
  temp_sink <- tempfile()
  sink(temp_sink)
  on.exit(sink(), add = TRUE)
  result <- eval(expr)
  return(invisible(result))
}
