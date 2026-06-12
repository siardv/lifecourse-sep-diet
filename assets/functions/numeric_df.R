numeric_df <- function(input_data) {
  input_data <- labelled::user_na_to_na(input_data)
  if (is.data.frame(input_data)) {
    output_data <- lapply(input_data, function(col) {
      if (is.factor(col)) {
        as.numeric(col)
      } else if (haven::is.labelled(col)) {
        as.numeric(col)
      } else if (is.character(col)) {
        as.numeric(col)
      } else {
        col
      }
    })
    data.frame(output_data, stringsAsFactors = FALSE)
  } else if (is.factor(input_data)) {
    as.numeric(input_data)
  } else if (haven::is.labelled(input_data)) {
    as.numeric(input_data)
  } else if (is.character(input_data)) {
    as.numeric(input_data)
  } else {
    input_data
  }
}
