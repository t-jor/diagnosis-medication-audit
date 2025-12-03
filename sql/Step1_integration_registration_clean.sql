
-- Create table "registration_clean" (in health_tail_integration)
-- Purpose: Clean table healthtail_reg_card 

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
