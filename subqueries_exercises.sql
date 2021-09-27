##SUBQUERY EXERCISES 
USE employees;

#1. Find all the current employees with the same hire date as employee 101010 using a sub-query.
SELECT *
FROM employees
JOIN dept_emp USING(emp_no)
WHERE to_date > CURDATE() 
	  AND hire_date = (SELECT hire_date FROM employees WHERE emp_no = 101010);

#2. Find all the titles ever held by all current employees with the first name Aamod.
-- Planning the inner query, all employees named Aamod
SELECT emp_no
FROM employees
WHERE first_name LIKE 'Aamod';


-- Placing the subquery into outer query
SELECT DISTINCT title -- Assuming that they only want the titles without repeats from multiple Aamod's
FROM titles
JOIN salaries USING (emp_no) -- This will find current employees
WHERE salaries.to_date > NOW() -- If we use to_date from TITLES we will only get current titles rather than all titles ever held
	  AND emp_no IN( 
					SELECT emp_no
					FROM employees
					WHERE first_name LIKE 'Aamod'
                    );
-- INSTRUCTOR SOLUTION
SELECT DISTINCT title
FROM titles
WHERE emp_no IN 
(
	SELECT emp_no
	FROM employees
	JOIN dept_emp USING (emp_no)
	WHERE first_name = 'aamod' 
	AND to_date > NOW()
);

#3. How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.
-- Planning the inner query
SELECT *
FROM employees;

SELECT emp_no, to_date
FROM dept_emp
WHERE to_date <= NOW(); ##WRONG!!!

-- INSTRUCTOR SOLUTION
Select *
FROM employees
WHERE emp_no NOT IN
(
	SELECT emp_no
    FROM dept_emp
    WHERE to_date > NOW()
);

-- Placing subquery in outer query
SELECT *
FROM employees
WHERE emp_no IN (
					SELECT emp_no
                    FROM dept_emp
                    WHERE to_date <= NOW()
				);
-- ANSWER: 85108 Employees no longer work for the company.

#4. Find all the current department managers that are female. List their names in a comment in your code.
-- Planning the inner query
SELECT *
FROM dept_manager
WHERE to_date > CURDATE();

-- Placing subquery in outer query
Select *
FROM employees
WHERE gender = 'F' 
	  AND emp_no IN(
			SELECT emp_no
			FROM dept_manager
			WHERE to_date > CURDATE()
		  );
-- ANSWER: Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil

#5. Find all the employees who currently have a higher salary than the companies overall, historical average salary.
-- Planning the inner query
SELECT AVG(salary)
FROM salaries
WHERE to_date > NOW(); -- Historical average is being interpreted as all non-current salaries

-- Placing subquery in outer query
SELECT first_name, last_name, salary
FROM employees
JOIN salaries USING(emp_no)
WHERE salary > (
				SELECT AVG(salary)
				FROM salaries
				WHERE to_date > NOW()
			   )
ORDER BY salary; ##ALSO WRONG!!!

-- INSTRUCTOR SOLUTION
SELECT emp_no
FROM salaries
WHERE salary >
(
	SELECT AVG(salary) 
    FROM salaries
)
	  AND to_date > NOW();

#6. How many current salaries are within 1 standard deviation of the current highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?
#Hint Number 1 You will likely use a combination of different kinds of subqueries.
#Hint Number 2 Consider that the following code will produce the z score for current salaries.

/*CODE PROVIDED:
- Returns the historic z-scores for each salary
- Notice that there are 2 separate scalar subqueries involved*/
SELECT emp_no, salary, 
    (salary - (SELECT AVG(salary) FROM salaries)) 
    / 
    (SELECT stddev(salary) FROM salaries) AS zscore
FROM salaries
WHERE to_date > CURDATE();

-- CURRENT Salaries
SELECT *
FROM salaries
WHERE to_date > CURDATE(); -- 240124 rows

-- Highest Salary
SELECT MAX(salary)
FROM salaries;

-- Possible Solution
SELECT *
FROM 
	(  -- ZTABLE
		SELECT salary,
		(salary - (SELECT AVG(salary) FROM salaries)) 
		/ 
		(SELECT stddev(salary) FROM salaries) AS zscore
		FROM salaries
        WHERE to_date > CURDATE() #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ) AS ztable
#JOIN salaries ON salaries.salary = ztable.salary 
#WHERE salaries.to_date > CURDATE() #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
LIMIT 10;

-- INSTRUCTOR SOLUTION
SELECT
        ( -- Numerator
			SELECT COUNT(salary)-- COUNT salaries that are greater than the MAX salary minus one Standard Deviation
			FROM salaries
			WHERE to_date > NOW()
			AND salary > (
							(SELECT MAX(salary) FROM salaries WHERE to_date > NOW())
							-
							(SELECT STD(salary) FROM salaries WHERE to_date > NOW())
						 )
		) 
        / -- DIVIDE the Numerator COUNT from Denominator COUNT to get percentage
        ( -- Denominator
			SELECT COUNT(*) -- COUNT total current salaries
			FROM salaries 
			WHERE to_date > NOW()
        ) * 100 AS 'Percent of Salaries';