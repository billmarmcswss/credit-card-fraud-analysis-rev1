# Credit Card Fraud Risk Analysis Framework

## Project Overview
I developed a fraud risk assessment framework using Bayesian statistical methods to analyze over 100,000 credit card transactions. 
The challenge was that raw fraud rates can be misleading—a merchant with one fraud case out of five transactions shows 20%, 
but that's less reliable than a merchant with 50 cases out of 1,000 transactions at 5%. My Bayesian approach combined prior 
knowledge about overall fraud patterns with observed data to generate statistically-adjusted risk scores. The analysis 
identified New York as the highest-risk state and revealed significant merchant-level risk variations—some merchants 
showed fraud rates 3–4 times higher than average.

With larger datasets, this framework would yield even more refined patterns and a clearer picture of fraud dynamics. 
The methodology creates actionable intelligence for fraud prevention teams by providing reliable risk estimates that 
account for sample size effects, rather than reacting to statistical noise from small datasets.

*A comprehensive analysis of credit card fraud patterns using Bayesian statistical methods to identify geographic and merchant risk concentrations.*

## Project Highlights
- **Dataset:** 100,000+ credit card transactions (October 2023 – October 2024)
- **Methodology:** Bayesian risk modeling with geographic and temporal analysis
- **Key Finding:** Framework successfully identified risk patterns across multiple dimensions

## Technical Approach
- Data processing and quality assessment (85.3% geographic mapping success)
- Bayesian fraud rate calculation to account for statistical uncertainty
- Geographic hotspot analysis identifying NY as highest-risk state
- Merchant risk stratification revealing 3–4x risk variations
- Temporal pattern detection showing seasonal fraud cycles

## Business Impact
Developed a transferable analytical framework for ongoing fraud risk assessment that adapts to current data rather than relying on static assumptions.

## Repository Structure
- `/analysis/` – R analysis code and reports
- `/data/` – Dataset files
- `/visualizations/` – Generated charts and maps
- `/presentation/` – Final presentation materials

## How to Run

1. **Clone the repository:**
    ```
    git clone https://github.com/billmarmcswss/credit-card-fraud-analysis.git
    cd credit-card-fraud-analysis
    ```

2. **Install required R packages:**  
   *(Open R or RStudio, then run:)*  
    ```r
    # Required packages:
    install.packages(c("readr", "dplyr", "ggplot2", "usmap", "scales", "tibble", "stringr", "purrr", "gridExtra", "zoo", "lubridate", "tidyr"))
    ```

3. **Access the analysis:**  
    - Main analysis scripts are in `/analysis/`.
    - Run the main `.R` or `.Rmd` file (e.g., `fraud_analysis.Rmd`) for the full workflow, including data cleaning, modeling, and visualization.
    - Data files are in `/data/`.

4. **Outputs:**  
    - Visualizations will be generated in `/visualizations/`.
    - Reports and presentations can be found in `/presentation/`.

> **Note:**  
> Some datasets may be too large for GitHub. If required data is missing, please see the README in `/data/` for download instructions or contact the author.

## Limitations and Next Steps

- The dataset, while comprehensive, is limited to a single year of transactions. Broader timeframes could reveal longer-term trends.
- Merchant names and locations are anonymized; more detailed merchant info could yield deeper insights.
- Future work: Integrate additional data sources, test other statistical or machine learning models, and deploy as a real-time fraud monitoring tool.

## Questions or Feedback?
Feel free to open an issue or contact me via [LinkedIn](https://www.linkedin.com/in/william-matthews-65a071232/) with questions, feedback, or collaboration requests.




