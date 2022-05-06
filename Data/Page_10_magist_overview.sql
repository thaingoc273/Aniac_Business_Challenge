# 1. How many orders are there in the dataset? 
# The orders table contains a row for each order, so it should be easy to find out!
USE magist;
SELECT *
FROM orders;

SELECT count(*)
FROM orders; 

# Answer: 99441


# 2. Are orders actually delivered?  
SELECT distinct order_status
FROM orders;

/* All the status of orders
delivered
unavailable
shipped
canceled
invoiced
processing
approved
created
*/

SELECT order_status, count(*)
FROM orders
GROUP BY order_status;

# 3. Is Magist having user growth? 
SELECT year(order_purchase_timestamp) as year_purchase, month(order_purchase_timestamp) as month_purchase, count(*) as number_of_purchses
FROM orders
GROUP BY year_purchase, month_purchase
ORDER BY year_purchase, month_purchase;

# The number of purschases grows over year. 
# 2016 with 3 months (10,11,12) 329 orders
# 2017 full year with 45099 orders
# 2018 the first 10 month with 54013
SELECT year(order_purchase_timestamp) as year_purchase, count(*) as number_of_purchses
FROM orders
GROUP BY year_purchase
ORDER BY year_purchase;

# 4. How many products are there in the products table?

SELECT COUNT(DISTINCT product_id) as No_product
FROM products;

# Number of products: 32951
# No difference with or without distinct

# 5. Which are the categories with most products? 
SELECT product_category_name, COUNT(*)
FROM products
GROUP BY product_category_name
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT product_category_name, COUNT(DISTINCT product_category_name) as No_category
FROM products;

# The number of category is 74
# Category cama_mesa_banho has 3029 products

# 6. How many of those products were present in actual transactions?
SELECT DISTINCT order_item_id
FROM order_items;
# There are 21 classes of order_item_id

SELECT COUNT(DISTINCT product_id) AS No_product
FROM order_items;

# The number is 32951. That means all products were present in actual transactions

# 7. What’s the price for the most expensive and cheapest products? 

SELECT MAX(price) AS MAX_Price, MIN(price) AS MIN_Price
FROM order_items;

# MAX 6753

# Select order with max price

SELECT *
FROM order_items
WHERE price = (SELECT MAX(price) FROM order_items); # 1 Order

SELECT *
FROM order_items
WHERE price = (SELECT MIN(price) FROM order_items); # 3 Orders

# 8. What are the highest and lowest payment values?

SELECT MAX(payment_value) AS MAX_payment, MIN(payment_value) AS MIN_payment
FROM order_payments;

# MAX 1366.4 and MIN 0

# List all payments with value 0. Payment type are voucher and not_defined
SELECT *
FROM order_payments
WHERE payment_value = 0;


