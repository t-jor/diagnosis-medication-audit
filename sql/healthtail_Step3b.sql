/*
Create an additional table for the Looker Studio Dashboard (in health_tail_consumer)
Purpose: inventory analysis >>> monthly medication inventory table with inflows, outflows, net flows and cumulative running totals
Restriction: inventory calculation starts at 0 in Jan 2024, because no opening balances are available
*/

CREATE OR REPLACE TABLE `healthtail-project-473107.health_tail_consumer.med_inventory_all` AS
WITH
-- 1) Inflows from "invoices"-table (stock_in)
stock_in AS (
  SELECT
    DATE_TRUNC(month_invoice, MONTH) AS month_date,                        -- month (DATE)
    FORMAT_DATE('%Y-%m', DATE_TRUNC(month_invoice, MONTH)) AS month_label, -- month as label (e.g. "2024-01")
    med_name,
    SUM(packs)       AS qty_in,        -- total packs purchased
    SUM(total_price) AS value_in       -- total purchase cost
  FROM `healthtail-project-473107.health_tail_raw.invoices`
  GROUP BY 1,2,3
),

-- 2) Outflows from "visits"-table (stock_out)
stock_out AS (
  SELECT
    DATE_TRUNC(DATE(visit_datetime), MONTH) AS month_date,                 -- month (DATE)
    FORMAT_DATE('%Y-%m', DATE_TRUNC(DATE(visit_datetime), MONTH)) AS month_label,
    med_prescribed AS med_name,
    SUM(med_dosage) AS qty_out,       -- total dosage prescribed (packs out)
    SUM(med_cost)   AS value_out      -- total medication cost
  FROM `healthtail-project-473107.health_tail_raw.visits`
  GROUP BY 1,2,3
),

-- 3) Merge inflows and outflows into one row per month & medication
monthly AS (
  SELECT
    COALESCE(i.month_date, o.month_date)   AS month_date,
    COALESCE(i.month_label, o.month_label) AS month_label,
    COALESCE(i.med_name, o.med_name)       AS med_name,

    COALESCE(i.qty_in,   0) AS qty_in,
    COALESCE(o.qty_out,  0) AS qty_out,
    COALESCE(i.value_in, 0) AS value_in,
    COALESCE(o.value_out,0) AS value_out,

    -- Net monthly flows (in - out)
    COALESCE(i.qty_in,0)   - COALESCE(o.qty_out,0)   AS qty_flow,
    COALESCE(i.value_in,0) - COALESCE(o.value_out,0) AS value_flow
  FROM stock_in i
  FULL OUTER JOIN stock_out o
    ON i.month_date = o.month_date
   AND i.med_name   = o.med_name
),

-- 4) Add running totals (cumulative inventory per medication)
final AS (
  SELECT
    month_date,
    month_label,
    med_name,
    qty_in,
    qty_out,
    qty_flow,
    value_in,
    value_out,
    value_flow,

    -- Running total of packs (cumulative stock per medication)
    SUM(qty_flow)   OVER (
      PARTITION BY med_name
      ORDER BY month_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_packs,

    -- Running total of value (cumulative cost/value per medication)
    SUM(value_flow) OVER (
      PARTITION BY med_name
      ORDER BY month_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_value
  FROM monthly
)

-- 5) Final output
SELECT *
FROM final
ORDER BY med_name, month_date;
