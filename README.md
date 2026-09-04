# International Stroke Trial Analysis: Aspirin and 6-Month Mortality

## Overview

This project analyzes data from the International Stroke Trial (IST) to evaluate whether randomized aspirin allocation was associated with six-month mortality among patients with acute ischemic stroke.

A secondary analysis examined whether the aspirin effect differed according to baseline atrial fibrillation (AF) status.

The analysis was conducted in SAS and demonstrates an applied clinical-trial workflow including data cleaning, descriptive statistics, logistic regression, interaction testing, subgroup analysis, arrays, DO loops, macro programming, and ODS output capture.

---

## Research Questions

### Primary Question

Among participants in the International Stroke Trial, was randomized aspirin allocation associated with lower six-month mortality compared with no aspirin allocation?

### Secondary Question

Did the effect of aspirin on six-month mortality differ according to baseline atrial fibrillation status?

---

## Study Design

The International Stroke Trial was a large randomized clinical trial of more than 19,000 patients with acute ischemic stroke.

Because aspirin allocation was randomized, the analysis included both an unadjusted treatment comparison and a covariate-adjusted logistic regression model.

---

## Exposure and Outcome

Exposure:

* Randomized aspirin allocation (`RXASP`)
* Aspirin vs. no aspirin

Outcome:

* Six-month all-cause mortality
* Derived as `FDEAD_num`
* `1` = died within six months
* `0` = alive at six months

---

## Covariates

The adjusted model included:

* Age
* Sex
* Baseline systolic blood pressure
* Atrial fibrillation
* Level of consciousness
* Stroke subtype

Categorical predictors were modeled using reference-cell parameterization in `PROC LOGISTIC`.

---

## Data Preparation

Data cleaning included:

* Recoding dataset-specific numeric and character missing-value codes
* Converting unknown and unassessable responses to SAS missing values
* Deriving the numeric six-month mortality outcome
* Harmonizing pilot-phase and main-trial heparin coding
* Performing post-cleaning quality-control checks

SAS arrays and iterative DO loops were used to streamline repeated missing-value recoding across multiple variables.

The cleaned dataset retained all 19,435 original observations.

---

## Descriptive Analysis

Baseline characteristics were summarized according to randomized aspirin allocation.

Continuous variables:

* Age
* Baseline systolic blood pressure

Categorical variables:

* Sex
* Level of consciousness
* Stroke subtype
* Heparin allocation
* Atrial fibrillation
* Six-month mortality

`PROC MEANS` and `PROC FREQ` were used for descriptive summaries.

---

## Statistical Analysis

### Crude Logistic Regression

An unadjusted logistic regression model estimated the relationship between randomized aspirin allocation and six-month mortality.

### Covariate-Adjusted Logistic Regression

A multivariable logistic regression model estimated the aspirin effect while adjusting for baseline prognostic characteristics.

### Effect Modification

An aspirin × atrial fibrillation interaction term was included to evaluate whether the treatment effect differed according to AF status.

### Stratified Analysis

Separate adjusted logistic regression models were fitted among:

* Participants without atrial fibrillation
* Participants with atrial fibrillation

A parameterized SAS macro was used to run the same model specification in both AF strata.

---

## Results

The covariate-adjusted model estimated:

* Adjusted odds ratio for aspirin: 0.925
* 95% CI: 0.856–0.999
* p = 0.047

Participants randomized to aspirin had approximately 7.5% lower adjusted odds of six-month mortality compared with participants not randomized to aspirin.

The aspirin × atrial fibrillation interaction was not statistically significant:

* Interaction p = 0.638

There was no statistical evidence that the aspirin effect differed according to baseline AF status.

---

## SAS Programming Techniques

This project demonstrates:

* DATA step processing
* Arrays
* Iterative DO loops
* Conditional recoding
* Missing-value handling
* Variable derivation
* Macro programming
* Macro parameters
* ODS OUTPUT
* Automated saving of model estimates
* `PROC IMPORT`
* `PROC CONTENTS`
* `PROC PRINT`
* `PROC FREQ`
* `PROC MEANS`
* `PROC LOGISTIC`
* Interaction modeling
* Stratified regression
* Data quality-control checks

---

## Repository Contents

```text
intl-stroke-trial-analysis/
│
├── README.md
└── Intl Stroke Analysis.sas
```

Patient-level data are not redistributed in this repository.

---

## Software

SAS

---

## Data Source

International Stroke Trial Collaborative Group.

---
