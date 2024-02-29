/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 5

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses:
	- LIKE (%, _)

------------------------------------------------------------------------------------------------

/* In SQL we can have many databases, they will show up in the schemas list
   We must first define which database we will be working with.
*/
USE publications;

/*******************************************************************************
LIKE

https://www.w3schools.com/sql/sql_like.asp

Here we will also learn to use some wild card characters:
https://www.w3schools.com/sql/sql_wildcards.asp
(You can ignore 'Wildcard Characters in MS Access'
You need to look at the section 'Wildcard Characters in SQL Server')
*******************************************************************************/

/*
1. Select all books from the table title that contain the word "cooking"
   in its title
*/
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '%cooking%';

/* 
2. Select all titles that start with the word "The"
*/

SELECT 
	*
FROM 
	titles
WHERE
	title LIKE "The%";

/* 
3. Select the full names (first and last name) of authors whose last name
   starts with "S"
*/

SELECT 
    au_fname, au_lname
FROM
    authors
WHERE
    au_lname LIKE 'S%';

/* 
4. Select the name and address of all stores located in an Avenue 
   (its address ends with "Ave.")
*/

SELECT 
    stor_name, stor_address
FROM
    stores
WHERE
    stor_address LIKE '%Ave.';


/* 
5. Select the name and address of all stores located in an Avenue or in a 
   Street (address ended in "St.")
*/

SELECT 
    stor_name, stor_address
FROM
    stores
WHERE
    stor_address LIKE '%Ave.'
        OR stor_address LIKE '%St.';

/* 
6. Look at the "employee" table (select all columns to explore the raw data):
   Find a pattern that reveals whether an employee is Female or Male.
   Select all female employees.
*/

SELECT 
    *
FROM
    employee
WHERE
    emp_id LIKE '%F';

/* 
7. Select the first and last names of all male employees whose name starts with "P".
*/

SELECT 
    *
FROM
    employee
WHERE
    emp_id LIKE '%M' AND fname LIKE 'P%';

/* 
8. Select all books that have an "ing" in the title, with at least 4 other 
   characters preceding it. For example, 'cooking' has 4 characters before the
   'ing', so this should be included; 'sewing' has only 3 characters before the
   'ing', so this shouldn't be included. 
*/

SELECT 
    *
FROM
    titles
WHERE
    title LIKE '%____ing%';
    
/*
BONUS MATERIAL!!


Actually, there are no titles in this database with fewer than four characters
in front of 'ing' (Exercise 8). We can make a quick modification to our database to see what
happens if we do have titles containing the word 'sewing'.
*/
INSERT INTO titles (title_id, title, `type`, pub_id, pubdate)
VALUES ('HE5478', 'Sewing in the Modern Age', 'home_econ', '0736', '1991-06-18 00:00:00'),
('HE7961', 'Fundamentals of Machine Sewing', 'home_econ', '0736', '1991-06-18 00:00:00');
/*
Now compare the outputs of the following queries:
*/

-- This will select all title with 'ing': 'cooking' and 'sewing' alike
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '%ing%';

-- This excludes 'Sewing in the Modern Age', 
-- but still selects 'Fundamentals of Machine Sewing'!
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '%____ing%';

-- This excludes all titles with 'sewing'
-- but has also excluded 'Cooking with Computers: Surreptitious Balance Sheets'!
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '% ____ing%';

-- Finally, we have all titles with 'cooking' but none with 'sewing'
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '% ____ing%' OR title LIKE '____ing%';
    
/*
Finally, let's clean up our additions to avoid inconsistencies later.
*/
DELETE FROM titles
WHERE title_id IN ('HE5478', 'HE7961');