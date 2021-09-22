#2. In your script, use DISTINCT to find the unique titles in the titles table. How many unique titles have there ever been? Answer that in a comment in your SQL file.
USE employees;
SELECT DISTINCT title
FROM titles;
-- ANSWER: 7 unique titles 

#3. Write a query to to find a list of all unique last names of all employees that start and end with 'E' using GROUP BY.
SELECT last_name
FROM employees
WHERE last_name LIKE 'E%' AND last_name LIKE '%e'
GROUP BY last_name;

#4. Write a query to to find all unique combinations of first and last names of all employees whose last names start and end with 'E'.
SELECT CONCAT(first_name, ' ' , last_name) AS Full_Name
FROM employees
WHERE last_name LIKE 'E%' AND last_name LIKE '%e'
GROUP BY Full_Name;

#5. Write a query to find the unique last names with a 'q' but not 'qu'. Include those names in a comment in your sql code.
SELECT last_name
FROM employees
WHERE last_name LIKE '%q%' AND NOT last_name LIKE '%qu%'
GROUP BY last_name;
-- ANSWER: Chleq, Lindqvist, Qiwen

#6. Add a COUNT() to your results (the query above) to find the number of employees with the same last name.
SELECT last_name AS Last_Name, count(last_name) AS Count
FROM employees
WHERE last_name LIKE '%q%' AND NOT last_name LIKE '%qu%'
GROUP BY last_name;

#7. Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.
SELECT first_name AS 'First Name', sum(gender='M') AS 'MALES', sum(gender='F') AS 'FEMALES' -- SUM will take an argument where count() won't?
FROM employees
WHERE first_name IN('Irena', 'Vidya','Maya') 
GROUP BY first_name;

#8. Using your query that generates a username for all of the employees, generate a count employees for each unique username. Are there any duplicate usernames? BONUS: How many duplicate usernames are there?
SELECT COUNT(LOWER( CONCAT( 
		 SUBSTR(first_name,1,1), #first initial of first name 
		 SUBSTR(last_name,1,4),  #first 4 of last name
		'_', 
		DATE_FORMAT(birth_date, '%m'), # month
		DATE_FORMAT(birth_date, '%y') # last two digits of year
		)))
		AS ALL_Usernames,
	######################################	
		COUNT(DISTINCT LOWER( CONCAT( 
		 SUBSTR(first_name,1,1), #first initial of first name 
		 SUBSTR(last_name,1,4),  #first 4 of last name
		'_', 
		DATE_FORMAT(birth_date, '%m'), # month
		DATE_FORMAT(birth_date, '%y') # last two digits of year
		)))
		AS Unique_Usernames,
	######################################	
		300024-285872 AS Duplicate_Usernames
FROM employees;

#9. More practice with aggregate functions:

#Find the historic average salary for all employees. Now determine the current average salary.
SELECT avg(salary) AS Historic_Average, 
CASE WHEN to_date > CURDATE() THEN avg(salary) END AS Current_Average
FROM salaries
GROUP BY salary;

SELECT avg(salary) AS Current_Average
FROM salaries
WHERE to_date > CURDATE();

#Now find the historic average salary for each employee. Reminder that when you hear "for each" in the problem statement, you'll probably be grouping by that exact column.
#Find the current average salary for each employee.
#Find the maximum salary for each current employee.
#Now find the max salary for each current employee where that max salary is greater than $150,000.
#Find the current average salary for each employee where that average salary is between $80k and $90k.
