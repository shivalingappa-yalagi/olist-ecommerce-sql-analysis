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