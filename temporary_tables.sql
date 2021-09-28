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

/*#INSTRUCTOR ANSWER
describe employees.employees; -- to get the length of varchar!
ALTER TABLE employees_with_departments ADD full_name VARCHAR(31);
*/

SELECT *
FROM hopper_1558.employees_with_departments;

#B. Update the table so that full name column contains the correct data
UPDATE hopper_1558.employees_with_departments
SET full_name = CONCAT(first_name, ' ' , last_name);

#C. Remove the first_name and last_name columns from the table.
ALTER TABLE hopper_1558.employees_with_departments DROP first_name, DROP last_name;

#D. What is another way you could have ended up with this same table?
CREATE TEMPORARY TABLE hopper_1558.employees_with_departments AS (
SELECT CONCAT(first_name,' ', last_name) AS full_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > NOW()
);

/*#INSTRUCTOR NOTES
USE hopper_1558
DROP TABLE employees_with_departments; -- will remove table from database Hopper_1558! useful if made duplicates on accident
*/

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

/*#INSTRUCTOR ANSWER
alter table ryan.payments add column cents INT UNSIGNED
*/

#3. Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?
USE employees;
USE hopper_1558;

CREATE TEMPORARY TABLE hopper_1558.pay_versus_department AS (
SELECT dept_name, AVG(salary)
FROM salaries
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE salaries.to_date > NOW()
GROUP BY dept_name
);

SELECT * FROM hopper_1558.pay_versus_department; -- View new PAY_VS_DEPARTMENT table

/*
-- Current average salary per department
SELECT dept_name, AVG(salary)
FROM pay_versus_department
GROUP BY dept_name;

-- Overall historical average salary
SELECT AVG(salary)
FROM pay_versus_department;

-- All together noow
SELECT *
FROM pay_versus_department
WHERE AVG(Salary) */

-- Code below Assisted By Jared Godar
ALTER TABLE hopper_1558.pay_versus_department ADD z_score float;
#SELECT avg(salary) FROM department_pay as avg_salary; -- $63805.40
#SELECT stddev(salary) FROM department_pay as stdev_salary;  -- 16900.85
ALTER TABLE hopper_1558.pay_versus_department ADD avg_salary float;
ALTER TABLE hopper_1558.pay_versus_department ADD std_salary float;

UPDATE hopper_1558.pay_versus_department
SET avg_salary = 63805.4;

UPDATE hopper_1558.pay_versus_department
SET std_salary = 16900.85;

UPDATE hopper_1558.pay_versus_department
SET z_score = (`avg(salary)` - avg_salary) 
    / 
     std_salary;
     
SELECT * FROM hopper_1558.pay_versus_department
ORDER BY z_score DESC;