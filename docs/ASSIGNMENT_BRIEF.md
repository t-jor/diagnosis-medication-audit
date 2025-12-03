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
- Fields: owner_id, patient_id, breed, pet_type, age, name, phone, registration_date  

### **2) visits**

- Clinical visits and treatments  
- Fields: visit_id, patient_id, diagnosis, doctor, datetime, medication prescribed, dosage, medication cost  

### **3) invoices**

- Medication purchase logs  
- Fields: med_name, packs, pack_price, total_price, month_invoice  

All files contain **synthetic/fake data** and may include inconsistencies or missing values.

---

## 4. Tasks & Deliverables

The assignment required the following deliverables:

### **1) SQL File – Data Cleaning & Aggregation**

- Clean the registration dataset  
- Combine invoice and visit data into a monthly medication audit  
- Output aggregated tables suitable for analysis  

### **2) SQL File – Research Questions / Insights**

Provide SQL queries answering key business questions, including:

- Cost drivers  
- Medication usage patterns  
- Highest spent medication  
- Month with highest usage  

### **3) Looker Studio Dashboard**

A public dashboard that:

- Directly connects to BigQuery  
- Contains **at least 5 stakeholder questions** visualized  
- Uses filters, time controls, and interactive elements  
- Consists of max. **2 pages** (guideline; more allowed)  

### **4) Final Presentation**

- Walk through methodology, analysis, and dashboard  
- Highlight insights and business implications  

---

## 5. Stakeholder Questions (Q1–Q8)

These business questions form the core of the dashboard:

1. **Which diagnoses are most common overall?**  
2. **How do diagnoses break down by pet type?**  
3. **Which diseases are most prevalent among specific breeds?**  
4. **Which diseases generate the highest treatment cost?**  
5. **Which pet types are more susceptible or more expensive to treat?**  
6. **How does age influence disease prevalence and cost?**  
7. **How does medication spending change over time?**  
8. **Are certain diagnoses increasing over time?**  

Dashboard pages must clearly address these questions.

---

## 6. Requirements & Constraints

- Use **BigQuery** for data storage, cleaning, aggregation, and analysis  
- Use **Looker Studio** for dashboard visualization  
- SQL queries must be exported as separate files  
- Dashboard must be published with a **shareable public link**  
- Data includes intentional quality issues (case inconsistencies, missing values, messy names)  
- No opening medication inventory balance available  
- Students may add additional tables if needed for dashboarding  

---

## 7. Evaluation Criteria

- Data cleaning quality  
- Correctness and clarity of SQL queries  
- Dashboard usability and visual clarity  
- Coverage of the 8 stakeholder questions  
- Ability to extract insights and communicate recommendations  
- Technical structure of the solution (datasets, tables, logic)  

---

## 8. Notes

- The dataset is fictional, designed for analytics learning.  
- Students were encouraged to build additional data models (diagnosis share, inventory flows, etc.) if it improves clarity or dashboard quality.  

---

## 9. Author of Summary

This assignment brief was compiled for documentation purposes by:  

**Thomas Jortzig**  
HealthTail-Project - September 2025
