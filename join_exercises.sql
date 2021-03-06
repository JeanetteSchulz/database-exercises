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
SELECT employees.first_name AS 'First Name', employees.last_name 'Last Name'
FROM employees
JOIN salaries USING(emp_no)
JOIN dept_emp USING(emp_no)
JOIN titles USING (emp_no)
JOIN departments USING (dept_no)
WHERE departments.dept_name = 'Marketing' 
	  AND dept_emp.to_date > CURDATE() -- Currently employed in Marketing
      AND salaries.to_date > CURDATE() -- Current received Salary
      AND titles.to_date > CURDATE() -- Currently has a title
ORDER BY salaries.salary DESC
LIMIT 1;

#9. Which current department manager has the highest salary?
SELECT departments.dept_name AS Department, CONCAT(employees.first_name, ' ', employees.last_name) AS 'Current Manager', salaries.salary AS Salary
FROM dept_manager
JOIN employees USING(emp_no)
JOIN salaries USING(emp_no)
JOIN departments USING(dept_no)
WHERE salaries.to_date > CURDATE()
	  AND dept_manager.to_date > CURDATE()
ORDER BY salaries.salary DESC
LIMIT 1;

##INSTRUCTOR'S SOLUTION
#10. Bonus Find the names of all current employees, their department name, and their current manager's name.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name', dept_name AS Department, CONCAT(managers.first_name, ' ', managers.last_name) AS 'Manager Name'
FROM employees e
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
JOIN dept_manager USING(dept_no)
JOIN employees as managers ON managers.emp_no = dept_manager.emp_no
WHERE dept_emp.to_date > CURDATE() 
	  AND dept_manager.to_date > CURDATE();

##The Graveyard of attempts :(
/*10. Bonus Find the names of all current employees, their department name, and their current manager's name.
SELECT A.emp_no, CONCAT(A.first_name, ' ', A.last_name) AS 'Employees', departments.dept_name AS 'Department', CONCAT(B.first_name, ' ', B.last_name) AS 'Managers', dept_emp.to_date, dept_manager.to_date
FROM employees A, employees B
#JOIN A.emp_no = dept_emp.emp_no -- RYAN's CODE
JOIN dept_manager ON dept_manager.emp_no = B.emp_no -- Needed for Current Manager
JOIN dept_emp ON dept_emp.emp_no = A.emp_no-- inlcuded to find CURRENT employees
JOIN departments ON departments.dept_no = dept_emp.dept_no -- Needed for Department Name
WHERE B.emp_no = dept_manager.emp_no
	  AND dept_emp.to_date > CURDATE() -- current employee, NOT READING THIS ROW!!
      AND dept_manager.to_date > CURDATE() -- current manager
;

#CURRENT MANAGERS
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Current Manager'
FROM dept_manager
JOIN employees USING(emp_no)
JOIN departments ON dept_manager.dept_no = departments.dept_no
WHERE dept_manager.to_date > CURDATE();

SELECT *
FROM dept_emp
JOIN departments USING(dept_no)
WHERE emp_no = 10001;

#10. Bonus Find the names of all current employees, their department name, and their current manager's name.
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS 'Employees', departments.dept_name AS 'Department', CONCAT(M.first_name, ' ', M.last_name) AS 'Managers', dept_emp.to_date, dept_manager.to_date
FROM employees e, employees M
JOIN dept_emp ON e.emp_no = dept_emp.emp_no -- inlcuded to find CURRENT employees
JOIN dept_manager ON dept_manager.emp_no = M.emp_no -- Needed for Current Manager

JOIN departments ON departments.dept_no = dept_emp.dept_no -- Needed for Department Name
WHERE M.emp_no = dept_manager.emp_no

	  AND dept_emp.to_date > CURDATE() -- current employee, NOT READING THIS ROW!!
      AND dept_manager.to_date > CURDATE() -- current manager
;

#10. Bonus Find the names of all current employees, their department name, and their current manager's name.
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS 'Employees', departments.dept_name AS 'Department', CONCAT(M.first_name, ' ', M.last_name) AS 'Managers', dept_emp.to_date, dept_manager.to_date
FROM employees e, employees M
JOIN dept_emp ON dept_emp.emp_no = M.emp_no -- inlcuded to find CURRENT employees
JOIN dept_manager ON dept_manager.emp_no = M.emp_no -- Needed for Current Manager
JOIN departments ON departments.dept_no = dept_emp.dept_no -- Needed for Department Name
WHERE M.emp_no = dept_manager.emp_no

	  AND dept_emp.to_date > CURDATE() -- current employee, NOT READING THIS ROW!!
      AND dept_manager.to_date > CURDATE() -- current manager
;

SELECT *
FROM employees;
SELECT *
FROM dept_emp;
SELECT *
FROM dept_manager;


#JOIN e.emp_no = dept_emp.emp_no -- RYAN's CODE

##Internet try
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS 'Employees', CONCAT(M.first_name, ' ', M.last_name) AS 'Managers'
FROM employees e
JOIN dept_emp ON dept_emp.emp_no = e.emp_no

JOIN dept_manager ON dept_manager.emp_no = e.emp_no
INNER JOIN employees M ON M.emp_no = dept_manager.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no -- Needed for Department Name
WHERE e.emp_no = dept_emp.emp_no -- RYAN's CODE
	  AND dept_emp.to_date > CURDATE() -- current employee, NOT READING THIS ROW!!
      AND dept_manager.to_date > CURDATE() -- current manager
;

#10. Bonus Find the names of all current employees, their department name, and their current manager's name.
SELECT A.emp_no, CONCAT(A.first_name, ' ', A.last_name) AS 'Employees', departments.dept_name AS 'Department', CONCAT(B.first_name, ' ', B.last_name) AS 'Managers', dept_emp.to_date, dept_manager.to_date
FROM employees A, employees B
JOIN dept_manager USING(emp_no) -- Needed for Current Manager
JOIN dept_emp ON dept_emp.emp_no = A.emp_no -- inlcuded to find CURRENT employees <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Problem child
JOIN departments ON departments.dept_no = dept_emp.dept_no -- Needed for Department Name
WHERE B.emp_no = dept_manager.emp_no
	  AND dept_emp.to_date > CURDATE() -- current employee
      AND dept_manager.to_date > CURDATE() -- current manager
;
*/
