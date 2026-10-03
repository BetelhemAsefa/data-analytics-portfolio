# Predicting Customer Response to Marketing Campaigns

**Goal:** Predict which customers will accept a marketing offer, so campaigns reach likely responders and spend less on people who won't respond.

**Data:** [Marketing Campaign dataset](https://www.kaggle.com/datasets/rodsaldanha/marketing-campaign) (Kaggle). Customer demographics, purchasing behavior, spending by product category, and past campaign responses. Target variable: `Response` (1 = accepted).

**Tools:** R (caret, randomForest, nnet, tidyverse)

## Approach

1. **Cleaning:** removed missing values; dropped ID and constant columns (`ID`, `Dt_Customer`, `Z_CostContact`, `Z_Revenue`); converted categorical variables to factors and combined rare marital-status categories
2. **Exploration:** found an **85/15 class imbalance**, since most customers did not respond
3. **Modeling:** 70/30 train/test split; trained Logistic Regression, Random Forest, and a Neural Network (tuned with 10-fold cross-validation)
4. **Evaluation:** confusion matrices with accuracy, sensitivity, specificity, F1, and Kappa

## Results

| Model | Accuracy | Sensitivity | Specificity | F1 | Kappa |
|---|---|---|---|---|---|
| Logistic Regression | 0.890 | 0.965 | 0.465 | 0.937 | 0.498 |
| Random Forest | 0.879 | 0.979 | 0.313 | 0.932 | 0.381 |
| **Neural Network** | 0.885 | 0.950 | **0.515** | 0.934 | **0.508** |

*Note: caret treated non-responders as the positive class, so sensitivity measures how well each model identifies non-responders, and specificity measures how well it identifies responders.*

## Key takeaway

Accuracy was misleading. Because 85% of customers don't respond, a model can score high just by predicting "no response" for almost everyone. I chose the **Neural Network** because it had the highest Kappa and was best at identifying actual responders, which are the customers a campaign is trying to reach.

## Files

- `Predicting_Customer_respose.R`: full analysis script
- `Predicting Customer Response to Marketing Campaigns Using Classification Models.pdf`: full report
