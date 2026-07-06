isco08_to_jobtitle <- function(x) {
  sapply(x, function(code) {
    if (is.na(code)) {
      return(NA)
    }
    f <- ISCO08ConveRsions::isco08tojobtitle
    tryCatch(tryCatch(f(formatC(as.integer(code),
      width = 4,
      flag = "0", format = "d"
    )), error = function(e) {
      f(code)
    }), error = function(e) NA)
  })
}
