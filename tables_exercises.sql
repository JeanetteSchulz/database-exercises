-- Use the employees database
USE employees;

-- List all the tables in the database
SHOW TABLES;

-- Explore the employees table. What different data types are present on this table?
DESCRIBE employees; 

-- Which table(s) do you think contain a numeric type column? 
	-- salaries has employee number which is an int
	
-- Which table(s) do you think contain a string type column? 
	-- dept_manager has dept_no which is a char

-- Which table(s) do you think contain a date type column? 
	-- employees table has hire_date
	
-- What is the relationship between the employees and the departments tables? 
	-- There are no shared fields, however dept_emp combines them

-- Show the SQL that created the dept_manager table.
SHOW CREATE TABLE dept_manager;
