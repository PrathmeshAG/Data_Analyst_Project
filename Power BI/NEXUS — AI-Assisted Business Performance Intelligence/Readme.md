# NEXUS — AI-Assisted Business Performance Intelligence

> **A business intelligence solution designed to transform raw sales data into actionable business insights using SQL, Power BI, DAX, and built-in analytical capabilities.**

---

## 📊 Project Overview

**NEXUS** is an end-to-end Business Intelligence and Performance Analytics project designed to transform raw and inconsistent sales data into a structured analytical solution.

The project demonstrates a complete analytics workflow from **raw data preparation to business decision support**.

NEXUS helps business stakeholders understand:

- Revenue and profit performance
- Year-over-year growth
- Sales target achievement
- Regional performance
- Product and category contribution
- Profitability and margin trends
- Discount impact
- Revenue forecasting
- Unusual revenue patterns
- Business performance risks
- Data-driven recommendations

### End-to-End Workflow

```text
Raw Data
   ↓
SQL Data Cleaning & Transformation
   ↓
Data Validation
   ↓
Power BI Data Modeling
   ↓
DAX Measures & Business Logic
   ↓
Interactive Power BI Dashboards
   ↓
Advanced Analytics
   ↓
Business Insights & Recommendations
```

---

# 🎯 Business Problem

Businesses generate large volumes of transactional data, but raw data alone does not provide clear answers for management.

Common challenges include:

- Duplicate transactions
- Missing values
- Invalid quantities
- Inconsistent text values
- Missing prices
- Incorrect discount values
- Unstructured dates
- Difficulty comparing actual sales with targets
- Difficulty identifying profitable products and regions

NEXUS addresses these challenges by building a centralized Business Intelligence solution that converts raw sales data into actionable insights.

### Key Business Questions

The solution helps answer questions such as:

- How much revenue and profit are we generating?
- Are we achieving our sales targets?
- Which regions contribute the most revenue?
- Which products and categories drive profitability?
- Is revenue growing or declining?
- How are discounts affecting profitability?
- Which areas require management attention?
- Where are unusual revenue patterns occurring?
- What does the future revenue trend look like?
- Which business areas should be prioritized?

---

# 🛠️ Tools & Technologies

| Technology | Purpose |
|---|---|
| **MySQL** | Data cleaning, transformation and validation |
| **SQL** | Data preparation and business calculations |
| **Power BI** | Dashboard development and visualization |
| **DAX** | KPI calculations, time intelligence and business logic |
| **Power BI Analytics** | Forecasting, anomaly detection and analytical exploration |
| **GitHub** | Project documentation and version control |

---

# 🗂️ Dataset

The project works with multiple business datasets representing a realistic sales environment.

### Data Sources

- Customers
- Products
- Orders
- Sales Targets

The transactional dataset contains approximately **100K sales records**, providing sufficient scale for realistic business performance analysis.

The raw data contains intentional data quality issues to simulate a real-world analytics environment.

---

# 🧹 SQL Data Cleaning & Transformation

Raw CSV datasets were imported into **MySQL** and transformed into clean analytical tables.

### Data Cleaning Activities

The SQL layer handles:

- Duplicate record handling
- Removal of unnecessary spaces
- Standardization of text values
- Missing value treatment
- Invalid quantity correction
- Discount validation
- Missing unit price handling
- Region standardization
- Date conversion
- Product master lookup
- Revenue calculation
- Cost calculation
- Profit calculation

### Business Metrics Prepared in SQL

The cleaned order table includes calculated fields such as:

- Gross Sales
- Discount Amount
- Net Sales / Revenue
- Cost
- Profit

This ensures that Power BI receives a structured and analysis-ready dataset.

---

# 🗃️ Data Model

The Power BI model follows a structured relational design with transactional and dimension tables.

## Fact / Transaction Tables

### `orders_clean`

The primary transactional table containing:

- Order Date
- Order ID
- Customer ID
- Product ID
- Quantity
- Discount
- Unit Price
- Region
- Gross Sales
- Discount Amount
- Revenue
- Cost
- Profit

