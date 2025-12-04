# Assignment Brief – HealthTail BI Project

This document summarizes the original assignment for the HealthTail BI project, including objectives, data sources, required deliverables, and stakeholder questions.  
It serves as a reference for understanding the project scope and constraints.

---

## 1. Background

**Client:** HealthTail – a large veterinary hospital  
**Partner:** Clinipet – consultancy providing BI solutions for vet clinics  

HealthTail struggles with manual medication auditing, limited visibility into disease and cost trends, and outdated reporting processes.  
The goal of this assignment is to design a lightweight end-to-end BI solution that automates medication audits and allows HealthTail to analyze diagnoses, cost, and stock movements across pet types, breeds, and age groups.

---

## 2. Project Objective

Create a complete BI workflow that:

- Cleans and standardizes raw clinic data in BigQuery  
- Builds aggregated tables for medication stock in/out  
- Answers key business questions through SQL analysis  
- Publishes an interactive Looker Studio dashboard  
- Supports insight generation for management and veterinary staff  

---

## 3. Provided Data (Raw CSV Files)

The client supplied three datasets:

### **1) healthtail_reg_cards**

- Patient and owner information  
- Fields: patient_id, owner_id, owner_name, pet_type, breed, patient_name, gender, patient_age, date_registration, owner_phone  

### **2) visits**

- Clinical visits and treatments  
- Fields: visit_id, patient_id, visit_datetime, doctor, diagnosis, med_prescribed, med_dosage, med_cost  

### **3) invoices**

- Medication purchase logs  
- Fields: month_invoice, invoice_id, supplier, med_name, packs, price, total_price  

All files contain **synthetic/fake data** and may include inconsistencies or missing values.

---

## 4. Tasks & Deliverables

The assignment requires building a complete end-to-end BI pipeline aligned with the SQL development steps.  
It consists of data cleaning, medication audit, consumer table modeling, dashboard creation, and a final presentation.

### **1) Data Cleaning (SQL Step 1)**

- Clean and standardize the registration dataset  
- Fix inconsistencies (casing, missing values, formatting issues)  
- Produce a cleaned table used as the foundation for further modeling  

### **2) Data Aggregation & Medication Audit (SQL Step 2a & 2b – MAQs)**

- Combine the visits and invoices datasets into a consolidated monthly medication audit (`med_audit`)
- Calculate medication inflow, outflow, and net stock movement  
- Answer the four **Medication Audit Questions (MAQs)** that evaluate medication usage and inventory patterns  

### **3) Consumer Tables for Dashboarding (SQL Step 3, 3a, 3b, 3c – SBQs)**

- Build additional analytics-ready consumer tables for diagnoses, costs, and inventory flows  
- These tables serve as the basis for answering the eight **Stakeholder Business Questions (SBQs)**  
- Includes diagnosis frequency, cost drivers, pet-type comparisons, age patterns, and trend analyses  

### **4) Looker Studio Dashboard**

- Create a multi-page dashboard
- Visualize all SBQs with interactivity, filters, and time controls  
- Connect directly to BigQuery consumer tables  

### **5) Final Presentation**

- Walk through methodology, SQL logic, and dashboard insights  
- Communicate findings and business implications to stakeholders  

---

## 5. Medication Audit Questions (MAQs)

These questions are answered entirely through SQL in the `med_audit` table.  
They represent the core analytical tasks of the medication audit.

1. **MAQ1 – What is the total medication inflow per month?**  
2. **MAQ2 – What is the total medication outflow per month?**  
3. **MAQ3 – Which medications show the largest imbalance between inflow and outflow?**  
4. **MAQ4 – What is the monthly net change in medication stock?**  

These questions are **part of the technical SQL assignment** and are **not visualized in the dashboard**.

---

## 6. Stakeholder Business Questions (SBQs)

These business questions form the core of the dashboard:

1. **SBQ1 - Which diagnoses are most common overall?**  
2. **SBQ2 - How do diagnoses break down by pet type?**  
3. **SBQ3 - Which diseases are most prevalent among specific breeds?**  
4. **SBQ4 - Which diseases generate the highest treatment cost?**  
5. **SBQ5 - Which pet types are more susceptible or more expensive to treat?**  
6. **SBQ6 - How does age influence disease prevalence and cost?**  
7. **SBQ7 - How does medication spending change over time?**  
8. **SBQ8 - Are certain diagnoses increasing over time?**  

Dashboard pages must clearly address these questions.

---

## 7. Requirements & Constraints

- Use **BigQuery** for data storage, cleaning, aggregation, and analysis  
- Use **Looker Studio** for dashboard visualization  
- SQL queries must be exported as separate files  
- Dashboard must be published with a **shareable public link**  
- Data includes intentional quality issues (case inconsistencies, missing values, messy names)  
- No opening medication inventory balance available  
- Students may add additional tables if needed for dashboarding  

---

## 8. Evaluation Criteria

- Data cleaning quality  
- Correctness and clarity of SQL queries  
- Dashboard usability and visual clarity  
- Coverage of the 8 stakeholder questions  
- Ability to extract insights and communicate recommendations  
- Technical structure of the solution (datasets, tables, logic)  

---

## 9. Notes

- The dataset is fictional, designed for analytics learning.  
- Students were encouraged to build additional data models (diagnosis share, inventory flows, etc.) if it improves clarity or dashboard quality.  

---

## 10. Author of Summary

This assignment brief was compiled for documentation purposes by:  

**Thomas Jortzig**  
HealthTail-Project (09/2025)
