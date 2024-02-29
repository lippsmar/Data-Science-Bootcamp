/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 9

*******************************************************************************
*******************************************************************************

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + R
* MacOS: Cmd + R

In the exercises below you will need to use the clauses you used in the
previous SQL Challenges, plus the following clauses:
    - AS
	- LEFT JOIN
    - RIGHT JOIN
    - INNER JOIN
*/

USE publications; 
 
/*******************************************************************************
ALIAS (AS) for tables
*******************************************************************************/

/* 1. Select the table sales, assigning the alias "s" to it. 
   Select the column ord_num using the syntax "table_alias.column" */

select s.ord_num from sales as s;


/*******************************************************************************
JOINS

We will only use LEFT, RIGHT, and INNER joins.
You do not need to worry about the other types for now

- https://www.w3schools.com/sql/sql_join.asp
- https://www.w3schools.com/sql/sql_join_left.asp
- https://www.w3schools.com/sql/sql_join_right.asp
- https://www.w3schools.com/sql/sql_join_inner.asp
*******************************************************************************/

-- 2. Select the title and publisher name of all books

select t.title, p.pub_name from titles as t left join publishers as p on t.pub_id=p.pub_id;
    
-- 4. Select the order number, quantity and book title for all sales.

select s.ord_num, s.qty, t.title from sales as s left join titles as t on s.title_id=t.title_id;

/* 5. Select the full name of all employees and the name of the publisher they 
   work for */

select e.fname, e.lname, p.pub_name from employee as e left join publishers as p on e.pub_id=p.pub_id;

-- 6. Select the full name and job description of all employees.



/* 7. Select the full name, job description and publisher name of all employees
   Hint: you will have to perform 2 joins in a single query to merge 3 tables 
         together. */

select e.fname, e.lname, j.job_desc, p.pub_name from employee as e left join jobs as j on e.job_id=j.job_id left join publishers as p on e.pub_id=p.pub_id;


/* 8. Select the full name, job description and publisher name of employees
   that work for Binnet & Hardley.
   Hint: you can add a WHERE clause after the joins */

SELECT 
    e.fname, e.lname, j.job_desc, p.pub_name
FROM
    employee AS e
        LEFT JOIN
    jobs AS j ON e.job_id = j.job_id
        LEFT JOIN
    publishers AS p ON e.pub_id = p.pub_id
WHERE
    pub_name like 'Binnet % Hardley';

/* 9. Select the name and PR Info (from the pub_info table) from all publishers
   based in Berkeley, California. */



/* 10. Selet all columns from the discounts table.
   Observe the columns it has and now some of them are filled with NULL values.
*/
select * from discounts;


/* 11. Select all store names, their store id and the discounts they offer.

	   - When selecting the store id, select it two times: from the stores table
         and from the discounts table.
         
       - ALL stores should be displayed, even if they don't offer any discount 
         (i.e. have a NULL value on the discount column). */



/* 12. Select all store names and the discounts they offer.

       - This time, we don't want do display stores that don't offer any 
         discount.
         
   Hint: change the join type! */


