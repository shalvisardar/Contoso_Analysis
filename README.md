# Contoso Business Analytics Project

Comprehensive analysis of **Contoso's Business Performance**, combining **Sales Performance** and **Customer Behavior** to uncover growth drivers, retention challenges, and strategic opportunities.

This project integrates multiple analytical perspectives to move beyond isolated metrics and build a **holistic understanding of business performance**.
<br><br>

## Project Objective

The goal of this project is to:

- Analyze revenue, profit, and cost trends over time  
- Understand the impact of pricing strategies on business performance  
- Evaluate customer retention and lifecycle behavior  
- Identify high-value customer segments  
- Provide actionable business recommendations  


## Tools & Technologies

- PostgreSQL - Data transformation and modeling  
- DBeaver - SQL development  
- Power BI - Dashboard visualization  


## Project Structure

### 1. Sales & Revenue Analysis
Focuses on business performance across 2019-2023:
- Revenue, profit, and cost trends  
- Pricing strategy and AOV dynamics  
- Margin resilience despite price cuts  
- Economic cycle interpretation  

📂 See detailed analysis: [Sales and Revenue Analysis](01_Sales_and_Revenue_Analysis)


### 2. Customer Behavior Analysis
Focuses on customer lifecycle and value:

- Cohort and retention analysis  
- Survival curve modeling  
- Pareto-based revenue concentration  
- RFM segmentation  
- Customer migration across segments  

📂 See detailed analysis: [Customer Analysis](02_Customer_Analysis)
<br><br><br>

# Key Business Insights

## 1. Strategic Pricing Drove Peak Revenue in 2022

- Revenue peaked at **$ 42.9M** in **2022**, following aggressive price cuts  
- Pricing strategy appears to have amplified the demand recovery seen in 2021  
 
*Growth was **strategy-driven**, not purely demand-driven*  


## 2. External Shock and Pricing Strategy Are Reflected in Retention Patterns

Cohort analysis clearly captures two major events:

- **2020 (Pandemic Impact):**
  - Customer retention ↓ **7.77%** averaging to **~6.27%**
  - Revenue retention ↓ **9.95%** averaging to **~5.08%**

- **2022 (Pricing Strategy):**
  - Customer retention ↑ **11.39%** averaging to **~22.26%**
  - Revenue retention ↑ **9.13%** averaging to **~20.60%**

*Indicates strong sensitivity of customer behavior to **external shocks and pricing actions***


## 3. Retention Breakdown Occurs Immediately After First Purchase

- **~55% of customers churn after their first purchase**  
- Only **~11% return for a second purchase**  
- Retention stabilizes at ~12% for subsequent periods  

*The biggest business risk lies in: **First → Second purchase conversion***


## 4. Revenue Is Highly Concentrated

- **~38.2% of customers drive ~80% of revenue**  

Strong Pareto distribution indicates:
- *Heavy reliance on a limited customer base*
- *Potential vulnerability if High-Value customers churn*  


## 5. Revenue Is Driven by a Small Set of High-Value Segments

- **Mid-Value, Champions,** and **Potential Champions** contribute **~70% of total revenue**  
- **~8% of customers (Single High-Value Buyers)** contribute **~14% of revenue**  

*These One-Time high spenders represent a **High-impact conversion opportunity***


## 6. Most Customers Follow a Declining Lifecycle Path

Typical customer journey:

    New Customer → Mid-Value → Low-Value → Churn Risk

Only a small proportion of customers transition into higher-value segments.

*Indicates:*
- *Weak retention mechanisms*  
- *Limited customer progression strategy* 
<br><br><br>


# Business Recommendations

## 1. Improve First-to-Second Purchase Conversion
- Identify friction points after initial purchase  
- Implement post-purchase engagement strategies  
- Offer targeted incentives for repeat purchases  


## 2. Strengthen High-Value Customer Strategy
- *Focus on:* 
    - Champions  
    - Potential Champions  
    - Mid-Value customers  
- *Approach:*
    - Loyalty programs  
    - Personalized offers  
    - Early access incentives  


## 3. Convert High-Value One-Time Buyers
- Re-target high spenders with personalized campaigns  
- Offer incentives for repeat purchases  
- Leverage product recommendations  


## 4. Optimize Pricing Strategy

- 2022 price cuts successfully drove volume and retention  
- However, they also contributed to reduced per-customer value  

*Future pricing should balance:*
- *Demand generation*  
- *Profitability*  
- *Customer lifetime value*  


## 5. Improve Retention Across Lifecycle Stages

- Identify early churn signals  
- Target “At Risk” and “About to Sleep” segments  
- Implement win-back campaigns  


---
---
