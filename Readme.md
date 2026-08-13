# E-Commerce Delivery Performance & Customer Experience Analysis

An end-to-end data analytics project using the Brazilian Olist
e-commerce dataset to analyze **sales performance, delivery operations,
customer satisfaction, product categories, seller performance, and
logistics-related factors**.

The project combines **SQL, Python, and Power BI** to move from raw data
validation and business analysis to an interactive dashboard and
actionable recommendations.

---

## Project Overview

The objective of this project is to understand:

- How efficiently orders are being delivered
- How delivery delays relate to customer experience
- Which states experience weaker delivery performance
- Which product categories have high delivery times or freight costs
- Which sellers perform strongly or poorly based on customer ratings
- How sales and revenue are distributed across categories
- Where the business has opportunities to improve repeat-purchase behavior

**Workflow:** Data Preparation → Data Quality Validation → SQL Analysis
→ Python Analysis → Power BI Dashboard → Business Insights &
Recommendations

---

## Business Questions

1.  What percentage of orders are delivered late?
2.  How does delivery delay affect customer review scores?
3.  Which locations experience the most delivery delays?
4.  Which product categories have the highest delivery times or delay
    levels?
5.  Which sellers are associated with strong or weak customer
    satisfaction?
6.  How do freight costs and order values vary across products and
    locations?
7.  Which delivery, product, and seller characteristics are associated
    with lower customer review scores?
8.  How concentrated are sales across product categories?
9.  How common are repeat purchases among customers?

---

## Dataset

The project uses the **Brazilian Olist e-commerce dataset**.

### Tables Used

| Table       |      Rows |
| ----------- | --------: |
| Customers   |    99,441 |
| Orders      |    99,441 |
| Order Items |   112,650 |
| Payments    |   103,886 |
| Products    |    32,340 |
| Reviews     |    99,223 |
| Sellers     |     3,095 |
| Geolocation | 1,000,163 |

---

## Tools & Technologies

---

Tool Purpose

---

**MySQL / SQL** Database setup, data validation,
joins, transformations and business
analysis

**Python** Exploratory analysis, diagnostic
analysis and deeper investigation

**Power BI** Interactive dashboards, KPIs,
slicers and business visualization

**Jupyter Notebook** Python-based analytical workflow

**Git / GitHub** Project versioning and portfolio
presentation

---

---

## Data Preparation & Quality Checks

Before analysis, the datasets were loaded into MySQL and validated.

The data-quality workflow included:

- Table row-count validation
- Identifier uniqueness checks
- Missing-value analysis
- Duplicate checks
- Date-range validation
- Referential relationship checks
- Review-score validation
- Order timestamp consistency checks
- Business-rule validation

### Known Data Quality Issues

A small number of data-quality issues were identified and documented
rather than silently removed:

- Missing product IDs in a subset of order items
- Zero-value voucher/special payment records
- A small number of carrier timestamp anomalies
- A very small number of delivery timestamp anomalies

The analysis retained these records because the issues were considered
limited and did not materially affect the planned exploratory analysis.

---

## Analytical Approach

### 1. SQL

SQL was used to build the analytical foundation:

- Database and table creation
- CSV data loading
- Data validation
- Multi-table joins
- Aggregations
- KPI calculations
- Delivery-performance analysis
- Product/category analysis
- Seller analysis
- Customer analysis
- Revenue and freight-cost analysis

### 2. Python

Python was used for exploratory and diagnostic analysis to investigate
patterns beyond basic SQL aggregation.

The Python workflow supports:

- Distribution analysis
- Delivery-delay analysis
- Customer-review analysis
- Relationship exploration
- Statistical investigation
- Visualization of analytical patterns

### 3. Power BI

The final Power BI report contains three analytical pages.

---

## Power BI Dashboard

## Page 1 --- Olist E-Commerce Overview

Provides a high-level view of marketplace performance.

### Main KPIs

