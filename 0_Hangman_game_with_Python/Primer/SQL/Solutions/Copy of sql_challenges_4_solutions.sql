/*
*******************************************************************************
*******************************************************************************

SQL CHALLENGES 4

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses/operators:
	- SELECT FROM
    - AS
	- DISTINCT
	- WHERE
	- AND / OR / NOT
	- ORDER BY
	- LIMIT
    - MIN(), MAX()
    - COUNT(), AVG(), SUM()
    
In SQL we can have many databases, they will show up in the schemas list
We must first define which database we will be working with.
*/

-- 1. From hoy many different states are our authors?
SELECT
	COUNT(DISTINCT state) AS total_states
FROM
	authors;

-- 2. How many publishers are based in the USA?
SELECT 
    COUNT(pub_id) AS USA_publishers
FROM
    publishers
WHERE
	country = "USA";

-- 3. What's the average quantity of titles sold per sale by store 7131?
SELECT 
    AVG(qty)
FROM
    sales
WHERE
    stor_id = 7131;

    
-- 4. When was the employee with the highest level hired?
SELECT 
    hire_date
FROM
    employee
ORDER BY job_lvl DESC
LIMIT 1;


-- 5. What's the average price of psychology books?
SELECT
	AVG(price)
FROM
	titles
WHERE
	type = "psychology";
    
    
-- 6. Which category of books has had more year-to-date sales, "business" or 
-- "popular_comp"? You can write two queries to answer this question.

-- business
SELECT
	SUM(ytd_sales)
FROM
	titles
WHERE
	type = "business";

-- popular_comp
SELECT
	SUM(ytd_sales)
FROM
	titles
WHERE
	type = "popular_comp";



-- 7. What's the title and the price of the most expensive book?
SELECT
	title,
    price
FROM
	titles
ORDER BY
	price DESC
LIMIT 1;

-- 8. What's the price of the most expensive psychology book?
SELECT
    price
FROM
	titles
WHERE
	type = "psychology"
ORDER BY
	price DESC
LIMIT 1;

-- alternative:
SELECT
    MAX(price)
FROM
	titles
WHERE
	type = "psychology";


-- 9. How many authors live in either San Jose or Salt Lake City
SELECT
	COUNT(*)
FROM
	authors
WHERE
	city = "San Jose" OR city = "Salt Lake City";