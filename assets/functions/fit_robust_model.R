fit_robust_model <- function(dat, frm, ctrl = NULL) {
  if (is.null(ctrl)) {
    ctrl <- robustbase::lmrob.control(
      method = "MM", setting = "KS2014",
      psi = "bisquare", cov = ".vcov.avar1", max.it = 200,
      k.max = 5000, rel.tol = 0.0000001, trace.lev = 0
    )
  }
  tryCatch(
    {
      fit <- robustbase::lmrob(frm, dat, control = ctrl)
      invalid <- function(obj) {
        any(is.na(coef(obj))) || any(abs(coef(obj)) > 10000) ||
          !obj$converged || obj$scale < 0.0001 || any(obj$rweights <
          0.05)
      }
      if (invalid(fit)) {
        warning("Initial fit invalid. Adjusting control parameters.")
        fb1 <- modifyList(ctrl, list(
          method = "S", psi = "optimal",
          cov = ".vcov.w", max.it = 300
        ))
        fit <- robustbase::lmrob(frm, dat, control = fb1)
        if (invalid(fit)) {
          warning("Secondary fit invalid. Switching to minimal robustness control.")
          fb2 <- robustbase::lmrob.control(
            method = "M",
            psi = "huber", cov = ".vcov.w", max.it = 150,
            rel.tol = 0.00001, trace.lev = 0
          )
          fit <- robustbase::lmrob(frm, dat, control = fb2)
        }
      }
      if (invalid(fit)) {
        warning("Model fit remains invalid after all attempts.")
      } else if (!fit$converged) {
        warning("Model fit did not converge.")
      }
      print(summary(fit))
      fit
    },
    error = function(err) {
      warning(glue("Robust fit failed entirely. Returning 'M' fallback: {err$message}"))
      robustbase::lmrob(frm, dat, control = robustbase::lmrob.control(
        method = "M",
        psi = "huber", max.it = 100
      ))
    }
  )
}
