WITH User_Metrics AS (
  -- Calculate lifetime metrics for every single user
  SELECT 
    user_id,
    DATE(MIN(event_timestamp)) AS first_visit_date,
    SUM(revenue) AS total_user_revenue,
    -- If they ever triggered a 'renew' event, we count them as retained (1), else churned (0)
    MAX(CASE WHEN event_name = 'renew' THEN 1 ELSE 0 END) AS is_retained
  FROM `project-ee1dd28d-f35d-46f2-951.customer_data.saas_events_optimized`
  GROUP BY user_id
),

Before_After_Split AS (
  -- Tag users based on when they started their journey
  SELECT 
    user_id,
    total_user_revenue,
    is_retained,
    CASE 
      WHEN first_visit_date < '2025-04-01' THEN '1. Before Launch (Jan-Mar)'
      ELSE '2. After Launch (Apr-Jun)' 
    END AS launch_period
  FROM User_Metrics
)

-- Aggregate the final metrics for comparison
SELECT 
  launch_period,
  COUNT(user_id) AS total_users_in_cohort,
  ROUND(AVG(total_user_revenue), 2) AS average_revenue_per_user,
  ROUND(AVG(is_retained) * 100, 2) AS retention_rate_pct
FROM Before_After_Split
GROUP BY launch_period
ORDER BY launch_period;