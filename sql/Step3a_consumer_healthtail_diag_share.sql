/*
Create an additional table for the Looker Studio Dashboard (in health_tail_consumer)
Purpose: show diagnosis share per month
*/
CREATE OR REPLACE TABLE
  `healthtail-project-473107.health_tail_consumer.healthtail_diag_share` AS
WITH monthly AS (
  SELECT
    DATE_TRUNC(DATE(visit_datetime), MONTH) AS visit_month,
    FORMAT_DATE('%Y-%m', DATE_TRUNC(visit_datetime, MONTH)) AS visit_month_label,
    diagnosis,
    COUNT(*) AS diag_count
  FROM
    `healthtail-project-473107.health_tail_raw.visits`
  GROUP BY 1, 2, 3
),
totals AS (
  SELECT
    visit_month,
    SUM(diag_count) AS total_count
  FROM monthly
  GROUP BY 1
)
SELECT
  m.visit_month,
  m.visit_month_label,
  m.diagnosis,
  m.diag_count,
  t.total_count,
  SAFE_DIVIDE(m.diag_count, t.total_count) AS diag_share
FROM monthly m
JOIN totals t
  ON m.visit_month = t.visit_month;
