# 🚀 Product Funnel Analytics & Experimentation System

## 📌 Project Overview
This project is an end-to-end product analytics engine designed to simulate and analyze user behavior for a SaaS application. By engineering a longitudinal dataset of **200,000+ events**, I modeled the entire user journey—from initial website visit to long-term subscription renewal. The system identifies friction points in the conversion funnel, measures "stickiness" through cohort retention matrices, and provides a statistical framework for A/B test validation.

## 🎯 Business Problem
Most organizations struggle to answer critical growth questions: 
* **Where exactly do users drop off?** (Conversion Friction)
* **Is our new feature actually driving revenue, or is it noise?** (Statistical Significance)
* **How long do users stay before churning?** (Cohort Retention)

## 🛠️ Tech Stack & Skills
* **Data Engineering:** Python (Pandas, NumPy)
* **Data Warehousing:** Google BigQuery (SQL)
* **Advanced Analytics:** SQL (Window Functions, CTEs, Cohort Logic)
* **Statistics:** Python (SciPy) for Independent T-Tests
* **Data Visualization:** Power BI

## 🏗️ Phase 1: Data Engineering & Modeling
To mimic a real-world production environment, I engineered a **relational, event-based dataset.**
* **Event Generation:** Python script simulating 50,000 users over 6 months.
* **Probabilistic Logic:** Defined distinct conversion paths for "Control" and "Variant" groups.
* **Schema:** `user_id`, `event_name`, `timestamp`, `device`, `country`, `experiment_group`.

## 🧱 Phase 2: Advanced Funnel Analysis
Using **BigQuery SQL**, I built a dynamic funnel to track acquisition, activation, and conversion.
**Key Metric:** Identified a critical drop-off point at the onboarding stage, allowing for targeted UX interventions.



## 📊 Phase 3: Cohort Retention Analysis
* **Analytical Framework**: Developed a Retention Matrix using SQL to track how different monthly cohorts returned to the platform over time.
* **Visualization**: Transformed the matrix into a Clustered Retention Chart (see Dashboard) to highlight a stable ~6% Month 1 retention rate across all cohorts.
* **Insight**: Confirmed that the new revenue from the Variant group is sustainable and not a one-time spike.



## 🧪 Phase 4: A/B Testing & Statistical Validation
* **Challenge:** Identified **Cohort Maturation Bias** in initial analysis.
* **Solution:** Conducted a concurrent Independent T-Test using Python.
* **Results:** Variant ARPU ($5.58) vs. Control ARPU ($2.89).
* **Conclusion:** Achieved a **92.9% revenue uplift** with $p < 0.001$.

## 📈 Phase 5: Executive Dashboard (Power BI)
The data was translated into a high-level business summary to communicate results to non-technical stakeholders.

### **Dashboard Screenshot**
![Product Funnel Dashboard](https://github.com/JeeniyaShakya/Product_funnel_experimentation_system/blob/main/Saas_growth_exp_dashboard.png)

## 🏆 Techniques Used
* **Funnel Visualization:** Dynamic slicers to compare conversion between experiment groups.
* **Retention Heatmap:** Conditional formatting to highlight high-performing cohorts.
* **Revenue Trend:** Line charts displaying the "breakaway" point of the Variant group.
* **Smart Narratives:** Summary of Step 5 Python results for immediate stakeholder understanding.

## 🏁 Final Conclusion
* **Recommendation:** Ship the Variant feature to 100% of the user base immediately.
* **Growth Insight:** Prioritize "Onboarding" UX engineering, as it represents the highest churn within the first 48 hours of the user journey.
