-- ======================================================
-- REVENUE TREND ANALYSIS: Daily, Weekly, Monthly, Quarterly
-- ======================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        DATE(o.order_purchase_timestamp) AS order_date,
        p.payment_value
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
),

daily_revenue AS (
    SELECT
        order_date,
        SUM(payment_value) AS total_daily_revenue,
        COUNT(order_id) AS daily_orders
    FROM delivered_orders
    GROUP BY order_date
),

monthly_revenue AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(payment_value) AS total_monthly_revenue,
        COUNT(order_id) AS monthly_orders
    FROM delivered_orders
    GROUP BY month
),

weekly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        WEEK(order_date, 1) AS week_num,
        SUM(payment_value) AS total_weekly_revenue,
        COUNT(order_id) AS weekly_orders
    FROM delivered_orders
    GROUP BY yr, week_num
),

quarterly_revenue AS (
    SELECT
        YEAR(order_date) AS yr,
        QUARTER(order_date) AS qtr,
        SUM(payment_value) AS total_quarterly_revenue,
        COUNT(order_id) AS quarterly_orders
    FROM delivered_orders
    GROUP BY yr, qtr
)

-- Final Output: Monthly Revenue (Main Metric)
SELECT *
FROM monthly_revenue
ORDER BY month;