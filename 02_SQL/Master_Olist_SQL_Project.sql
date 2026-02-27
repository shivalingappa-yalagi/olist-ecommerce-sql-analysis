/* ===========================================================
   OLIST E-COMMERCE PROJECT – MASTER SQL FILE
   Author  : Shivalingappa Yalagi
   Purpose : Complete SQL Analysis (20 Modules Combined)
   =========================================================== */

/* ===========================================================
   01 – BASIC EXPLORATION
   =========================================================== */
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



/* ===========================================================
   02 – ORDER STATUS ANALYSIS
   =========================================================== */
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

--------------------------------------------------------------

-- Q7: Days delayed for each order
-- Purpose: Calculate how many days an order was late.
SELECT
    order_id,
    DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS delay_days
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date > order_estimated_delivery_date
ORDER BY delay_days DESC;

------------------------------------------------------------------

-- Q8: Average delay by customer state
-- Purpose: Identify states with the longest delivery delays.
SELECT
    c.customer_state,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 2) AS avg_delay_days,
    COUNT(*) AS delayed_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY c.customer_state
ORDER BY avg_delay_days DESC;



/* ===========================================================
   03 – CUSTOMER ANALYSIS
   =========================================================== */
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

/* ===========================================================
   04 – SELLER ANALYSIS
   =========================================================== */
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

/* ===========================================================
   05 – PAYMENT ANALYSIS
   =========================================================== */
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


/* ===========================================================
   06 – PRODUCT ANALYSIS
   =========================================================== */
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





/* ===========================================================
   07 – GEOLOCATION ANALYSIS
   =========================================================== */
/*---------------------------------------------------------
    OLIST E-COMMERCE SQL PROJECT
    File: 07_geolocation_analysis.sql
    Purpose: Analyze locations, zip codes, city/state mapping
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Count unique geolocation entries
-- Purpose: Understand coverage of geographic dataset
-------------------------------------------------------------
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_codes,
    COUNT(DISTINCT geolocation_city) AS unique_cities,
    COUNT(DISTINCT geolocation_state) AS unique_states
FROM olist_geolocation_dataset;


-------------------------------------------------------------
-- Q2: States with the most geo data points
-- Purpose: Identify which states have the highest number of coordinates
-------------------------------------------------------------
SELECT 
    geolocation_state AS state,
    COUNT(*) AS total_points
FROM olist_geolocation_dataset
GROUP BY geolocation_state
ORDER BY total_points DESC
LIMIT 10;


-------------------------------------------------------------
-- Q3: Cities with the most geo data points
-- Purpose: Determine which cities have the highest location density
-------------------------------------------------------------
SELECT 
    geolocation_city AS city,
    COUNT(*) AS total_points
FROM olist_geolocation_dataset
GROUP BY geolocation_city
ORDER BY total_points DESC
LIMIT 15;


-------------------------------------------------------------
-- Q4: Zip codes with highest number of coordinates
-- Purpose: Some zip prefixes appear many times for different coordinates
-------------------------------------------------------------
SELECT 
    geolocation_zip_code_prefix AS zip_code,
    COUNT(*) AS total_points
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
ORDER BY total_points DESC
LIMIT 15;


-------------------------------------------------------------
-- Q5: Validate if multiple cities share same ZIP prefix
-- Purpose: Check for data duplication or mapping inconsistencies
-------------------------------------------------------------
SELECT 
    geolocation_zip_code_prefix AS zip_code,
    COUNT(DISTINCT geolocation_city) AS city_count
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
HAVING city_count > 1
ORDER BY city_count DESC
LIMIT 20;


-------------------------------------------------------------
-- Q6: Top states by seller concentration
-- Purpose: Where most sellers are located
-------------------------------------------------------------
SELECT
    geolocation_state AS state,
    COUNT(*) AS seller_geo_points
FROM olist_geolocation_dataset g
JOIN olist_sellers_dataset s
    ON g.geolocation_zip_code_prefix = s.seller_zip_code_prefix
GROUP BY state
ORDER BY seller_geo_points DESC
LIMIT 10;


-------------------------------------------------------------
-- Q7: Top states by customer concentration
-- Purpose: Where most customers are located
-------------------------------------------------------------
SELECT
    geolocation_state AS state,
    COUNT(*) AS customer_geo_points
FROM olist_geolocation_dataset g
JOIN olist_customers_dataset c
    ON g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
GROUP BY state
ORDER BY customer_geo_points DESC
LIMIT 10;


-------------------------------------------------------------
-- Q8: Mapping cities to average latitude/longitude
-- Purpose: Create usable coordinate mapping for BI / visualization
-------------------------------------------------------------
SELECT
    geolocation_city AS city,
    ROUND(AVG(geolocation_lat), 6) AS avg_latitude,
    ROUND(AVG(geolocation_lng), 6) AS avg_longitude
FROM olist_geolocation_dataset
GROUP BY geolocation_city
ORDER BY city ASC
LIMIT 20;

/* ===========================================================
   08 – REVIEW ANALYSIS
   =========================================================== */
