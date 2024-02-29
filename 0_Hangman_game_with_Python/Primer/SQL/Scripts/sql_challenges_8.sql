/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 8

*******************************************************************************
*******************************************************************************

In the exercises below you might need to use the any of the clauses learend so 
far.

*/

USE publications;


/* 1. Select the top 5 orders with most quantity sold between 1993-03-11 and
    1994-09-13 from the table sales */

SELECT 
    ord_num, ord_date, qty
FROM
    sales
where ord_date between "1993-03-11" and "1994-09-13"
order by qty desc
limit 5
;

/* 2. How many authors have an "i" in their first name, are from Utah,
   Maryland, or Kansas? */

select * from authors
where au_fname like('%i%') and state in ('UT','MD' , 'KS')
;


/* 3. In California, how many authors are there in cities that contain an "o"
   in the name?
   - Show only results for cities with more than 1 author.
   - Sort the cities ascendingly by author count.
*/

select 
