/*---------------------------------------------------------
   OLIST E-COMMERCE SQL PROJECT
   File: 05_payment_analysis.sql
   Folder: 02_SQL/analysis
   Purpose: Analyze payment methods & financial behavior
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Count of payments by payment type
-- Purpose: Identify the most commonly used payment methods.
-------------------------------------------------------------
SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payments DESC;

-------------------------------------------------------------
-- Q2: Payments by number of installments
-- Purpose: Understand financing behavior & consumer trends.
-------------------------------------------------------------
SELECT
    payment_installments,
    COUNT(*) AS total_orders
FROM olist_order_payments_dataset
GROUP BY payment_installments
ORDER BY payment_installments ASC;

-------------------------------------------------------------
-- Q3: Average payment value by payment type
-- Purpose: Identify how much customers spend across payment methods.
-------------------------------------------------------------
SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY avg_payment_value DESC;

-------------------------------------------------------------
-- Q4: Total revenue collected by payment type
-- Purpose: Show which payment methods generate most revenue.
-------------------------------------------------------------
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_revenue DESC;

-------------------------------------------------------------
-- Q5: Distribution of single-payment vs multi-payment orders
-- Purpose: Understand how many orders use multiple payments.
-------------------------------------------------------------
SELECT
    CASE 
        WHEN cnt = 1 THEN 'single_payment'
        ELSE 'multi_payment'
    END AS payment_category,
    COUNT(*) AS total_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS cnt
    FROM olist_order_payments_dataset
    GROUP BY order_id
) AS t
GROUP BY payment_category;

-------------------------------------------------------------
-- Q6: Maximum, minimum, and average payment values
-- Purpose: Summary of payment value distribution.
-------------------------------------------------------------
SELECT
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment,
    ROUND(AVG(payment_value), 2) AS avg_payment
FROM olist_order_payments_dataset;

-------------------------------------------------------------
-- Q7: Payment trends by month
-- Purpose: Identify financial seasonality over time.
-------------------------------------------------------------
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year_mon,
    ROUND(SUM(payment_value), 2) AS total_monthly_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY year_mon
ORDER BY year_mon ASC;
