
\# 🛒 \*\*Olist Marketplace Data Analysis – End-to-End SQL Project\*\*



\### \*\*Comprehensive E-commerce Analytics Using SQL, MySQL, and Python\*\*



---



\## 📌 \*\*Project Summary\*\*



This project is a complete end-to-end SQL analytics case study based on the \*\*Olist E-Commerce Marketplace\*\* dataset, one of Brazil’s largest online retail platforms.

The analysis covers:



\* Customer behavior

\* Seller performance

\* Logistics efficiency

\* Product category analytics

\* Seasonality

\* Cohorts \& retention

\* RFM segmentation

\* Revenue trends

\* Geographic performance



All SQL scripts, documentation, insights, and datasets are structured professionally to demonstrate real-world Data Analyst skills.



---



\## 📂 \*\*Project Structure\*\*



```

## 📂 Project Structure

Olist_SQL_Project/

├── 01_Datasets/
│   ├── Raw_Dataset
│   └── Cleaned_Dataset
│
├── 02_SQL/
│   ├── Queries
│   └── Insights
│
├── 03_Documentation/
│   ├── Project_Overview.md
│   ├── Insights_Summary.md
│   ├── Olist_SQL_Project_Final_Report.md
│   └── README.md
│
├── 04_Query_Results/
│   ├── CSV_Files
│   ├── Excel_Files
│   └── Images
│
├── 05_References/
│   ├── Data_Dictionary.md
│   ├── ER_Diagram.png
│   └── Links.txt
│
└── 06_PowerBI_Dashboard/
    ├── PBIX_Files
    ├── Images
    ├── Data_Model
    └── Exports
```





\## 🧰 \*\*Technologies Used\*\*



| Purpose                | Tool                           |

| ---------------------- | ------------------------------ |

| Database \& Queries     | \*\*MySQL Workbench 8.x\*\*        |

| Data Cleaning          | \*\*Python (Pandas)\*\*, \*\*Excel\*\* |

| File/System Management | Windows 11                     |

| Documentation          | Markdown                       |

| Version Control        | Git \& GitHub                   |



---
## 🗂 Database Schema

![ER Diagram](05_References/ER_Diagram.png)


\# 📊 \*\*Key Analysis Modules \& Insights\*\*



Below is a condensed summary of all 20 modules.

Full details are available inside \*\*03\_Documentation/Insights\_Summary.md\*\*.



---



\## \*\*01 – Basic Exploration\*\*



\* Verified dataset consistency

\* Identified timeline: \*2016–2018\*

\* Customer base dominated by \*\*one-time buyers\*\*



---



\## \*\*02 – Order \& Delivery Performance\*\*



\* Average delivery time: \*\*12–14 days\*\*

\* Estimated delivery time: \*\*23 days\*\*

\* Olist delivers \*\*~10 days earlier than estimated\*\*



---



\## \*\*03 – Customer Insights\*\*



\* SP, RJ, MG contribute \*\*70%+ customers\*\*

\* Only \*\*3–5%\*\* repeat customers

\* High churn marketplace



---



\## \*\*04 – Seller Insights\*\*



\* Sellers heavily concentrated in SP \& PR

\* High-performing sellers have:



&nbsp; \* Very low cancellations

&nbsp; \* Faster delivery

&nbsp; \* Higher monthly revenue



---



\## \*\*05 – Payment Analysis\*\*



\* \*\*Credit cards\*\* dominate revenue (~R$ 12M)

\* Installment payments = \*\*65%+ of orders\*\*

\* Boleto = second most popular



---



\## \*\*06 – Product Performance\*\*



\* Beauty/Health highest revenue

\* Gifts and watches highest AOV

\* Home category highest volume



---



\## \*\*07 – Geolocation Analysis\*\*



\* Dense urban areas → faster delivery

\* Northern/rural regions → longer shipping distance



---



\## \*\*08 – Review Score Analysis\*\*



\* Average review score: \*\*4.08\*\*

\* 1-star reviews: delays + damaged products

\* 5-star reviews: fast delivery + quality



---



\## \*\*09 – Customer RFM Segmentation\*\*



| Segment         | Count  |

| --------------- | ------ |

| Lost            | 40,435 |

| New Customers   | 24,715 |

| About to Sleep  | 26,675 |

| Loyal Customers | \*\*5\*\*  |

| Champions       | \*\*0\*\*  |