### `targets_clean`

Contains sales target information by:

- Date
- Region
- Sales Target

---

## Dimension Tables

### `customers_clean`

Contains customer-level attributes such as:

- Customer ID
- Customer Name
- Segment
- Region

### `products_clean`

Contains product-level information such as:

- Product ID
- Product Name
- Category
- Unit Cost
- Unit Price

### `DimDate`

Dedicated date dimension used for:

- Year analysis
- Month analysis
- Year-over-Year calculations
- Month-over-Month calculations
- Time intelligence
- Forecasting

### `DimRegion`

Common region dimension used for consistent regional analysis across sales and targets.

---

## 🔗 Data Model Structure

```text
                    DimDate
                       │
                       │
                       ▼
                orders_clean
                /           \
               /             \
              ▼               ▼
     customers_clean     products_clean


                  DimRegion
                     │
                     ▼
                orders_clean
                     │
                     │
                     ▼
                targets_clean
                     ▲
                     │
                  DimDate
```

The model uses one-to-many relationships from dimension tables to transactional tables to support efficient filtering and analysis.

---

# 🧮 DAX & Business Metrics

DAX measures were created to provide reusable business KPIs and analytical calculations.

## Core KPIs

```DAX
Revenue = SUM(orders_clean[Sales])

Profit = SUM(orders_clean[Profit])

Margin % = DIVIDE([Profit], [Revenue])

Orders = DISTINCTCOUNT(orders_clean[OrderID])

Customers = DISTINCTCOUNT(orders_clean[CustomerID])

Avg Order Value = DIVIDE([Revenue], [Orders])
```

---

## 📈 Growth Analysis

NEXUS includes time-intelligence measures for performance comparison.

Key metrics include:

- Revenue LY
- YoY Growth %
- Revenue PM
- MoM Growth %
- Profit LY
- Profit YoY Growth %
- Revenue Change
- Profit Change
- Margin Change

Example:

```DAX
YoY Growth % =
DIVIDE(
    [Revenue] - [Revenue LY],
    [Revenue LY]
)
```

This allows management to understand whether business performance is improving or declining over time.

---

# 🎯 Target Performance

Sales performance is compared against regional and monthly targets.

Key measures include:

- Sales Target
- Target Achievement %
- Target Gap
- Target Variance %
- Target Status

Example business statuses:

```text
Above Target
Near Target
Below Target
```

This helps identify regions and periods that require corrective action.

---

# 💰 Profitability Analysis

The project analyzes profitability using:

- Total Cost
- Revenue
- Profit
- Margin %
- Profit per Order
- Revenue per Customer
- Discount Amount
- Discount Impact %
- Cost Ratio

This allows the business to evaluate whether revenue growth is translating into healthy profit margins.

---

# 📊 Dashboard 1 — Executive Overview

The **Executive Overview** provides a high-level summary of overall business performance.

### Key KPIs

- Revenue
- Profit
- Margin %
- Orders
- YoY Growth

### Main Analysis

The dashboard provides a consolidated view of:

- Revenue trends over time
- Revenue versus target
- Regional revenue performance
- Category contribution
- Top-performing products
- Overall business performance

### Why It Matters

This page is designed for management and decision-makers who need a quick understanding of the current business position without going into detailed transactional analysis.

### Dashboard Preview

![Executive Overview](Images/Executive%20Overview.png)

---

# 📦 Dashboard 2 — Product Intelligence

The **Product Intelligence** page focuses on product and category-level performance.

### Key Analysis

- Top products by revenue
- Top products by profit
- Category performance
- Product margin
- Revenue versus profit
- Product performance matrix
- High-revenue / low-margin products

### Business Questions

This dashboard helps identify:

- Which products contribute the most revenue?
- Which products generate the highest profit?
- Which categories are strongest?
- Are there products generating high revenue but relatively low margins?

### Why It Matters

