/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 7

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses:
    - GROUP BY
    - HAVING
------------------------------------------------------------------------------------------------

*/

USE publications;

/*******************************************************************************
GROUP BY

https://www.w3schools.com/sql/sql_groupby.asp
*******************************************************************************/

-- 1. Find the total amount of authors for each state

select count(au_id), state from authors group by state;


/* 2. Find the total amount of authors by each state and order them in 
    descending order */

select count(au_id) as 'total_authors', state from authors group by state order by total_authors desc;

-- 3. What's the price of the most expensive title from each publisher?

select max(price), pub_id from titles group by pub_id;

select max(price), pub_id, max(title) from titles group by pub_id;

select max(price), pub_id, title from titles group by pub_id;

-- 4. Find out the top 3 stores with the most sales

select sum(qty), stor_id from sales group by stor_id order by sum(qty) desc limit 3;

/* 5. Find the average job level for each job_id from the employees table.
    Order the jobs in ascending order by its average job level. */

select avg(job_lvl), job_id from employee group by job_id order by avg(job_lvl) asc;

/* 6. For each type (business, psychology…), find out how many books each
    publisher has. */

select pub_id, count(pub_id), type from titles group by type, pub_id;


/* 7. Add the average price of each publisher - book type combination from your
   previous query */


/*******************************************************************************
HAVING

https://www.w3schools.com/sql/sql_having.asp
*******************************************************************************/

/* 8. From your previous query, keep only the combinations of publisher - book
   type with an average price higher than 12 */



/* 9. Order the results of your previous query by these two criteria:
      1. Count of books, descendingly
      2. Average price, descendingly */



/* 10. Some authors have a contract, while others don't - it's indicated in the
     "contract" column of the authors table.
     
     Select all the states and cities where there are 2 or more contracts 
     overall */



/* 
The main difference between WHERE and HAVING is that:
    - the WHERE clause is used to specify a condition for filtering most records
    - the HAVING clause is used to specify a condition for filtering values from 
      an aggregate (such as MAX(), AVG(), COUNT() etc...)
 */

