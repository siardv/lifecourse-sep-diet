order_array <- function(x) {
  numeric_part <- suppressWarnings(as.numeric(x))
  numeric_order <- order(numeric_part, na.last = NA)
  non_numeric_order <- order(x[is.na(numeric_part) & x != "Total"])
  total_index <- which(x == "Total")
  order_indices <- c(numeric_order, which(is.na(numeric_part) &
    x != "Total")[non_numeric_order], total_index)
  return(order_indices)
}
