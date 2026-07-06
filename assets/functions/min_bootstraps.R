min_bootstraps <- function(data, percentile = 0.95, alpha = 0.05, delta = 0.01) {
  if (!is.data.frame(data) && !is.matrix(data)) {
    stop("data must be a data frame or matrix")
  }

  z_alpha <- qnorm(1 - alpha / 2)
  required_n_boot <- ceiling((z_alpha / delta)^2 * percentile * (1 - percentile))

  max(required_n_boot, 100)
}
