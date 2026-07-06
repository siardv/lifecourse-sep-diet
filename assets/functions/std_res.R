std_res <- function(model, assign_to) {
  if (inherits(model, "lmrob")) {
    stdres <- resid(model) / model$scale
  } else {
    stdres <- rstandard(model)
  }
  if (missing(assign_to)) {
    return(stdres)
  } else if (length(assign_to) == 1 && is.character(assign_to)) {
    assign(assign_to, stdres, envir = parent.frame())
  } else {}
}
