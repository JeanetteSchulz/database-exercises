USE employees; -- use employees database
SHOW TABLES; -- shows tables used in employees database
DESCRIBE employees; -- in employees table of employees database, show data types used
DESCRIBE dept_manager;
-- Which table(s) do you think contain a numeric type column? salaries has employee number which is an int
-- Which table(s) do you think contain a string type column? dept_manager has dept_no which is a char
-- Which table(s) do you think contain a date type column? employees table has hire_date
-- What is the relationship between the employees and the departments tables? There are no shared fields, however dept_emp combines them
SHOW CREATE TABLE dept_manager;
