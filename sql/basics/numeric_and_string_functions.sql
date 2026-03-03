/*
=================================================
Topic: Numeric and String Functions in PostgreSQL
Purpose: Practice data transformation and sorting
FROM: karpov.courses 
=================================================
*/

----------------------------------------------------
-- 1. Product Physical Metrics
-- Calculate volume (m³), weight (kg), and size difference
----------------------------------------------------
SELECT 
product_id,
product_length_cm AS length_cm,
product_width_cm AS width_cm,
product_height_cm AS height_cm,
ROUND((product_height_cm*product_length_cm*product_width_cm)/1000000.0,1) AS round_volume_m3,
CEIL(product_weight_g/1000.0) AS product_weight_kg,
ABS((product_length_cm - product_width_cm)/100.0) AS abs_diff
FROM 
products

----------------------------------------------------
-- 2. Product Name Cleaning and Transformation
----------------------------------------------------

SELECT 
product_id,
CONCAT(product_brand, ' - ',product_category_name ) AS product_full_name_clean,
CONCAT(SUBSTRING(product_brand, 1,3),'',LENGTH(product_category_name))  AS product_number,
SPLIT_PART(product_category_name, ' ', 1) AS main_category
FROM
products

----------------------------------------------------
-- 3. Pricing Adjustments
----------------------------------------------------
SELECT
product_id,
price,
FLOOR(0.95*price) AS price_5_perc_discount,
FLOOR(price - 100) AS price_100_rub_discount
FROM 
order_items
ORDER BY product_id DESC, price DESC

/*
Key Takeaway:
Scalar functions are used to transform data at the row level.
They are essential for cleaning, formatting, and preparing data for analysis.
*/