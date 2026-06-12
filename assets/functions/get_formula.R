get_formula <- function(model_object) {
  f <- formula(model_object)
  env <- environment(f)
  formula_str <- paste(deparse(f), collapse = "")
  clean_formula_str <- gsub("\\s+", " ", formula_str)
  clean_formula <- as.formula(clean_formula_str, env = env)
  return(clean_formula)
}
