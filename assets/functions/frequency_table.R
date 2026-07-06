frequency_table <- function(x, var_name = NULL) {
  if (is.null(var_name)) {
    var_name <- names(x)[ncol(x)]
  }
  col_data <- labelled::user_na_to_regular_na(x[[var_name]])
  val_labels <- attr(col_data, "labels")
  if (is.null(val_labels)) {
    val_labels <- labelled::get_value_labels(col_data)[[1]]
  }
  labels_df <- data.frame(
    value = as.character(val_labels),
    label = dQuote(names(val_labels)), stringsAsFactors = FALSE
  )
  freq_tbl <- as.data.frame(table(col_data, useNA = "ifany"),
    stringsAsFactors = FALSE
  )
  names(freq_tbl) <- c("value", "frequency")
  freq_tbl$value <- as.character(freq_tbl$value)
  missing_cond <- freq_tbl$value %in% c("NA", "<NA>") | is.na(freq_tbl$value)
  freq_tbl$value[missing_cond] <- "N/A"
  valid_rows <- freq_tbl[freq_tbl$value != "N/A", ]
  missing_rows <- freq_tbl[freq_tbl$value == "N/A", ]
  valid_rows <- valid_rows[gtools::mixedorder(valid_rows$value), ]
  freq_tbl <- dplyr::bind_rows(valid_rows, missing_rows)
  total_count <- sum(freq_tbl$frequency)
  valid_total <- sum(valid_rows$frequency)
  freq_tbl$cum_perc_total <- round(
    100 * cumsum(freq_tbl$frequency) / total_count,
    2
  )
  freq_tbl$perc_valid <- ifelse(freq_tbl$value == "N/A", NA,
    round(100 * freq_tbl$frequency / valid_total, 2)
  )
  valid_freq <- freq_tbl$frequency[freq_tbl$value != "N/A"]
  cum_valid <- round(
    100 * cumsum(valid_freq) / valid_total,
    2
  )
  freq_tbl$cum_perc_valid <- NA
  freq_tbl$cum_perc_valid[freq_tbl$value != "N/A"] <- cum_valid
  if (nrow(freq_tbl) > 0) {
    freq_tbl$cum_perc_total[nrow(freq_tbl)] <- 100
    if (any(freq_tbl$value != "N/A")) {
      last_valid <- max(which(freq_tbl$value != "N/A"))
      freq_tbl$cum_perc_valid[last_valid] <- 100
    }
  }
  tbl_names <- c(
    "Value", "Label", "Frequency", "$\\%$ Valid",
    "$\\%$ Cum. Valid", "$\\%$ Cum. Total"
  )
  tbl <- dplyr::left_join(freq_tbl, labels_df, by = "value") %>%
    dplyr::select(
      value, label, frequency, perc_valid, cum_perc_valid,
      cum_perc_total
    ) %>%
    as_kable(cols = tbl_names) %>%
    footnote(general_title = "Original coding: ") %>%
    add_style()
  print(tbl)
}
