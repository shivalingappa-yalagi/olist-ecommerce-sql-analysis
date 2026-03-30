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