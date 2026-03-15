/*
============================================================
SQL Window Functions Practice
Dataset: Karpov.Courses SQL Training
Description:
This file contains analytical SQL queries demonstrating the
use of window functions for advanced data analysis.

Concepts covered:
- OVER()
- PARTITION BY
- ORDER BY in window functions
- ROW_NUMBER(), RANK(), DENSE_RANK()
- LAG(), LEAD()
- Running totals
- Moving averages
- Analytical segmentation
============================================================
*/


/*
============================================================
Task 1 — Category Price Benchmark
Business Question:
Show the price of each sold product and compare it with the
average price of all products in the same category.
============================================================
*/

SELECT
    oi.price,
    p.product_category_name,
    AVG(oi.price) OVER(PARTITION BY p.product_category_name) AS avg_category_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
ORDER BY price ASC;



/*
============================================================
Task 2 — Customer Cumulative Spend
Business Question:
Calculate the cumulative amount spent by each customer
across their orders.
============================================================
*/

SELECT *,
       SUM(order_total_price) OVER(
            PARTITION BY customer_id
            ORDER BY order_id
       ) AS cumulative_spend
FROM (
    SELECT DISTINCT
        o.customer_id,
        o.order_id,
        o.order_created_time,
        SUM(oi.price) OVER(PARTITION BY o.order_id) AS order_total_price
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
) t1;



/*
============================================================
Task 3 — Top Products by Height per Category
Business Question:
Find the top 5 tallest products within each product category
and compare ranking methods.
============================================================
*/

SELECT *
FROM (
    SELECT
        product_category_name,
        product_id,
        product_height_cm,

        ROW_NUMBER() OVER(
            PARTITION BY product_category_name
            ORDER BY product_height_cm DESC
        ) AS row_num,

        RANK() OVER(
            PARTITION BY product_category_name
            ORDER BY product_height_cm DESC
        ) AS rank_num,

        DENSE_RANK() OVER(
            PARTITION BY product_category_name
            ORDER BY product_height_cm DESC
        ) AS dense_rank_num

    FROM products
) t1
WHERE dense_rank_num < 6;



/*
============================================================
Task 4 — Moving Average Revenue
Business Question:
Calculate daily revenue and a 3-day moving average
to analyze short-term revenue trends.
============================================================
*/

WITH daily_revenue_t1 AS (

    SELECT DISTINCT
        o.order_created_time::date AS order_date,
        SUM(oi.price) OVER(
            PARTITION BY o.order_created_time::date
        ) AS daily_revenue

    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
)

SELECT *,
       AVG(daily_revenue) OVER(
            ORDER BY order_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg_3d_revenue
FROM daily_revenue_t1;



/*
============================================================
Task 5 — Category Monthly Revenue Trend
Business Question:
Calculate monthly revenue for each product category and
revenue accumulated before the current month.
============================================================
*/

WITH monthly_revenue_by_category AS (

    SELECT
        p.product_category_name,
        DATE_TRUNC('month', o.order_created_time)::date AS category_month,
        SUM(oi.price) AS monthly_revenue,

        SUM(SUM(oi.price)) OVER(
            PARTITION BY p.product_category_name
            ORDER BY DATE_TRUNC('month', o.order_created_time)
        ) AS total_revenue_before_this_month

    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id

    GROUP BY
        p.product_category_name,
        DATE_TRUNC('month', o.order_created_time)::date
)

SELECT
    product_category_name,
    category_month,
    monthly_revenue,
    COALESCE(
        LAG(total_revenue_before_this_month)
        OVER(PARTITION BY product_category_name),
        0
    ) AS total_revenue_before_this_month
FROM monthly_revenue_by_category
ORDER BY product_category_name, category_month;



/*
============================================================
Task 6 — Customer Repeat Purchase Speed
Business Question:
Measure the average time between the first and second
orders for customers who made multiple purchases.
============================================================
*/

WITH order_sequence AS (

    SELECT
        customer_id,
        order_created_time,

        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY order_created_time
        ) AS order_rank,

        LEAD(order_created_time)
        OVER(
            PARTITION BY customer_id
            ORDER BY order_created_time
        ) AS next_order_time

    FROM orders
)

