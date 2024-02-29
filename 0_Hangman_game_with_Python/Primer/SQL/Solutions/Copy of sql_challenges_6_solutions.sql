/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 6

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses:
    - IN (NOT IN)
    - BETWEEN (AND)
    
------------------------------------------------------------------------------------------------

/* In SQL we can have many databases, they will show up in the schemas list
   We must first define which database we will be working with.
*/
USE publications;


/*******************************************************************************
IN

https://www.w3schools.com/sql/sql_in.asp
*******************************************************************************/

/* 1. Select the name and state of all stores located in either California (CA)
   or Oregon (OR) */
SELECT 
    *
FROM
    stores
WHERE
    state IN ('CA' , 'OR');


/* 2. Using "IN", select all titles of type "psychology", "mod_cook" and 
"trad_cook" */
SELECT 
    *
FROM
    titles
WHERE
    type IN ('psychology' , 'mod_cook', 'trad_cook');


/* 3. Select all the authors from the author table that do not come from the 
cities Salt Lake City, Ann Arbor, and Oakland. */
SELECT 
    *
FROM
    authors
WHERE
    city NOT IN ('Salt Lake City' , 'Ann Arbor', 'Oakland');


/* The differences between IN, LIKE, and =

IN :  takes many values to look for, such as a list of values, and does not 
      work with the wildcards (%, _).
      
= :   takes only one value to look for and does not work with wildcards (%, _).

LIKE: takes only one value to look for and works with wildcards (%, _). 
      It is also case insentsitive. */

/*******************************************************************************
BETWEEN

https://www.w3schools.com/sql/sql_between.asp
*******************************************************************************/

/* 4. Select all the order numbers with a quantity sold between 25 and 45 from 
   the table sales */
SELECT 
    ord_num, qty
FROM
    sales
WHERE
    qty BETWEEN 25 AND 45;


-- 5. Select all the orders between 1993-03-11 and 1994-09-13
SELECT 
    *
FROM
    sales
WHERE
    ord_date BETWEEN '1993-03-11' AND '1994-09-13';


/* 6. Select all job descriptions with a maximum level ("max_lvl") between 150 
     and 200. */
SELECT 
    job_desc, max_lvl
FROM
    jobs
WHERE
    max_lvl BETWEEN 150 AND 200;


/*
BONUS MATERIAL!!


When searching between two dates (Exercise 6), the time counts as well! Let's 
change the time on one of our sales.
*/
UPDATE sales
SET ord_date = '1994-09-13 12:00:00'
WHERE ord_num = 'QA7442.3' AND stor_id = '7066';
/* And see how this affects our query: 
*/
SELECT 
    *
FROM
    sales
WHERE
    ord_date BETWEEN '1993-03-11' AND '1994-09-13'
ORDER BY
	ord_date;
/* At the bottom of the table, we see only one order from 1994-09-13!
Let's modify the query:
*/
SELECT 
    *
FROM
    sales
WHERE
    ord_date BETWEEN '1993-03-11' AND '1994-09-13 23:59:59'
ORDER BY
	ord_date;
/* Now we see two orders on 1994-09-13! 
When times are a part of our sales information, we should include 
the time in our BETWEEN AND to capture the full length of the day. 

Now we'll undo our previous change.*/
UPDATE sales
SET ord_date = '1994-09-13 00:00:00'
WHERE ord_num = 'QA7442.3' AND stor_id = '7066';