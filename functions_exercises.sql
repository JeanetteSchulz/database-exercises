USE employees;

-- 2. Write a query to to find all employees whose last name starts and ends with 'E'. Use concat() to combine their first and last name together as a single column named full_name.
SELECT emp_no, CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE '%e'
	AND last_name LIKE 'E%'
ORDER BY emp_no;

-- 3. Convert the names produced in your last query to all uppercase.
SELECT emp_no, UPPER(CONCAT(first_name, ' ', last_name)) AS full_name
FROM employees
WHERE last_name LIKE '%e'
	AND last_name LIKE 'E%'
ORDER BY emp_no;

-- 4. Find all employees hired in the 90s and born on Christmas. Use datediff() function to find how many days they have been working at the company (Hint: You will also need to use NOW() or CURDATE()),
SELECT DATEDIFF(NOW(), hire_date) AS Days_At_Company, first_name, last_name
FROM employees
WHERE YEAR(hire_date) LIKE '199%'
		AND birth_date LIKE '%-12-25'
ORDER BY Days_At_Company DESC;

-- 5. Find the smallest and largest current salary from the salaries table.
SELECT MIN(salary) AS Smallest_Salary, MAX(salary) AS Largest_Salary
FROM salaries; 

-- 6. Use your knowledge of built in SQL functions to generate a username for all of the employees. A username should be all lowercase, and consist of the first character of the employees first name, the first 4 characters of the employees last name, an underscore, the month the employee was born, and the last two digits of the year that they were born. 
SELECT LOWER( CONCAT( 
		 SUBSTR(first_name,1,1), 
		 SUBSTR(last_name,1,4), 
		'_', 
		DATE_FORMAT(birth_date, '%m'),
		DATE_FORMAT(birth_date, '%y')
		)) 
		AS username,
		first_name,
		last_name,
		birth_date
FROM employees;