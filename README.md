# International Stroke Trial Analysis: Aspirin and 6-Month Mortality

## Overview

This project analyzes data from the International Stroke Trial (IST) to evaluate whether randomized aspirin allocation was associated with six-month mortality among patients with acute ischemic stroke.

A secondary analysis examined whether the association between aspirin allocation and mortality differed according to baseline atrial fibrillation (AF) status.

The analysis was conducted in SAS and demonstrates an applied clinical-trial workflow including data cleaning, quality-control checks, descriptive statistics, logistic regression, covariate adjustment, interaction testing, and stratified analysis.

---

## Research Questions

### Primary Question

Among participants in the International Stroke Trial, was randomized aspirin allocation associated with lower six-month mortality compared with no aspirin allocation?

### Secondary Question

Did the effect of aspirin on six-month mortality differ according to baseline atrial fibrillation status?

---

## Study Design

The International Stroke Trial was a large randomized clinical trial of patients with acute ischemic stroke.

The original trial enrolled more than 19,000 participants and evaluated antithrombotic treatment strategies using a randomized factorial design.

Because aspirin allocation was randomized, the unadjusted treatment comparison serves as the primary comparison between treatment groups.

A covariate-adjusted logistic regression model was also fitted to account for important baseline prognostic characteristics and evaluate the robustness of the treatment-effect estimate.

---

## Exposure

The primary exposure was randomized aspirin allocation:

* Aspirin
* No aspirin

Treatment allocation was represented by the `RXASP` variable.

---

## Outcome

The primary outcome was all-cause mortality within six months of randomization.

A binary mortality variable was derived from the follow-up mortality information and coded as:

* `1` = died within six months
* `0` = alive at six months

Quality-control checks were performed after outcome derivation to verify correct coding.

---

## Covariates

The adjusted analysis included the following baseline characteristics:

* Age
* Sex
* Baseline systolic blood pressure
* Atrial fibrillation
* Level of consciousness
* Stroke subtype
* Randomized heparin allocation

Categorical predictors were modeled using reference-cell parameterization in `PROC LOGISTIC`.

---

## Data Preparation and Quality Control

The SAS workflow included:

* Importing the IST dataset
* Inspecting variable structure and distributions
* Recoding dataset-specific missing-value codes
* Deriving the six-month mortality outcome
* Recoding treatment and clinical variables
* Evaluating missingness
* Checking categorical-variable distributions
* Cross-validating derived variables
* Defining the complete-case analytic population

The final complete-case adjusted analysis included 18,298 participants.

Quality-control procedures were used throughout the workflow to verify that variable recoding and outcome derivation were performed correctly.

---

## Descriptive Analysis

Baseline patient characteristics were summarized using:

* Means and standard deviations for continuous variables
* Frequencies and percentages for categorical variables

Treatment-group characteristics were examined according to randomized aspirin allocation.

SAS procedures used included:

```sas
PROC MEANS
PROC FREQ
```

These analyses were used to describe the study population and inspect the distribution of key variables before regression modeling.

---

## Unadjusted Logistic Regression

An unadjusted logistic regression model estimated the relationship between randomized aspirin allocation and six-month mortality.

The model can be represented as:

$$
\text{logit}[P(Y=1)] =
\beta_0 + \beta_1(\text{Aspirin})
$$

where \(Y\) represents six-month mortality.

The resulting odds ratio compared mortality among participants randomized to aspirin with mortality among participants not randomized to aspirin.

---

## Covariate-Adjusted Logistic Regression

A multivariable logistic regression model was fitted using `PROC LOGISTIC`.

The adjusted model included:

* Aspirin allocation
* Age
* Sex
* Systolic blood pressure
* Atrial fibrillation
* Level of consciousness
* Stroke subtype
* Heparin allocation

The purpose of the adjusted model was to account for major baseline prognostic factors and assess whether the estimated aspirin effect was robust to covariate adjustment.

---

## Primary Result

Adjusted odds ratio for aspirin: 0.925

95% CI: 0.856–0.999

p = 0.047

This estimate indicates that participants randomized to aspirin had approximately 7.5% lower adjusted odds of six-month mortality compared with participants not randomized to aspirin.

The confidence interval was close to 1.0, suggesting that the magnitude of the estimated treatment effect was modest.

---

## Effect Modification by Atrial Fibrillation

To evaluate whether the aspirin effect differed according to baseline atrial fibrillation status, an interaction term was added to the adjusted logistic regression model:

$$
\text{Aspirin} \times \text{Atrial Fibrillation}
$$

The interaction test produced:

p = 0.638

There was no statistical evidence that the association between aspirin allocation and six-month mortality differed according to baseline atrial fibrillation status.

The lack of a statistically significant interaction should not be interpreted as proof that treatment effects were identical across AF groups.

---

## Stratified Analysis

Separate adjusted logistic regression models were also fitted among:

* Participants with atrial fibrillation
* Participants without atrial fibrillation

These models were used to estimate the aspirin treatment effect within each AF stratum.

The stratified analyses complemented the formal interaction test and provided subgroup-specific treatment-effect estimates.

---

## Interpretation

The analysis found a modest association between randomized aspirin allocation and lower six-month mortality after adjustment for important baseline prognostic characteristics.

The adjusted estimate favored aspirin, although the confidence interval was close to the null value.

There was no statistical evidence that the effect of aspirin differed between participants with and without baseline atrial fibrillation.

Overall, the project demonstrates how randomized clinical-trial data can be analyzed using regression modeling, interaction testing, and clinically defined subgroup analyses.

---

## Methods Demonstrated

### Epidemiologic and Statistical Methods

* Randomized treatment comparison
* Descriptive statistics
* Binary outcome analysis
* Logistic regression
* Multivariable covariate adjustment
* Effect-modification analysis
* Interaction testing
* Stratified analysis
* Complete-case analysis
* Confidence-interval interpretation
* Clinical interpretation of odds ratios

### SAS Programming

* DATA step processing
* Conditional recoding
* Missing-value handling
* Variable derivation
* `PROC IMPORT`
* `PROC CONTENTS`
* `PROC FREQ`
* `PROC MEANS`
* `PROC LOGISTIC`
* CLASS statements and reference categories
* Interaction terms
* Stratified regression models
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

Analysis performed using SAS.

---

## Data Source

International Stroke Trial Collaborative Group.

The International Stroke Trial was a large randomized clinical trial evaluating antithrombotic treatment among patients with acute ischemic stroke.

---

## Author

Vasilios (Bill) Janinis, MPH

MPH in Epidemiology and Biostatistics
Boston University School of Public Health

Areas of interest:

* Health Economics and Outcomes Research
* Real-World Evidence
* Pharmacoepidemiology
* Comparative Effectiveness Research
* Clinical Epidemiology
* Biostatistics
