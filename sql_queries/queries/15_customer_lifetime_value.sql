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