# International Stroke Trial Analysis: Aspirin and 6-Month Mortality

## Overview

This project analyzes data from the International Stroke Trial (IST) to evaluate whether randomized aspirin allocation was associated with six-month mortality among patients with acute ischemic stroke.

A secondary analysis examined whether the association between aspirin allocation and mortality differed according to baseline atrial fibrillation (AF) status.

The analysis was conducted in SAS and demonstrates an applied clinical-trial workflow including data import, data inspection, missing-value recoding, quality-control checks, descriptive statistics, logistic regression, covariate adjustment, interaction testing, stratified analysis, array processing, DO loops, macro programming, and ODS output capture.

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

A covariate-adjusted logistic regression model was also fitted to account for important baseline prognostic characteristics and assess the robustness of the aspirin treatment-effect estimate.

---

## Exposure

The primary exposure was randomized aspirin allocation:

* Aspirin
* No aspirin

Treatment allocation was represented by the `RXASP` variable.

---

## Outcome

The primary outcome was all-cause mortality within six months of randomization.

A binary mortality variable was derived from the follow-up mortality variable and coded as:

* `1` = died within six months
* `0` = alive at six months

The derived mortality variable was cross-checked against the original follow-up mortality variable during quality control.

---

## Covariates

The adjusted analysis included the following baseline characteristics:

* Age
* Sex
* Baseline systolic blood pressure
* Atrial fibrillation
* Level of consciousness
* Stroke subtype

Categorical predictors were modeled using reference-cell parameterization in `PROC LOGISTIC`.

Reference categories included:

* No aspirin for `RXASP`
* Male for `SEX`
* Fully alert for `RCONSC`
* Lacunar anterior circulation syndrome for `STYPE`
* No atrial fibrillation for `RATRIAL`

---

## Data Import and Initial Inspection

The IST dataset was imported from CSV format using `PROC IMPORT`.

Initial dataset inspection included:

* `PROC CONTENTS` to inspect variable names, types, and attributes
* `PROC PRINT` to review the first observations
* `PROC MEANS` to inspect numeric-variable distributions

These steps were used to understand the dataset structure before beginning data cleaning.

---

## Data Cleaning

Data cleaning was performed in a SAS DATA step.

The cleaning workflow included:

* Recoding dataset-specific numeric missing-value codes
* Recoding character values representing unknown or unassessable observations
* Harmonizing treatment coding
* Deriving the numeric six-month mortality outcome

### Numeric Missing Values

Dataset-specific numeric codes representing missing or unknown values were converted to SAS numeric missing values.

Examples included:

* `HOURLOCAL = 99`
* `MINLOCAL = 99`
* `OCCODE = 0 or 9`
* `DDEADC = 0`
* `FDEADC = 0`

These values were recoded to `.`.

---

## Arrays and DO Loops

Arrays and iterative DO loops were used to reduce repetitive data-cleaning code.

### Baseline Deficit Variables

The variables `RDEF1` through `RDEF8` were coded as Y/N/C, where `C` indicated that the deficit could not be assessed.

An array was used to apply the same cleaning rule across all eight variables:

```sas
array rdef{8} RDEF1-RDEF8;

do i=1 to 8;
    if rdef{i} = 'C' then rdef{i} = '';
end;
```

This replaced multiple repeated IF statements with a single iterative operation.

### Variables Coded as Unknown

A second array included 33 variables where `U` represented an unknown value.

The same missing-value transformation was applied to each variable:

```sas
array unknown{33}
    DASP14 DASPLT DLH14 DMH14 DSCH DIVH DAP DOAC DGORM
    DSTER DCAA DHAEMD DCAREND DTHROMB DMAJNCH DSIDE
    DDIAGISC DDIAGHA DDIAGUN DNOSTRK DRSISC
    DRSH DRSUNK DPE DALIVE DDEAD DPLACE FPLACE FDEAD
    FRECOVER FDENNIS FAP FOAC;

do i=1 to 33;
    if unknown{i} = 'U' then unknown{i} = '';
end;
```

The temporary loop index `i` was dropped before saving the cleaned dataset.

---

## Mortality Outcome Derivation

A numeric mortality outcome was derived from `FDEAD`:

```sas
if FDEAD = 'Y' then FDEAD_num = 1;
else if FDEAD = 'N' then FDEAD_num = 0;
```

This variable was used as the binary outcome in all logistic regression models.

---

## Heparin Coding Harmonization

Pilot-phase medium-heparin allocation used the value `H`, whereas the main trial used `M` for the corresponding treatment category.

To consolidate the coding into a single category:

```sas
if RXHEP = 'H' then RXHEP = 'M';
```

Post-cleaning frequency checks were used to verify that only `N`, `L`, and `M` remained.

---

## Quality Control

Post-cleaning QC checks were performed to confirm that data transformations were applied correctly.

These included:

* Confirming that `RXHEP` contained only the expected treatment categories
* Confirming that `FDEAD_num` contained only valid binary values
* Cross-tabulating `FDEAD` against `FDEAD_num`
* Assessing missingness in age, systolic blood pressure, and mortality
* Reviewing distributions of key categorical analysis variables
* Checking atrial fibrillation missingness

SAS procedures used for quality control included:

```sas
PROC FREQ
PROC MEANS
```

---

## Descriptive Analysis

Baseline characteristics were summarized according to randomized aspirin allocation.

