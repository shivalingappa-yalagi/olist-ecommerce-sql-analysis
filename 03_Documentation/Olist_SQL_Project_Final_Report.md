# 📘 **Olist E-Commerce Data Analysis – End-to-End SQL Case Study**

### **Final Professional Report (Markdown Version)**

---

Below is the **complete Markdown document**.

---

# ---------------------------------------------

# 🟦 **Olist E-Commerce Data Analysis – End-to-End SQL Case Study**

# ---------------------------------------------

## **📌 Executive Summary**

The Olist E-Commerce Data Analysis project presents a comprehensive SQL-driven examination of customer behavior, seller performance, product trends, payment preferences, delivery efficiency, and customer satisfaction across the Brazilian marketplace.
Using 20 SQL insight modules, this study uncovers actionable patterns that help optimize the marketplace across logistics, operations, marketing, product strategy, and customer experience.

Key highlights include:

* Strong customer concentration in economically advanced states such as **São Paulo (SP)**.
* Delivery delays as a major driver of low customer reviews.
* High reliance on **credit card installments** for purchases.
* Significant imbalance between seller distribution and customer demand across states.
* Low repeat purchase rates, indicating a need for improved retention strategies.
* Product and category performance showing strong 80/20 dynamics.

This report translates SQL outputs into strategic insights, offering a clear roadmap for operational improvement and long-term growth.

---

# ---------------------------------------------

# 🟦 **Section 2: Dataset Overview**

# ---------------------------------------------

### **2.1 Data Sources**

The project uses eight core datasets representing the end-to-end e-commerce journey:

* Customers
* Orders
* Order Items
* Order Payments
* Order Reviews
* Products
* Sellers
* Geolocation

### **2.2 Database Tables**

The cleaned datasets were imported into MySQL with structured relationships:

* `customers`
* `orders`
* `order_items`
* `order_payments`
* `order_reviews`
* `products`
* `sellers`
* `geolocation`

### **2.3 Data Cleaning Summary**

Performed using Excel:

* Removed line breaks, special characters
* Standardized date formats
* Validated numeric fields
* Cleaned IDs and foreign key references

### **2.4 Relational Mapping**

Key relationships:

* Customers → Orders
* Orders → Payments
* Orders → Items
* Orders → Reviews
* Items → Sellers
* Items → Products

### **2.5 Scope of Analysis**

Covers:

* Customer distribution
* Seller coverage
* Product/category performance
* Payment behaviors
* Delivery timelines
* Review score patterns
* Repeat purchase behavior

---

# ---------------------------------------------

# 🟦 **Section 3: Project Objectives & Problem Statement**

# ---------------------------------------------

### **3.1 Objectives**

* Understand customer demographics and regional demand
* Evaluate seller distribution across states
* Identify top product categories by volume and revenue
* Analyze payment method preferences
* Assess delivery performance and delays
* Study customer satisfaction and review patterns
* Measure repeat purchase behavior

### **3.2 Problem Statement**

Olist faces challenges including:

* Geographic imbalances between demand and supply
* Delivery delays affecting satisfaction
* Heavy reliance on installment payments
* Low customer retention
* Underperforming product categories
* Lack of unified analytical visibility

This study addresses these gaps through structured SQL insights.

---

# ---------------------------------------------

# 🟦 **Section 4: SQL Workflow & Methodology**

# ---------------------------------------------

### **4.1 Data Cleaning & Preparation**

* UTF-8 fixes
* Text standardization
* Date formatting
* Duplicate removal
* Consistency checks

### **4.2 Database Import**

* Loaded using `LOAD DATA LOCAL INFILE`
* Imported into schema `olist_project`

### **4.3 Query Development**

20 SQL modules written using:

* Joins
* Aggregations
* Window functions
* Date operations
* Subqueries

### **4.4 Validation**

* Verified row counts
* Cross-checked relationships
* Ensured correct join logic

### **4.5 Insight Interpretation**

Each SQL result was expanded into:

* Summary
* Interpretation
* Business implications
* Recommendation

---

# ---------------------------------------------

# 🟦 **Section 5: Insight-by-Insight Analysis (Q1–Q20)**

# ---------------------------------------------

Below is the **complete insight summary**.

---

## **🔹 Q1 — Customer Distribution by State**

