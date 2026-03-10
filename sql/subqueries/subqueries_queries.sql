/* =====================================================
SQL Subqueries Practice
Dataset: Karpov.Courses training dataset

В этом файле собраны SQL-запросы, демонстрирующие
использование подзапросов для аналитики данных.
===================================================== */


/* =====================================================
Task 1 — Find Most Expensive Order Item

Бизнес-задача:
Найти товар с максимальной ценой среди всех товаров
в таблице заказов.
===================================================== */

SELECT
    order_id,
    product_id,
    price
FROM order_items
WHERE price = (
    SELECT MAX(price)
    FROM order_items
);



/* =====================================================
Task 2 — Category Average vs Overall Average

Бизнес-задача:
Определить категории товаров, средний вес которых
выше среднего веса товаров по всей таблице.
===================================================== */

SELECT
    product_category_name,
    AVG(product_weight_g) AS category_avg_weight,
    (
        SELECT AVG(product_weight_g)
        FROM products
    ) AS overall_avg_weight
FROM products
GROUP BY product_category_name
HAVING AVG(product_weight_g) >
    (
        SELECT AVG(product_weight_g)
        FROM products
    )
ORDER BY category_avg_weight DESC;



/* =====================================================
Task 3 — Product Discount Classification

Бизнес-задача:
Определить уровень скидки для товаров категории
"Одежда" на основе сравнения цены товара
со средней ценой товаров данной категории.
===================================================== */

SELECT
    p.product_id,
    p.product_category_name,
    oi.price,
    CASE
        WHEN oi.price >
            (
                SELECT AVG(price)
                FROM order_items
                WHERE product_id IN (
                    SELECT product_id
                    FROM products
                    WHERE product_category_name = 'Одежда'
                )
            )
        THEN 'Скидка 15%'

        WHEN oi.price =
            (
                SELECT AVG(price)
                FROM order_items
                WHERE product_id IN (
                    SELECT product_id
                    FROM products
                    WHERE product_category_name = 'Одежда'
                )
            )
        THEN 'Скидка 10%'

        ELSE 'Скидка 5%'
    END AS discount_status

FROM products p
INNER JOIN order_items oi
    ON p.product_id = oi.product_id

WHERE p.product_category_name = 'Одежда'

ORDER BY
    p.product_id,
    oi.price;



/* =====================================================
Task 4 — Products Purchased by Customers from Samara

Бизнес-задача:
Найти товары, которые покупали клиенты
из города Самара.
===================================================== */

SELECT
    p.product_id,
    p.product_brand,
    oi.price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IN
(
    SELECT order_id
    FROM orders
    WHERE customer_id IN
    (
        SELECT customer_id
        FROM customers
        WHERE customer_city = 'Самара'
    )
)
ORDER BY
    p.product_id DESC,
    oi.price DESC;



/* =====================================================
Task 5 — Categories with Existing Orders

Бизнес-задача:
Определить категории товаров, которые
хотя бы один раз присутствовали в заказах.
===================================================== */

SELECT DISTINCT
    p.product_category_name
FROM products p
WHERE EXISTS
(
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
)
ORDER BY p.product_category_name ASC;



/* =====================================================
Task 6 — Customer Segmentation by Page Views (CTE)

Бизнес-задача:
Сегментировать клиентов по количеству
просмотров страниц.
===================================================== */

WITH views AS
(
    SELECT
        customer_id,
        COUNT(event_type) FILTER
        (WHERE event_type = 'Page View') AS views_count
    FROM customer_actions
    GROUP BY customer_id
)

SELECT
    customer_id,
    views_count,
    CASE
        WHEN views_count >= 40 THEN 'Активный'
        WHEN views_count < 10 THEN 'Новичок'
        ELSE 'Средний'
    END AS customer_status
FROM views
ORDER BY
    views_count DESC,
    customer_id DESC;



/* =====================================================
Task 7 — Customers Viewing Pages Without Purchases

Бизнес-задача:
Найти клиентов, которые просматривали страницы,
но не сделали доставленных заказов.
===================================================== */

SELECT
    customer_id,
    customer_city
FROM customers
WHERE customer_id IN
(
    SELECT DISTINCT customer_id
    FROM customer_actions
    WHERE event_type = 'Page View'
    AND customer_id NOT IN
    (
        SELECT customer_id
        FROM orders
        WHERE order_status = 'Delivered'
    )
);



/* =====================================================
Task 8 — Brands with Above-Average Prices

Бизнес-задача:
Найти бренды товаров, средняя цена которых
выше средней цены всех товаров на 20%.
===================================================== */

SELECT
    product_brand,
    AVG(price) AS brand_avg_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY product_brand
HAVING AVG(price) >
(
    SELECT 1.2 * AVG(price)
    FROM order_items
)
ORDER BY brand_avg_price DESC;



/* =====================================================
Task 9 — Products Purchased by Customers
from Major Cities

Бизнес-задача:
Найти товары, которые покупали клиенты
из Москвы и Санкт-Петербурга.
===================================================== */

SELECT
    product_id,
    product_category_name,
    product_brand
FROM products
WHERE product_id IN
(
    SELECT product_id
    FROM order_items
    WHERE order_id IN
    (
        SELECT order_id
        FROM orders
        WHERE customer_id IN
        (
            SELECT customer_id
            FROM customers
            WHERE customer_city IN
            ('Москва', 'Санкт-Петербург')
        )
    )
);



/* =====================================================
Task 10 — Customer Segmentation by First Order (CTE)

Бизнес-задача:
Определить сегмент клиента на основе даты
его первого заказа.
===================================================== */

WITH customer_first_order AS
(
    SELECT
        customer_id,
        MIN(order_created_time) AS first_order_date
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    first_order_date,
    CASE
        WHEN first_order_date < '2024-02-01'
        THEN 'Старый клиент'
        ELSE 'Новый клиент'
    END AS customer_segment
FROM customer_first_order
ORDER BY first_order_date;