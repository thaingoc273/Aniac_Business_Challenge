/* In relation to the products:

What categories of tech products does Magist have?
How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
What’s the average price of the products being sold?
Are expensive tech products popular? *
* TIP: Look at the function CASE WHEN to accomplish this task.
*/
USE magist;

# a. What categories of tech products does Magist have?
# See the translation to get high tech products
SELECT  *
FROM product_category_name_translation;

# The total number of catergories is 74

# The high tech categories: audio, cds_dvds_musicals, dvds_blu_ray, computers, watches_gifts, pc_gamer, telephony


# b. How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
SELECT count(*) as Number_sales
FROM order_items
WHERE product_id IN (
	SELECT product_id
    FROM product_category_name_translation
    JOIN products
    USING (product_category_name)
    WHERE product_category_name_english IN ('electronics', 'computers_accessories', 'computers', 'signaling_and_security', 'tablets_printing_image'));
    
# The number of sales for high tech products is 11190

SELECT count(*)
FROM order_items;

# Total sales is 112650. The percent of high tech sales is about 10%

	
# c. What’s the average price of the products being sold?
SELECT AVG(price) as Average_price_tech
FROM order_items
WHERE product_id IN (
	SELECT product_id
    FROM product_category_name_translation
    LEFT JOIN products
    USING (product_category_name)
    WHERE product_category_name_english IN ('electronics', 'computers_accessories', 'computers', 'signaling_and_security', 'tablets_printing_image'));

# Average price is 161.80

# d. Are expensive tech products popular?

SELECT MIN(price) AS Min_price, MAX(price) AS Max_price
FROM order_items
WHERE product_id IN (
	SELECT product_id
    FROM product_category_name_translation
    LEFT JOIN products
    USING (product_category_name)
    WHERE product_category_name_english IN ('electronics', 'computers_accessories', 'computers', 'signaling_and_security', 'tablets_printing_image'));
    
# Min 5 and Max 6729
SELECT (CASE
		WHEN price>=200 THEN 'HIGH PRICE'
        WHEN price<20 THEN 'LOW PRICE'
        ELSE 'MIDLE PRICE'
	END) price_classification, count(*) as No_sales
FROM order_items
GROUP BY
	price_classification;
	 
SELECT (CASE
		WHEN price>=200 THEN 'HIGH PRICE'
        WHEN price<20 THEN 'LOW PRICE'
        ELSE 'MIDLE PRICE'
	END) price_classification, count(*) as No_sales
FROM order_items
WHERE product_id IN (
	SELECT product_id
    FROM product_category_name_translation
    LEFT JOIN products
    USING (product_category_name)
    WHERE product_category_name_english IN ('audio', 'cds_dvds_musicals', 'dvds_blu_ray', 'computers', 'watches_gifts', 'pc_gamer', 'telephony'))
GROUP BY
	price_classification;

/*
In relation to the sellers:

How many sellers are there?
What’s the average monthly revenue of Magist’s sellers?
What’s the average revenue of sellers that sell tech products?

*/

# How many sellers are there? 3095

SELECT COUNT(DISTINCT seller_id) AS No_of_Sellers
FROM sellers;

# What’s the average monthly revenue of Magist’s sellers?
SELECT 
	MONTH(shipping_limit_date) as Month, YEAR(shipping_limit_date) as Year, SUM(price) AS REVENUE
FROM 
	order_items
GROUP BY 
	MONTH(shipping_limit_date), YEAR(shipping_limit_date)
ORDER BY
	YEAR(shipping_limit_date) , MONTH(shipping_limit_date);

# What’s the average revenue of sellers that sell tech products?

SELECT 
	MONTH(shipping_limit_date) as Month, YEAR(shipping_limit_date) as Year, SUM(price) AS REVENUE
FROM 
	order_items
WHERE
	product_id IN (
	SELECT product_id
    FROM product_category_name_translation
    LEFT JOIN products
    USING (product_category_name)
    WHERE product_category_name_english IN ('audio', 'cds_dvds_musicals', 'dvds_blu_ray', 'computers', 'watches_gifts', 'pc_gamer', 'telephony'))
GROUP BY 
	MONTH(shipping_limit_date), YEAR(shipping_limit_date)
ORDER BY
	YEAR(shipping_limit_date) , MONTH(shipping_limit_date);    
    
/*
In relation to the delivery time:

What’s the average time between the order being placed and the product being delivered?
How many orders are delivered on time vs orders delivered with a delay?
Is there any pattern for delayed orders, e.g. big products being delayed more often?

*/

# What’s the average time between the order being placed and the product being delivered?
# order_status = 'delivered'
# 12,09 days

SELECT 
	AVG(timestampdiff(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS AVG_TIME_DELIVERY_DAY
FROM 
	orders
WHERE 
	order_status = 'delivered';

# How many orders are delivered on time vs orders delivered with a delay?
# On Time 88644
SELECT 
	COUNT(*) AS No_ON_TIME
FROM 
	orders
WHERE
	order_status = 'delivered' 
    and order_delivered_customer_date <= order_estimated_delivery_date;

# Delay 7826     
SELECT 
	COUNT(*) AS No_DELAY
FROM 
	orders
WHERE
	order_status = 'delivered' AND
    order_delivered_customer_date > order_estimated_delivery_date;
    
SELECT 
	*
FROM 
	orders
WHERE
	# order_status = 'delivered' AND
    order_delivered_customer_date > order_estimated_delivery_date;    
    
# Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT *
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE
	order_status = 'delivered' 
    and order_delivered_customer_date > order_estimated_delivery_date
ORDER BY product_weight_g desc;

# Checking SEPT 2016 average delivery time
SELECT AVG(timestampdiff(DAY, order_purchase_timestamp, order_delivered_customer_date))
FROM orders
WHERE month(order_purchase_timestamp) = 9 and year(order_purchase_timestamp)=2016 and order_status='delivered';

SELECT *
FROM orders
WHERE month(order_purchase_timestamp) = 9 and year(order_purchase_timestamp)=2016;

SELECT count(*)
FROM sellers;

SELECT count(distinct customer_id)
FROM customers;

SELECT count(distinct order_id)
FROM orders; 

SELECT count(product_id)
FROM products;
