robust_analysis <- function(
  data, form, n_boots = NULL, pct = 0.95, alpha = 0.05,
  delta = 0.01, ctrl = NULL, seed = 625, psi = "bisquare",
  std_data = TRUE
) {
  set.seed(seed, kind = "default")
  if (std_data) {
    data <- standardize(data)
  }
  mm_list <- prepare_model_matrices(form, data)
  dm <- mm_list$design_matrix
  resp <- mm_list$response
  if (!is.null(n_boots) && n_boots > 0) {
    min_boots <- n_boots
  } else {
    n_boots <- 0
    min_boots <- NA
    message("Bootstrapping is disabled (`n_boots = 0`). Only robust and OLS models will be fitted.")
  }
  ctrl <- create_lmrob_control(ctrl, psi)
  fits <- fit_models(data, form, ctrl)
  robust_fit <- fits$robust_fit
  ols_fit <- fits$ols_fit
  robust_results <- process_model(
    robust_fit, "robust", n_boots,
    min_boots, data, resp, dm, ctrl, pct
  )
  ols_results <- process_model(
    ols_fit, "ols", n_boots, min_boots,
    data, resp, dm, ctrl, pct
  )
  analysis_results <- list(
    robust_model_results = list(
      model_object = robust_fit,
      analysis_output = robust_results
    ), ols_model_results = list(
      model_object = ols_fit,
      analysis_output = ols_results
    ), analysis_metadata = list(
      total_observations = nrow(data),
      number_of_predictors = ncol(dm), bootstrap_iterations = n_boots,
      minimum_required_bootstraps = min_boots, analysis_timestamp = Sys.time(),
      robustbase_version = utils::packageVersion("robustbase")
    ),
    detailed_outputs = list(robust = robust_results, ols = ols_results)
  )
  class(analysis_results) <- "structured_models"
  return(analysis_results)
}
