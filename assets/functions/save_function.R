save_function <- function(fun, name = NULL, dir = here::here("assets", "functions")) {
  stopifnot(is.function(fun) && dir.exists(dir))
  fun_name <- if (is.null(name)) {
    deparse(substitute(fun))
  } else {
    name
  }
  file_path <- file.path(dir, paste0(fun_name, ".R"))
  x <- deparse(fun)
  x[1] <- paste0(fun_name, " <- ", x[1])
  fun_string <- paste0(x, collapse = "\n")
  writeLines(fun_string, con = file_path)
  styler::style_file(file_path)
  return(invisible())
}
