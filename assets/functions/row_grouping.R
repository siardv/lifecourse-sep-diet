row_grouping <- function(x) {
  x <- table(x)[unique(x)]
  names(x) <- make.unique(names(x))
  invisible(capture.output(dput(x, control = "niceNames")))
  return(x)
}
