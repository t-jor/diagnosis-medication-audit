
-- Answer audit-focused questions, based on table "med_audit"

/*
1. What med did we spend the most money on in total?
  -- Solution a: returns med with highest spent - but without possible ties
*/
SELECT
  med_name,
  SUM(total_value) AS total_spent
FROM
  `healthtail-project-473107.health_tail_integration.med_audit`
WHERE
  source_table = "invoices" -- or WHERE stock_movement = "stock_in"
GROUP BY
  med_name
ORDER BY
  total_spent DESC
LIMIT
  1;
  
  -- Solution b: returns med with highest spent - including possible ties
WITH
  expenditures AS (
  SELECT
    med_name,
    SUM(total_value) AS total_spent
  FROM
    `healthtail-project-473107.health_tail_integration.med_audit`
  WHERE
    source_table = 'invoices'
  GROUP BY
    med_name )
SELECT
  med_name,
  total_spent
FROM
  expenditures
QUALIFY
  DENSE_RANK() OVER (ORDER BY total_spent DESC) = 1; 

  /* 
 2. What med had the highest monthly total_value spent on patients? At what month?
  -- Solution a: without possible ties
*/
SELECT
  med_name,
  month_label,
  SUM(total_value) AS total_spent
FROM
  `healthtail-project-473107.health_tail_integration.med_audit`
WHERE
  source_table = "visits" -- or WHERE stock_movement = "stock_out"
GROUP BY
  1,
  2
ORDER BY
  total_spent DESC
LIMIT
  1;

  -- Solution b: including possible ties (test with rank = 20)
WITH
  consumed AS (
  SELECT
    med_name,
    month_label,
    SUM(total_value) AS total_spent
  FROM
    `healthtail-project-473107.health_tail_integration.med_audit`
  WHERE
    source_table = 'visits'
  GROUP BY
    1,
    2 )
SELECT
  med_name,
  month_label,
  total_spent
FROM
  consumed
QUALIFY
  DENSE_RANK() OVER (ORDER BY total_spent DESC) = 1; 

  /*
3. What month was the highest in packs of meds spent in vet clinic?
  -- Solution a: without possible ties
*/
SELECT
  month_label,
  SUM(total_packs) AS total_consumed_packs
FROM
  `healthtail-project-473107.health_tail_integration.med_audit`
WHERE
  source_table = "visits" -- or WHERE stock_movement = "stock_out"
GROUP BY
  1
ORDER BY
  total_consumed_packs DESC
LIMIT
  1;

  -- Solution b: including possible ties
WITH
  consumed AS (
  SELECT
    month_label,
    SUM(total_packs) AS total_consumed_packs
  FROM
    `healthtail-project-473107.health_tail_integration.med_audit`
  WHERE
    source_table = 'visits'
  GROUP BY
    1 )
SELECT
  month_label,
  total_consumed_packs
FROM
  consumed
QUALIFY
  DENSE_RANK() OVER (ORDER BY total_consumed_packs DESC) = 1; 
  
  /*
4. What’s an average monthly spent in packs of the med that generated the most revenue?
  -- Solution a: without possible ties
*/
SELECT
  med_name,
  SUM(total_value) AS total_revenue,
  AVG(total_packs) AS avg_packs
FROM
  `healthtail-project-473107.health_tail_integration.med_audit`
WHERE
  source_table = 'visits'
GROUP BY
  1
ORDER BY
  total_revenue DESC
LIMIT
  1;

  -- Solution b: including possible ties
WITH
  consumed AS (
  SELECT
    med_name,
    SUM(total_value) AS total_revenue,
    AVG(total_packs) AS avg_packs
  FROM
    `healthtail-project-473107.health_tail_integration.med_audit`
  WHERE
    source_table = 'visits'
  GROUP BY
    1 )
SELECT
  med_name,
  total_revenue,
  avg_packs
FROM
  consumed
QUALIFY
  DENSE_RANK() OVER (ORDER BY total_revenue DESC) = 1;