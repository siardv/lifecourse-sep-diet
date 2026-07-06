format_coef <- function(coef, pval = NULL, se = NULL, digits = 3, linebreak = TRUE) {
  if (is.na(coef)) {
    return("--")
  }
  p_fmt <- format_p_value(pval, add_stars = TRUE, omit_p_label = TRUE)
  spc <- ifelse(coef >= 0 & coef < 10, "<span style=\"display:inline-block; width: 4px\"> </span>",
    ""
  )
  fmt_num <- function(x, digits) {
    num_str <- sprintf(paste0("%.", digits, "f"), x)
    sub("^(-?)0\\.", "\\1.", num_str)
  }
  main_str <- sprintf("%s%s<sup>%s</sup>", spc, fmt_num(
    coef,
    digits
  ), p_fmt)
  if (!is.null(se)) {
    se_str <- sprintf(
      "<span style='font-size: 0.8em'>(%s)</span>",
      fmt_num(se, digits)
    )
    main_str <- paste0(main_str, ifelse(linebreak, "<br>",
      ""
    ), se_str)
  }
  return(main_str)
}
