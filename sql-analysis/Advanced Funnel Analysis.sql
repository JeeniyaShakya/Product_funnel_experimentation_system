WITH Funnel_Base AS (
  -- 1. CTE & COUNT DISTINCT: Aggregate unique users at each stage, cohorted by experiment_group
  SELECT
    experiment_group AS cohort,
    event_name,
    COUNT(DISTINCT user_id) AS users_at_stage
  FROM `project-ee1dd28d-f35d-46f2-951.customer_data.saas_events_optimized`
  WHERE event_name IN ('visit_website', 'sign_up', 'complete_onboarding', 'subscribe')
  GROUP BY experiment_group, event_name
),

Ordered_Funnel AS (
  -- 2. CTE: Force the events into a logical step-by-step funnel sequence
  SELECT 
    cohort,
    CASE 
      WHEN event_name = 'visit_website' THEN 1
      WHEN event_name = 'sign_up' THEN 2
      WHEN event_name = 'complete_onboarding' THEN 3
      WHEN event_name = 'subscribe' THEN 4
    END AS step_number,
    event_name AS stage_name,
    users_at_stage
  FROM Funnel_Base
)

-- 3. WINDOW FUNCTIONS & COHORT LOGIC: Calculate dynamic drop-offs and conversion rates
SELECT 
  cohort,
  step_number,
  stage_name,
  users_at_stage,
  
  -- Window Function (LAG): Finds the exact number of users in the previous step
  LAG(users_at_stage) OVER(PARTITION BY cohort ORDER BY step_number) AS previous_stage_users,
  
  -- Window Function (FIRST_VALUE): Always references the top of the funnel (Website Visitors)
  FIRST_VALUE(users_at_stage) OVER(PARTITION BY cohort ORDER BY step_number) AS total_visitors,

  -- METRIC: Step-to-Step Drop-off %
  ROUND((1 - SAFE_DIVIDE(users_at_stage, LAG(users_at_stage) OVER(PARTITION BY cohort ORDER BY step_number))) * 100, 2) AS step_dropoff_pct,

  -- METRIC: Overall Conversion Rate (from initial visit to this specific stage)
  ROUND(SAFE_DIVIDE(users_at_stage, FIRST_VALUE(users_at_stage) OVER(PARTITION BY cohort ORDER BY step_number)) * 100, 2) AS total_conversion_pct

FROM Ordered_Funnel
ORDER BY cohort, step_number;