/*---------------------------------------------------------
    OLIST E-COMMERCE SQL PROJECT
    File: 08_review_analysis.sql
    Purpose: Analyze customer review behavior & satisfaction
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Distribution of review scores (1 to 5)
-- Purpose: Identify overall customer satisfaction levels
-------------------------------------------------------------
SELECT 
    review_score,
    COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;


-------------------------------------------------------------
-- Q2: Percentage distribution of review scores
-- Purpose: Understand relative share of positive/negative reviews
-------------------------------------------------------------
SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM olist_order_reviews_dataset)) * 100, 2) AS percentage
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;


-------------------------------------------------------------
-- Q3: Average review score
-- Purpose: Overall mindset/satisfaction across entire platform
-------------------------------------------------------------
SELECT 
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM olist_order_reviews_dataset;


-------------------------------------------------------------
-- Q4: Reviews with and without comments
-- Purpose: Determine how many users write text feedback
-------------------------------------------------------------
SELECT
    SUM(review_comment_title IS NOT NULL OR review_comment_message IS NOT NULL) AS with_comments,
    SUM(review_comment_title IS NULL AND review_comment_message IS NULL) AS without_comments
FROM olist_order_reviews_dataset;


-------------------------------------------------------------
-- Q5: Identify extremely negative reviews (score = 1)
-- Purpose: Investigate major issues
-------------------------------------------------------------
SELECT 
    review_id,
    order_id,
    review_comment_message
FROM olist_order_reviews_dataset
WHERE review_score = 1
LIMIT 15;


-------------------------------------------------------------
-- Q6: Identify extremely positive reviews (score = 5)
-- Purpose: Check for recurring praise or strengths
-------------------------------------------------------------
SELECT 
    review_id,
    order_id,
    review_comment_message
FROM olist_order_reviews_dataset
WHERE review_score = 5
LIMIT 15;


-------------------------------------------------------------
-- Q7: Average review score by year-month
-- Purpose: Track customer satisfaction trend over time
-------------------------------------------------------------
SELECT
    DATE_FORMAT(review_creation_date, '%Y-%m') AS year_mon,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM olist_order_reviews_dataset
GROUP BY year_mon
ORDER BY year_mon;


-------------------------------------------------------------
-- Q8: Correlation of review score with delivery delays
-- Purpose: Understand whether late deliveries cause low ratings
-------------------------------------------------------------
SELECT
    r.review_score,
    COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset r
JOIN olist_orders_dataset o
    ON r.order_id COLLATE utf8mb4_unicode_ci = o.order_id COLLATE utf8mb4_unicode_ci
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY r.review_score
ORDER BY r.review_score;


-------------------------------------------------------------
-- Q9: Review score by state (customer state)
-- Purpose: Identify regions with highest/lowest satisfaction
-------------------------------------------------------------
SELECT
    c.customer_state,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset r
JOIN olist_orders_dataset o
    ON r.order_id COLLATE utf8mb4_unicode_ci = o.order_id COLLATE utf8mb4_unicode_ci
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_review_score DESC;


-------------------------------------------------------------
-- Q10: Review score per product category
-- Purpose: Which product categories get the best or worst reviews?
-------------------------------------------------------------
SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset r
JOIN olist_order_items_dataset oi
    ON r.order_id COLLATE utf8mb4_unicode_ci = oi.order_id COLLATE utf8mb4_unicode_ci
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY category
HAVING total_reviews > 100
ORDER BY avg_review_score DESC;

/* ===========================================================
   09 – CUSTOMER RFM ANALYSIS
   =========================================================== */
