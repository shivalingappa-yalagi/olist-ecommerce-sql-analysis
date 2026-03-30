-- ========================================================
-- CUSTOMER COHORT RETENTION ANALYSIS (MONTHLY)
-- Cohort Month vs Returning Customer Activity
-- ========================================================

WITH delivered_orders AS (
    SELECT
        customer_id,
        DATE(order_purchase_timestamp) AS order_date,
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month
    FROM olist_orders_dataset
    WHERE order_status = 'delivered'
),

first_purchase AS (
    SELECT
        customer_id,
        MIN(order_month) AS cohort_month
    FROM delivered_orders
    GROUP BY customer_id
),

cohort_activity AS (
    SELECT
        d.customer_id,
        fp.cohort_month,
        d.order_month AS active_month
    FROM delivered_orders d
    JOIN first_purchase fp
        ON d.customer_id = fp.customer_id
),

cohort_index AS (
    SELECT
        cohort_month,
        active_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohort_activity
    GROUP BY cohort_month, active_month
),

cohort_matrix AS (
    SELECT
        cohort_month,
        active_month,
        active_customers,
        TIMESTAMPDIFF(MONTH, 
            STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'),
            STR_TO_DATE(CONCAT(active_month, '-01'), '%Y-%m-%d')
        ) AS month_index
    FROM cohort_index
)

SELECT 
    cohort_month,
    month_index,
    active_customers
FROM cohort_matrix
ORDER BY cohort_month, month_index;