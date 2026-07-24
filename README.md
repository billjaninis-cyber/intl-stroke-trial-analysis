# International Stroke Trial SAS Analysis

## Overview

This repository contains a secondary analysis of the International
Stroke Trial conducted in SAS.

The project evaluates whether randomized aspirin allocation was associated
with six-month mortality following acute ischemic stroke and whether this
association differed according to atrial fibrillation status.

## Research Questions

1. Is aspirin allocation associated with six-month mortality?
2. Does atrial fibrillation modify the association between aspirin and mortality?
3. Which baseline clinical characteristics are associated with mortality?

## Methods

The analysis included:

- Descriptive statistics and baseline characteristic tables
- Unadjusted logistic regression
- Multivariable logistic regression
- Aspirin-by-atrial-fibrillation interaction analysis
- Models stratified by atrial fibrillation status

The adjusted model included:

- Age
- Sex
- Systolic blood pressure
- Level of consciousness
- Stroke subtype
- Atrial fibrillation

## Key Results

The final complete-case analytic sample included 18,298 participants.

Randomized aspirin allocation was associated with modestly lower adjusted
odds of six-month mortality:

- Adjusted OR: 0.925
- 95% CI: 0.856–0.999
- p-value: 0.047

There was no evidence that atrial fibrillation modified the association
between aspirin allocation and mortality:

- Interaction p-value: 0.638

## Repository Structure

- `code/`: SAS programs used for data preparation and analysis
- `report/`: Final written report
- `output/`: Final tables and selected results
- `data/`: Data-access information; raw data are not redistributed

## Software

Analyses were conducted using SAS 9.4.

## Data Availability

The raw International Stroke Trial data are not included in this repository.
Users should obtain the dataset through the appropriate authorized source.

## Disclaimer

This analysis was completed for educational purposes and should not be used
to guide clinical care.
