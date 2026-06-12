prepare_model_matrices <- function(form, data) {
  mf <- stats::model.frame(form, data)
  dm <- stats::model.matrix(form, mf)
  resp <- stats::model.response(mf)
  list(model_frame = mf, design_matrix = dm, response = resp)
}