\* Very few repeat or loyal customers

\* Strong opportunity for CRM \& retention programs



---



\## \*\*10 – Product Category Analysis\*\*



\* Beauty/health repeatedly appears as a top performer

\* Home category shows stable demand

\* Electronics slower delivery but high AOV



---



\## \*\*11 – Seller Performance Analysis\*\*



\* Top seller revenue: \*\*R$ 249K\*\*

\* Very low cancellations across top sellers

\* Delivery speed strongly correlates with revenue



---



\## \*\*12 – Delivery Performance Analysis\*\*



\* Most states deliver \*\*earlier than estimated\*\*

\* RJ has \*\*highest late-delivery percentage (12%)\*\*

\* SP delivers fastest: \*\*8.7 days\*\*



---



\## \*\*13 – Payment Behavior Analysis\*\*



\* Installment payments dominate Brazilian e-commerce

\* Debit card usage very low

\* Vouchers used primarily for promotions



---



\## \*\*14 – Product Category Performance\*\*



\* Beauty/health → best combination of delivery speed, revenue \& reviews

\* Gifts/watches → highest price category

\* Bed/Bath → highest volume category



---



\## \*\*15 – Customer Lifetime Value (CLV)\*\*



\* Top customers generate \*\*R$ 6K–13K\*\*

\* Almost all are \*\*one-time buyers\*\*

\* No long-term retention

\* Large revenue gap that CRM strategies can fix



---



\## \*\*16 – Revenue Trend Analysis\*\*



\* 2017–2018 revenue shows \*\*exponential growth\*\*

\* 2017 Q4 → first time crossing \*\*R$ 1M monthly revenue\*\*

\* Seasonal peaks: November (Black Friday) \& December



---



\## \*\*17 – Cohort Retention Analysis\*\*



\* Retention drops \*\*90% after Month 0\*\*

\* Month 1 retention low, Month 2 extremely low

\* Marketplace behaves like a “single-purchase pattern” platform



---



\## \*\*18 – Category Seasonality Trends\*\*



\### Seasonal (Q4 Peaks):



\* Watches/Gifts

\* Beauty

\* Toys

\* Electronics

\* Sports



\### Stable (All-Year):



\* Bed/Bath

\* Housewares

\* Furniture



---



\## \*\*19 – Logistics Performance by State\*\*



\* Fastest deliveries: \*\*SP, MG, PR\*\*

\* Slowest: \*\*RJ, RS\*\*

\* Early deliveries are common (avg: \*\*-11 to -14 days\*\*)

\* RJ needs logistics optimization



---



\## \*\*20 – Marketplace Geography Analysis\*\*



\* Largest customer base: \*\*SP (41,746)\*\*

\* Largest seller base: \*\*SP (1,849)\*\*

\* PR has strong seller network

\* RJ has high demand but low seller count → \*\*expansion opportunity\*\*



---



\# 🛠 \*\*Skills Demonstrated\*\*



This project showcases:



\### 🔹 SQL Skills



\* Multi-table joins

\* CTEs

\* Aggregations

\* Window functions

\* Date/time functions

\* Case logic

\* Complex grouping and segmentation



\### 🔹 Analytics Skills



\* RFM modeling

\* Cohort retention

\* CLV analysis

\* Logistics evaluation

\* Category performance

\* Seasonality \& trend analysis



\### 🔹 Business Insights



\* Marketplace performance evaluation

\* Operational improvement recommendations

\* Customer behavior interpretation

\* Revenue forecasting signals



---



\# 📈 \*\*How to Use This Repository\*\*



```

git clone https://github.com/<your-username>/Olist\_SQL\_Project.git

cd Olist\_SQL\_Project

```



Inside the project:



\* Run SQL files using MySQL Workbench

\* View documentation in `03\_Documentation/`

\* Use `.txt` insights for reports or dashboards

\* Extend the project using Power BI or Python if needed



---



\# 🎯 \*\*Future Enhancements (Optional)\*\*



You may add:



\* Power BI dashboard

\* Python EDA notebook

\* Machine learning models (CLV prediction, churn modeling)

\* SQL stored procedures for automated reporting

\* Interactive visual analytics



---



\# ⭐ \*\*Author\*\*



\*\*Shivalingappa\*\*

Aspiring Data Analyst skilled in SQL, Power BI, Python \& Data Visualization.



---



\# 🏁 \*\*End of README.md\*\*



---





