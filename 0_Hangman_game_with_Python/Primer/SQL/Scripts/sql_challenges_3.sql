/*
*******************************************************************************
*******************************************************************************

SQL CHALLENGES 3

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses/operators:
	- ORDER BY
	- LIMIT
    - MIN(), MAX()
    - COUNT(), AVG(), SUM()

In SQL we can have many databases, they will show up in the schemas list
We must first define which database we will be working with.
*/

USE publications;

/******************************************************************************
ORDER BY
******************************************************************************/
SELECT 
    title, ytd_sales
FROM
    titles
ORDER BY ytd_sales;

-- 2. Repeat the same query, but this time sort the titles in descending order

SELECT 
    title, ytd_sales
FROM
    titles
ORDER BY ytd_sales DESC;

/******************************************************************************
LIMIT

https://www.w3schools.com/mysql/mysql_limit.asp
******************************************************************************/

SELECT 
    title, ytd_sales
FROM
    titles
ORDER BY ytd_sales DESC
LIMIT 5;

/******************************************************************************
MIN and MAX

https://www.w3schools.com/sql/sql_min_max.asp
******************************************************************************/

SELECT 
    MAX(qty) AS 'maximum qty ever sold'
FROM
    sales;

-- 5. What's the price of the cheapest book?

SELECT 
    MIN(price)
FROM
    titles;

/******************************************************************************
COUNT, AVG, and SUM

https://www.w3schools.com/sql/sql_count_avg_sum.asp

******************************************************************************/

SELECT 
    COUNT(au_id)
FROM
    authors;

 -- 7. What's the total amount of year-to-date sales?

SELECT 
    SUM(ytd_sales)
FROM
    titles;

 -- 8. What's the average price of books?

SELECT 
    AVG(price)
FROM
    titles;

/* 9. In a single query, select the count, average and sum of quantity in the
table sales */

SELECT 
    COUNT(qty), AVG(qty), SUM(qty)
FROM
    sales;