/*---------------------------------------------------------
   OLIST E-COMMERCE SQL PROJECT
   File: 06_product_analysis.sql
   Purpose: Product category, pricing, freight & popularity analysis
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Top 15 product categories by number of items sold
-------------------------------------------------------------
SELECT
    pct.product_category_name_english AS category,
    COUNT(*) AS total_items_sold
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY total_items_sold DESC
LIMIT 15;

-------------------------------------------------------------
-- Q2: Average product price by category
-------------------------------------------------------------
SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY avg_price DESC
LIMIT 15;

-------------------------------------------------------------
-- Q3: Average freight value by category
-------------------------------------------------------------
SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY avg_freight DESC
LIMIT 15;

-------------------------------------------------------------
-- Q4: Most expensive individual products (top 10)
-------------------------------------------------------------
SELECT
    oi.product_id,
    ROUND(MAX(oi.price), 2) AS max_product_price
FROM olist_order_items_dataset oi
GROUP BY oi.product_id
ORDER BY max_product_price DESC
LIMIT 10;

-------------------------------------------------------------
-- Q5: Product catalog completeness check
-------------------------------------------------------------
SELECT
    SUM(product_weight_g  IS NULL OR product_weight_g  = 0) AS missing_weight,
    SUM(product_length_cm IS NULL OR product_length_cm = 0) AS missing_length,
    SUM(product_height_cm IS NULL OR product_height_cm = 0) AS missing_height,
    SUM(product_width_cm  IS NULL OR product_width_cm  = 0) AS missing_width
FROM olist_products_dataset;

-------------------------------------------------------------
-- Q6: Product popularity (unique customers per product)
-------------------------------------------------------------
SELECT
    oi.product_id,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
GROUP BY oi.product_id
ORDER BY unique_customers DESC
LIMIT 15;

-------------------------------------------------------------
-- Q7: Highest reviewed product categories
-------------------------------------------------------------

SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist_order_items_dataset oi
JOIN olist_order_reviews_dataset r
    ON oi.order_id COLLATE utf8mb4_unicode_ci =
       r.order_id COLLATE utf8mb4_unicode_ci
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
HAVING COUNT(r.review_id) > 100
ORDER BY avg_review_score DESC
LIMIT 15;



