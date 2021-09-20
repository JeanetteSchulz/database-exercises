-- 1. Create a file named where_exercises.sql. Make sure to use the employees database.
USE employees;

-- 2. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. Enter a comment with the number of records returned. Answer: 709 records were returned
SELECT first_name, last_name
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');

-- 3. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN. Enter a comment with the number of records returned. Does it match number of rows from Q2? Answer: The number of records returned is 709, the same as Q2!
SELECT first_name
FROM employees
WHERE first_name = 'Irena'
	OR first_name = 'Vidya'
	OR first_name = 'Maya';

-- 4. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', using OR, and who is male. Enter a comment with the number of records returned. ANSWER: 441 records returned
SELECT first_name, last_name, gender
FROM employees
WHERE (first_name = 'Irena'
	OR first_name = 'Vidya'
	OR first_name = 'Maya')
	AND gender = 'M';

-- 5. Find all current or previous employees whose last name starts with 'E'. Enter a comment with the number of employees whose last name starts with E. Answer: 7330 employees have a last name that starts with E
SELECT last_name, first_name
FROM employees
WHERE last_name LIKE 'E%'
ORDER BY last_name;

-- 6. Find all current or previous employees whose last name starts or ends with 'E'. Enter a comment with the number of employees whose last name starts or ends with E. How many employees have a last name that ends with E, but does not start with E? Answer: There are 30723 employees who's last name starts or ends with E. There are 23393 employees who have a name that ends with E, but does not start with E.
SELECT last_name, first_name
FROM employees
WHERE last_name LIKE '%e'
	OR last_name LIKE 'E%';

SELECT last_name, first_name
FROM employees
WHERE last_name LIKE '%e'
	AND NOT last_name LIKE 'E%';

-- 7. Find all current or previous employees employees whose last name starts and ends with 'E'. Enter a comment with the number of employees whose last name starts and ends with E. How many employees' last names end with E, regardless of whether they start with E? ANSWER: 899 employess have a last name that starts AND ends with E. 24292 employees have a name ending in E.
SELECT last_name, first_name
FROM employees
WHERE last_name LIKE '%e'
	AND last_name LIKE 'E%';

SELECT last_name, first_name
FROM employees
WHERE last_name LIKE '%e';

-- 8. Find all current or previous employees hired in the 90s. Enter a comment with the number of employees returned. ANSWER: 135214 employees were hired in the 90s
SELECT hire_date, last_name
FROM employees
WHERE YEAR(hire_date) BETWEEN 1990 AND 1999;

-- 9. Find all current or previous employees born on Christmas. Enter a comment with the number of employees returned. ANSWER: 842 employees have a birthday on Christmas
SELECT birth_date
FROM employees
WHERE MONTH(birth_date) = 12 AND DAY(birth_date) = 25;

-- 10. Find all current or previous employees hired in the 90s and born on Christmas. Enter a comment with the number of employees returned. ANSWER: 362 employees returned
SELECT birth_date, hire_date, last_name
FROM employees
WHERE (YEAR(hire_date) BETWEEN 1990 AND 1999)
	AND (MONTH(birth_date) = 12 AND DAY(birth_date) = 25);

-- 11. Find all current or previous employees with a 'q' in their last name. Enter a comment with the number of records returned. ANSWER: 1873 employees returned
SELECT last_name
FROM employees
WHERE last_name LIKE '%q%';

-- 12. Find all current or previous employees with a 'q' in their last name but not 'qu'. How many employees are found? ANSWER 547 employees returned
SELECT last_name
FROM employees
WHERE last_name LIKE '%q%'
	AND NOT last_name LIKE '%qu%';