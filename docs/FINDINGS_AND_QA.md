# Findings and Stakeholder Q&A – HealthTail BI Project

This document summarizes the analytical findings derived from the BigQuery models and the Looker Studio dashboard.  
It answers the eight stakeholder questions and outlines key insights.

---

## 1. Stakeholder Questions – Key Findings

### Q1 — What are the most common diagnoses overall?

- The top three diagnoses account for **16.8%** of all treatments.  
- **HCM** is the most frequent diagnosis overall, followed by Hip Dysplasia and Arthritis.  
- Overall case distribution is broad with no extreme concentration.

---

### Q2 — How do diagnoses break down by pet type?

- **HCM** occurs exclusively in **cats**.  
- **Hip Dysplasia**: **77% dogs**, **23% cats**.  
- **Arthritis**: **57% hamsters**, **24% dogs**, **19% cats**.  
- Species-specific diagnosis patterns are clearly visible.

---

### Q3 — Which diseases are most prevalent among specific breeds?

Breed patterns differ meaningfully within each species.  
Examples visible in the dashboard:

- **Hamsters:** Different top diagnoses per breed (e.g., Arthritis vs. Wet Tail Disease).  
- **Cats:** Breed-specific genetic tendencies (e.g., HCM in Ragdoll, SMA in Maine Coon).  
- **Dogs:** Distinct endocrine/metabolic patterns by breed (e.g., Hypothyroidism in Beagle, Addison’s Disease in Poodle).

These examples illustrate that the dashboard allows diagnosis-by-breed exploration across all species.

---

### Q4 — Which diseases incur the highest spending?

- **Cancer** shows the highest total spending.  
- Followed by **HCM** and **Arthritis**.  
- Cost-intensive diagnoses tend to be chronic or require repeated treatments.

---

### Q5 — Are certain pet types more expensive to treat?

- **Dogs** show the highest medication cost (total and per case).  
- Followed by **cats**, then **hamsters**.  
- Treatment counts are relatively comparable, but cost intensity varies.

---

### Q6 — How does age influence prevalence and cost?

- **Senior animals (8+ years)** account for the highest total medication cost due to more cases.  
- **Puppies/Kittens (0–1)** have fewer treatments and therefore low total cost.  
- Adults show balanced patterns across diagnoses.

---

### Q7 — How does medication spending change over time?

- **Total cost peaks at the end of 2024**, driven by a high number of treatments.  
- **Cost per case** remains more stable.  
- No strong seasonal patterns detected; deeper disease-level analysis may reveal more.

---

### Q8 — Are certain diagnoses increasing over time?

- Diagnosis frequency peaks end of 2024 due to overall treatment volume.  
- **Diagnosis share (% of total)** is more stable over time.  
- Examples: slight increase in **Allergies**, slight decrease in **Ringworm**.  
  *(These are illustrative examples; other diagnoses may show similar or different patterns.)*

---

## 2. Dashboard Page Coverage

```text
| Dashboard Page             | Addresses Questions          |
|---------------------------|-------------------------------|
| Diagnosis by Frequency    | Q1, Q2, Q3, Q6, Q8            |
| Diagnosis by Cost         | Q4, Q5, Q6, Q7                |
| Stock Movement            | (Not part of Q1–Q8, but required in the project brief) |
```

---

## 3. Data Sources Used (Short Summary)

The dashboard uses several consumer-layer tables from BigQuery:

- `healthtail_facts`  
- `healthtail_diag_share`  
- `med_inventory_all`  
- Data Blend: `med_diagnosis_map` + `healthtail_facts`

(Details and rationale are fully documented in the Technical README.)

---

## 4. Additional Insights

- Strong overstocking for some medications (e.g., **Vetmedin**) suggests procurement optimization potential.  
- Senior pets represent a high-cost segment suitable for preventive and chronic-care programs.  
- Treatment volume influences most time-based patterns more strongly than diagnosis-specific effects.  
- Seasonal trends are not clearly visible; a disease-level seasonality deep-dive could provide additional value.

---

## 5. Author

**Thomas Jortzig**  
HealthTail-Project - September 2025
