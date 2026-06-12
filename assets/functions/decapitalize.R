decapitalize <- function(x) {
  upper <- gsub("^([A-Z])[a-z].*$", "\\1", x)
  ifelse(nchar(upper) == 1, tolower(upper) %s+% substr(
    x, 2,
    nchar(x)
  ), x)
}