WITH orders_final AS (
    SELECT  
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        p.payment_value
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_payments_dataset p 
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),

rfm_base AS (
    SELECT 
        customer_id,
        
        -- Recency: days since last order
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM orders_final),
            MAX(order_purchase_timestamp)
        ) AS recency,
        
        -- Frequency: total delivered orders
        COUNT(order_id) AS frequency,
        
        -- Monetary value
        SUM(payment_value) AS monetary
    FROM orders_final
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT 
        customer_id,
        recency,
        frequency,
        monetary,
        
        -- Recency score (lower recency = better)
        CASE 
            WHEN recency <= 30 THEN 5
            WHEN recency <= 60 THEN 4
            WHEN recency <= 120 THEN 3
            WHEN recency <= 240 THEN 2
            ELSE 1
        END AS recency_score,
        
        -- Frequency score
        CASE 
            WHEN frequency >= 10 THEN 5
            WHEN frequency >= 6 THEN 4
            WHEN frequency >= 3 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS frequency_score,
        
        -- Monetary score
        CASE 
            WHEN monetary >= 2000 THEN 5
            WHEN monetary >= 1000 THEN 4
            WHEN monetary >= 500 THEN 3
            WHEN monetary >= 200 THEN 2
            ELSE 1
        END AS monetary_score
    FROM rfm_base
)

SELECT *
FROM rfm_scores
ORDER BY monetary DESC;

/* ===========================================================
   10 – CUSTOMER RFM SEGMENTATION
   =========================================================== */
WITH orders_final AS (
    SELECT  
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        p.payment_value
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_payments_dataset p 
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),

rfm_base AS (
    SELECT 
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM orders_final),
            MAX(order_purchase_timestamp)
        ) AS recency,
        COUNT(order_id) AS frequency,
        SUM(payment_value) AS monetary
    FROM orders_final
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT 
        customer_id,
        recency,
        frequency,
        monetary,
        
        CASE 
            WHEN recency <= 30 THEN 5
            WHEN recency <= 60 THEN 4
            WHEN recency <= 120 THEN 3
            WHEN recency <= 240 THEN 2
            ELSE 1
        END AS recency_score,
        
        CASE 
            WHEN frequency >= 10 THEN 5
            WHEN frequency >= 6 THEN 4
            WHEN frequency >= 3 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS frequency_score,
        
        CASE 
            WHEN monetary >= 2000 THEN 5
            WHEN monetary >= 1000 THEN 4
            WHEN monetary >= 500 THEN 3
            WHEN monetary >= 200 THEN 2
            ELSE 1
        END AS monetary_score
    FROM rfm_base
),

rfm_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        recency_score,
        frequency_score,
        monetary_score,
        
        (recency_score + frequency_score + monetary_score) AS total_rfm_score,
        
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 
                THEN 'Champions'
                
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 
                THEN 'Loyal Customers'
                
            WHEN recency_score >= 4 AND frequency_score <= 2 
                THEN 'Potential Loyalists'
                
            WHEN recency_score <= 2 AND frequency_score >= 4 
                THEN 'At Risk'
                
            WHEN recency_score = 1 AND frequency_score = 1 
                THEN 'Lost Customers'
                
            WHEN recency_score >= 3 AND monetary_score >= 4 
                THEN 'Big Spenders'
                
            ELSE 'Others'
        END AS customer_segment
    FROM rfm_scores
)

SELECT *
FROM rfm_segments
ORDER BY total_rfm_score DESC;

/* ===========================================================
   11 – SELLER PERFORMANCE ANALYSIS
   =========================================================== */
-- ============================================
-- 1. Seller Performance – Revenue, Orders, Delivery Speed
-- ============================================

WITH seller_orders AS (
    SELECT 
        s.seller_id,
        oi.order_id,
        oi.price,
        oi.freight_value,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        o.order_status
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_sellers_dataset s 
        ON oi.seller_id = s.seller_id
    LEFT JOIN olist_orders_dataset o
        ON oi.order_id = o.order_id
),

seller_metrics AS (
    SELECT
        seller_id,
        
        COUNT(DISTINCT order_id) AS total_orders,
        
        SUM(price + freight_value) AS total_revenue,
        
        AVG(price) AS avg_order_value,
        
        AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) 
            AS avg_delivery_days,
        
        SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
        SUM(CASE WHEN order_status IN ('canceled', 'unavailable') THEN 1 ELSE 0 END) 
            AS canceled_orders
        
    FROM seller_orders
    GROUP BY seller_id
)

