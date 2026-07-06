fit_models <- function(data, form, ctrl) {
  robust_result <- tryCatch(
    {
      fit_robust_model(data, form, ctrl)
    },
    error = function(e) {
      warning(e$message)
      NULL
    }
  )
  ols_result <- stats::lm(form, data = data)
  list(robust_fit = robust_result, ols_fit = ols_result)
}
