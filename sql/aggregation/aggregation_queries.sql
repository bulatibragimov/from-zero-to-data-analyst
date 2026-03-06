/* =====================================================
SQL Data Aggregation Practice
Dataset: Karpov.Courses training dataset

В этом файле собраны SQL-запросы, демонстрирующие навыки:
- агрегирования данных
- группировки
- фильтрации агрегированных значений
- расчёта аналитических метрик
===================================================== */


/* =====================================================
Task 1 — Customers Distribution by City

Бизнес-задача:
Определить, в каких городах зарегистрировано больше всего клиентов.
===================================================== */

SELECT
    customer_city,
    COUNT(*) AS customers_count
FROM customers
GROUP BY customer_city
ORDER BY customers_count DESC;



/* =====================================================
Task 2 — Order Price Statistics

Бизнес-задача:
Рассчитать основные метрики по каждому заказу:
- общая стоимость заказа
- количество товаров
- средняя цена товара
- максимальная и минимальная цена товара
===================================================== */

SELECT
    order_id,
    SUM(price) AS total_price,
    COUNT(product_id) AS items_count,
    AVG(price) AS avg_price,
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM order_items
GROUP BY order_id
ORDER BY order_id ASC;



/* =====================================================
Task 3 — Customer Registrations by Month

Бизнес-задача:
Проанализировать динамику регистрации пользователей по месяцам.
===================================================== */

SELECT
    DATE_TRUNC('month', created_at) AS registration_month,
    COUNT(DISTINCT customer_id) AS unique_customers_count
FROM customers
GROUP BY registration_month
ORDER BY registration_month DESC;



/* =====================================================
Task 4 — Average Product Weight by Brand

Бизнес-задача:
Найти бренды, у которых средний вес товара слишком маленький
или слишком большой.
===================================================== */

SELECT
    product_brand,
    AVG(product_weight_g) AS avg_weight_g
FROM products
GROUP BY product_brand
HAVING AVG(product_weight_g) < 200
   OR AVG(product_weight_g) > 400
ORDER BY avg_weight_g DESC;



/* =====================================================
Task 5 — User Activity by Event Type

Бизнес-задача:
Проанализировать активность пользователей по типу событий.
===================================================== */

SELECT
    event_type,
    COUNT(*) AS event_count,
    COUNT(DISTINCT customer_id) AS unique_customers_count
FROM customer_actions
GROUP BY event_type;



/* =====================================================
Task 6 — Unique Product Brand and Category Pairs

Бизнес-задача:
Получить уникальные комбинации брендов и категорий товаров.
===================================================== */

SELECT DISTINCT
    product_brand,
    product_category_name
FROM products
ORDER BY product_brand DESC;



/* =====================================================
Task 7 — Customer Gender Data Completeness

Бизнес-задача:
Сравнить общее количество пользователей
и количество пользователей, указавших пол.
===================================================== */

SELECT
    COUNT(*) AS total_customers,
    COUNT(gender) AS customers_with_gender
FROM customers;



/* =====================================================
Task 8 — Returned vs Delivered Orders per Customer

Бизнес-задача:
Определить, сколько заказов каждый пользователь
вернул и сколько заказов было успешно доставлено.
===================================================== */

SELECT
    customer_id,
    COUNT(CASE WHEN order_status = 'Returned' THEN 1 END) AS returned_orders,
    COUNT(CASE WHEN order_status = 'Delivered' THEN 1 END) AS delivered_orders
FROM orders
GROUP BY customer_id
ORDER BY customer_id ASC;



/* =====================================================
Task 9 — Late Deliveries by Order Status

Бизнес-задача:
Посчитать общее количество заказов по каждому статусу
и определить, сколько из них были доставлены с опозданием.
===================================================== */

SELECT
    order_status,
    COUNT(*) AS total_orders,
    COUNT(order_status) FILTER (
        WHERE order_delivered_customer_time > order_estimated_delivery_time
    ) AS late_orders
FROM orders
GROUP BY order_status;



/* =====================================================
Task 10 — Customers with Average Delivery Delay

Бизнес-задача:
Найти клиентов, у которых средняя задержка доставки
превышает 2 дня.
===================================================== */

SELECT
    customer_id,
    ROUND(
        AVG(
            DATE_PART(
                'DAY',
                order_delivered_customer_time - order_estimated_delivery_time
            )::INTEGER
        ),
        2
    ) AS average_delay_days
FROM orders
WHERE order_delivered_customer_time IS NOT NULL
  AND order_estimated_delivery_time IS NOT NULL
  AND order_delivered_customer_time > order_estimated_delivery_time
GROUP BY customer_id
HAVING AVG(
        DATE_PART(
            'DAY',
            order_delivered_customer_time - order_estimated_delivery_time
        )
    ) > 2
ORDER BY customer_id;



/* =====================================================
Task 11 — Product Price Variation

Бизнес-задача:
Найти товары с наибольшей вариацией цены
в разных заказах.
===================================================== */

SELECT
    product_id,
    ROUND(
        (MAX(price) - MIN(price)) / AVG(price),
        3
    ) AS price_variation_coefficient
FROM order_items
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY price_variation_coefficient DESC
LIMIT 10;