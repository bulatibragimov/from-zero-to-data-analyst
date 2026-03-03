/*
=========================================================
PROJECT: E-commerce Data Exploration
Dataset Source: Karpov.Courses
Author: <your_name>
=========================================================

Цель проекта:
Провести первичный аналитический аудит базы интернет-магазина:

1. Анализ клиентской базы
2. Исследование товарного каталога
3. Проверка SLA и своевременности доставки
4. Работа с пропущенными значениями
5. Анализ временных характеристик заказов

=========================================================
*/



/* =======================================================
1. CUSTOMER ANALYSIS
======================================================= */

-- 1.1 Клиенты, зарегистрированные после 1 февраля 2024

SELECT 
    customer_id,
    customer_zip_code,
    customer_city,
    created_at
FROM customers
WHERE created_at >= '2024-02-01';



-- 1.2 Клиенты из Москвы и Санкт-Петербурга,
-- зарегистрированные в январе

SELECT 
    customer_id
FROM customers
WHERE customer_city IN ('Москва', 'Санкт-Петербург')
  AND DATE_PART('month', created_at) = 1;



-- 1.3 Разделение клиентов на столичный регион и другие

SELECT 
    customer_id,
    CASE
        WHEN customer_city IN ('Москва', 'Санкт-Петербург')
            THEN 'Столица'
        ELSE 'Другие регионы'
    END AS region_group,
    UPPER(customer_city) AS city_upper
FROM customers;



-- 1.4 Клиенты с отсутствующим городом

SELECT 
    customer_id
FROM customers
WHERE customer_city IS NULL;



-- 1.5 Замена NULL в городе альтернативным значением

SELECT
    customer_id,
    customer_zip_code,
    customer_city,
    COALESCE(customer_city, 
             CAST(customer_zip_code AS VARCHAR)) AS destination
FROM customers;



-- 1.6 Анализ даты регистрации клиентов

SELECT 
    customer_id,
    customer_city,
    DATE_PART('day', created_at)   AS day_created_at,
    DATE_PART('month', created_at) AS month_created_at,
    DATE_PART('year', created_at)  AS year_created_at,
    DATE_PART('day', NOW() - created_at) AS register_days_ago
FROM customers;



-- 1.7 Приведение типов и сортировка по почтовому индексу

SELECT
    customer_id,
    CAST(customer_zip_code AS INTEGER) AS customer_zip_code,
    CAST(created_at AS VARCHAR) AS created_at
FROM customers
ORDER BY customer_zip_code ASC;




/* =======================================================
2. PRODUCT ANALYSIS
======================================================= */

-- 2.1 Товары категории "Одежда", отсортированные по весу

SELECT *
FROM products
WHERE LOWER(product_category_name) = 'одежда'
ORDER BY product_weight_g DESC;



-- 2.2 Выборка товаров из ключевых категорий

SELECT 
    product_id,
    product_brand,
    product_category_name
FROM products
WHERE product_category_name 
      IN ('Электроника','Одежда','Сад');



-- 2.3 Поиск брендов по ключевому слову "фото"

SELECT 
    product_id,
    LOWER(product_brand) AS product_brand
FROM products
WHERE LOWER(product_brand) LIKE '%фото%';



-- 2.4 Классификация брендов по ключевым словам

SELECT 
    product_id,
    LOWER(product_brand) AS product_brand,
    CASE
        WHEN LOWER(product_brand) LIKE '%фото%' 
            THEN 'Фото'
        WHEN LOWER(product_brand) LIKE '%техно%' 
          OR LOWER(product_brand) LIKE '%квант%' 
            THEN 'Техно'
        WHEN LOWER(product_brand) LIKE '%энерго%' 
            THEN 'Энерго'
        ELSE 'Другое'
    END AS brand_group
FROM products;



-- 2.5 Товары тяжелее 500 г с ключевым словом "фото"

SELECT 
    product_id,
    product_brand,
    product_category_name
FROM products
WHERE LOWER(product_brand) LIKE '%фото%'
  AND product_weight_g > 500;




/* =======================================================
3. ORDER & DELIVERY ANALYSIS
======================================================= */

-- 3.1 Заказы, созданные после 5 января 2024,
-- не возвращенные, доставленные в пределах SLA (5–10 дней)

SELECT
    order_id,
    order_status,
    order_created_time
FROM orders
WHERE order_created_time > '2024-01-05'
  AND order_status != 'Returned'
  AND order_estimated_delivery_time 
      BETWEEN order_created_time + INTERVAL '5 days'
          AND order_created_time + INTERVAL '10 days'
  AND order_delivered_customer_time IS NOT NULL
ORDER BY order_created_time DESC;



-- 3.2 Проверка своевременности доставки
-- Период анализа: 15.01.2024 – 03.03.2024 (не включительно)

SELECT
    order_id,
    COALESCE(order_delivered_customer_time, '2050-01-01')
        AS delivered_time_filled,
    CASE
        WHEN order_delivered_customer_time 
             <= order_estimated_delivery_time 
            THEN 'вовремя'
        WHEN order_delivered_customer_time 
             > order_estimated_delivery_time 
            THEN 'опоздал'
        ELSE 'остальные случаи'
    END AS delivery_status
FROM orders
WHERE order_created_time >= '2024-01-15'
  AND order_created_time < '2024-03-03';



-- 3.3 Расчет задержки доставки в днях

SELECT
    order_id,
    CAST(order_created_time AS DATE) 
        AS order_created_day,
    CAST(order_delivered_customer_time AS DATE) 
        AS order_delivered_customer_day,
    CAST(order_estimated_delivery_time AS DATE) 
        AS order_estimated_delivery_day,
    DATE_PART(
        'days', 
        order_estimated_delivery_time 
        - order_delivered_customer_time
    ) AS delivery_delay_days
FROM orders
ORDER BY delivery_delay_days ASC, order_id ASC;