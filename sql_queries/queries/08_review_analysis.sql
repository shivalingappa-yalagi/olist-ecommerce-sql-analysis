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