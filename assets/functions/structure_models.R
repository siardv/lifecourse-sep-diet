structure_models <- function(unadj_mods, adj_mods) {
  update_model <- function(mod) {
    if (!is.null(mod$call$formula)) {
      mod$call$formula <- formula(mod)
    }
    if (!is.null(mod$model)) {
      if (!is.null(mod$model$call$formula)) {
        mod$model$call$formula <- formula(mod$model)
      }
      mod$model$call$data <- mod$call$data
    }
    mod
  }
  update_mods <- function(mods) {
    lapply(mods, function(m) {
      if (!is.null(m$robust_model_results$model_object)) {
        m$robust_model_results$model_object <- update_model(m$robust_model_results$model_object)
      }
      if (!is.null(m$ols_model_results$model_object)) {
        m$ols_model_results$model_object <- update_model(m$ols_model_results$model_object)
      }
      m
    })
  }
  adj_mods <- update_mods(adj_mods)
  unadj_mods <- update_mods(unadj_mods)
  create_model_structure <- function(fit, include_bootstrap = TRUE) {
    process_fit <- function(fit_res) {
      if (is.null(fit_res) || is.null(fit_res$analysis_output)) {
        return(list(fit = NULL, bootstrap = list(
          std_errors = NULL,
          coefs = NULL, p_value = NULL, conf_int = NULL,
          ests = NULL
        )))
      }
      bootstrap_data <- if (include_bootstrap) {
        list(
          std_errors = fit_res$analysis_output$standard_errors,
          coefs = if (!is.null(fit_res$analysis_output$bootstrap_estimates)) {
            colMeans(fit_res$analysis_output$bootstrap_estimates,
              na.rm = TRUE
            )
          } else {
            NULL
          }, p_value = unlist(fit_res$analysis_output$p_values),
          conf_int = fit_res$analysis_output$confidence_intervals,
          ests = fit_res$analysis_output$bootstrap_estimates
        )
      } else {
        list(
          std_errors = NULL, coefs = NULL, p_value = NULL,
          conf_int = NULL, ests = NULL
        )
      }
      list(fit = fit_res$model_object, bootstrap = bootstrap_data)
    }
    list(
      robust = process_fit(fit$robust_model_results),
      ols = process_fit(fit$ols_model_results)
    )
  }
  model_names <- paste0("model_", seq_along(adj_mods) - 1)
  adjusted <- lapply(adj_mods, create_model_structure)
  unadjusted <- lapply(unadj_mods, create_model_structure)
  list(adjusted = list(robust = setNames(lapply(
    adjusted, `[[`,
    "robust"
  ), model_names), ols = setNames(lapply(
    adjusted,
    `[[`, "ols"
  ), model_names)), unadjusted = list(robust = setNames(lapply(
    unadjusted,
    `[[`, "robust"
  ), model_names), ols = setNames(lapply(
    unadjusted,
    `[[`, "ols"
  ), model_names)))
}
