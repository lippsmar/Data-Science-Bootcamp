/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 5

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses:
	- LIKE (%, _)

--------------------------------------------------------------------------------

In SQL we can have many databases, they will show up in the schemas list
We must first define which database we will be working with. */

USE publications;

/*******************************************************************************
LIKE

https://www.w3schools.com/sql/sql_like.asp

Here we will also learn to use some wild card characters:
https://www.w3schools.com/sql/sql_wildcards.asp
(You can ignore 'Wildcard Characters in MS Access'
You need to look at the section 'Wildcard Characters in SQL Server')
*******************************************************************************/

/* 1. Select all books from the table title that contain the word "cooking"
   in its title */

select*from titles where (title like('%cooking%') and title is not null);

-- 2. Select all titles that start with the word "The"

select*from titles where (title like('the%') and title is not null);

/* 3. Select the full names (first and last name) of authors whose last name
   starts with "S" */

select au_fname, au_lname from authors where au_lname like ('S%');

/* 4. Select the name and address of all stores located in an Avenue
   (its address ends with "Ave.") */

select stor_name, stor_address from stores where stor_address like ('%Ave.');

/* 5. Select the name and address of all stores located in an Avenue or in a
   Street (address ended in "St.") */

select stor_name, stor_address from stores where stor_address like ('%Ave.') or stor_address like ('%St.');

/* 6. Look at the "employee" table (select all columns to explore the raw data):
   Find a pattern that reveals whether an employee is Female or Male.
   Select all female employees. */

select*from employee where emp_id like ('%F');

/* 7. Select the first and last names of all male employees whose name starts
   with "P". */

SELECT 
    fname, lname
FROM
    employee
WHERE
    emp_id LIKE ('%M')
        AND emp_id LIKE ('P%');

/* 8. Select all books that have an "ing" in the title, with at least 4 other
   characters preceding it. For example, 'cooking' has 4 characters before the
   'ing', so this should be included; 'sewing' has only 3 characters before the
   'ing', so this shouldn't be included. */

select*from titles where title like '%____ing%' ;