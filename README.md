# Survival Analysis of a Randomised Cancer Trial

A clinical-trial **survival analysis** in **R**: does adjuvant chemotherapy delay
recurrence and prolong survival in colon cancer? Built from a real, published
**randomised controlled trial** with openly available patient-level data.

> Adjuvant **levamisole plus fluorouracil** cuts the rate of death by about
> **a third** versus observation (adjusted HR 0.67, 95% CI 0.53 to 0.86,
> p = 0.001; log-rank p = 0.003), with most of the benefit in preventing
> recurrence. Levamisole alone shows no benefit. A Random Survival Forest
> reaches the same discrimination as the Cox model and confirms the same drivers.

---

## Read the report

**[Full report (HTML)](https://kingsley-amg.github.io/clinical-trial-survival/)**,
with Kaplan-Meier curves, hazard-ratio forest plot, model diagnostics and a
plain-English interpretation, knitted from R Markdown. A **PDF version** is in
[`report/`](report/).

## The question

The cleanest evidence that a treatment works comes from a randomised controlled
trial. Here, 929 stage B/C colon cancer patients were randomised after surgery
to observation, levamisole, or levamisole plus fluorouracil, then followed for
recurrence and death. Because many patients had not had the event by the end of
follow-up (censoring), the analysis uses survival methods rather than averages.

## What it does

1. **Randomisation check**, a baseline balance table by arm (gtsummary), showing
   the groups are comparable, as randomisation should deliver.
2. **Kaplan-Meier survival curves** for overall survival and recurrence-free
   survival, with risk tables, median survival and **log-rank tests**.
3. **Cox proportional-hazards model**, adjusted hazard ratios with 95% CIs and a
   forest plot, controlling for age, nodal burden, tumour extent and grade.
4. **Diagnostics**, the proportional-hazards assumption tested with scaled
   Schoenfeld residuals (cox.zph).
5. **Machine-learning benchmark**, a **Random Survival Forest**
   (randomForestSRC), compared with Cox on the concordance index, with
   permutation variable importance.

## Key findings

| Result | Value |
|---|---|
| Lev+5FU vs observation (adjusted) | HR 0.67 (0.53 to 0.86), p = 0.001 |
| Log-rank test, overall survival | p = 0.003 |
| Median survival, control vs Lev+5FU | 5.7 years vs not reached |
| Cox C-index vs Random Survival Forest | comparable discrimination |
| Strongest prognostic drivers | positive nodes, local extent, age |

## Recommendation

Adjuvant levamisole plus fluorouracil delays recurrence and prolongs survival,
and the benefit is largest in the highest-risk patients (more than four positive
nodes, greater local extent), who are the clearest candidates for the combination.

## Structure

```
clinical-trial-survival/
|- 01_prepare.R              # load + clean the trial data, write tidy CSV + dictionary
|- survival_analysis.Rmd     # the full analysis (source)
|- data/                     # colon_clean.csv + data_dictionary.csv
|- docs/index.html           # knitted HTML report (GitHub Pages)
|- report/                   # PDF version
```

## Reproduce

```r
install.packages(c("survival","survminer","gtsummary","broom",
                   "randomForestSRC","dplyr","forcats","ggplot2",
                   "scales","rmarkdown"))
Rscript 01_prepare.R
rmarkdown::render("survival_analysis.Rmd")
```

## Data and tools

R, with survival, survminer, randomForestSRC, gtsummary and broom. Data: the
**colon cancer adjuvant-therapy trial** (Moertel et al.), a real published RCT
whose patient-level records ship in R's `survival` package, one of the few trials
with openly available individual data.

## Honest limitations

This is a single historical trial, so the specific regimen reflects the standard
of its era rather than current protocols; the value here is the method. Some
covariates have missing values (complete-case analysis for the models).
Randomisation supports a causal reading of the treatment effect, but the
prognostic factors are observational and may be confounded.

## Author

**Kingsley Amegah**, Health Data Scientist. GitHub: [@Kingsley-amg](https://github.com/Kingsley-amg)
