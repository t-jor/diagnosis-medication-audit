
-- Create table "med_audit" (in health_tail_consumer)
-- Purpose: Track movement of medications in stock, aggregate and combine visits and invoice tables (as base for answering audit-focused questions via SQL-queries)

CREATE OR REPLACE TABLE
  `healthtail-project-473107.health_tail_consumer.med_audit` AS
WITH
  stock_in AS (
  SELECT
    DATE_TRUNC(month_invoice, MONTH) AS month_date,
    FORMAT_DATE('%Y-%m', DATE_TRUNC(month_invoice, MONTH)) AS month_label,
    med_name,
    SUM(packs) AS qty,
    SUM(total_price) AS value,
    'stock_in' AS stock_movement,
    'invoices' AS source_table
  FROM
    `healthtail-project-473107.health_tail_raw.invoices`
  GROUP BY
    1,
    2,
    3 ),
  stock_out AS (
  SELECT
    DATE_TRUNC(visit_datetime, MONTH) AS month_date,
    FORMAT_DATE('%Y-%m', DATE_TRUNC(visit_datetime, MONTH)) AS month_label,
    med_prescribed AS med_name,
    SUM(med_dosage) AS qty,
    SUM(med_cost) AS value,
    'stock_out' AS stock_movement,
    'visits' AS source_table
  FROM
    `healthtail-project-473107.health_tail_raw.visits`
  GROUP BY
    1,
    2,
    3 )
SELECT
  month_date,
  month_label,
  med_name,
  ROUND(qty, 2) AS total_packs,
  ROUND(value, 2) AS total_value,
  stock_movement,
  -- Auxiliary field for inventory flow: additions positive, disposals negative
  CASE
    WHEN stock_movement = 'stock_in' THEN ROUND(qty, 2)
    ELSE -ROUND(qty, 2)
  END AS qty_flow,
  CASE
    WHEN stock_movement = 'stock_in' THEN ROUND(value, 2)
    ELSE -ROUND(value, 2)
  END AS value_flow,
  source_table
FROM (
  SELECT
    *
  FROM
    stock_in
  UNION ALL
  SELECT
    *
  FROM
    stock_out );