/* =====================================================
SQL Data Joining Practice
Dataset: Karpov.Courses training dataset

В этом файле собраны SQL-запросы, демонстрирующие:
- объединение таблиц
- использование различных типов JOIN
- анализ данных из нескольких источников
===================================================== */


/* =====================================================
Task 1 — Orders and Product Categories

Бизнес-задача:
Посмотреть стоимость товаров в заказах
и их категории.
===================================================== */

SELECT
    o.price,
    p.product_category_name
FROM order_items o
LEFT JOIN products p
    ON o.product_id = p.product_id
ORDER BY o.price DESC;



/* =====================================================
Task 2 — Customers and Their Orders

Бизнес-задача:
Посмотреть какие заказы связаны с каждым клиентом.
===================================================== */

SELECT
    c.customer_id,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id ASC;



/* =====================================================
Task 3 — Customers Without Activity

Бизнес-задача:
Найти клиентов, у которых отсутствуют события
в таблице customer_actions.
===================================================== */

SELECT
    c.customer_id,
    c.created_at
FROM customers c
LEFT JOIN customer_actions ca
    ON c.customer_id = ca.customer_id
WHERE ca.customer_id IS NULL
ORDER BY c.customer_id;



/* =====================================================
Task 4 — Customers and Order Status

Бизнес-задача:
Посмотреть информацию о заказах клиентов
вместе со статусом заказа.
===================================================== */

SELECT
    c.customer_id,
    c.customer_city,
    o.order_id,
    o.order_status
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY o.order_id;



/* =====================================================
Task 5 — Full Join Customers and Orders

Бизнес-задача:
Получить полный список клиентов и заказов,
включая записи без совпадений.
===================================================== */

SELECT
    c.customer_id,
    o.order_id
FROM customers c
FULL OUTER JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY o.order_id;



/* =====================================================
Task 6 — Customer Event Types

Бизнес-задача:
Посмотреть какие типы событий выполняли клиенты.
===================================================== */

SELECT DISTINCT
    c.customer_id,
    ca.event_type
FROM customers c
LEFT JOIN customer_actions ca
    ON c.customer_id = ca.customer_id
ORDER BY c.customer_id, ca.event_type;



/* =====================================================
Task 7 — Product Brands Bought in Moscow

Бизнес-задача:
Найти бренды товаров, которые покупали
клиенты из Москвы.
===================================================== */

SELECT DISTINCT
    p.product_brand
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
INNER JOIN orders o
    ON oi.order_id = o.order_id
    AND o.order_status = 'Delivered'
JOIN customers c
    ON o.customer_id = c.customer_id
    AND c.customer_city = 'Москва'
ORDER BY p.product_brand DESC;



/* =====================================================
Task 8 — Products and Prices

Бизнес-задача:
Посмотреть товары и их цены в заказах,
включая товары, которые могли не продаваться.
===================================================== */

SELECT
    oi.price,
    p.product_id
FROM order_items oi
RIGHT JOIN products p
    USING(product_id)
ORDER BY oi.price;



/* =====================================================
Task 9 — Items Sold by Brand in Moscow

Бизнес-задача:
Посчитать количество проданных товаров
по каждому бренду среди клиентов Москвы.
===================================================== */

SELECT
    p.product_brand,
    COUNT(oi.order_id) AS items_count
FROM products p
LEFT JOIN order_items oi
    USING(product_id)
LEFT JOIN orders o
    USING(order_id)
JOIN customers c
    USING(customer_id)
WHERE c.customer_city = 'Москва'
GROUP BY p.product_brand
ORDER BY p.product_brand ASC;



/* =====================================================
Task 10 — Products and Orders by Category

Бизнес-задача:
Посчитать количество товаров и заказов
в каждой категории товаров.
===================================================== */

SELECT
    p.product_category_name,
    COUNT(DISTINCT p.product_id) AS products_in_category,
    COUNT(DISTINCT o.order_id) AS orders_count
FROM products p
LEFT JOIN order_items o
    ON p.product_id = o.product_id
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT o.order_id) >= 400
ORDER BY orders_count DESC;



/* =====================================================
Task 11 — Customers With Few Orders

Бизнес-задача:
Найти клиентов, у которых меньше 3 заказов,
и определить дату их последнего заказа.
===================================================== */

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    c.customer_city,
    MAX(o.order_created_time) AS last_order_date
FROM customers c
LEFT JOIN orders o
    USING(customer_id)
GROUP BY c.customer_id, c.customer_city
HAVING COUNT(DISTINCT o.order_id) < 3
ORDER BY c.customer_id;



/* =====================================================
Task 12 — Order Return Rate by City

Бизнес-задача:
Рассчитать долю возвратов заказов
по каждому городу.
===================================================== */

SELECT
    c.customer_city,
    COUNT(o.order_id) AS total_orders,
    COUNT(o.order_id) FILTER (WHERE order_status = 'Returned') AS canceled_orders,
    ROUND(
        COUNT(o.order_id) FILTER (WHERE order_status = 'Returned') * 100.0
        / COUNT(o.order_id),
        2
    ) AS cancel_rate_percent
FROM customers c
LEFT JOIN orders o
    USING(customer_id)
GROUP BY c.customer_city
ORDER BY cancel_rate_percent DESC;