process_model <- function(
  fit, type, n_boots, min_boots, data, resp, dm, ctrl,
  pct
) {
  if (is.null(fit)) {
    return(NULL)
  }
  model_output <- list(
    coefficients = coef(fit), standard_errors = sqrt(diag(stats::vcov(fit))),
    confidence_intervals = NULL, p_values = NULL, bootstrap_estimates = NULL,
    bootstrap_quality_score = 0, valid_bootstrap_count = 0,
    bootstrap_convergence_rate = 0, diagnostics = list()
  )
  if (n_boots > 0) {}
  return(model_output)
}
