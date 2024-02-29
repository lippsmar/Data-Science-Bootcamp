/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 9

*******************************************************************************
*******************************************************************************

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + r
* MacOS: Cmd + r

In the exercises below you will need to use the clauses you used in the
previous SQL Challenges, plus the following clauses:
    - AS
	- LEFT JOIN
    - RIGHT JOIN
    - INNER JOIN
    - CASE
*/

USE publications; 
 
/*******************************************************************************
ALIAS (AS) for tables
*******************************************************************************/

/* 1. 
Assign an alias to the table sales. 
Select the column ord_num using the syntax "table_alias.column"
*/

SELECT 
    s.ord_num
FROM
    sales AS s;

/*******************************************************************************
JOINS

We will only use LEFT, RIGHT, and INNER joins.
You do not need to worry about the other types for now

- https://www.w3schools.com/sql/sql_join.asp
- https://www.w3schools.com/sql/sql_join_left.asp
- https://www.w3schools.com/sql/sql_join_right.asp
- https://www.w3schools.com/sql/sql_join_inner.asp
*******************************************************************************/

/*
3. Select the title and publisher name of all books 
*/

SELECT 
    t.title,
    p.pub_name
FROM
    titles t
        LEFT JOIN
    publishers p ON t.pub_id = p.pub_id;
    
/*
4. Select the order number, quantity and book title for all sales.
*/
SELECT 
    s.ord_num, s.qty, t.title
FROM
    sales s
        LEFT JOIN
    titles t ON s.title_id = t.title_id;


/*
5. Select the full name of all employees and the name of the publisher they 
   work for
*/

SELECT 
    e.fname, e.lname, p.pub_name
FROM
    employee e
        LEFT JOIN
    publishers p ON e.pub_id = p.pub_id;

/*
6. Select the full name and job description of all employees.
*/

SELECT 
    e.fname, e.lname, j.job_desc
FROM
    employee e
        LEFT JOIN
    jobs j ON e.job_id = j.job_id;


/*
7. Select the full name, job description and publisher name of all employees
   Hint: you will have to perform 2 joins in a single query to merge 3 tables 
         together.
*/

SELECT 
    e.fname, e.lname, j.job_desc, p.pub_name
FROM
    employee e
        LEFT JOIN
    jobs j ON e.job_id = j.job_id
		LEFT JOIN
    publishers p ON e.pub_id = p.pub_id;

/*
8. Select the full name, job description and publisher name of employees
   that work for Binnet & Hardley.
   Hint: you can add a WHERE clause after the joins

*/
SELECT 
    e.fname, e.lname, j.job_desc, p.pub_name
FROM
    employee e
        LEFT JOIN
    jobs j ON e.job_id = j.job_id
		LEFT JOIN
    publishers p ON e.pub_id = p.pub_id
WHERE
	pub_name = "Binnet & Hardley";

/*
9. Select the name and PR Info (from the pub_info table) from all publishers
   based in Berkeley, California.
*/

SELECT 
    p.pub_name, pi.pr_info
FROM
    publishers p
        LEFT JOIN
    pub_info pi ON p.pub_id = pi.pub_id
WHERE
    p.city = 'Berkeley' AND state = 'CA';

/*
10. Selet all columns from the discounts table.
   Observe the columns it has and now some of them are filled with NULL values.
*/
SELECT * FROM discounts;

/*
11. Select all store names, their store id and the discounts they offer.
   - When selecting the store id, select it two times: from the stores table
   and from the discounts table.
   - ALL stores should be displayed, even if they don't offer any discount 
     (i.e. have a NULL value on the discount column).
*/

SELECT 
    s.stor_name,
    s.stor_id,
    d.stor_id,
    d.discount
FROM
    stores s
        LEFT JOIN
    discounts d ON d.stor_id = s.stor_id;

/*
12. Select all store names and the discounts they offer.
   - This time, we don't want do display stores that don't offer any discount.
   Hint: change the join type!
*/

SELECT 
    s.stor_name,
    d.discount
FROM
    stores s
        INNER JOIN
    discounts d ON d.stor_id = s.stor_id;

/* 
13. Using LEFT JOIN: in which cities has "Is Anger the Enemy?" been sold?
*/

SELECT DISTINCT
    (st.city)
FROM
    titles t
        LEFT JOIN
    sales s ON t.title_id = s.title_id
        LEFT JOIN
    stores st ON s.stor_id = st.stor_id
WHERE
    t.title = 'Is Anger the Enemy?';


/*
14. Select all the book titles that have a link to the employee Howard Snyder 
    (he works for the publisher that has published those books).
   
*/
SELECT 
    t.title, e.fname, e.lname
