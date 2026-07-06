isco08_to_isei08 <- function(x) {
  sapply(x, function(code) {
    if (is.na(code)) {
      return(NA)
    }
    tryCatch(ISCO08ConveRsions::isco08toisei08(formatC(as.integer(code),
      width = 4, flag = "0", format = "d"
    )), error = function(e) NA)
  })
}