SELECT 
    seller_id,
    total_orders,
    delivered_orders,
    canceled_orders,
    total_revenue,
    avg_order_value,
    avg_delivery_days
FROM seller_metrics
ORDER BY total_revenue DESC;

/* ===========================================================
   12 – DELIVERY PERFORMANCE ANALYSIS
   =========================================================== */
-- ====================================================
-- Delivery Performance Analysis: Actual vs Estimated 
-- Delivery Speed, Delays, Seller & State Performance
-- ====================================================

WITH delivery_data AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        o.order_status,
        c.customer_state,
        DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS actual_delivery_days,
        DATEDIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp) AS estimated_delivery_days,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM olist_orders_dataset o
    LEFT JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

state_delivery AS (
    SELECT
        customer_state,
        COUNT(order_id) AS total_orders,
        AVG(actual_delivery_days) AS avg_actual_delivery,
        AVG(estimated_delivery_days) AS avg_estimated_delivery,
        AVG(delay_days) AS avg_delay
    FROM delivery_data
    GROUP BY customer_state
),

seller_delivery AS (
    SELECT
        oi.seller_id,
        COUNT(oi.order_id) AS total_orders,
        AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days,
        AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)) AS avg_delay_days,
        SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_deliveries
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_orders_dataset o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
)

-- Final Output: Delivery Performance Summary
SELECT * 
FROM seller_delivery
ORDER BY avg_delivery_days;

/* ===========================================================
   13 – PAYMENT BEHAVIOR ANALYSIS
   =========================================================== */
-- ==================================================
-- Payment Behavior Analysis: Method, Installments,
-- Revenue Impact, Order Value Relationship
-- ==================================================

WITH payment_data AS (
    SELECT
        p.order_id,
        p.payment_sequential,
        p.payment_type,
        p.payment_installments,
        p.payment_value,
        o.customer_id,
        o.order_status
    FROM olist_order_payments_dataset p
    LEFT JOIN olist_orders_dataset o
        ON p.order_id = o.order_id
    WHERE o.order_status = 'delivered'
),

payment_summary AS (
    SELECT
        payment_type,
        COUNT(order_id) AS total_orders,
        SUM(payment_value) AS total_revenue,
        AVG(payment_value) AS avg_payment_value,
        AVG(payment_installments) AS avg_installments,
        SUM(CASE WHEN payment_installments > 1 THEN 1 ELSE 0 END) AS installment_orders,
        SUM(CASE WHEN payment_installments = 1 THEN 1 ELSE 0 END) AS single_payment_orders
    FROM payment_data
    GROUP BY payment_type
),

installment_analysis AS (
    SELECT
        payment_installments,
        COUNT(order_id) AS orders_with_installments,
        AVG(payment_value) AS avg_value_for_installments
    FROM payment_data
    GROUP BY payment_installments
)

-- Final Output
SELECT 
    ps.payment_type,
    ps.total_orders,
    ps.total_revenue,
    ps.avg_payment_value,
    ps.avg_installments,
    ps.installment_orders,
    ps.single_payment_orders
FROM payment_summary ps
ORDER BY ps.total_revenue DESC;

/* ===========================================================
   14 – PRODUCT CATEGORY PERFORMANCE
   =========================================================== */
-- =========================================================
-- Product Category Performance (FINAL COLLATION FIX)
-- =========================================================

WITH order_items AS (
    SELECT
        oi.order_id,
        oi.product_id COLLATE utf8mb4_0900_ai_ci AS product_id,
        oi.price,
        oi.freight_value,
        p.product_category_name COLLATE utf8mb4_0900_ai_ci AS product_category_name
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_products_dataset p
        ON oi.product_id COLLATE utf8mb4_0900_ai_ci = p.product_id COLLATE utf8mb4_0900_ai_ci
),

orders_with_delivery AS (
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_days
    FROM olist_orders_dataset o
    WHERE o.order_status = 'delivered'
),

reviews AS (
    SELECT
        order_id COLLATE utf8mb4_0900_ai_ci AS order_id,
        review_score
    FROM olist_order_reviews_dataset
),