FROM
    employee e
        INNER JOIN
    titles t ON e.pub_id = t.pub_id
WHERE
    e.fname = 'Howard'
        AND e.lname = 'Snyder';


/* 
15. Using the JOIN of your choice: Select the book title with higher number of 
   sales (qty)
*/

SELECT 
    s.title_id, 
    t.title, 
    SUM(s.qty) AS total_sales
FROM
    sales AS s
        LEFT JOIN
    titles AS t ON s.title_id = t.title_id
GROUP BY s.title_id , t.title
ORDER BY total_sales DESC
LIMIT 1;

/*
16. Select all book titles and the full name of their author(s).
   - If a book has multiple authors, all authors must be displayed (in multiple
     rows).
   - Book with no authors and authors with no books should not be displayed.
*/
SELECT 
	t.title,
    a.au_fname,
    a.au_lname
FROM
	titles t
INNER JOIN
	titleauthor ta ON t.title_id = ta.title_id
INNER JOIN
	authors a ON ta.au_id = a.au_id;

/*
17. Select the full name of authors of Psychology books

   Bonus hint: if you want to prevent duplicates but allow authors with shared
   last names to be displayed, you can concatenate the first and last names
   with CONCAT(), and use the DISTINCT clause on the concatenated names.
*/
SELECT
	DISTINCT CONCAT(a.au_fname, " ", a.au_lname) AS full_name
FROM
	authors a
INNER JOIN
	titleauthor ta ON a.au_id = ta.au_id
INNER JOIN
	titles t ON ta.title_id = t.title_id
WHERE
	t.type = "Psychology";

/*
18. Explore the raw data and try to grasp the meaning of each column. 
   The notes below will help:
   - "Royalty" means the percentage of the sale price paid to the author(s).
   - Sometimes, the royalty may be smaller for the first few sales (which have
     to cover the publishing costs to the publisher) but higher for the sales 
     above a certain threshold.
   - In the "roysched" table each title_id can appear multiple times, with
     different royalty values for each range of sales.
   - Select all rows for particular title_id, for example "BU1111", and explore
	 the data.
*/

SELECT * FROM roysched WHERE title_id = "BU1111";

/*
19. Select all the book titles and the maximum royalty they can reach.
    Display only titles that are present in the roysched table.

*/
SELECT 
    t.title,
    MAX(r.royalty) max_royalty
FROM
    titles t
        INNER JOIN
    roysched r ON t.title_id = r.title_id
GROUP BY
	t.title
ORDER BY
	max_royalty DESC;



/**************************
CASE
**************************/
-- https://www.w3schools.com/sql/sql_case.asp

/* 
20. Select everything from the sales table and create a new column called 
    "sales_category" with case conditions to categorise qty:
   
		qty >= 50 high sales
		20 <= qty < 50 medium sales
		qty < 20 low sales
*/

SELECT 
    *,
    CASE
        WHEN qty >= 50 THEN 'high sales'
        WHEN qty < 20 THEN 'low sales'
        ELSE 'medium sales'
    END AS sales_category
FROM
    sales;

/* 
21. Adding to your answer from the previous question. Find out the total amount
   of books sold (qty) in each sales category i.e. How many books had high 
   sales, how many had medium sales, and how many had low sales
*/

SELECT 
    CASE
        WHEN qty >= 50 THEN 'high sales'
        WHEN qty < 20 THEN 'low sales'
        ELSE 'medium sales'
    END AS sales_category,
    SUM(qty)
FROM
    sales
GROUP BY sales_category;

/* 
22. Adding to your answer from question 8. Output only those sales categories 
   that have a SUM(qty) greater than 100, and order them in descending order
*/

SELECT 
    CASE
        WHEN qty >= 50 THEN 'high sales'
        WHEN qty < 20 THEN 'low sales'
        ELSE 'medium sales'
    END AS sales_category,
    SUM(qty)
FROM
    sales
GROUP BY sales_category
HAVING SUM(qty) > 100
ORDER BY SUM(qty) DESC;

/* 
23. Find out the average book price, per publisher, for the following book 
    types and price categories:
		book types: business, traditional cook and psychology
		price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high
        
    - When displaying the average prices, use ROUND() to hide decimals.
*/

SELECT 
    pub_id,
    CASE
        WHEN price <= 5 THEN 'super low'
        WHEN price <= 10 THEN 'low'
        WHEN price <= 15 THEN 'medium'
        ELSE 'high'
    END AS price_category,
    ROUND(AVG(price)) AS 'avg_price'
FROM
    titles
WHERE
    type IN ('business' , 'trad_cook', 'psychology')
GROUP BY pub_id , price_category;