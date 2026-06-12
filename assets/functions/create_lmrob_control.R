create_lmrob_control <- function(ctrl, psi) {
  if (is.null(ctrl)) {
    robustbase::lmrob.control(
      setting = "KS2014", psi = psi,
      method = "MM", cov = ".vcov.avar1", max.it = 200,
      k.max = 5000, rel.tol = 0.0000001, trace.lev = 0
    )
  } else {
    ctrl
  }
}
