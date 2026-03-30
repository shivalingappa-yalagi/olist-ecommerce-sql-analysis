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