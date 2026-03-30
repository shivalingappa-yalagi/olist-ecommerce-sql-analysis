/*---------------------------------------------------------
   OLIST E-COMMERCE SQL PROJECT
   File: 04_seller_analysis.sql
   Folder: 02_SQL/analysis
   Purpose: Analyze seller distribution & performance
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Top 10 states by number of sellers
-- Purpose: Understand seller distribution across Brazil.
-------------------------------------------------------------
SELECT 
    seller_state,
    COUNT(*) AS total_sellers
FROM olist_sellers_dataset
GROUP BY seller_state
ORDER BY total_sellers DESC
LIMIT 10;

-------------------------------------------------------------
-- Q2: Top 10 cities by number of sellers
-- Purpose: Identify seller concentration regions.
-------------------------------------------------------------
SELECT 
    seller_city,
    COUNT(*) AS total_sellers
FROM olist_sellers_dataset
GROUP BY seller_city
ORDER BY total_sellers DESC
LIMIT 10;

-------------------------------------------------------------
-- Q3: Sellers by number of products sold (order items count)
-- Purpose: Identify seller activity based on item quantity.
-------------------------------------------------------------
SELECT
    oi.seller_id,
    COUNT(oi.order_item_id) AS total_items_sold
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY total_items_sold DESC
LIMIT 10;

-------------------------------------------------------------
-- Q4: Orders per seller
-- Purpose: Understand how many orders each seller fulfilled.
-------------------------------------------------------------
SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 10;

-------------------------------------------------------------
-- Q5: Seller product variety (number of unique products per seller)
-- Purpose: Identify sellers with wide product ranges.
-------------------------------------------------------------
SELECT
    seller_id,
    COUNT(DISTINCT product_id) AS unique_products
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY unique_products DESC
LIMIT 10;

-------------------------------------------------------------
-- Q6: Seller performance - average delivery delay caused per seller
-- Purpose: Identify sellers associated with most late deliveries.
-------------------------------------------------------------
SELECT
    oi.seller_id,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 2) AS avg_delay_days,
    COUNT(*) AS delayed_orders
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY oi.seller_id
HAVING delayed_orders > 20   -- Filter to avoid noisy small samples
ORDER BY avg_delay_days DESC
LIMIT 15;

-------------------------------------------------------------
-- Q7: Total revenue generated per seller
-- Purpose: Identify high-value sellers.
-------------------------------------------------------------
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;