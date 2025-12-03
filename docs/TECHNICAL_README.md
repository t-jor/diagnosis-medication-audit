# Technical Documentation – HealthTail BI Project

This document describes the data model, ETL logic, SQL components and architecture behind the HealthTail BI solution.  
It provides a detailed technical reference for anyone reviewing the implementation.

---

## 1. Data Sources

The client provided three CSV files:

### 1.1 healthtail_reg_cards

- Patient & owner information  
- Columns include: owner_id, patient_id, breed, pet_type, age, patient_name, owner_phone, date_registration  

### 1.2 visits

- Clinical visits and treatments  
- Includes: visit_id, patient_id, diagnosis, doctor, visit_datetime, medication prescribed, dosage, medication cost  

### 1.3 invoices

- Medication purchase logs  
- Includes: med_name, packs, pack_price, total_price, month_invoice  

These files were uploaded into the RAW dataset in BigQuery.

---

## 2. Layered BigQuery Architecture

The project follows a clear 3-layer modeling structure:

```text
RAW → INTEGRATION → CONSUMER → Looker Studio
```

### 2.1 RAW Layer

Exact copies of the client-provided CSVs.

### 2.2 INTEGRATION Layer

- `registration_clean` → cleaned patient/owner dataset  
- `med_audit` → consolidated medication stock in/out  

### 2.3 CONSUMER Layer

Final analytics structures:

- `healthtail_facts`  
- `healthtail_diag_share`  
- `med_inventory_all`  
- `med_diagnosis_map`  

### 2.4 BigQuery Folder Structure

```markdown
![BigQuery Structure](/img/bigquery_structure.png)
```

---

## 3. ETL Steps

### 3.1 Step 1 — Cleaning & Aggregation  

SQL: `/sql/healthtail_Step1.sql`

#### registration_clean

Main transformations:

- Normalize patient names (InitCap)  
- Clean owner names (prefix/suffix removal)  
- Remove non-numeric characters from phone numbers  
- Handle missing breeds (`Unknown`)  
- Normalize casing & spacing  

#### med_audit

Combines medication **stock in** (invoices) and **stock out** (visits):

- Monthly aggregation  
- Unifies schema across invoices and visits  
- Adds helper fields:  
  - `qty_flow` → +in / -out  
  - `value_flow` → +in / -out  

Used for:

- Trend analysis  
- Treatment cost insights  
- Inventory calculations  

---

### 3.2 Step 2 — SQL for Research Questions  

SQL: `/sql/healthtail_Step2.sql`

This step includes SQL queries to answer:

1. Medication with highest total spend  
2. Medication × month with highest patient spending  
3. Month with highest packs consumed  
4. Average monthly packs for the top-revenue medication  

Both single-value and tie-aware (`DENSE_RANK`) versions are provided.

---

### 3.3 Step 3 — Consumer Model  

SQL: `/sql/healthtail_Step3.sql`

#### healthtail_facts

Final visit-level fact table including:

- Visit metadata (visit_day, visit_month, month_label)  
- Patient context (breed, pet_type, registration date)  
- Medication context (dosage, cost)  
- Age buckets by species  

This table feeds the majority of dashboard pages.

---

## 4. Additional Analysis Tables (Step 3a–3c)

### 4.1 Diagnosis Share per Month  

SQL: `/sql/healthtail_Step3a.sql`

- Monthly count per diagnosis  
- Adds `diag_share = diag_count / total_month_count`  

### 4.2 Medication Inventory Model  

SQL: `/sql/healthtail_Step3b.sql`

- Inflows (invoices)  
- Outflows (visits)  
- Monthly net flow  
- Running totals for packs and value (inventory over time)  
- **Note:** Inventory start balance is `0` in Jan 2024  

### 4.3 Medication–Diagnosis Mapping  

SQL: `/sql/healthtail_Step3c.sql`

- Maps medication names to diagnoses  
- Used for dashboard drill-downs  

---

## 5. Data Model Diagram

```text
healthtail_reg_cards ───┐
                         ├──► registration_clean ─┐
visits ──────────────────┘                         │
                                                   ├──► healthtail_facts → Looker Studio
invoices ─────► med_audit ────────────────────────┘

additional:
   visits ─────────► healthtail_diag_share
   invoices+visits ─► med_inventory_all
   visits ─────────► med_diagnosis_map
```

