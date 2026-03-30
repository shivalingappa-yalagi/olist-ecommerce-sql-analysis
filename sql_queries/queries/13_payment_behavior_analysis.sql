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