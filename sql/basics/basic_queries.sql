/*
========================================
Topic: Basic SQL Queries
Course: CarpovCourses
Description:
Practice of SELECT, WHEN, ORDER BY
========================================
*/

SELECT
  *
FROM
  customers
LIMIT
  100

/* Выбор всех столбцов из таблицы customers, 
ограниченная кол-вом строк 100
*/
/*
SELECT - всегда отвечает за такие колонки, которые мы хотим извлечь из данных.
FROM - всегда после SELECT, отвечет из какой таблицы берем колонки.

Стурктура SELECT -> FROM -> ORDER BY -> LIMIT
*/

ORDER BY -- играет роль сортировки, то есть по умолчанию 
-- с меньшего на больший, по умолчнаию ASC
-- с большего на меньший, то DESC

-- Можно накладывать не только на одну колонку, но и на несколько,
-- причем будут накладываться условия слева напрово соответственно.

SELECT 
customer_id AS id ,
customer_city AS city 
FROM
customers
-- AS - переименовывает нашу колонку в другое название.

Аналогично есть еще несколько функций
ROUND(название колонки, до кого знака после запятой округлять) - функция окргления

SELECT 
order_id,
ROUND(price)
FROM
orders -- выдаст колонку с названием round, поэтому использовать
-- после функций AS очень желательно, чтобы не ошибиться в дальнейшем

SELECT 
LOWER(customer_city), -- все буквы маленькими
UPPER(customer_city) -- все буквы заглавными
FROM
customers

SELECT 
product_id,
product_length* product_width*product_height AS product_volume
FROM
products


SELECT
    price,
    ABS(price - 100)        AS abs_example, -- модуль
    ROUND(price / 3.0, 2)   AS round_example, -- округление до n знаков 
    CEIL(price / 7.0)       AS ceil_example, -- округление вверх/вниз
    FLOOR(price / 7.0)      AS floor_example, -- округление вверх/вниз
    POWER(price, 2)         AS power_example,  -- возведение в степень
    SQRT(price)             AS sqrt_example, -- квадратный корень
    EXP(1)                  AS exp_example --- e в степени x
FROM order_items
LIMIT 5;

-- разделение на 3 категории цены 
SELECT
product_id,
price,
CASE 
WHEN price<10000 THEN 'small_price'
WHEN price>= 10000 and price <40000 THEN 'medium_price'
ELSE 'big_price'
END AS price_type
FROM order_items
LIMIT 100

--  Если пользователь относится к этим городам, то ничего не нужно изменять, а все остальные города должны попасть в категорию «другой город»
SELECT
customer_id,
customer_city,
CASE WHEN customer_city='Санкт-Петербург' OR customer_city='Екатеринбург' THEN customer_city 
ELSE 'другой город'
END AS city_type
FROM customers

-- Напомним: оператор AND возвращает значение true только при выполнении ОБОИХ условий. 
-- Оператор OR возвращает значение true при выполнении ХОТЯ БЫ ОДНОГО условия. 

SELECT
DISTINCT -- это выбор уникальных значений
customer_city
FROM customers

SELECT
customer_id,
COALESCE(customer_city, 'Город не указан') AS customer_city  -- озволяет заменить пустое значение в колонке на то, которое нам нужно
FROM customers
ORDER BY customer_city DESC