describe <- function(
  df, exclude = NULL, kable_format = "html", caption = "Descriptive Statistics",
  normality = TRUE, print_only = TRUE, add_footnote = TRUE,
  latex = TRUE, decimals = 3, ...
) {
  df <- df %>%
    dplyr::mutate(dplyr::across(
      where(is.logical),
      as.numeric
    )) %>%
    dplyr::select(-dplyr::any_of(exclude))
  nt <- if (normality) {
    df %>%
      dplyr::select(where(function(x) {
        is.numeric(x) &&
          length(unique(x)) > 4
      })) %>%
      purrr::map_dfr(function(x) {
        tst <- if (nrow(df) > 5000) {
          DescTools::LillieTest(x)
        } else {
          shapiro.test(x)
        }
        tibble::tibble(norm = tst$statistic, p = tst$p.value)
      }, .id = "var")
  } else {
    tibble::tibble(var = character(), norm = numeric(), p = numeric())
  }
  ds <- psych::describe(df, ranges = TRUE) %>%
    tibble::as_tibble(rownames = "var") %>%
    dplyr::select(
      var, n, mean, min, max, sd, skew, kurtosis,
      se
    ) %>%
    dplyr::left_join(nt, by = "var") %>%
    dplyr::mutate(p = format_p_value(
      p,
      TRUE, TRUE, TRUE
    ))
  if (print_only) {
    ds %<>% dplyr::mutate(dplyr::across(
      where(is.numeric),
      ~ format(round(.x, decimals), nsmall = decimals)
    ))
  }
  cn <- if (latex) {
    c(
      "$\\text{}$", "$n$", "$\\bar{x}$", "$\\text{min}$",
      "$\\text{max}$", "$\\sigma$", "$\\text{Sk}$", "$\\text{K}$",
      "$SE$", "$\\text{Normality}^{\\dagger}$", "$p$"
    )
  } else {
    c(
      "Var", "n", "Mean", "Min", "Max", "SD", "Skew", "Kurtosis",
      "SE", "Norm", "p"
    )
  }
  if (!normality) {
    cn <- head(cn, -2)
  }
  out <- knitr::kable(ds,
    format = kable_format, digits = decimals,
    row.names = FALSE, escape = FALSE, col.names = cn, caption = caption,
    align = c("l", rep("c", length(cn) - 1)), ...
  )
  if (normality && add_footnote && kable_format == "html") {
    out <- kableExtra::footnote(out,
      general = paste0(ifelse(nrow(df) <=
        5000, "Shapiro-Wilk", "Lilliefors"), " Test$^{\\dagger}$"),
      footnote_as_chunk = TRUE, escape = FALSE
    )
  }
  if (print_only) {
    return(out)
  } else {
    return(invisible(ds))
  }
}
