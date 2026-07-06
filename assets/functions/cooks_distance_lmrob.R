cooks_distance_lmrob <- function(fit) {
  rob_residuals <- residuals(fit)
  hat_values <- hatvalues(fit)
  p <- fit$rank
  scale_estimate <- fit$scale
  cooks_dist <- (rob_residuals^2 / (p * scale_estimate^2)) *
    (hat_values / ((1 - pmin(hat_values, 0.99))^2))
  return(cooks_dist)
}