SELECT
    AVG(next_order_time - order_created_time)
        AS avg_time_between_1st_and_2nd_order
FROM order_sequence
WHERE order_rank = 1
AND next_order_time IS NOT NULL;



/*
============================================================
Task 7 — Customers Whose First Purchase Was Cars
============================================================
*/

WITH t1 AS (

    SELECT
        o.customer_id,
        o.order_id,
        p.product_category_name,

        DENSE_RANK() OVER(
            PARTITION BY o.customer_id
            ORDER BY o.order_created_time
        ) AS order_rank

    FROM orders o
    JOIN order_items oi USING(order_id)
    JOIN products p USING(product_id)
)

SELECT DISTINCT customer_id
FROM t1
WHERE product_category_name = 'Автомобили'
AND order_rank = 1
ORDER BY customer_id DESC;



/*
============================================================
Task 8 — Top 3 Most Expensive Products per Category
============================================================
*/

WITH catalog AS (

    SELECT
        p.product_category_name,
        p.product_id,
        oi.price,

        DENSE_RANK() OVER(
            PARTITION BY p.product_category_name
            ORDER BY oi.price DESC
        ) AS price_rank

    FROM products p
    JOIN order_items oi USING(product_id)
)

SELECT *
FROM catalog
WHERE price_rank < 4
ORDER BY product_category_name, price_rank;



/*
============================================================
Task 9 — Price Deviation Analysis
Business Question:
Compare each product price with the average price
in its category and brand.
============================================================
*/

SELECT DISTINCT
    p.product_id,
    p.product_category_name,
    p.product_brand,
    oi.price,

    AVG(oi.price) OVER(
        PARTITION BY p.product_category_name
    ) AS avg_category_price,

    AVG(oi.price) OVER(
        PARTITION BY p.product_brand
    ) AS avg_brand_price,

    oi.price -
    AVG(oi.price) OVER(
        PARTITION BY p.product_category_name
    ) AS category_price_delta,

    oi.price -
    AVG(oi.price) OVER(
        PARTITION BY p.product_brand
    ) AS brand_price_delta

FROM products p
JOIN order_items oi USING(product_id)

ORDER BY
    product_id,
    product_category_name,
    price;



/*
============================================================
Task 10 — Customer Category Diversity Ranking
Business Question:
Identify customers who purchase from the widest range
of product categories.
============================================================
*/

WITH catalog AS (

    SELECT DISTINCT
        o.customer_id,
        p.product_category_name

    FROM orders o
    JOIN order_items oi USING(order_id)
    JOIN products p USING(product_id)
)

SELECT *,
       DENSE_RANK() OVER(
            ORDER BY distinct_categories_count DESC
       ) AS diversity_rank
FROM (

    SELECT DISTINCT
        customer_id,
        COUNT(product_category_name)
        OVER(PARTITION BY customer_id)
        AS distinct_categories_count

    FROM catalog

) t1
ORDER BY diversity_rank, customer_id;



/*
============================================================
Task 11 — User Session Identification
Business Question:
Identify user sessions where the gap between events
does not exceed 30 minutes.
============================================================
*/

WITH events_with_lag AS (

    SELECT
        customer_id,
        event_timestamp,

        LAG(event_timestamp)
        OVER(
            PARTITION BY customer_id
            ORDER BY event_timestamp
        ) AS prev_event_time

    FROM customer_actions
),

session_boundaries AS (

    SELECT
        customer_id,
        event_timestamp,

        CASE
            WHEN prev_event_time IS NULL
            OR (event_timestamp - prev_event_time) > INTERVAL '30 minutes'
            THEN 1
            ELSE 0
        END AS is_new_session

    FROM events_with_lag
),

sessions AS (

    SELECT
        customer_id,
        event_timestamp,

        SUM(is_new_session)
        OVER(
            PARTITION BY customer_id
            ORDER BY event_timestamp
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_num

    FROM session_boundaries
)

SELECT
    customer_id,
    event_timestamp,
    CONCAT(customer_id, '_', session_num) AS session_id
FROM sessions
ORDER BY customer_id, event_timestamp;