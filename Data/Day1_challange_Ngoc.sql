use publications;
select * from authors;

select au_fname, au_lname
from authors;

select concat(au_fname, au_lname) as full_name
from authors;

select distinct au_fname
from authors;

select au_fname, au_lname
from authors
where au_lname =  "Ringer" and au_fname="Anne";

# Trick on and or statement

select au_fname, au_lname, city
from authors
where (city = "Oakland" or city = "Berkeley") and au_fname = "Dean";  

select au_fname, au_lname, city
from authors
where (city = "Oakland" or city = "Berkeley") and au_lname != "Straight";  

select *
from titles
order by pubdate desc;

select * 
from titles
order by ytd_sales desc
limit 5;

select min(qty), max(qty)
from sales;

select count(*), avg(qty), sum(qty)
from sales;

select title
from titles
where title like "%cooking";

# No record 
select title
from titles
where title like "% ____ing";

select * 
from authors
where city not in ("Salt Lake City", "Ann Arbor", "Oakland");

select *
from sales
where qty between 25 and 45;

select * 
from sales
where ord_date between '1993-03-11' and '1994-09-13';



-- MULTIPLE FUNCTIONS
# Select the top 5 orders with more quantity sold between 1993-03-11 and 1994-09-13 from the table sales
select *
from sales
where ord_date between '1993-03-11' and '1994-09-13'
order by qty desc
limit 5;

# Retrun the count of all the authors that have a "i" on the first name, in the state of UT, MD and KS
select count(*)
from authors
where au_fname like "%i%" and state in ("UT", "MD", "KS");


# Select the total sum of ytd_sales of the top 5 titles from titles with a lower royalty, between a price of 15 to 25
select sum(ytd_sales)
from titles
where royalty between 15 and 25
order by royalty;
-- GROUP BY
# Select the total count of authors by each state 
# https://www.w3schools.com/sql/sql_groupby.asp

select count(*)
from authors
group by state;

# Select the total count of authors by each state and order them descinding
select count(*)
from authors
group by state
order by 1 desc;

# Select the maximum price for each publisher id in the table titles.
select pub_id, max(price)
from titles
group by pub_id;

# Find out top 3 stores with more sales
select *
from sales
order by qty desc
limit 3;
-- HAVING 
# Select for each publisher the total number of titles for each book type with an average price higher than 12
# https://www.w3schools.com/sql/sql_having.asp
select pub_id, type, count(*)
from titles
group by pub_id, type
having avg(price)>12;

# Select for each publisher the total number of titles for each book type with an average price higher than 12 and order them by the average price
select pub_id, type, count(*), avg(price)
from titles
group by pub_id, type
having avg(price)>12
order by avg(price)>12;


# Select all the states and cities that contains more than 1 contract
select *
from authors;


/* The main difference between WHERE and HAVING is that:
 the WHERE clause is used to specify a condition for filtering records before any groupings are made,
 while the HAVING clause is used to specify a condition for filtering values from a group this is why HAVING always comes after the GROUP BY and before ORDER BY */

-- CASE
# Create a new column called "sales_category" with case conditions to categorise qty in sales table: 
#  * qty >= 50 high sales
#  * 20 <= qty < 50 medium sales
#  * qty < 20 low sales
# https://www.w3schools.com/sql/sql_case.asp
select case 
		when qty>=50 then "high sales"
        when qty<50 and qty>=20 then "medium sales"
        else "low sales"
        end as sales_category
from sales;


# Find out the total amount of books sold (qty) by each sale category created with CASE
# HINT: you can use GROUP BY with the new variable you created
select case 
		when qty>=50 then "high sales"
        when qty<50 and qty>=20 then "medium sales"
        else "low sales"
        end as sales_category, count(*)
from sales
group by 1;

## challenge
/*  Find out the total amount of books sold (qty) by each sale category created with CASE, having the SUM(qty) greater than 100 and order them DESC */
select case 
		when qty>=50 then "high sales"
        when qty<50 and qty>=20 then "medium sales"
        else "low sales"
        end as sales_category, count(*)
from sales
group by 1
having sum(qty)>100
order by sum(qty) desc;

-- LAST CHALLENGES
# In California, how many authors are there in cities containing an "o" in the name?
select count(*)
from authors
where city like '%o%';

# Show only results for cities with more than 1 author.
select *
from authors
group by city
having count(*)>1;

select *
from authors
group by city
having count(*)>1
order by count(*);


# Find out the average price for each publisher and price category for the following book types: 
# * business, traditional cook and psychology
# * price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high
SELECT  avg(price), pub_id
from titles
group by case
			when price <= 5 then "supper low"
            when price >5 and price <=10 then 'low'
			when price >10 and price <=15 then 'medium'
            else 'high'
		end, pub_id;

