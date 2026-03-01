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