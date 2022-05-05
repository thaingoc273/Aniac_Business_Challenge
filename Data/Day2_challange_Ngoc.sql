/*
SQL JOIN
------------------------------------------------------------------------------------------------
HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + r
* MacOS: Cmd + r
*/
USE publications; 

-- AS 
# Change the column name qty to Quantity into the sales table
# https://www.w3schools.com/sql/sql_alias.asp
SELECT *, qty as 'Quantity'
FROM sales;
# Assign a new name into the table sales, and call the column order number using the table alias
SELECT s.ord_num
FROM sales AS s;

-- JOINS: a few examples
# https://www.w3schools.com/sql/sql_join.asp
-- LEFT JOIN
SELECT * 
FROM stores s 
LEFT JOIN discounts d ON d.stor_id = s.stor_id;
-- RIGHT JOIN
SELECT * 
FROM stores s 
RIGHT JOIN discounts d ON d.stor_id = s.stor_id;

SELECT * 
FROM stores s 
RIGHT JOIN discounts d USING (stor_id);

SELECT *
FROM discounts;

SELECT *
FROM stores;
-- INNER JOIN
SELECT * 
FROM stores s 
INNER JOIN discounts d ON d.stor_id = s.stor_id;

-- CHALLENGES: 
# In which cities has "Is Anger the Enemy?" been sold?
# HINT: you can add WHERE function after the joins
SELECT *
FROM  sales as sa
RIGHT JOIN stores as st
ON sa.stor_id = st.stor_id
RIGHT JOIN titles as ti
ON ti.title_id = sa.title_id
where ti.title = "Is Anger the Enemy?";

-- Second solution

# Select all the books (and show their title) where the employee
# Howard Snyder had work.

SELECT *
FROM titles as ti
LEFT JOIN employee as em
ON ti.pub_id = em.pub_id;
#WHERE concat(em.fname, ' ', em.lname) ='Howard Snyder';

# Select all the authors that have work (directly or indirectly)
# with the employee Howard Snyder

SELECT *, au.au_id, au.au_fname, au.au_lname, au.address, au.city, au.phone, au.state, au.zip, ti.title_id
FROM authors as au
JOIN titleauthor as tiau 
ON au.au_id = tiau.au_id
JOIN titles as ti
ON ti.title_id = tiau.title_id
JOIN publishers as pu
ON pu.pub_id = ti.pub_id
JOIN employee as em
ON pu.pub_id = em.pub_id
WHERE concat(em.fname, ' ', em.lname) = "Howard Snyder";


# Select the book title with higher number of sales (qty)
SELECT ti.title, sum(sa.qty)
FROM titles as ti
LEFT JOIN sales as sa
ON ti.title_id = sa.title_id
GROUP BY ti.title_id
ORDER BY sum(sa.qty) desc
LIMIT 1;

# Is Anger the Enemy? 108

SELECT (SELECT title FROM titles as ti WHERE ti.title_id = sa.title_id), sum(qty)  
FROM sales as sa
GROUP BY sa.title_id
ORDER BY sum(qty) desc;

# Perform full outer join in MySQL with tables stores and discounts
SELECT *
FROM stores
LEFT JOIN discounts
USING (stor_id)
UNION
SELECT *
FROM stores
RIGHT JOIN discounts
USING (stor_id);
SELECT *
FROM discounts;
SELECT *
FROM stores;

SELECT s.*, d.*
FROM stores AS s
RIGHT JOIN discounts AS d
USING (stor_id);

SELECT s.*, d.*
FROM stores AS s
RIGHT JOIN discounts AS d
ON s.stor_id = d.stor_id;

SELECT s.*, d.*
FROM stores AS s
LEFT JOIN discounts AS d
USING (stor_id);

SELECT s.*, d.*
FROM stores AS s
LEFT JOIN discounts AS d
USING (stor_id)

UNION ALL


SELECT s.*, d.*
FROM stores AS s
RIGHT JOIN discounts AS d
USING (stor_id);
