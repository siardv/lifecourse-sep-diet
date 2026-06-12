std_text <- function(x) {
  x <- tolower(x)
  x <- textclean::replace_non_ascii(x)
  x <- gsub("[^[:alnum:]]", " ", x)
  x <- gsub("\\s+", " ", x)
  x <- gsub("^\\s+|\\s+$", "", x)
  return(x)
}
