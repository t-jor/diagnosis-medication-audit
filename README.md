# HealthTail – Diagnoses & Medication Audit

![Project Type](https://img.shields.io/badge/Project-BI%20Case%20Study-6C63FF)
![Tech Stack](https://img.shields.io/badge/Tech-BigQuery%20%E2%80%A2%20SQL%20%E2%80%A2%20Looker%20Studio-4B8BBE)

A business-focused BI project for **HealthTail**, a major veterinary hospital, to automate medication auditing, analyze disease trends, and support data-driven decision-making.

This project combines **BigQuery**, **SQL**, and **Looker Studio** to transform raw clinic data into actionable insights.

---

## 🚀 Project Goal

Provide HealthTail with:

- A **clean, unified dataset** for diagnoses & medication spend  
- A **monthly medication audit** (stock in/out, value, usage)  
- An **interactive analytics dashboard** for diagnoses, cost, trends & inventory  
- **Business insights** to support procurement, treatment planning & budgeting

---

## 🩺 Business Context

HealthTail struggled with:

- Manual, error-prone medication auditing  
- No clear overview of disease trends & cost drivers  
- No ability to analyze diagnoses by **pet type, breed, or age**  
- Limited visibility into **inventory buildup** and stock inefficiencies  

This BI solution modernizes their analytics capabilities.

---

## 📊 Dashboard Preview (Looker Studio)

### Diagnosis by Frequency

![Diagnosis by Frequency](/img/dashboard_diagnosis_frequency.png)

### Diagnosis by Cost

![Diagnosis by Cost](/img/dashboard_diagnosis_cost.png)

### Stock Movement

![Stock Movement](/img/dashboard_stock_movement.png)

### 🔗 Live Dashboard

👉 [Open in Looker Studio](https://lookerstudio.google.com/s/oWTydFfl2W4)

---

## 🔍 Key Insights (Business-Level)

- **Cancer & HCM are the highest-cost diagnoses** (major spend drivers).  
- **Senior pets** generate a disproportionately high share of treatment cost.  
- **Vetmedin (Pimobendan) is massively overstocked** → ~€607k inventory in Dec 2025.  
- **Seasonal patterns** in Allergies & Conjunctivitis (spring peaks).  
- **Dog treatments dominate total cost**, cats have many cases but lower cost-per-case.

---

## 🧭 Project Approach

1. Load client CSVs (patients, visits, invoices) into BigQuery  
2. Clean and standardize registration data  
3. Build integrated medication audit (**stock in / stock out**)  
4. Create analysis-ready consumer tables  
5. Answer stakeholder questions with SQL  
6. Build interactive dashboard in Looker Studio  

Technical details are documented in `/docs/TECHNICAL_README.md`.

---

## 📂 Repository Structure

```text
/sql                    ← All project SQL files
/docs
   TECHNICAL_README.md ← Detailed ETL + modelling documentation
   FINDINGS_AND_QA.md  ← Answers to stakeholder questions + insights
/img                    ← Dashboard screenshots
/dashboard              ← Looker Studio link
README.md               ← Executive summary (this file)
```

---

## 👤 Author

**Thomas Jortzig**  
HealthTail-Project - September 2025

---

## 📎 Additional Documentation

- Technical ETL & Data Modelling → `/docs/TECHNICAL_README.md`  
- Findings & Stakeholder Q&A → `/docs/FINDINGS_AND_QA.md`  