Product-level analysis helps management understand which products should receive more attention and where profitability may need improvement.

### Dashboard Preview

![Product Intelligence](Images/Product%20Intelligence.png)

---

# 🌎 Dashboard 3 — Regional Performance

The **Regional Performance** page evaluates business performance across regions.

### Key Metrics

- Revenue
- Profit
- Margin %
- Target Achievement %
- Revenue Growth

### Main Analysis

- Revenue by region
- Profit by region
- Regional margin
- Revenue versus target
- Monthly regional performance
- Regional performance comparison

### Business Questions

The dashboard helps answer:

- Which region generates the highest revenue?
- Which region generates the highest profit?
- Which region has the strongest margin?
- Which regions are below target?
- Where should management focus corrective actions?

### Dashboard Preview

![Regional Performance](Images/Regional%20Performance.png)

---

# 🤖 Dashboard 4 — AI Business Insights

The **AI Business Insights** page combines Power BI's analytical capabilities with dynamic business logic.

It is designed to move beyond traditional reporting and provide deeper analytical exploration.

### Main Components

- Key Influencers
- Decomposition Tree
- Smart Narrative
- Revenue Forecast
- Anomaly Detection
- Top / Bottom Performers
- Dynamic Business Recommendations

### Dashboard Preview

![AI Business Insights](Images/AI%20Business%20Insights.png)

---

# 🔎 Key Influencers

The **Key Influencers** visual is used to identify factors associated with higher or lower business performance.

The analysis can evaluate factors such as:

- Discount %
- Product Category
- Quantity
- Unit Price
- Region
- Product

For example, the analysis can help determine which business attributes are associated with higher profitability.

### Business Value

Instead of only showing **what happened**, Key Influencers helps explore **what factors may be driving the result**.

---

# 🌳 Decomposition Tree

The **Decomposition Tree** provides an interactive way to break down business metrics.

Example analytical path:

```text
Revenue
   ↓
Category
   ↓
Product
```

Users can interactively drill into different dimensions to understand which categories and products contribute to revenue.

### Business Value

It helps transform a high-level KPI into a detailed explanation of the underlying business drivers.

---

# 📝 Smart Narrative

The dashboard includes a dynamic **Smart Narrative** section.

The narrative can summarize important metrics and respond to report filters and slicers.

This allows users to interpret dashboard results without manually analyzing every visual.

---

# 🔮 Revenue Forecasting

Power BI forecasting is used to estimate future revenue trends based on historical performance.

The forecast helps answer:

> **What could the future revenue trend look like based on historical data?**

### Business Value

Forecasting can help management:

- Anticipate future revenue trends
- Understand potential growth direction
- Support planning decisions
- Identify potential changes in demand

---

# 🚨 Anomaly Detection

Power BI anomaly detection is used to identify unusual revenue patterns in the historical trend.

The analysis highlights points where actual revenue behaves differently from the expected pattern.

### Business Value

Anomaly detection can help investigate:

- Unexpected revenue spikes
- Unusual revenue drops
- Abnormal business periods
- Potential operational or market changes

---

# 🏆 Top / Bottom Performers

Products are ranked using profitability metrics to identify performance leaders and weaker performers.

The analysis can highlight:

- Top products by profit
- Bottom products by profit
- High-revenue products
- High-margin products
- Products requiring further review

This helps management prioritize product-level actions.

---

# 💡 AI-Assisted Business Recommendations

NEXUS includes dynamic recommendation logic based on business KPIs and DAX conditions.

The recommendations focus on areas such as:

### 1. Top Category

Identifies the strongest category based on profit contribution.

### 2. Discount Strategy

Evaluates discount impact and highlights whether discounting may be putting pressure on profitability.

### 3. Target Performance

Evaluates actual revenue against the sales target and indicates whether the business is:

- Below target
- Near target
- Meeting target
- Above target

### 4. Growth Outlook

Evaluates year-over-year revenue growth and provides a business-oriented interpretation.

---

## 🧠 AI Approach

