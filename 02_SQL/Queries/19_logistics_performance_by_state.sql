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