- Total Orders
- Total Customers
- Total Revenue

### Visuals

- Monthly Order Trend
- Review Score Distribution
- On-Time vs Late Delivery
- Top 10 Product Categories by Orders

![Olist E-Commerce Overview](Images/Olist%20E-Commerce%20Overview.png)

---

## Page 2 --- Olist Delivery Performance

Focuses on logistics and operational performance.

### Main KPIs

- Average Delivery Time
- On-Time Delivery %
- Average Delivery Delay
- Late Orders %

### Visuals

- Delivery Time Distribution
- Delivery Delay Distribution
- Top 10 Product Categories by Delivery Delay
- Top 10 States by On-Time Delivery %
- Delivery Time by Product Category

![Olist Delivery Performance](Images/Olist%20Delivery%20Performance.png)

---

## Page 3 --- Olist Customer & Seller Performance

Focuses on customer experience and seller-level performance.

### Main KPIs

- Average Review Score
- Average Seller Review Score
- Total Sellers

### Visuals

- Delivery Delay vs Review Score
- Average Review Score by Product Category
- Review Score by Delivery Status
- Seller Rating Distribution
- Seller Performance Matrix

![Olist Customer & Seller Performance](Images/Olist%20Customer%20%26%20Seller%20Performance.png)

---

## Key Findings

### Overall Marketplace

- The dataset contains **99,441 orders**, **96,096 unique customers**,
  and **3,095 sellers**.
- Average customer order value is approximately **160.99**.
- Customers purchase an average of **1.14 products per order**,
  indicating that most orders contain a single product.
- Monthly order volume increased throughout 2017 and reached its
  highest point in **November 2017 with 7,544 orders**.

### Delivery Performance

- Average delivery time is approximately **12.5 days** for delivered
  orders.
- Approximately **91.89% of delivered orders were delivered on or
  before the estimated delivery date**.
- Approximately **8.11% of delivered orders were delivered late**.
- Delivery performance varies significantly by customer state.
- **Roraima, Amapá and Amazonas** recorded the longest average
  delivery times, while **São Paulo, Paraná and Minas Gerais**
  recorded faster delivery performance.

### Customer Experience

- The average customer review score is **4.09 / 5**.
- **5-star reviews are the most common**, followed by 4-star reviews.
- The dashboard compares review scores across on-time and late
  deliveries, showing how delivery performance is associated with
  customer experience.
- The customer base is heavily weighted toward one-time purchasers:
  the analysis identified **93,099 single-purchase customers versus
  2,997 repeat customers**.

### Product Categories

- **cama_mesa_banho** is the most purchased product category, with
  **11,115 items sold**.
- **beleza_saude** and **esporte_lazer** are the next two
  highest-volume categories.
- **beleza_saude** contributes the highest share of product revenue at
  approximately **9.26%**, followed by **relogios_presentes (8.87%)**
  and **cama_mesa_banho (7.63%)**.
- **cds_dvds_musicais** has the highest average customer review score
  among product categories at approximately **4.64**.

### Freight & Logistics

- The **pcs** category has the highest average freight cost at
  approximately **48.45**.
- Several high-freight categories are furniture or bulky
  household-product categories, suggesting that product size, weight
  and handling requirements are important cost drivers.

### Seller Performance

- Seller order volume is concentrated among a relatively small group
  of highly active sellers.
- The highest-volume seller fulfilled approximately **2,033 order
  items**.
- Several sellers achieved average review scores above **4.70** with
  at least 20 reviews.
- Some sellers recorded average ratings between **2.10 and 3.10**,
  highlighting potential areas for service or product-quality
  improvement.

---

## Business Recommendations

### 1. Improve regional logistics

Prioritize logistics optimization in states with consistently longer
delivery times.

- Review warehouse and fulfillment locations
- Optimize shipping routes
- Evaluate regional logistics partners
- Improve delivery estimates for difficult-to-serve regions

