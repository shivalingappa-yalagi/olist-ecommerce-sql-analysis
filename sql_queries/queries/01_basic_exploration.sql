/*---------------------------------------------------------
   OLIST E-COMMERCE SQL PROJECT
   File: 01_basic_exploration.sql
   Folder: 02_SQL/exploration
   Purpose: Initial data exploration & understanding
----------------------------------------------------------*/

-- ========================================================
-- Q1: How many rows does each table contain?
-- Purpose: Understand dataset size and table distribution.
-- ========================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM olist_customers_dataset
UNION ALL
SELECT 'geolocation', COUNT(*) FROM olist_geolocation_dataset
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'payments', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'reviews', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'products', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist_sellers_dataset
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_name_translation
ORDER BY total_rows DESC;

-- Insight:
-- geolocation,Order_items, payments and customers tables contain the highest number of rows.

---------------------------------------------------------------------

-- ========================================================
-- Q2: What is the date range of orders in the dataset?
-- Purpose: Identify the analysis period.
-- ========================================================

SELECT 
    MIN(order_purchase_timestamp) AS start_date,
    MAX(order_purchase_timestamp) AS end_date
FROM olist_orders_dataset;

-- Insight:
-- Olist orders span approximately mid-2016 to late-2018.

---------------------------------------------------------------------

-- ========================================================
-- Q3: How many unique customers exist?
-- Purpose: Determine actual customer base.
-- ========================================================

SELECT COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM olist_customers_dataset;

-- Insight:
-- Unique customers help us understand market reach.

---------------------------------------------------------------------

-- ========================================================
-- Q4: How many repeat customers exist?
-- Purpose: Analyze customer loyalty & retention.
-- ========================================================

SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_unique_id
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
    HAVING COUNT(order_id) > 1
) AS t;

-- Insight:
-- Repeat customers show how many buyers made more than one order.

