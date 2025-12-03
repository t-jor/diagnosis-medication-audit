-- 1: Clean table healthtail_reg_card >>> Create table "registration_clean" (in health_tail_integration)
CREATE OR REPLACE TABLE
  `healthtail-project-473107.health_tail_integration.registration_clean` AS
WITH
  base AS (
  SELECT
    patient_id,
    owner_id,
    owner_name,
    pet_type,
    COALESCE(breed, 'Unknown') AS breed, -- replace missing values in column breed with “Unknown”
    INITCAP(LOWER(patient_name)) AS patient_name, -- standardisation on column patient_name
    gender,
    patient_age,
    date_registration,
    REGEXP_REPLACE(owner_phone, r'[^0-9]', '') AS owner_phone -- remove non-numeric data from column owner_phone
  FROM
    `healthtail-project-473107.health_tail_raw.healthtail_reg_cards` ),
  -- clean column owner_name (step 1-3)
  name_clean AS (
  SELECT
    patient_id,
    owner_id,
    pet_type,
    breed,
    patient_name,
    gender,
    patient_age,
    date_registration,
    owner_phone,
    -- 1) Commas -> Remove spaces, multiple spaces
    REGEXP_REPLACE(REGEXP_REPLACE(owner_name, r',', ' '), r'\s+', ' ') AS owner_name_norm
  FROM
    base ),
  name_clean2 AS (
  SELECT
    patient_id,
    owner_id,
    pet_type,
    breed,
    patient_name,
    gender,
    patient_age,
    date_registration,
    owner_phone,
    -- 2) Remove prefixes at the beginning (Mr/Mrs/Ms/Miss/Mx/Dr/Prof/Rev/Sir/Lady/Lord)
    REGEXP_REPLACE(owner_name_norm, r'(?i)^\s*(mr|mrs|ms|miss|mx|dr|prof|rev|sir|lady|lord)\.?\s+', '' ) AS owner_name_no_prefix
  FROM
    name_clean ),
  name_final AS (
  SELECT
    patient_id,
    owner_id,
    pet_type,
    breed,
    patient_name,
    gender,
    patient_age,
    date_registration,
    owner_phone,
    -- 3) Remove suffixes at the end (Jr/Sr/II/III/IV/PhD/MD/DDS/DVM/CPA/Esq/MBA/RN)
    --    (+ allows multiple suffixes; only at the end)
    INITCAP(LOWER(TRIM( REGEXP_REPLACE(owner_name_no_prefix, r'(?i)(?:\s*,?\s*(jr|sr|ii|iii|iv|phd|md|dds|dvm|cpa|esq|mba|rn)\.?\s*)+$', '' ) ))) AS owner_name
  FROM
    name_clean2 )
SELECT
  patient_id,
  owner_id,
  owner_name,
  pet_type,
  breed,
  patient_name,
  gender,
  patient_age,
  date_registration,
  owner_phone
FROM
  name_final;

-- 2: Track movement of medications in stock, aggregate and combine visits and invoice tables (as base for Step2 SQL-queries)>>> Create table "med_audit" (in health_tail_consumer)
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