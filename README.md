# Credit Card Fraud Analysis: Geographic and Merchant Risk Assessment (Rev1)

## Overview
This is a revised and improved version of my original credit card fraud analysis capstone project. This revision corrects analytical issues and provides cleaner, more accurate findings.

## What Changed in Rev1

### Corrections Made:
- **Fixed geographic ambiguity analysis**: The original version incorrectly reported ~34% geographic ambiguity due to a coding error that counted transactions per city instead of states per city. Analysis confirmed there is zero geographic ambiguity in the dataset.
- **Removed unnecessary sections**: Eliminated the "Data Quality Assessment: Geographic Ambiguity" section and related discussions that were based on the incorrect analysis.
- **Updated visualizations**: Corrected map captions to remove references to non-existent ambiguity issues.

### What Remains Accurate:
- All fraud pattern findings (state-level and merchant-level risk assessments)
- Bayesian statistical analysis and visualizations
- Temporal trend analysis
- Strategic recommendations

## Key Findings
- Identifies highest-risk states for credit card fraud
- Pinpoints specific merchants with elevated fraud rates
- Applies Bayesian methodology for statistically-robust risk estimates
- Provides actionable recommendations for fraud prevention resource allocation

## Technologies Used
- R / RMarkdown
- ggplot2, usmap, dplyr, lubridate
- Bayesian statistical methods

## Files
- `Capstone_Report.Rmd` - Main analysis file
- `/data` - Credit card fraud dataset
- `/visualizations` - Generated plots and maps

## Author
William Matthews

[Link to original version](https://github.com/billmarmcswss/credit-card-fraud-analysis)