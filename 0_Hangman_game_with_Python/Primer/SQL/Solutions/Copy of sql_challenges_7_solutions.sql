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
SELECT 
    state, COUNT(*)
FROM
    authors
GROUP BY state;

/* 2. Find the total amount of authors by each state and order them in 
    descending order */

SELECT 
    state, 
    COUNT(*) AS state_authors
FROM
    authors
GROUP BY state
ORDER BY state_authors DESC;

-- 3. What's the price of the most expensive title from each publisher?
SELECT 
    pub_id, MAX(price)
FROM
    titles
GROUP BY pub_id;

-- 4. Find out the top 3 stores with most book sales
SELECT 
    stor_id, SUM(qty)
FROM
    sales
GROUP BY stor_id
ORDER BY SUM(qty) DESC
LIMIT 3;

/* 5. Find the average job level for each job_id from the employees table.
   Order the jobs in ascending order by its average job level. */

SELECT 
    job_id, AVG(job_lvl)
FROM
    employee
GROUP BY job_id
ORDER BY AVG(job_lvl);

/* 6. For each type (business, psychology…), find out how many books each
    publisher has. */

SELECT 
    pub_id, type, COUNT(*)
FROM
    titles
GROUP BY pub_id , type;

/* 7. Add the average price of each publisher - book type combination from your
   previous query */
SELECT 
    pub_id, type, COUNT(*), AVG(price)
FROM
    titles
GROUP BY pub_id , type;
/*******************************************************************************
HAVING

https://www.w3schools.com/sql/sql_having.asp
*******************************************************************************/

/* 8. From your previous query, keep only the combinations of publisher - book
   type with an average price higher than 12 */
   SELECT 
    pub_id, type, COUNT(*)
FROM
    titles
GROUP BY pub_id , type
HAVING AVG(price) > 12;

/* 9. Order the results of your previous query by these two criteria:
      1. Count of books, descendingly
      2. Average price, descendingly */

SELECT 
    pub_id, type, COUNT(*), AVG(price)
FROM
    titles
GROUP BY pub_id , type
HAVING AVG(price) > 12
ORDER BY 
	COUNT(*) DESC,
	AVG(price) DESC;

/* 10. Some authors have a contract, while others don't - it's indicated in the
     "contract" column of the authors table.
     
     Select all the states and cities where there are 2 or more contracts 
     overall */
     
SELECT 
    state, city, SUM(contract)
FROM
    authors
GROUP BY state , city
HAVING SUM(contract) > 1
ORDER BY city; -- ORDER BY will order the results alphabetically too


/* 
The main difference between WHERE and HAVING is that:
    - the WHERE clause is used to specify a condition for filtering most records
    - the HAVING clause is used to specify a condition for filtering values from 
      an aggregate (such as MAX(), AVG(), COUNT() etc...)
 */


/*
BONUS MATERIAL!!


You may have noticed in Exercise 10 that we get the same result if we group by 
city alone, we get the same result as grouping by city and state together!
*/ 
SELECT 
    city, SUM(contract)
FROM
    authors
GROUP BY city
HAVING SUM(contract) > 1
ORDER BY city;
/*
Why? Each city has a unique name in the database. Let's add an author in a
city with a name we've seen before, but in a different state.
*/
INSERT INTO authors (au_id, au_lname, au_fname, phone, city, state, contract)
VALUES ('478-25-7923', 'Acres', 'Melody', '217 332-5438', 'San Jose', 'IL', 1);

/* Now we should see a difference between grouping just by city vs. 
grouping by city and state together */
SELECT 
    city, SUM(contract)
FROM
    authors
GROUP BY city
HAVING SUM(contract) > 1
ORDER BY city;
SELECT 
    state, city, SUM(contract)
FROM
    authors
GROUP BY state , city
HAVING SUM(contract) > 1
ORDER BY city;
/* 
The second query, by city and state, now does not include San Jose, since
we have two authors in San Jose, but one in California and one in Illinois! 

Now let's remove this author to avoid inconsistencies later.
*/
DELETE FROM authors
WHERE au_id = '478-25-7923';