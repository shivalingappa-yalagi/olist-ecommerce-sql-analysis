/*---------------------------------------------------------
   OLIST E-COMMERCE SQL PROJECT
   File: 02_order_status_analysis.sql
   Folder: 02_SQL/analysis
   Purpose: Analyze order statuses and delivery performance
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Count of orders by status
-- Purpose: Understand the distribution of all order statuses.
-------------------------------------------------------------
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-------------------------------------------------------------
-- Q2: Percentage share of each order status
-- Purpose: Identify the proportion of delivered, shipped,
--          cancelled, and unavailable orders.
-------------------------------------------------------------
SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND( (COUNT(*) / (SELECT COUNT(*) FROM olist_orders_dataset)) * 100, 2 ) AS percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-------------------------------------------------------------
-- Q3: How many orders were delivered?
-- Purpose: Core delivery metric.
-------------------------------------------------------------
SELECT COUNT(*) AS delivered_orders
FROM olist_orders_dataset
WHERE order_status = 'delivered';

-------------------------------------------------------------
-- Q4: How many orders were never delivered? (Cancelled + Unavailable)
-- Purpose: Measure operational failure.
-------------------------------------------------------------
SELECT 
    SUM(order_status IN ('canceled', 'unavailable')) AS not_delivered_orders
FROM olist_orders_dataset;

-------------------------------------------------------------
-- Q5: How many orders were delivered late?
-- Purpose: Measure SLA (service-level agreement) violations.
-------------------------------------------------------------
SELECT 
    COUNT(*) AS late_deliveries
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date > order_estimated_delivery_date;

-------------------------------------------------------------
-- Q6: On-time vs late delivery performance
-- Purpose: Evaluate delivery reliability.
-------------------------------------------------------------
SELECT
    SUM(order_delivered_customer_date <= order_estimated_delivery_date) AS on_time_deliveries,
    SUM(order_delivered_customer_date >  order_estimated_delivery_date) AS late_deliveries
FROM olist_orders_dataset
WHERE order_status = 'delivered';