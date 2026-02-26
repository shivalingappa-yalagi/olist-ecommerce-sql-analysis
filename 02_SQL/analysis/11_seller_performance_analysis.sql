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