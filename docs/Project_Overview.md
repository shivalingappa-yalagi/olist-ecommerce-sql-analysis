> This document explains the project background, objectives, and methodology.
\# \*\*Olist Marketplace Data Analysis – End-to-End SQL Project\*\*



\### \*\*Project Overview\*\*



---



\## \*\*1. Introduction\*\*



This project is a comprehensive, end-to-end SQL-based analysis of the \*\*Olist E-commerce Marketplace\*\*, one of Brazil’s largest online marketplaces.

Using the complete Olist dataset (100K+ orders, 99K+ customers, 70K+ order items, 60+ features), this project provides deep analytical insights across:



\* Customer behavior

\* Order performance

\* Delivery logistics

\* Seller performance

\* Product category trends

\* Payments and financial metrics

\* Geography and marketplace distribution

\* RFM segmentation

\* Cohort retention

\* Revenue trends and seasonality



The project follows a \*\*real-world analytics workflow\*\*, similar to what Data Analysts perform in e-commerce companies.



---



\## \*\*2. Project Objectives\*\*



The primary goal of this project is to create a complete SQL-driven analytics framework for an e-commerce marketplace.



\### ✔ Analyze marketplace performance



\### ✔ Understand customer and seller behavior



\### ✔ Measure logistics efficiency



\### ✔ Identify top-performing product categories



\### ✔ Evaluate financial and payment patterns



\### ✔ Build customer segments and retention models



\### ✔ Generate insights to support business decision-making



Every insight is backed by queries written in \*\*MySQL\*\*, using optimized joins, aggregations, date functions, window logic, and grouping strategies.



---



\## \*\*3. Dataset Description\*\*



The dataset contains multiple relational tables:



| Table Name                          | Description                              |

| ----------------------------------- | ---------------------------------------- |

| `olist\_orders\_dataset`              | Order timestamps, status, delivery info  |

| `olist\_order\_items\_dataset`         | Items, price, freight, product mapping   |

| `olist\_order\_payments\_dataset`      | Payment value, type, installments        |

| `olist\_order\_reviews\_dataset`       | Customer feedback and review scores      |

| `olist\_products\_dataset`            | Product metadata, dimensions, categories |

| `olist\_customers\_dataset`           | Customer IDs, city, state distribution   |

| `olist\_sellers\_dataset`             | Seller IDs, locations, supply density    |

| `olist\_geolocation\_dataset`         | ZIP codes with geo-coordinates           |

| `product\_category\_name\_translation` | Portuguese → English categories          |



---



\## \*\*4. Tools \& Technology\*\*



| Purpose                   | Tool/Technology                               |

| ------------------------- | --------------------------------------------- |

| Database \& SQL processing | \*\*MySQL Workbench 8.x\*\*                       |

| CSV cleaning              | \*\*Excel\*\*, \*\*Python (Pandas)\*\*                |

| Project organization      | GitHub                                        |

| Documentation             | Markdown                                      |

| File system               | Windows 11                                    |

| Analysis methodology      | Exploratory Data Analysis (EDA), RFM, Cohorts |



---



\## \*\*5. Project Structure\*\*



```

## 5. Project Structure

Olist_SQL_Project/

├── 01_Datasets
│   ├── Raw_Dataset
│   └── Cleaned_Dataset
│
├── 02_SQL
│   ├── Queries
│   └── Insights
│
├── 03_Documentation
│   ├── Project_Overview.md
│   ├── Insights_Summary.md
│   └── Olist_SQL_Project_Final_Report.md
│
├── 04_Query_Results
│   ├── CSV_Files
│   ├── Excel_Files
│   └── Images
│
├── 05_References
│
└── 06_PowerBI_Dashboard

```



---



\## \*\*6. Analysis Modules (1–20)\*\*



The project is divided into \*\*20 analysis modules\*\*, each delivering a unique business insight:



1\. Basic Exploration

2\. Order \& Delivery Performance

3\. Customer Insights

4\. Seller Insights

5\. Payment Analysis

6\. Product Performance

7\. Geolocation Mapping

8\. Review Sentiment \& Score Patterns

9\. Customer RFM Segmentation

10\. Product Category Analysis

11\. Seller Performance Metrics

12\. Delivery Performance by State

13\. Payment Behavior Analysis

14\. Product Category Performance

15\. Customer Lifetime Value

16\. Revenue Trend Analysis

17\. Cohort Retention Analysis

18\. Category Seasonality Trends

19\. Logistics Performance by State

20\. Marketplace Geography Analysis



Each section includes SQL code, exported results, `.txt` insight summaries, and business interpretation.



---



\## \*\*7. Key Deliverables\*\*



\* 20 SQL scripts

\* 20 insight reports (txt)

\* Complete project documentation

\* Cleaned datasets

\* Professional GitHub structure

\* Analysis-ready queries for dashboards



---



\## \*\*8. Business Value\*\*



The insights generated help answer core marketplace questions:



💡 \*Which states deliver fastest?\*

💡 \*Which product categories generate the highest revenue?\*

💡 \*How loyal are customers? What is retention rate?\*

💡 \*Which sellers underperform?\*

💡 \*How do payment methods impact revenue?\*

💡 \*What geographic regions generate the most business?\*

💡 \*How seasonal is the marketplace?\*



These insights are essential for:



\* Logistics planning

\* Category expansion strategy

\* Marketing segmentation

\* Delivery optimization

\* User experience improvement

\* Revenue forecasting



---



\## \*\*9. Conclusion\*\*



This project represents a \*\*full-cycle analytical investigation\*\* of an e-commerce marketplace.

From raw data → SQL modeling → insights → documentation, the project demonstrates the analytical and technical depth required for data-driven decision-making.



\*\*It is GitHub-ready, recruiter-friendly, and highly aligned with real-world Data Analyst responsibilities.\*\*



---



