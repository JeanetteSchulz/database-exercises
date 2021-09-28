#Subqueries Exercises reattempt
#To practice from scratch and do better than before
USE employees;

#1. Find all the current employees with the same hire date as employee 101010 using a sub-query.
SELECT hire_date
FROM employees
WHERE emp_no = 101010;

SELECT *
FROM employees
JOIN dept_emp USING(emp_no)
WHERE to_date > NOW() 
AND hire_date = (
SELECT hire_date
FROM employees
WHERE emp_no = 101010);


#2. Find all the titles ever held by all current employees with the first name Aamod.
SELECT *
FROM employees
JOIN dept_emp USING(emp_no)
WHERE first_name = 'Aamod'
AND to_date > CURDATE();

SELECT DISTINCT title 
FROM titles
WHERE emp_no IN (
SELECT emp_no
FROM employees
JOIN dept_emp USING(emp_no)
WHERE first_name = 'Aamod'
AND to_date > CURDATE()
);

#3. How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.
SELECT *
FROM dept_emp
WHERE to_date > NOW();

SELECT *
FROM employees
WHERE emp_no NOT IN (
SELECT emp_no
FROM dept_emp
WHERE to_date > NOW()
);

#4. Find all the current department managers that are female. List their names in a comment in your code.
SELECT *
FROM dept_manager
WHERE to_date > NOW();

SELECT *
FROM employees
WHERE gender = 'F'
AND emp_no IN (
SELECT emp_no
FROM dept_manager
WHERE to_date > NOW()
); -- ANSWER: Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil

#5. Find all the employees who currently have a higher salary than the companies overall, historical average salary.
SELECT AVG(salary)
FROM salaries;

SELECT *
FROM salaries
WHERE to_date > NOW()
AND salary > (
SELECT AVG(salary)
FROM salaries
);

#6. How many current salaries are within 1 standard deviation of the current highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?
-- CURRENT Highest salary
SELECT MAX(salary)
FROM salaries
WHERE to_date > NOW();

-- 1 Standard DEV
SELECT STDDEV(salary)
FROM salaries
WHERE to_date > NOW();

-- Current salaries within 1 STD dev
SELECT COUNT(*)
FROM salaries
WHERE to_date > NOW() 
AND salary > (
(SELECT MAX(salary) FROM salaries WHERE to_date > NOW()) 
- 
(SELECT STDDEV(salary) FROM salaries WHERE to_date > NOW())
);

-- Percentage
SELECT 
		(-- Numerator
			SELECT COUNT(salary)
			FROM salaries
			WHERE to_date > NOW() 
			AND salary > (
							(SELECT MAX(salary) FROM salaries WHERE to_date > NOW()) 
							- 
							(SELECT STDDEV(salary) FROM salaries WHERE to_date > NOW())
						 )
		) 
		/ -- DIVIDE 
		(-- Denominator
			SELECT COUNT(*)
            FROM salaries 
            WHERE to_date > NOW()
		) * 100 AS 'Percentage'
FROM salaries;

