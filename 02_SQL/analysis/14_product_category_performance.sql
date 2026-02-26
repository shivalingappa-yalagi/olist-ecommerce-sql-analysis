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