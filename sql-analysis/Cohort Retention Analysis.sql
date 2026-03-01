WITH User_Cohorts AS (
  -- 1. Find the exact month each user started their journey (Their "Birth Month")
  SELECT 
    user_id,
    DATE_TRUNC(DATE(MIN(event_timestamp)), MONTH) AS cohort_month
  FROM `project-ee1dd28d-f35d-46f2-951.customer_data.saas_events_optimized`
  GROUP BY user_id
),

Active_Months AS (
  -- 2. Find every unique month a user triggered any event (e.g., visiting, subscribing, renewing)
  SELECT DISTINCT 
    user_id,
    DATE_TRUNC(DATE(event_timestamp), MONTH) AS activity_month
  FROM `project-ee1dd28d-f35d-46f2-951.customer_data.saas_events_optimized`
),

Cohort_Distance AS (
  -- 3. Calculate how many months passed between their birth month and their activity month
  SELECT 
    u.cohort_month,
    a.activity_month,
    DATE_DIFF(a.activity_month, u.cohort_month, MONTH) AS month_number,
    u.user_id
  FROM User_Cohorts u
  JOIN Active_Months a ON u.user_id = a.user_id
),

Retention_Agg AS (
  -- 4. Pivot the raw counts into columns using conditional aggregation
  SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END) AS month_0_users, -- The starting cohort size
    COUNT(DISTINCT CASE WHEN month_number = 1 THEN user_id END) AS month_1_users,
    COUNT(DISTINCT CASE WHEN month_number = 2 THEN user_id END) AS month_2_users,
    COUNT(DISTINCT CASE WHEN month_number = 3 THEN user_id END) AS month_3_users
  FROM Cohort_Distance
  GROUP BY cohort_month
)

-- 5. Calculate the final percentages for your dashboard
SELECT 
  FORMAT_DATE('%Y-%m', cohort_month) AS cohort_month,
  month_0_users AS total_new_users,
  ROUND(SAFE_DIVIDE(month_1_users, month_0_users) * 100, 2) AS month_1_retention_pct,
  ROUND(SAFE_DIVIDE(month_2_users, month_0_users) * 100, 2) AS month_2_retention_pct,
  ROUND(SAFE_DIVIDE(month_3_users, month_0_users) * 100, 2) AS month_3_retention_pct
FROM Retention_Agg
ORDER BY cohort_month;
