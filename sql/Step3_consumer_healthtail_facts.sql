  /*
Join visits-table with cleaned registration info as base for the Looker Studio Dashboard >>> Create table "healthtail_facts" (in health_tail_consumer)
*/
CREATE OR REPLACE TABLE
  `healthtail-project-473107.health_tail_consumer.healthtail_facts` AS
SELECT
  visit_id,
  patient_id,
  visit_datetime AS visit_day,
  DATE_TRUNC(DATE(visit_datetime), MONTH) AS visit_month,
  FORMAT_DATE('%Y-%m', DATE_TRUNC(visit_datetime, month)) AS visit_month_label,
  doctor,
  diagnosis,
  med_prescribed,
  med_dosage,
  med_cost,
  pet_type,
  breed,
  gender,
  patient_age,
  CASE
    WHEN pet_type = 'Dog' THEN 
      CASE
        WHEN patient_age IS NULL THEN 'Unknown'
        WHEN patient_age < 2 THEN 'Dog: 0–1 (Puppy)'
        WHEN patient_age < 8 THEN 'Dog: 2–7 (Adult)'
        ELSE 'Dog: 8+ (Senior)'
      END
    WHEN pet_type = 'Cat' THEN 
      CASE
        WHEN patient_age IS NULL THEN 'Unknown'
        WHEN patient_age < 2 THEN 'Cat: 0–1 (Kitten)'
        WHEN patient_age < 11 THEN 'Cat: 2–10 (Adult)'
        ELSE 'Cat: 11+ (Senior)'
      END
    ELSE 
      CASE
        WHEN patient_age IS NULL THEN 'Unknown'
        WHEN patient_age < 2 THEN 'Other: 0–1'
        WHEN patient_age < 8 THEN 'Other: 2–7'
        ELSE 'Other: 8+'
      END
  END AS age_bucket_species,
  date_registration
FROM
  healthtail-project-473107.health_tail_raw.visits
LEFT JOIN
  healthtail-project-473107.health_tail_integration.registration_clean
USING
  (patient_id);