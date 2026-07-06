format_p_value <- function(
  p_value, add_stars = FALSE, use_concat = TRUE, omit_p_label = FALSE,
  verbose = FALSE, use_dot_for_0.1 = FALSE, as_html = TRUE
) {
  if (is.character(p_value)) {
    p_value <- utils::type.convert(p_value, as.is = TRUE)
  }
  if (!omit_p_label) {
    if (isTRUE(all(p_value > 0.05, na.rm = TRUE))) {
      if (verbose) {
        message("All p-values are greater than 0.05, no changes made.")
      }
      return(p_value)
    }
  }
  formatted_p <- ifelse(p_value < 0.001, "$\\leq 0.001$", sprintf(
    "$%.3f$",
    p_value
  ))
  formatted_p[is.na(formatted_p)] <- ""
  formatted_p <- format(formatted_p, nsmall = 4, justify = "left")
  ast <- function(i) {
    sprintf("$^{%s}$", ifelse(i == 0, "\\cdot",
      strrep("\\ast", i)
    ))
  }
  if (add_stars) {
    stars_label <- ifelse(is.na(p_value), " ", ifelse(p_value <=
      0.001, ast(3), ifelse(p_value <= 0.01, ast(2), ifelse(p_value <=
      0.05, ast(1), ifelse((use_dot_for_0.1 && p_value <=
      0.1), ast(0), "")))))
    stars_label <- format(stars_label, justify = ifelse(omit_p_label,
      "right", "left"
    ))
    if (omit_p_label) {
      formatted_p <- paste0("$\\ $", stars_label)
    } else {
      if (use_concat) {
        formatted_p <- paste0(formatted_p, stars_label)
      } else {
        formatted_p <- list(p = formatted_p, stars = stars_label)
      }
    }
  } else {
    if (!use_concat) {
      formatted_p <- list(p = formatted_p, stars = "")
    }
  }
  if (as_html) {
    formatted_p <- md_to_html(formatted_p)
  }
  return(formatted_p)
}
