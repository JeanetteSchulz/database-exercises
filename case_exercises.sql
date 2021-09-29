## CASE EXERCISES ##
Use employees;

#1. Write a query that returns all employees (emp_no), their department number, their start date, 
#their end date, and a new column 'is_current_employee' that is a 1 if the employee is still 
#with the company and 0 if not.

SELECT emp_no, dept_no, hire_date, to_date, 
	CASE 
		WHEN to_date > NOW() THEN TRUE
        ELSE FALSE
        END AS is_current_employee
FROM employees
JOIN dept_emp USING(emp_no);

#2. Write a query that returns all employee names (previous and current), and a new column 
#'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their 
#last name.

SELECT CONCAT(first_name, ' ', last_name) AS employee_names, 
	CASE
		WHEN LEFT(last_name,1) BETWEEN 'A' AND 'H' THEN 'A-H'
        WHEN LEFT(last_name,1) BETWEEN 'I' AND 'Q' THEN 'I-Q'
        ELSE 'R-Z'
        END AS alpha_group
FROM employees;

#3. How many employees (current or previous) were born in each decade?
-- Who is the oldest? 1952
SELECT MAX(YEAR(birth_date))
FROM employees;
-- Who is the youngest? 1965
SELECT MIN(YEAR(birth_date))
FROM employees;

SELECT 
	CASE
		WHEN YEAR(birth_date) BETWEEN 1950 AND 1959 THEN '50s'
        #WHEN YEAR(birth_date) BETWEEN 1960 AND 1969 THEN '60s'
        ELSE '60s'
	END AS Decade,   
    COUNT(*)
FROM employees
GROUP BY Decade;

#BONUS Q
#What is the current average salary for each of the following department groups:
# R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
CREATE TEMPORARY TABLE hopper_1558.new_department_averages AS(
SELECT  
	CASE
		WHEN dept_name IN('research', 'development') THEN 'R&D' 
        WHEN dept_name IN('SALES','marketing') THEN 'Sales & Marketing'
        WHEN dept_name IN('Production', 'Quality Management') THEN 'Prod & Marketing'
        WHEN dept_name IN('Finance','Human Resources') THEN 'Finance & HR'
        ELSE dept_name
	END AS Department,
    AVG(salary) AS Average_Salary -- This gives us the salary of the individual department, not the departments combined
FROM departments
JOIN dept_emp USING(dept_no)
JOIN salaries USING(emp_no)
GROUP BY Department -- This eliminates duplicates but that means some of the departments had thier name changed but arent represented in the list. ie only RESEARCH or DEVELOPMENT will represent R&D
);

USE hopper_1558;

SELECT AVG(80667.6058 + 71913.2000); #152580.80580000 -- Average of Sales and Marketing, AVG(AVG + AVG)= New AVG
SELECT AVG(59665.1817 + 59478.9012); #119144.08290000 -- Research & Development
SELECT AVG(70489.3649 + 55574.8794); #126064.24430000 -- Finance & Human Resources
SELECT AVG(59605.4825 + 71913.2000); #131518.68250000 -- Production & Marketing

UPDATE new_department_averages
SET Average_Salary = 152580.80580000
WHERE Department = 'Sales & Marketing'; -- For simplicity sake, I will just strong arm the new table to display what I want

UPDATE new_department_averages
SET Average_Salary = 126064.24430000
WHERE Department = 'Finance & HR';

UPDATE new_department_averages
SET Average_Salary = 131518.68250000 
WHERE Department = 'Prod & Marketing';

UPDATE new_department_averages
SET Average_Salary = 119144.08290000 
WHERE Department = 'R&D';

SELECT *
FROM new_department_averages; #FINAL ANSWER