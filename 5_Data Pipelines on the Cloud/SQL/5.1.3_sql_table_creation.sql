/***************************
Setting up the environment
***************************/

-- Drop the database if it already exists
DROP DATABASE IF EXISTS sql_workshop ;

-- Create the database
CREATE DATABASE sql_workshop;

-- Use the database
USE sql_workshop;



/***************************
Creating the first table
***************************/

-- Create the 'authors' table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT, -- Automatically generated ID for each author
    author_name VARCHAR(255) NOT NULL, -- Name of the author
    PRIMARY KEY (author_id) -- Primary key to uniquely identify each author
);

/* An auto-increment attribute automatically generates a unique number
(typically used for a primary key) for each new record inserted into a table. */

/* A primary key is a unique identifier for each record in a database table,
ensuring that no two rows have the same value in this column. */

/* VARCHAR(255) data type can store strings of up to 255 characters, 
but strings can also be shorter than that. 
VARCHAR stands for "variable character"*/

/* NOT NULL constraint is used to specify that a column must not be NULL. 
This means that when you insert a new row into a table or update an existing row, 
you must provide a value for the column. */

SELECT * FROM authors;
-- it's empty at the moment



/***************************
Inserting information into a table
***************************/

-- Inserting a single record

INSERT INTO authors (author_name) 
VALUES ('Haruki Murakami');

SELECT * 
FROM authors;

-- Inserting multiple records

INSERT INTO authors (author_name) 
VALUES ('Margaret Atwod'), ('Henrik Ibsen');

SELECT * 
FROM authors;



/***************************
Updating a record
***************************/

-- We spelt someone's name wrong. Let's correct it
UPDATE authors
SET author_name = 'Margaret Atwood'
WHERE author_id = 2;

SELECT * 
FROM authors;



/***************************
Deleting information into a table
***************************/

-- Delete a single record
DELETE FROM authors 
WHERE author_name = 'Haruki Murakami';

/* some of you may get an error about using safe mode here
this is protection against accidental deletion
You can either turn off safe mode or use the id instead */

DELETE FROM authors 
WHERE author_id = 1;

SELECT * 
FROM authors;

-- Delete multiple records
DELETE FROM authors 
WHERE author_id IN (2, 3);

SELECT * 
FROM authors;



/***************************
Creating the second table
***************************/

-- Create the 'books' table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT, -- Automatically generated ID for each book
    book_title VARCHAR(255) NOT NULL, -- Title of the book
    year_published INT, -- Year the book was published
    author_id INT, -- ID of the author who wrote the book
    PRIMARY KEY (book_id), -- Primary key to uniquely identify each book
    FOREIGN KEY (author_id) REFERENCES authors(author_id) -- Foreign key to connect each book to its author
);

/* INT is a numeric data type that stores signed integers. 
This means that INT values can represent both positive and negative whole numbers. */

/* A foreign key is a constraint that links a column in one table to a primary key in another table. */