SP leads significantly; heavy geographic concentration.
**Recommendation:** Region-wise marketing & delivery optimization.

---

## **🔹 Q2 — Customer Distribution by City**

Major metro cities dominate.
**Recommendation:** Hyperlocal delivery efficiencies.

---

## **🔹 Q3 — Seller Distribution by State**

Imbalanced seller presence; SP dominates.
**Recommendation:** Seller onboarding in high-demand/low-supply states.

---

## **🔹 Q4 — Seller Distribution by City**

Urban seller concentration.
**Recommendation:** Micro-fulfillment centers in underserved cities.

---

## **🔹 Q5 — Orders per Customer**

Most customers are single-order buyers.
**Recommendation:** Launch loyalty and retention programs.

---

## **🔹 Q6 — Payment Method Trends**

Credit card dominates; installment-heavy.
**Recommendation:** Promote instant-pay incentives.

---

## **🔹 Q7 — Installment Usage**

1–3 installments common; high installments for expensive items.
**Recommendation:** Category-wise EMI strategies.

---

## **🔹 Q8 — Revenue by Category**

Few categories drive majority revenue.
**Recommendation:** Focus on high-performing categories.

---

## **🔹 Q9 — Order Volume by Category**

Volume and revenue vary widely by category.
**Recommendation:** Category-tiering for inventory planning.

---

## **🔹 Q10 — Estimated vs Actual Delivery Time**

Significant late deliveries.
**Recommendation:** SLA improvement + delay alerts.

---

## **🔹 Q11 — Average Delivery Time by State**

Northern states face longer deliveries.
**Recommendation:** Regional logistics optimization.

---

## **🔹 Q12 — Late Delivery % by Region**

High delay rates in several states.
**Recommendation:** Carrier performance monitoring.

---

## **🔹 Q13 — Review Score Distribution**

High 5-star share, but many 1-star ratings.
**Recommendation:** Customer recovery workflows.

---

## **🔹 Q14 — Delivery Performance vs Ratings**

Delays strongly linked to low ratings.
**Recommendation:** Delivery SLA enforcement.

---

## **🔹 Q15 — Repeat Customer Analysis**

Low repeat purchase awareness.
**Recommendation:** Personalized offers.

---

## **🔹 Q16 — Order Status Breakdown**

Mostly delivered; some cancellations.
**Recommendation:** Real-time seller inventory sync.

---

## **🔹 Q17 — Freight Cost Analysis**

Freight varies with distance and weight.
**Recommendation:** Dynamic freight pricing.

---

## **🔹 Q18 — Top-Selling Categories**

Certain categories dominate volume.
**Recommendation:** Strengthen supply chain for top categories.

---

## **🔹 Q19 — Revenue by Seller**

Small number of sellers drive most revenue.
**Recommendation:** Seller growth programs.

---

## **🔹 Q20 — Marketplace State-Level Overview**

SP leads across all metrics; regional imbalance.
**Recommendation:** State-level performance dashboards.

---

# ---------------------------------------------

# 🟦 **Section 6: Key Business Recommendations**

# ---------------------------------------------

### **6.1 Logistics Optimization**

* SLA dashboards
* Delay alerts
* Regional warehouse setup

### **6.2 Seller Network Strengthening**

* Acquire sellers in high-demand states
* Introduce seller scorecards

### **6.3 Category Strategy**

* Focus on top categories
* Improve low-performing SKUs

### **6.4 Payment Strategy**

* Promote single-pay discounts
* Structured installment offers

### **6.5 Customer Retention**

* Loyalty programs
* Personalized emails

### **6.6 Review Management**

* Automated follow-ups for low ratings
* Product replacement/refund process

### **6.7 Unified BI Dashboard**

Combine all KPIs (customers, sellers, delivery, reviews, revenue).

---

# ---------------------------------------------

# 🟦 **Section 7: Conclusion**

# ---------------------------------------------

This end-to-end SQL case study provides a structured analysis of Olist’s marketplace performance across customers, sellers, payments, products, deliveries, and satisfaction metrics. The insights and recommendations offer actionable direction for improving logistics, retention, seller operations, and category strategies.
This project demonstrates strong SQL capability, analytical thinking, and business interpretation — making it a valuable addition to your Data Analyst portfolio.

---