category_metrics AS (
    SELECT
        oi.product_category_name,
        COUNT(oi.order_id) AS total_orders,
        SUM(oi.price + oi.freight_value) AS total_revenue,
        AVG(oi.price) AS avg_product_price,
        AVG(od.delivery_days) AS avg_delivery_days,
        AVG(r.review_score) AS avg_review_score
    FROM order_items oi
    LEFT JOIN orders_with_delivery od
        ON oi.order_id COLLATE utf8mb4_0900_ai_ci = od.order_id COLLATE utf8mb4_0900_ai_ci
    LEFT JOIN reviews r
        ON oi.order_id COLLATE utf8mb4_0900_ai_ci = r.order_id COLLATE utf8mb4_0900_ai_ci
    WHERE oi.product_category_name IS NOT NULL
    GROUP BY oi.product_category_name
)

SELECT *
FROM category_metrics
ORDER BY total_revenue DESC;

/* ===========================================================
   15 – CUSTOMER LIFETIME VALUE
   =========================================================== */
-- ======================================================
-- CUSTOMER LIFETIME VALUE (CLV) ANALYSIS
-- Total Revenue + Avg Order Value + Repeat Rate
-- ======================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        p.payment_value
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),

customer_revenue AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(payment_value) AS total_revenue,
        AVG(payment_value) AS avg_order_value,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        MAX(order_purchase_timestamp) AS last_purchase_date
    FROM delivered_orders
    GROUP BY customer_id
),

customer_lifetime AS (
    SELECT
        customer_id,
        total_orders,
        total_revenue,
        avg_order_value,
        DATEDIFF(last_purchase_date, first_purchase_date) AS customer_lifetime_days,
        
        CASE 
            WHEN total_orders >= 5 THEN 'High Repeat Customer'
            WHEN total_orders >= 3 THEN 'Moderate Repeat Customer'
            WHEN total_orders = 2 THEN 'Occasional Buyer'
            ELSE 'One-Time Buyer'
        END AS repeat_category
    FROM customer_revenue
)

SELECT *
FROM customer_lifetime
ORDER BY total_revenue DESC;

/* ===========================================================
   16 – REVENUE TREND ANALYSIS
   =========================================================== */
-- ======================================================
-- REVENUE TREND ANALYSIS: Daily, Weekly, Monthly, Quarterly
-- ======================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        DATE(o.order_purchase_timestamp) AS order_date,
        p.payment_value
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),

daily_revenue AS (
    SELECT
        order_date,
        SUM(payment_value) AS total_daily_revenue,
        COUNT(order_id) AS daily_orders
    FROM delivered_orders
    GROUP BY order_date
),

monthly_revenue AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(payment_value) AS total_monthly_revenue,
        COUNT(order_id) AS monthly_orders
    FROM delivered_orders
    GROUP BY month
),

weekly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        WEEK(order_date, 1) AS week_num,
        SUM(payment_value) AS total_weekly_revenue,
        COUNT(order_id) AS weekly_orders
    FROM delivered_orders
    GROUP BY yr, week_num
),

quarterly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        QUARTER(order_date) AS qtr,
        SUM(payment_value) AS total_quarterly_revenue,
        COUNT(order_id) AS quarterly_orders
    FROM delivered_orders
    GROUP BY yr, qtr
)

-- Final Output: Monthly Revenue (Main Metric)
SELECT *
FROM monthly_revenue
ORDER BY month;

/* ===========================================================
   17 – CUSTOMER COHORT RETENTION
   =========================================================== */
-- ========================================================
-- CUSTOMER COHORT RETENTION ANALYSIS (MONTHLY)
-- Cohort Month vs Returning Customer Activity
-- ========================================================

WITH delivered_orders AS (
    SELECT
        customer_id,
        DATE(order_purchase_timestamp) AS order_date,
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month
    FROM olist_orders_dataset
    WHERE order_status = 'delivered'
),

first_purchase AS (
    SELECT
        customer_id,
        MIN(order_month) AS cohort_month
    FROM delivered_orders
    GROUP BY customer_id
),

cohort_activity AS (
    SELECT
        d.customer_id,
        fp.cohort_month,
        d.order_month AS active_month
    FROM delivered_orders d
    JOIN first_purchase fp
        ON d.customer_id = fp.customer_id
),

