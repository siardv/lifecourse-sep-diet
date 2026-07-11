# Life-course SEP and diet quality

Reproducible analysis pipeline for a study of socioeconomic position across the
life course and diet quality in 1,784 Dutch adults. The pipeline is a Quarto
website of twelve notebooks covering data preparation through model evaluation,
built around robust linear regression with bootstrap inference.

**Published site:** <https://siardv.github.io/lifecourse-sep-diet/>

## Pipeline

| Step | Notebook | Purpose |
| ---- | -------- | ------- |
| 1 | Setup | Environment, options, shared functions |
| 2 | ISCO-08 Standardization and Validation | Audited occupation coding; attaches BRC14, ISEI-08, SIOPS-08, EGP-11; documents every correction with its justification |
| 3 | Data Cleaning & Recoding | Variable transformation and consistency |
| 4 | Detecting & Removing Outliers | Univariate and multivariate screening |
| 5 | Missing Data Imputation | Random forest imputation via missForest |
| 6 | Post-Imputation Finalization | Analysis-ready dataset |
| 7&#8209;9 | Models | Unadjusted models, assumption checks, adjusted models |
| 10&#8209;12 | Evaluation | Model fit, interaction effects, performance metrics |

## Repository layout

- `analysis/` notebook sources (`index.qmd` per step)
- `assets/data/` coding workbooks and public classification lookups
- `assets/functions/` shared R helper functions
- `assets/bib/`, `assets/style/` bibliography and site styling
- `scripts/` maintenance utilities, including `publish_site.sh`
- `_quarto.yml` site configuration

## Data availability

Individual-level survey data (`main_initial.sav` and datasets derived from it)
are not distributed in this repository. The audited ISCO-08 coding workbooks
and the public classification lookups (CBS BRC 2014 crosswalk, EGP lookup) are
included, and every occupation coding decision is documented on the step 2
page of the published site.

## Rendering

Requires R (4.6 or later) and Quarto (1.9 or later); each notebook loads its
own packages. A full render additionally requires the restricted source data,
so the published site is the reference output:

```sh
quarto render            # rebuild the site into _site/
scripts/publish_site.sh  # publish _site/ to the gh-pages branch
```

## Status

Manuscript under review. Author: Siard van den Bosch.

## Use of generative AI

All code, analyses, and text in this repository were written by the author. Generative AI tools (ChatGPT, Gemini, Claude, and Grok) were used only to obtain feedback and language suggestions on author-written manuscript drafts, as stated in the manuscript's declaration of generative AI and AI-assisted technologies; they were not used to generate the code, the analyses, or the references.
