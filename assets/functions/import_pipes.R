import_pipes <- function() {
  lapply(
    list(
      c("%>%", "magrittr"), c("%<>%", "magrittr"),
      c("%$%", "magrittr"), c("%T>%", "magrittr"), c(
        "%s+%",
        "stringi"
      ), c("%||%", "rlang"), c("%dopar%", "foreach")
    ),
    function(x) {
      assign(
        x[1], getExportedValue(x[2], x[1]),
        .GlobalEnv
      )
    }
  )
  assign("glue", function(...) {
    eval(substitute(glue::glue(..., .sep = " ")), parent.frame())
  }, .GlobalEnv)
}
