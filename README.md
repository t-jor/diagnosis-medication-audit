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

## 💼 Business Context

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
- **No strong seasonal patterns detected**; seasonality analysis per diagnosis is a promising follow-up.  
- **Dog treatments dominate total cost and cost-per-case**, while cats and hamsters have similar case counts but lower cost intensity.

---

## ❓ Questions Answered

### 1. Medication Audit – SQL (Step 2)

Using the aggregated table `med_audit`, the project answers four audit-focused questions (via [`Step2b_questions_med_audit.sql`](sql/Step2b_questions_med_audit.sql)):
:

1. Which medication has the **highest total spend** (purchases)?  
2. Which medication × month combination has the **highest spending on patients**?  
3. In which month were the **most packs consumed** in the clinic?  
4. For the **top-revenue medication**, what is the **average monthly usage (packs)**?

### 2. Dashboard Stakeholder Questions (Q1–Q8)

The Looker Studio dashboard is designed so that its pages allow HealthTail to answer the eight stakeholder questions from the assignment brief (diagnosis frequency, breakdown by pet type/breed, cost drivers, age effects, time trends, etc.).

Condensed answers and examples are documented in  
**➡️ [docs/FINDINGS_AND_QA.md](docs/FINDINGS_AND_QA.md)**.

---

## 🧭 Project Approach

1. Load client CSVs (patients, visits, invoices) into BigQuery  
2. Clean and standardize registration data  
3. Build integrated medication audit `med_audit` (**stock in / stock out**)  
4. Answer (4) audit-focused questions on `med_audit` with SQL
5. Create analysis-ready consumer tables  
6. Build interactive dashboard in Looker Studio
7. Answer (8) stakeholder questions via dashboard

Technical details are documented in
**➡️ [docs/TECHNICAL_README.md](docs/TECHNICAL_README.md)**

---

## 📂 Repository Structure

```text
/sql                    ← All project SQL files
/docs
   ASSIGNMENT_BRIEF.md  ← Summary of original assignment & requirements
   TECHNICAL_README.md  ← Detailed ETL + modelling documentation
   FINDINGS_AND_QA.md   ← Answers to stakeholder questions + insights
/img                    ← Dashboard screenshots
/dashboard              ← Looker Studio link (looker_studio_link.txt)
README.md               ← Executive summary (this file)
```

### Linked Documentation

- Technical ETL & Data Modelling → [docs/TECHNICAL_README.md](docs/TECHNICAL_README.md)  
- Findings & Stakeholder Q&A → [docs/FINDINGS_AND_QA.md](docs/FINDINGS_AND_QA.md)  
- Assignment Brief → [docs/ASSIGNMENT_BRIEF.md](docs/ASSIGNMENT_BRIEF.md)

---

## 👤 Author

**Thomas Jortzig**  
HealthTail-Project - September 2025