The project uses an **AI-assisted Business Intelligence approach** rather than building a custom machine learning or external AI API solution.

The analytical intelligence comes from:

- Power BI Key Influencers
- Decomposition Tree
- Smart Narrative
- Forecasting
- Anomaly Detection
- Dynamic DAX business rules

The recommendation layer is based on **rule-driven business logic**, making the insights explainable and easy to interpret.

---

# 🚦 Business Performance Indicators

NEXUS converts numerical KPIs into easy-to-understand business statuses.

## Target Status

```text
Above Target
Near Target
Below Target
```

## Growth Status

```text
Strong Growth
Positive Growth
Moderate Decline
Significant Decline
```

## Margin Status

```text
Healthy Margin
Moderate Margin
Low Margin
```

## Overall Business Performance

```text
Strong Performance
Stable Performance
Needs Attention
High Risk
```

These indicators help stakeholders quickly understand business health.

---

# 🔍 Data Quality & Validation

The SQL layer demonstrates practical data-quality handling.

| Data Issue | Treatment |
|---|---|
| Duplicate records | Identified and handled |
| Missing quantity | Replaced with valid default |
| Negative quantity | Corrected |
| Missing discount | Replaced with 0 |
| Invalid discount | Limited to valid range |
| Missing Unit Price | Recovered from product master |
| Inconsistent Region | Standardized |
| Text dates | Converted to Date |
| Missing category | Classified as Unknown |
| Duplicate customer records | Removed during cleaning |

This ensures that the Power BI dashboard is based on structured and consistent analytical data.

---

# 📌 Key Business Questions Answered

## Revenue

- What is the overall revenue?
- How is revenue trending over time?
- Is revenue growing year over year?
- Which regions generate the most revenue?

## Profitability

- What is total profit?
- Which products generate the highest profit?
- What is the current profit margin?
- Is profit growing along with revenue?

## Targets

- Are sales targets being achieved?
- Which regions are below target?
- What is the current target gap?

## Products

- Which products are top performers?
- Which categories contribute most to profit?
- Which products generate high revenue but lower margins?

## Regions

- Which region performs best?
- Which region has the strongest margin?
- Which regions require attention?

## Business Risks

- Are discounts affecting profitability?
- Are there unusual revenue patterns?
- Is revenue declining?
- Which areas show potential performance risks?

## Forecasting

- What is the expected future revenue trend?
- Does historical performance indicate continued growth?

---

# 📈 Project Architecture

```text
                    RAW SALES DATA
                          │
                          ▼
                    CSV DATASETS
                          │
                          ▼
                       MySQL
                          │
                          ▼
              SQL CLEANING & TRANSFORMATION
                          │
                          ▼
                 CLEAN ANALYTICAL DATA
                          │
                          ▼
                  POWER BI DATA MODEL
                          │
                          ▼
                    DAX MEASURES
                          │
                          ▼
                 INTERACTIVE DASHBOARDS
                          │
             ┌────────────┼────────────┐
             ▼            ▼            ▼
          KPI & BI    ADVANCED      FORECAST
          ANALYSIS    ANALYTICS
             │            │            │
             └────────────┼────────────┘
                          ▼
                 BUSINESS INSIGHTS
                          │
                          ▼
               RECOMMENDATIONS & ACTIONS
```

---

# 📁 Repository Structure

```text
NEXUS — AI-Assisted Business Performance Intelligence
│
├── Images
│   ├── AI Business Insights.png
│   ├── Executive Overview.png
│   ├── Product Intelligence.png
│   ├── Regional Performance.png
│   └── readme.md
│
├── PBIX File
│   └── [Power BI Report]
│
├── Row Data
│   └── [Raw CSV Datasets]
│
├── SQL File ( Cleaned Data)
│   └── SQL_Cleaning.sql
│
└── Readme.md
```

---

# 🔄 How to Explore the Project

### 1. Review the Raw Data

Start with the datasets available inside:

```text
Row Data
```

This represents the raw business data before transformation.