cohort_index AS (
    SELECT
        cohort_month,
        active_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohort_activity
    GROUP BY cohort_month, active_month
),

cohort_matrix AS (
    SELECT
        cohort_month,
        active_month,
        active_customers,
        TIMESTAMPDIFF(MONTH, 
            STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'),
            STR_TO_DATE(CONCAT(active_month, '-01'), '%Y-%m-%d')
        ) AS month_index
    FROM cohort_index
)

SELECT 
    cohort_month,
    month_index,
    active_customers
FROM cohort_matrix
ORDER BY cohort_month, month_index;

/* ===========================================================
   18 – CATEGORY SEASONALITY TRENDS
   =========================================================== */
-- ======================================================
-- CATEGORY SEASONALITY & MONTHLY TREND ANALYSIS
-- ======================================================

WITH delivered_orders AS (
    SELECT
        oi.order_id,
        oi.product_id,
        oi.price,
        oi.freight_value,
        p.product_category_name COLLATE utf8mb4_0900_ai_ci AS category,
        o.order_purchase_timestamp,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_products_dataset p
        ON oi.product_id COLLATE utf8mb4_0900_ai_ci = p.product_id COLLATE utf8mb4_0900_ai_ci
    LEFT JOIN olist_orders_dataset o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
),

category_monthly AS (
    SELECT
        category,
        order_month,
        COUNT(order_id) AS total_orders,
        SUM(price + freight_value) AS total_revenue,
        AVG(price) AS avg_price
    FROM delivered_orders
    WHERE category IS NOT NULL
    GROUP BY category, order_month
)

SELECT 
    category,
    order_month,
    total_orders,
    total_revenue,
    avg_price
FROM category_monthly
ORDER BY category, order_month;

/* ===========================================================
   19 – LOGISTICS PERFORMANCE BY STATE
   =========================================================== */
-- ==========================================================
-- LOGISTICS PERFORMANCE BY STATE
-- Delivery speed, delays, order count, and revenue by state
-- ==========================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_state,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        p.payment_value,
        
        DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS actual_delivery_days,
        DATEDIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp) AS estimated_delivery_days,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
        
    FROM olist_orders_dataset o
    LEFT JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    LEFT JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),

state_metrics AS (
    SELECT
        customer_state,
        COUNT(order_id) AS total_orders,
        SUM(payment_value) AS total_revenue,
        AVG(actual_delivery_days) AS avg_delivery_time,
        AVG(delay_days) AS avg_delay,
        
        SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) AS late_deliveries,
        SUM(CASE WHEN delay_days <= 0 THEN 1 ELSE 0 END) AS on_time_deliveries
        
    FROM delivered_orders
    GROUP BY customer_state
)

SELECT
    customer_state,
    total_orders,
    total_revenue,
    avg_delivery_time,
    avg_delay,
    late_deliveries,
    on_time_deliveries
FROM state_metrics
ORDER BY total_orders DESC;

/* ===========================================================
   20 – MARKETPLACE GEOGRAPHY ANALYSIS
   =========================================================== */
-- ============================================================
-- MARKETPLACE GEOGRAPHY ANALYSIS
-- Customer distribution, Seller distribution, Revenue by state
-- ============================================================

-- 1. Customer Distribution by State
WITH customer_state AS (
    SELECT
        customer_state,
        COUNT(customer_id) AS total_customers
    FROM olist_customers_dataset
    GROUP BY customer_state
),

-- 2. Seller Distribution by State
seller_state AS (
    SELECT
        seller_state,
        COUNT(seller_id) AS total_sellers
    FROM olist_sellers_dataset
    GROUP BY seller_state
),

-- 3. Revenue by Customer State
customer_revenue AS (
    SELECT
        c.customer_state,
        SUM(p.payment_value) AS total_revenue,
        COUNT(o.order_id) AS total_orders
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    LEFT JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
)

-- Final combined geography metrics
SELECT
    cs.customer_state AS state,
    cs.total_customers,
    ss.total_sellers,
    cr.total_revenue,
    cr.total_orders
FROM customer_state cs
LEFT JOIN customer_revenue cr
    ON cs.customer_state = cr.customer_state
LEFT JOIN seller_state ss
    ON cs.customer_state = ss.seller_state
ORDER BY cr.total_revenue DESC;

