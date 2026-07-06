# acceptance verifier for the rebuilt step 2 notebook.
# usage: Rscript scripts/verify_step2_rebuild.R <pre_render_backup.sav> [project_root]
# hard-stops unless the regenerated main_corrected.sav is value-identical to the
# pre-render backup, the ledger invariants hold, the rendered page carries the
# evidence tables and figures, and the notebook source passes the register scan.

library(magrittr) # pipe operator only; all other calls are namespaced

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) stop("usage: Rscript verify_step2_rebuild.R <pre_render_backup.sav> [project_root]")
backup_path <- args[1]
project <- if (length(args) >= 2) args[2] else file.path(Sys.getenv("HOME"), "projects", "lifecourse-sep-diet")

qmd_path    <- file.path(project, "analysis", "data", "preparation", "index.qmd")
new_path    <- file.path(project, "assets", "data", "saved", "main_corrected.sav")
html_path   <- file.path(project, "_site", "analysis", "data", "preparation", "index.html")
fig_dir     <- file.path(project, "_site", "analysis", "data", "preparation", "index_files", "figure-html")
scored_path <- file.path(project, "assets", "data", "isco08_codes_scored.xlsx")

failures <- character(0)
note_fail <- function(msg) failures <<- c(failures, msg)
report <- function(ok, msg) {
  cat(sprintf("[%s] %s\n", if (ok) "pass" else "FAIL", msg))
  if (!ok) note_fail(msg)
}

# 1. register scan on the deployed notebook source
src <- paste(readLines(qmd_path, warn = FALSE), collapse = "\n")
banned <- c("supersed", "previous version", "earlier revision", "no longer", "deprecat", "old version")
hits <- banned[vapply(banned, function(p) grepl(p, src, ignore.case = TRUE), logical(1))]
report(length(hits) == 0, paste0("notebook register scan (banned phrases: ",
                                 if (length(hits)) paste(hits, collapse = ", ") else "none", ")"))

# 2. ledger invariants on the regenerated dataset
new <- haven::read_sav(new_path)
report(sum(duplicated(new$idnummer)) == 0, "unique idnummer in main_corrected.sav")

scored <- readxl::read_excel(scored_path, col_types = "text")
counts_file <- table(scored$source[!is.na(scored$isco08) & scored$isco08 != "NA" & scored$isco08 != ""])
counts_new <- c(
  respondent = sum(!is.na(new$isco08r)),
  father     = sum(!is.na(new$isco08r_father)),
  mother     = sum(!is.na(new$isco08r_mother)),
  partner    = sum(!is.na(new$isco08r_partner))
)
report(all(counts_new[names(counts_file)] == as.integer(counts_file)),
       sprintf("joined coded counts match the coding file (%s)",
               paste(sprintf("%s=%d", names(counts_new), counts_new), collapse = ", ")))
report(all(counts_new == c(respondent = 1452, father = 1421, mother = 1136, partner = 906)),
       "audited ledger counts hold: 1452/1421/1136/906")

coded_scored <- function(code, score) all(!is.na(new[[score]][!is.na(new[[code]])]))
report(coded_scored("isco08r", "isei08") && coded_scored("isco08r_father", "isei08_father") &&
       coded_scored("isco08r_mother", "isei08_mother") && coded_scored("isco08r_partner", "isei08_partner"),
       "every coded report carries an ISEI-08 score")
report(all(c("siops08_father", "egp11_father", "lf_status_mother") %in% names(new)),
       "score, class, and labour-force columns present")

# 3. value-identical to the pre-render backup (column by column)
if (!file.exists(backup_path)) {
  report(FALSE, paste("pre-render backup not found:", backup_path))
} else {
  old <- haven::read_sav(backup_path)
  report(nrow(old) == nrow(new), sprintf("row count unchanged (%d)", nrow(new)))
  same_names <- setequal(names(old), names(new))
  report(same_names, "column sets identical")
  if (same_names && nrow(old) == nrow(new)) {
    o <- old[order(old$idnummer), ]
    n <- new[order(new$idnummer), ]
    col_equal <- function(a, b) {
      a <- unclass(haven::zap_labels(a)); b <- unclass(haven::zap_labels(b))
      if (!identical(is.na(a), is.na(b))) return(FALSE)
      i <- !is.na(a)
      if (is.numeric(a) && is.numeric(b)) return(all(abs(a[i] - b[i]) < 1e-9))
      identical(as.character(a[i]), as.character(b[i]))
    }
    diff_cols <- names(n)[!vapply(names(n), function(cn) col_equal(o[[cn]], n[[cn]]), logical(1))]
    report(length(diff_cols) == 0,
           paste0("all column values identical to the pre-render backup",
                  if (length(diff_cols)) paste0(" (differs: ", paste(diff_cols, collapse = ", "), ")") else ""))
  }
}

# 4. rendered page carries the evidence layer
report(file.exists(html_path), "rendered page exists")
if (file.exists(html_path)) {
  html <- paste(readLines(html_path, warn = FALSE), collapse = "\n")
  needed <- c(
    "Summary of ISCO-08 Correction Records by Respondent Category",
    "Corrected ISCO-08 Codes with Justifications for Respondents",
    "Corrected ISCO-08 Codes with Justifications for Partners",
    "Corrected ISCO-08 Codes with Justifications for Mother",
    "Corrected ISCO-08 Codes with Justifications for Father",
    "Coding Review Outcomes by Respondent Category"
  )
  for (cap in needed) report(grepl(cap, html, fixed = TRUE), paste("caption present:", cap))
  figs <- list.files(fig_dir, pattern = "^visualize-corrections-.*\\.png$")
  report(length(figs) >= 4, sprintf("correction figures rendered (%d found)", length(figs)))
}

cat(sprintf("\n%s: %d check group(s) failed.\n",
            if (length(failures) == 0) "ALL CHECKS PASSED" else "VERIFICATION FAILED", length(failures)))
if (length(failures) > 0) quit(status = 1)
