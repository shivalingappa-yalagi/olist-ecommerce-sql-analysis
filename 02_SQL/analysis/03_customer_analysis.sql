/*---------------------------------------------------------
   OLIST E-COMMERCE SQL PROJECT
   File: 03_customer_analysis.sql
   Folder: 02_SQL/analysis
   Purpose: Analyze customer distribution & behaviour
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Top 10 states by number of customers
-- Purpose: Identify regions with the highest customer base.
-------------------------------------------------------------
SELECT 
    customer_state,
    COUNT(*) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;

-------------------------------------------------------------
-- Q2: Top 10 cities by number of customers
-- Purpose: Find the highest customer density regions.
-------------------------------------------------------------
SELECT 
    customer_city,
    COUNT(*) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;

-------------------------------------------------------------
-- Q3: Average number of orders per customer
-- Purpose: Understand buying frequency.
-------------------------------------------------------------
SELECT 
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
FROM (
    SELECT 
        customer_unique_id,
        COUNT(order_id) AS order_count
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) AS t;

-------------------------------------------------------------
-- Q4: Top 10 most active customers (by number of orders)
-- Purpose: Identify highest-engagement customers.
-------------------------------------------------------------
SELECT 
    customer_unique_id,
    COUNT(order_id) AS total_orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;

-------------------------------------------------------------
-- Q5: Customer order distribution (1 order, 2 orders, 3+, etc.)
-- Purpose: Segment customers by order frequency.
-------------------------------------------------------------
SELECT 
    order_count,
    COUNT(*) AS total_customers
FROM (
    SELECT 
        customer_unique_id,
        COUNT(order_id) AS order_count
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) AS t
GROUP BY order_count
ORDER BY order_count ASC;

-------------------------------------------------------------
-- Q6: Customer activity timeline (first & last order)
-- Purpose: Understand when customers joined and last purchased.
-------------------------------------------------------------
SELECT 
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp) AS first_order_date,
    MAX(o.order_purchase_timestamp) AS last_order_date
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY first_order_date ASC
LIMIT 15;