### 2. Review SQL Cleaning

Open:

```text
SQL File ( Cleaned Data)
└── SQL_Cleaning.sql
```

to understand how the raw data was cleaned and transformed.

### 3. Open the Power BI Report

Open the `.pbix` file available inside:

```text
PBIX File
```

### 4. Explore the Dashboard

Navigate through the four analytical pages:

```text
Executive Overview
        ↓
Product Intelligence
        ↓
Regional Performance
        ↓
AI Business Insights
```

---

# ⭐ Project Highlights

### ✔ End-to-End Analytics Workflow

Demonstrates the complete process from raw data to business insights.

### ✔ SQL Data Preparation

Uses MySQL for cleaning, transformation, validation and business metric preparation.

### ✔ Power BI Data Modeling

Uses a structured relational model with fact and dimension tables.

### ✔ Advanced DAX

Includes:

- Time intelligence
- Growth calculations
- Target analysis
- Profitability metrics
- Business status logic
- Dynamic recommendation logic

### ✔ Advanced Power BI Analytics

Includes:

- Key Influencers
- Decomposition Tree
- Smart Narrative
- Forecasting
- Anomaly Detection

### ✔ Business-Focused Dashboard Design

The dashboards are designed around actual business questions rather than only displaying raw metrics.

### ✔ Decision Support

The solution converts analytical results into business-friendly insights and recommendations.

---

# 💼 Business Value

NEXUS provides a centralized view of business performance that can support management in:

- Monitoring revenue and profit
- Tracking sales targets
- Identifying profitable products
- Comparing regional performance
- Understanding growth trends
- Evaluating discount impact
- Detecting unusual revenue patterns
- Exploring revenue drivers
- Supporting business planning
- Prioritizing corrective actions

---

# 🎓 Skills Demonstrated

## SQL

- Data Cleaning
- Data Transformation
- Joins
- Conditional Logic
- Aggregations
- Data Validation
- Business Calculations

## Power BI

- Data Modeling
- Relationships
- Interactive Dashboards
- KPI Cards
- Charts
- Matrix
- Key Influencers
- Decomposition Tree
- Smart Narrative
- Forecasting
- Anomaly Detection

## DAX

- Measures
- `CALCULATE`
- `DIVIDE`
- `SAMEPERIODLASTYEAR`
- `DATEADD`
- `SWITCH`
- `TOPN`
- Time Intelligence
- Dynamic Business Logic

## Business Analytics

- Revenue Analysis
- Profitability Analysis
- Target Analysis
- Product Analysis
- Regional Analysis
- Growth Analysis
- Trend Analysis
- Forecasting
- Anomaly Detection
- Business Recommendations

---

# 📷 Dashboard Gallery

## Executive Overview

![Executive Overview](Images/Executive%20Overview.png)

## Product Intelligence

![Product Intelligence](Images/Product%20Intelligence.png)

## Regional Performance

![Regional Performance](Images/Regional%20Performance.png)

## AI Business Insights

![AI Business Insights](Images/AI%20Business%20Insights.png)

---

# 🚀 Conclusion

**NEXUS — AI-Assisted Business Performance Intelligence** demonstrates how raw business data can be transformed into a professional Business Intelligence solution using SQL, Power BI and DAX.

The project goes beyond basic reporting by combining:

**Data Cleaning → Data Modeling → KPI Analysis → Advanced Analytics → Forecasting → Anomaly Detection → Business Recommendations**

The result is an interactive decision-support solution that enables stakeholders to move from:

> **"What happened?"**

to

> **"Why did it happen?"**

and ultimately toward:

> **"What should we focus on next?"**

---

# 👨‍💻 Author

## Prathmesh Bobade

**B.Tech — Information Technology**

### Areas of Interest

- Data Analytics
- Business Intelligence
- SQL
- Power BI
- DAX
- Python
- Data Visualization

---

## ⭐ Project

**NEXUS — AI-Assisted Business Performance Intelligence**

> Transforming business data into insights, insights into decisions.
