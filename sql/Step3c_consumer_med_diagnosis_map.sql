/*
Create an additional table for the Looker Studio Dashboard (in health_tail_consumer)
Purpose: mapping of med_name to diagnosis
*/
CREATE OR REPLACE TABLE healthtail-project-473107.health_tail_consumer.med_diagnosis_map AS
SELECT DISTINCT
  med_prescribed AS med_name,
  diagnosis
FROM `healthtail-project-473107.health_tail_raw.visits`;