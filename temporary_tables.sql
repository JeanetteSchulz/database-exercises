#1. Using the example from the lesson, create a temporary table called employees_with_departments that contains first_name, last_name, and dept_name for employees currently with that department. Be absolutely sure to create this table on your own database. If you see "Access denied for user ...", it means that the query was attempting to write a new table to a database that you can only read.
CREATE TEMPORARY TABLE hopper_1558.employees_with_departments AS (
SELECT first_name, last_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > NOW()
);

SELECT database(); -- Check what database I am in
USE hopper_1558; -- Ensure I am using the temporary table I just made
SELECT *
FROM hopper_1558.employees_with_departments; -- See what my temp table looks like

#A. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
ALTER TABLE hopper_1558.employees_with_departments ADD full_name VARCHAR(100);

SELECT *
FROM hopper_1558.employees_with_departments;
#B. Update the table so that full name column contains the correct data
UPDATE hopper_1558.employees_with_departments
SET full_name = CONCAT(first_name, ' ' , last_name);

#C. Remove the first_name and last_name columns from the table.
ALTER TABLE hopper_1558.employees_with_departments DROP first_name, DROP last_name;

#D. What is another way you could have ended up with this same table?
CREATE TEMPORARY TABLE hopper_1558.employees_with_departments AS (
SELECT CONCAT(first_name,' ', last_name), dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > NOW()
);

#2. Create a temporary table based on the payment table from the sakila database.
#Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199.

USE sakila; -- Use requested database
SELECT *
FROM sakila.payment; -- See whats inside
SHOW CREATE TABLE payment;


CREATE TEMPORARY TABLE hopper_1558.mySakila AS (SELECT * FROM payment); -- Create new Temp Table
SELECT *
FROM hopper_1558.mySakila;-- View new temp table

ALTER TABLE hopper_1558.mySakila MODIFY amount FLOAT; -- Change to FLOAT so I can multiply without error code

UPDATE hopper_1558.mySakila 
SET amount = amount * 100; -- This will eliminate my decimal



#3. Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?