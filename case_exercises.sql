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