---

## 6. Dashboard Data Connections

The Looker Studio dashboard uses different tables depending on the page and the analytical purpose.  
Each page pulls from the most suitable BigQuery consumer table to ensure correct aggregations and performant queries.

### 6.1 Diagnosis by Frequency (Page 1)

**Data source:** `healthtail_facts`

Used for:

- KPIs
- Top Diagnoses by Frequency  
- Distribution by Pet Type  
- Distribution by Age  

Reason:  
`healthtail_facts` contains one row per treatment, enriched with patient and medication context, making it the most flexible base table.

---

### 6.2 Diagnosis by Share % (Trend Calculation)

**Data source:** `healthtail_diag_share`

Used for:

- Global Diagnosis Evolution (trend, total or % of total treatments per month)

Reason:  
Looker Studio cannot calculate correct monthly percentage-of-total using window functions.  
Therefore, `healthtail_diag_share` precomputes monthly counts and share ratios in BigQuery.

---

### 6.3 Diagnosis by Cost (Page 2)

**Data source:** `healthtail_facts`

Used for:

- KPIs
- Top Diagnoses by Cost  
- Cost by Pet Type  
- Cost by Age  
- Cost over time (trend, Total or per Case)

Reason:  
`healthtail_facts` provides both medical context and cost-level granularity, enabling flexible cost aggregation.

---

### 6.4 Stock Movement (Page 3)

**Data source:** `med_inventory_all`

Used for:

- KPIs
- Stock evolution (in packs)
- Stock evolution (in value €)
- Medication-level stock evolution

Reason:  
`med_inventory_all` extends `med_audit` with:

- monthly inflows and outflows  
- net flows  
- cumulative inventory (running totals)  

Using `med_audit` directly was insufficient because it did not compute running totals or harmonize invoices and visits at the right granularity.

---

### 6.5 Drug & Diagnosis Mapping (Page 4)

**Data sources (Data Blend):**

- `med_diagnosis_map`  
- `healthtail_facts`

Used for:

- Mapping each medication to the diagnoses it is associated with  
- Frequency of diagnoses per medication

Reason:  
Neither table alone contains both medication information **and** aggregated diagnosis frequency.  
A Looker Studio data blend merges:

1. Diagnosis frequency (`healthtail_facts`)  
2. Per-medication mapping rules (`med_diagnosis_map`)

This enables drill-downs such as:

> „For which diagnoses is drug X used and how common is this diagnosis?“

---

### 6.6 Not Used in Dashboard: `med_audit`

The `med_audit` table was required in the assignment to demonstrate aggregation of stock in/out movements.  
However, for dashboarding:

- More advanced inventory fields were needed (running totals, unified schema)
- Therefore, `med_inventory_all` was created as an enhanced, production-ready version

`med_audit` is part of the technical ETL pipeline but **not directly visualized**.

---

## 7. SQL File Locations

```text
/sql
   healthtail_Step1.sql
   healthtail_Step2.sql
   healthtail_Step3.sql
   healthtail_Step3a.sql
   healthtail_Step3b.sql
   healthtail_Step3c.sql
```

---

## 8. Reproducing the Pipeline

### 8.1 Setup

1. Create BigQuery datasets:  
   - `health_tail_raw`  
   - `health_tail_integration`  
   - `health_tail_consumer`  

2. Upload all CSVs into the RAW dataset.

### 8.2 Execute SQL

1. Run Step 1 SQL → produces `registration_clean` and `med_audit`  
2. Run Step 3 SQL → produces `healthtail_facts`  
3. Optional: Run Step 3a–3c → produces diagnosis share, inventory, and mapping tables  

### 8.3 Dashboard Setup

1. Open Looker Studio  
2. Connect to BigQuery  
3. Use the tables from the CONSUMER layer  
4. Configure filters, date controls, drilldowns  
5. Publish the dashboard (public link required)  
6. Store link in `/dashboard/looker_studio_link.txt`  

---

## 9. Notes & Limitations

- Dataset is synthetic (fake), used for analytics learning  
- Includes intentional inconsistencies  
- No opening inventory balance available  
- Phone numbers, names, and breeds required normalization  
- Monthly granularity limits date-level joins  

---

## 10. Author

**Thomas Jortzig**  
HealthTail-Project - September 2025
