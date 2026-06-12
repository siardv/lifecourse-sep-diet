named_list <- function(...) {
  quos <- rlang::enquos(...)
  vals <- list(...)
  nms <- names(vals)
  inf_nms <- sapply(quos, rlang::as_label)
  if (!is.null(nms) && length(nms)) {
    nms[nms == ""] <- inf_nms[nms == ""]
  } else {
    nms <- inf_nms
  }
  setNames(lapply(vals, eval), nms)
}
