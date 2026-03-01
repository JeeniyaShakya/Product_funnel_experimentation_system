SELECT 
  user_id,
  DATE(MIN(event_timestamp)) AS first_visit_date,
  SUM(revenue) AS total_user_revenue,
  MAX(CASE WHEN event_name = 'renew' THEN 1 ELSE 0 END) AS is_retained
FROM 
  `project-ee1dd28d-f35d-46f2-951.customer_data.saas_events_optimized`
GROUP BY 
  user_id;