### 2. Reduce late deliveries

Although overall on-time performance is strong, late orders have a
customer-experience implication.

- Monitor high-delay product categories
- Identify recurring seller-level delays
- Track regional delivery bottlenecks
- Improve estimated delivery-date accuracy

### 3. Increase repeat purchases

The analysis shows a large gap between single-purchase and repeat
customers.

- Introduce loyalty initiatives
- Use personalized post-purchase communication
- Recommend related products
- Develop targeted repeat-purchase campaigns

### 4. Optimize high-freight products

Bulky product categories have substantially higher freight costs.

- Negotiate category-specific logistics rates
- Review packaging and handling processes
- Evaluate regional fulfillment options
- Incorporate shipping cost into pricing decisions

### 5. Strengthen seller performance management

Seller-level variation in review scores creates an opportunity for
targeted interventions.

- Recognize consistently high-performing sellers
- Identify sellers with persistent low ratings
- Monitor seller delivery performance
- Provide quality and fulfillment improvement support

---

## Dashboard Interactivity

The Power BI report includes interactive filtering.

Primary slicers include:

- **Year / Order Date**
- **Order Status**
- **Product Category**
- **Customer State**

These filters allow stakeholders to move from overall marketplace
performance to more specific operational or customer segments.

---

## Project Structure

```text
E-commerce Delivery Performance & Customer Experience Analysis/
│
├── dataset/
│   └── raw Olist CSV files
│
├── SQL/
│   ├── 01_database_setup.sql
│   ├── 02_data_quality.sql
│   └── 03_exploratory_data_analysis.sql
│
├── Python/
│   └── 01_diagnostic_analysis.ipynb
│
├── Power BI/
│   └── Dashboard.pbix
│
├── Images/
│   ├── Olist E-Commerce Overview.png
│   ├── Olist Delivery Performance.png
│   └── Olist Customer & Seller Performance.png
│
└── README.md
```

---

## How to Reproduce the Analysis

### Step 1 --- Load the dataset

Place the Olist CSV datasets inside the `dataset/` folder.

### Step 2 --- Set up MySQL

Run:

```sql
01_database_setup.sql
```

This creates the `olist_ecommerce` database, imports the required
datasets and verifies the tables.

### Step 3 --- Validate the data

Run:

```sql
02_data_quality.sql
```

This performs data-quality and business-rule checks before analysis.

### Step 4 --- Perform exploratory analysis

Run:

```sql
03_exploratory_data_analysis.sql
```

This generates the main business metrics and analytical findings.

### Step 5 --- Run the Python analysis

Open:

```text
Python/01_diagnostic_analysis.ipynb
```

and execute the notebook for the Python-based diagnostic analysis.

### Step 6 --- Open the Power BI dashboard

Open:

```text
Power BI/Dashboard.pbix
```

to explore the interactive report.

---

## Limitations

- The Olist dataset represents a historical marketplace period rather
  than current e-commerce activity.
- The dataset ends during 2018, so the sharp decline at the end of the
  time series should not be interpreted as a confirmed demand
  collapse.
- Some timestamp inconsistencies and missing values exist in the
  source data.
- Delivery-time analysis excludes orders without a completed
  customer-delivery timestamp.
- Associations between delivery performance and review scores should
  not automatically be interpreted as causal relationships.
- Product category names retain the original source labels.

---

## Outcome

This project demonstrates an end-to-end **Data Analyst workflow**:

**Business Problem → Data Validation → SQL Analysis → Python Exploration
→ Power BI Dashboard → Business Insights → Recommendations**

The final deliverable combines technical analysis with business-focused
storytelling rather than presenting visualizations in isolation.

---

## Author

**Nandhusri Rajaraman**

Data Analytics Portfolio Project

**Skills demonstrated:** SQL · Python · Power BI · Data Cleaning
· Exploratory Data Analysis · Data Visualization · Business Analysis
