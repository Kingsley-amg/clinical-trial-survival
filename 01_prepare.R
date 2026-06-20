# =============================================================================
# Clinical trial survival analysis: data preparation
# -----------------------------------------------------------------------------
# Source: the colon cancer adjuvant-therapy trial (Moertel et al.), a real,
# published 3-arm randomised controlled trial whose patient-level data ships in
# R's `survival` package (one of the few RCTs with openly available records).
#
# 929 patients with stage B/C colon cancer randomised to:
#   Obs     = observation only (control)
#   Lev     = levamisole
#   Lev+5FU = levamisole + fluorouracil
# Two endpoints are recorded per patient (etype): 1 = recurrence, 2 = death.
#
# This script loads, cleans and labels the data and writes a tidy CSV plus a
# data dictionary used by the R Markdown analysis.
# =============================================================================
suppressMessages({library(survival); library(dplyr); library(forcats)})

data(cancer, package = "survival")

clean <- colon |>
  mutate(
    rx        = factor(rx, levels = c("Obs", "Lev", "Lev+5FU")),
    sex       = factor(sex, levels = c(0, 1), labels = c("Female", "Male")),
    obstruct  = factor(obstruct, levels = c(0, 1), labels = c("No", "Yes")),
    perfor    = factor(perfor, levels = c(0, 1), labels = c("No", "Yes")),
    adhere    = factor(adhere, levels = c(0, 1), labels = c("No", "Yes")),
    differ    = factor(differ, levels = c(1, 2, 3),
                       labels = c("Well", "Moderate", "Poor")),
    extent    = factor(extent, levels = c(1, 2, 3, 4),
                       labels = c("Submucosa", "Muscle", "Serosa", "Contiguous")),
    surg      = factor(surg, levels = c(0, 1),
                       labels = c("Short (<20d)", "Long (>=20d)")),
    node4     = factor(node4, levels = c(0, 1),
                       labels = c("1-3 nodes", ">4 nodes")),
    endpoint  = factor(etype, levels = c(1, 2),
                       labels = c("Recurrence", "Death")),
    time_yrs  = time / 365.25
  ) |>
  select(id, rx, age, sex, obstruct, perfor, adhere, nodes, node4,
         differ, extent, surg, endpoint, etype, time, time_yrs, status)

# Sanity checks
stopifnot(nrow(clean) == 1858, length(unique(clean$id)) == 929)

write.csv(clean, "data/colon_clean.csv", row.names = FALSE)

# Data dictionary
dict <- tibble::tribble(
  ~variable,   ~description,
  "id",        "Patient identifier (each appears twice: recurrence + death rows)",
  "rx",        "Randomised treatment arm: Obs, Lev, Lev+5FU",
  "age",       "Age in years at randomisation",
  "sex",       "Female / Male",
  "obstruct",  "Colon obstruction by tumour (No/Yes)",
  "perfor",    "Colon perforation (No/Yes)",
  "adhere",    "Adherence to nearby organs (No/Yes)",
  "nodes",     "Number of lymph nodes with detectable cancer",
  "node4",     "More than 4 positive nodes (1-3 nodes / >4 nodes)",
  "differ",    "Tumour differentiation: Well / Moderate / Poor",
  "extent",    "Extent of local spread: Submucosa..Contiguous",
  "surg",      "Time from surgery to registration (short/long)",
  "endpoint",  "Which event this row measures: Recurrence or Death",
  "etype",     "Event type code: 1 = recurrence, 2 = death",
  "time",      "Days to event or censoring",
  "time_yrs",  "Years to event or censoring",
  "status",    "Event indicator: 1 = event occurred, 0 = censored"
)
write.csv(dict, "data/data_dictionary.csv", row.names = FALSE)

cat("Wrote data/colon_clean.csv (", nrow(clean), "rows ) and data_dictionary.csv\n")
cat("Patients:", length(unique(clean$id)), "\n")
cat("Deaths:", sum(clean$status[clean$etype == 2]),
    "| Recurrences:", sum(clean$status[clean$etype == 1]), "\n")
print(table(Arm = clean$rx[clean$etype == 2]))
