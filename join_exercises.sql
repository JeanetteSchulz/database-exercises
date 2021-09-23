##Join Example Database
#1. Use the join_example_db. Select all the records from both the users and roles tables.
USE join_example_db;

SELECT *
FROM roles
JOIN users using(id);

#2. Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.
SELECT *
FROM roles
JOIN users using(id);

SELECT *
FROM roles
LEFT JOIN users using(id);

SELECT *
FROM roles
RIGHT JOIN users using(id);

#3. Although not explicitly covered in the lesson, aggregate functions like count can be used with join queries. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query.
SELECT role_id AS 'ROLE', COUNT(role_id) AS 'COUNT', COUNT(*)-COUNT(role_id) AS Null_Count
FROM roles
RIGHT JOIN users using(id)
GROUP BY role_id;

##Employees Database
#1. Use the employees database.
USE employees;

#2. Using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of the current manager for that department.
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Current Manager'
FROM dept_manager
JOIN employees USING(emp_no)
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date > CURDATE();

#3. Find the name of all departments currently managed by women.
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Current Manager'
FROM dept_manager
JOIN employees USING(emp_no)
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date > CURDATE() 
	  AND employees.gender = 'F';

#4. Find the current titles of employees currently working in the Customer Service department.
SELECT titles.title AS Title , COUNT(titles.title) AS 'Count'
FROM titles
JOIN dept_emp USING(emp_no)
JOIN departments ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Customer Service'
	  AND titles.to_date > CURDATE()
      AND dept_emp.to_date > CURDATE()
GROUP BY titles.title;

#5. Find the current salary of all current managers.
SELECT departments.dept_name AS Department, CONCAT(employees.first_name, ' ', employees.last_name) AS 'Current Manager', salaries.salary AS Salary
FROM dept_manager
JOIN employees USING(emp_no)
JOIN salaries USING(emp_no)
JOIN departments USING(dept_no)
WHERE salaries.to_date > CURDATE()
	  AND dept_manager.to_date > CURDATE();

#6. Find the number of current employees in each department.
SELECT departments.dept_no AS 'Department Number', departments.dept_name AS Department, COUNT(dept_emp.emp_no) AS 'Number of Employees'
FROM dept_emp
JOIN departments USING(dept_no)
WHERE dept_emp.to_date > CURDATE()
GROUP BY departments.dept_no, departments.dept_name;

#7. Which department has the highest average salary? Hint: Use current not historic information.
SELECT departments.dept_name AS Department, AVG(salary) AS Average_Salary
FROM salaries
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE dept_emp.to_date > CURDATE()
      AND salaries.to_date > CURDATE()
GROUP BY departments.dept_name
ORDER BY Average_Salary DESC
LIMIT 1;

#8. Who is the highest paid employee in the Marketing department?
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries USING(emp_no)
JOIN dept_emp USING(emp_no)
JOIN titles USING (emp_no)
JOIN departments USING (dept_no)
WHERE departments.dept_name = 'Marketing' 
	  AND dept_emp.to_date > CURDATE() -- Currently employed in Marketing
      AND salaries.to_date > CURDATE(); -- Current received Salary


SELECT * 
FROM titles;

SELECT *
FROM departments;

SELECT * 
FROM dept_emp;

SELECT *
FROM employees;

