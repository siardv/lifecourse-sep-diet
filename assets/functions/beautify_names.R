beautify_names <- function(vec, abbreviate = FALSE, as_HTML = TRUE, format_bracket_content = TRUE) {
  # define base mapping for variables
  base_mapping <- c(
    dhd_index = "DHD-index",
    dhd_kcal = "DHD-kcal",
    age = "Age",
    idnummer = "ID No.",
    income_hh = "Household Income",
    occupation_self = "Resp.'s Occupation (ISEI-08)",
    occupation_father = "Father's Occupation (ISEI-08)",
    occupation_mother = "Mother's Occupation (ISEI-08)",
    occupation_partner = "Partner's Occupation (ISEI-08)",
    adults_hh = "Adults in Household",
    num_children_hh = "Children in Household",
    bedrooms = "Bedrooms",
    diff_pay_bills = "Difficulty Paying Regular Bills",
    diff_live_income = "Difficulty Living from Income",
    smoking = "Smoking",
    normal_week = "Normal Survey Week",
    home_owner = "Home Ownership",
    woman = "Woman",
    partner = "Partner",
    education = "Education",
    education_self = "Resp.'s Education",
    education_partner = "Partner's Education",
    education_father = "Father's Education",
    education_mother = "Mother's Education",
    brc14 = "Resp.'s Occupation (BRC-14)",
    brc14_father = "Father's Occupation (BRC-14)",
    brc14_mother = "Mother's Occupation (BRC-14)",
    brc14_partner = "Partner's Occupation (BRC-14)",
    isco08r = "Resp.'s Occupation (ISCO-08; corrected)",
    isco08r_father = "Father's Occupation (ISCO-08; corrected)",
    isco08r_mother = "Mother's Occupation (ISCO-08; corrected)",
    isco08r_partner = "Partner's Occupation (ISCO-08; corrected)",
    isei08 = "Resp.'s Occupation (ISEI-08)",
    isei08_father = "Father's Occupation (ISEI-08)",
    isei08_mother = "Mother's Occupation (ISEI-08)",
    isei08_partner = "Partner's Occupation (ISEI-08)",
    isei08_self = "Resp.'s Occupation (ISEI-08)",
    income_hh_num = "Household Income (numeric)",
    eq_size = "Equivalized HH Size",
    hh_size = "Household Size",
    hardship = "Hardship",
    crowding = "Crowding",
    income_hh_eq = "Equivalized Income",
    children_yn = "Children in HH",
    income_hh_eq_rec = "Equivalized Income (recoded)",
    outlier = "Outlier",
    model_0 = "Model 0",
    model_1 = "Model 1",
    model_2 = "Model 2",
    model_3 = "Model 3",
    model_4 = "Model 4",
    model_5 = "Model 5",
    model_6 = "Model 6",
    model_7 = "Model 7",
    model_8 = "Model 8",
    model_9 = "Model 9",
    fit_0 = "Model 0 Fit",
    fit_1 = "Model 1 Fit",
    fit_2 = "Model 2 Fit",
    fit_3 = "Model 3 Fit",
    fit_4 = "Model 4 Fit",
    fit_5 = "Model 5 Fit",
    fit_6 = "Model 6 Fit",
    fit_7 = "Model 7 Fit",
    fit_8 = "Model 8 Fit",
    fit_9 = "Model 9 Fit",
    var = "Variable",
    erm = "ERM",
    oob = "OOB",
    sd_var = "SD",
    missing_rate = "Missing Rate",
    combined_score = "Combined Score",
    percentile = "Percentile",
    oob_rating = "OOB Rating",
    r2 = "$R^2$",
    r2_adj = "Adj. $R^2$",
    aic_sd = "AIC (SD)",
    bic_sd = "BIC (SD)",
    edf = "Eff. DF",
    rmse_sd = "RMSE (SD)",
    c_index = "C-Index",
    calibration = "Calibration",
    wt_metrics = "Weighted Metrics",
    boot_errors = "Bootstrap Errors",
    boot_r2 = "Bootstrap $R^2$",
    boot_rmse = "Bootstrap RMSE",
    boot_gof = "Bootstrap GOF",
    component = "Component",
    metric = "Metric",
    estimate = "Estimate",
    sd = "SD",
    ci_lower = "$CI$_{\\text{lower}}$",
    ci_upper = "$CI_{\\text{upper}}$",
    Slope = "Slope",
    Intercept = "Intercept",
    R2 = "$R^2$",
    CITL = "CITL",
    E.max = "$E_{max}$",
    e_Max = "$E_{max}$",
    E.max_bootstrap = "$E_{max}$",
    mean = "Mean",
    median = "Median",
    min = "Min",
    max = "Max",
    MAE = "MAE",
    mae = "MAE",
    MEDAE = "Median AE",
    medea = "Median AE",
    MAPE = "MAPE",
    mape = "MAPE",
    `Adj R2` = "Adj. $R^2$",
    rmse = "RMSE",
    aic = "AIC",
    bic = "BIC",
    `Univariate (dhd_kcal)` = "Univariate (DHD-kcal)",
    `Univariate (dhd_index)` = "Univariate (DHD-index)",
    education_parental = "Parental Education (mean)",
    isei08_parental = "Parental Occupation (mean ISEI-08)"
  )

  if (abbreviate) {
    base_mapping <- stringr::str_replace_all(
      base_mapping,
      c(
        "Education" = "Edu.",
        "Occupation" = "Occ.",
        "Partner" = "Ptr.",
        "Household" = "HH",
        "Equivalized" = "Eq.",
        "Recoded" = "Rec.",
        "Calibration" = "Calib."
      )
    ) %>% setNames(names(base_mapping))
  }

  # create regex mapping for exact matches
  regex_mapping <- base_mapping
  names(regex_mapping) <- sprintf("^%s$", names(base_mapping))

  # helper to beautify interaction terms
  beautify_interaction <- function(x, mapping) {
    parts <- stringr::str_split(x, ":")[[1]]
    parts <- sapply(parts, function(p) {
      if (p %in% names(mapping)) mapping[[p]] else p
    }, USE.NAMES = FALSE)
    paste(parts, collapse = " $\\times$ ")
  }

  # apply base mapping replacement
  vec <- stringr::str_replace_all(vec, regex_mapping)

  # process interaction terms containing colon(s)
  vec <- sapply(vec, function(x) {
    if (!is.na(x) && stringr::str_detect(x, ":")) {
      beautify_interaction(x, base_mapping)
    } else {
      x
    }
  }, USE.NAMES = FALSE)

  vec <- stringr::str_replace_all(vec, base_mapping)

  if (as_HTML) {
    if (format_bracket_content) {
      has_brackets <- grepl("\\(([^)]+)\\)", vec)
      vec[has_brackets] <- stringr::str_replace_all(
        vec[has_brackets],
        "\\(([^)]+)\\)",
        "<span style='font-size: 0.8em; white-space: nowrap;'>(\\1)</span>"
      )
    }
    vec <- md_to_html(vec)
  }

  return(vec)
}