### Continuous Variables

Age and baseline systolic blood pressure were summarized using:

* Number of observations
* Mean
* Standard deviation

These statistics were generated using `PROC MEANS`.

### Categorical Variables

The following categorical variables were examined by aspirin allocation:

* Sex
* Level of consciousness
* Stroke subtype
* Heparin allocation
* Atrial fibrillation
* Six-month mortality

Frequencies were generated using `PROC FREQ`.

A chi-square test was also used to examine the distribution of atrial fibrillation according to randomized aspirin allocation.

---

## Crude Logistic Regression

An unadjusted logistic regression model estimated the relationship between randomized aspirin allocation and six-month mortality.

The model can be represented as:

```math
logit[P(Y=1)] = β0 + β1(Aspirin)
```

where `Y` represents six-month mortality.

The crude model was restricted to observations with complete information on the covariates used in the adjusted analysis so that the crude and adjusted estimates could be compared using a similar analytic population.

---

## Covariate-Adjusted Logistic Regression

A multivariable logistic regression model was fitted using `PROC LOGISTIC`.

The adjusted model included:

* Aspirin allocation
* Age
* Sex
* Baseline systolic blood pressure
* Level of consciousness
* Stroke subtype
* Atrial fibrillation

The model estimated the association between aspirin allocation and six-month mortality while accounting for major baseline prognostic characteristics.

---

## ODS Output

ODS OUTPUT was used to save selected logistic-regression output tables as SAS datasets.

For the adjusted model, parameter estimates and odds ratios were stored using:

```sas
ods output
    ParameterEstimates=adjusted_estimates
    OddsRatios=adjusted_oddsratios;
```

This created reusable SAS datasets containing the model results rather than leaving the estimates only in the SAS Results Viewer.

ODS OUTPUT was also used to save:

* Interaction-model parameter estimates
* AF-stratified model parameter estimates
* AF-stratified odds ratios

This approach supports reproducible reporting and automated extraction of model results.

---

## Primary Result

The covariate-adjusted model estimated:

Adjusted odds ratio for aspirin: 0.925

95% CI: 0.856–0.999

p = 0.047

This estimate indicates that participants randomized to aspirin had approximately 7.5% lower adjusted odds of six-month mortality compared with participants not randomized to aspirin.

The confidence interval was close to 1.0, suggesting that the magnitude of the estimated treatment effect was modest.

---

## Effect Modification by Atrial Fibrillation

To evaluate whether the aspirin effect differed according to baseline atrial fibrillation status, an interaction term was included in the adjusted logistic regression model:

```math
Aspirin × Atrial Fibrillation
```

The interaction test produced:

p = 0.638

There was no statistical evidence that the association between aspirin allocation and six-month mortality differed according to baseline atrial fibrillation status.

The absence of a statistically significant interaction should not be interpreted as proof that the aspirin effect was identical in participants with and without atrial fibrillation.

---

## Stratified Analysis

Separate adjusted logistic regression models were fitted among:

* Participants without atrial fibrillation
* Participants with atrial fibrillation

The same model specification was used in each subgroup:

```sas
model FDEAD_num(event='1') =
    RXASP AGE SEX RSBP RCONSC STYPE;
```

Atrial fibrillation itself was not included as a covariate within these models because each regression was restricted to a single AF stratum.

---

## SAS Macro Programming

Because the same logistic regression model was applied separately to the two AF strata, a parameterized SAS macro was used to avoid duplicated code.

The macro was defined as:

```sas
%macro af_model(af);

ods output
    ParameterEstimates=af_&af._estimates
    OddsRatios=af_&af._oddsratios;

proc logistic data=stroke_clean descending;

where RATRIAL = "&af";

class RXASP (ref='N')
      SEX(ref='M')
      RCONSC(ref='F')
      STYPE(ref='LACS')
      / param=ref;

model FDEAD_num(event='1') =
      RXASP AGE SEX RSBP RCONSC STYPE;

run;

ods output close;

%mend af_model;
```

The macro parameter `af` acts as a placeholder for atrial fibrillation status.

The macro was called twice:

```sas
%af_model(N);
%af_model(Y);
```

The first call runs the model among participants without atrial fibrillation, while the second runs the same model among participants with atrial fibrillation.

The macro also automatically saves subgroup-specific parameter estimates and odds ratios as separate SAS datasets.

---

## Interpretation

The analysis found a modest association between randomized aspirin allocation and lower six-month mortality after adjustment for important baseline prognostic characteristics.

The adjusted estimate favored aspirin, although the confidence interval was close to the null value.

There was no statistical evidence that the effect of aspirin differed according to baseline atrial fibrillation status.

Overall, the project demonstrates an applied workflow for analyzing randomized clinical-trial data using descriptive statistics, multivariable logistic regression, interaction analysis, and clinically defined subgroup models.

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
* Arrays
* Iterative DO loops
* Conditional logic
* Numeric and character missing-value recoding
* Variable derivation
* Treatment-code harmonization
* SAS macro programming
* Macro parameters and macro-variable resolution
* ODS OUTPUT
* Automated creation of model-result datasets
* `PROC IMPORT`
* `PROC CONTENTS`
* `PROC PRINT`
* `PROC FREQ`
* `PROC MEANS`
* `PROC LOGISTIC`
* CLASS statements and reference-category specification
* Interaction terms
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
* Value Statistics

