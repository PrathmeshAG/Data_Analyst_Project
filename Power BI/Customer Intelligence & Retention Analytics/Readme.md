# 🚀 Customer Intelligence & Retention Analytics

## 📊 Project Overview
End-to-end analytics project on e-commerce data to uncover **customer behavior, revenue drivers, and retention (churn) patterns**.  
Delivers an interactive **Power BI** dashboard powered by **Python-based data cleaning** and **DAX measures**.

---

## 🧱 Workflow
Raw Data → **Python (Pandas) Cleaning** → **Power BI (Model + DAX)** → Interactive Dashboard

---

## ⚙️ Tech Stack
- Python (Pandas)
- Power BI (Data Model, DAX, Visualization)
- Excel / CSV (source)

---

## 🧹 Data Preparation (Python)
- Removed nulls & duplicates  
- Filtered invalid rows (negative qty, zero price)  
- Standardized dates  
- Created **Revenue = Quantity × UnitPrice**  

---

# 📊 Dashboard Preview

## 🟢 Main Dashboard
![Main Dashboard](./Main%201.png)

**What it shows:** KPIs (Revenue, Orders, Customers, AOV), category-wise sales, geo distribution.  
**Business use:** Quick executive snapshot of performance.

---

## 🔵 Customer Intelligence & Retention
![Customer Intelligence](./Main%202.png)

**What it shows:** Repeat vs New customers, top customers, revenue by category.  
**Business use:** Identify high-value and loyal customers.

---

## 🟣 Tooltip Interaction
![Tooltip](./Main%20tool%20tips.png)

**What it shows:** Hover-based details without clutter.  
**Business use:** Fast exploration while keeping the canvas clean.

---

## 🟡 Retention & Sales Performance
![Retention](./second%201.png)

**What it shows:** Active vs Inactive customers, repeat count, churn signals.  
**Business use:** Track retention health and churn risk.

---

## 🔶 Filtered View
![Filtered View](./Secoond_2.png)

**What it shows:** Category/region filtered insights.  
**Business use:** Segment-focused decision making.

---

## 🔍 Drillthrough – Customer Details
![Drillthrough](./Drill_through.png)

**What it shows:** Customer-level KPIs, order history, trends.  
**Business use:** Deep-dive into any customer.

---

## 🧠 Tooltip Detail View
![Tooltip Detail](./Tooltips.png)

**What it shows:** Customer distribution by country on hover.  
**Business use:** Geo insights without navigation.

---

# 📊 Pages
1. **Executive Overview** – KPIs, trends, category performance  
2. **Customer Intelligence & Retention** – segmentation, recency, churn  
3. **Product & Sales Performance** – product/category insights  
4. **Regional Analysis** – country/market view  
5. **Customer Details (Drillthrough)** – per-customer deep dive  

---

# 🧮 Key DAX (with purpose)

### Total Revenue
```DAX
Total Revenue = SUM(Orders[Revenue])
