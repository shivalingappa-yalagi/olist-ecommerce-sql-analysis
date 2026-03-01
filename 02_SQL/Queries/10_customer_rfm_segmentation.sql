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
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM orders_final),
            MAX(order_purchase_timestamp)
        ) AS recency,
        COUNT(order_id) AS frequency,
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
        
        CASE 
            WHEN recency <= 30 THEN 5
            WHEN recency <= 60 THEN 4
            WHEN recency <= 120 THEN 3
            WHEN recency <= 240 THEN 2
            ELSE 1
        END AS recency_score,
        
        CASE 
            WHEN frequency >= 10 THEN 5
            WHEN frequency >= 6 THEN 4
            WHEN frequency >= 3 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS frequency_score,
        
        CASE 
            WHEN monetary >= 2000 THEN 5
            WHEN monetary >= 1000 THEN 4
            WHEN monetary >= 500 THEN 3
            WHEN monetary >= 200 THEN 2
            ELSE 1
        END AS monetary_score
    FROM rfm_base
),

rfm_segments AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        recency_score,
        frequency_score,
        monetary_score,
        
        (recency_score + frequency_score + monetary_score) AS total_rfm_score,
        
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 
                THEN 'Champions'
                
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 
                THEN 'Loyal Customers'
                
            WHEN recency_score >= 4 AND frequency_score <= 2 
                THEN 'Potential Loyalists'
                
            WHEN recency_score <= 2 AND frequency_score >= 4 
                THEN 'At Risk'
                
            WHEN recency_score = 1 AND frequency_score = 1 
                THEN 'Lost Customers'
                
            WHEN recency_score >= 3 AND monetary_score >= 4 
                THEN 'Big Spenders'
                
            ELSE 'Others'
        END AS customer_segment
    FROM rfm_scores
)

SELECT *
FROM rfm_segments
ORDER BY total_rfm_score DESC;