# Customer Segmentation Using K-Means Clustering

**Goal:** Group mall customers into segments with distinct spending behavior so marketing can target each group differently instead of treating everyone the same.

**Data:** [Mall Customer Segmentation dataset](https://www.kaggle.com/datasets/vjchoudhary7/customer-segmentation-tutorial-in-python) (Kaggle). 200 customers, 5 variables (ID, gender, age, annual income, spending score). No missing values.

**Tools:** R (tidyverse, cluster)

## Approach

1. Exploratory analysis with histograms, boxplots for outliers, and an income vs. spending scatter plot
2. Clustering on standardized Age, Annual Income, and Spending Score
3. Choosing the number of clusters with the **Elbow Method** and **silhouette analysis**; both pointed to **k = 5**
4. Profiling each cluster and translating the profiles into business actions

## Segments

| Segment | Profile | Recommended action |
|---|---|---|
| High income, high spending | ~$86K income, spending score ~81.5 | Retain with loyalty programs and exclusive offers |
| High income, low spending | ~$86K income, spending score ~19.4 | **Main growth opportunity:** promotions and personalized recommendations |
| Moderate income, active spending | ~$41K income, spending score ~62.2 | Keep engaged with rewards and regular communication |
| Low income, low spending | ~$26.8K income, spending score ~18.4 | Spend fewer marketing resources here |
| Older, moderate behavior | Average age ~55.6 | Value-focused, practical product offers |

## Files

- `Customer Segmentation.R`: full analysis script
- `Customer Segmentation Using K-Means Clustering.pdf`: full report with figures

To run it, download `Mall_Customers.csv` from Kaggle into the same folder.
