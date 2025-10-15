USE capstone;
SELECT * FROM countries;
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM jobs;

-- 1a. how many employees are in each department and which department has the highest head count?
SELECT department_name, COUNT(e.employee_id) AS employee_count 
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY employee_count DESC;

-- 1b. department with the highest head count of employees
SELECT department_name, COUNT(e.employee_id) AS employee_count 
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY employee_count DESC
LIMIT 1;

-- 2a. average salary per department
SELECT d.department_name, ROUND(AVG(e.salary),0) AS Avg_salary
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY Avg_salary DESC ;

-- 2bi. department with highest average salary
SELECT d.department_name, ROUND(AVG(e.salary),0) AS Avg_salary
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY Avg_salary DESC
LIMIT 1;

-- 2bii. department with the lowest average salary
SELECT d.department_name, ROUND(AVG(e.salary),0) AS Avg_salary
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY Avg_salary
LIMIT 1;

-- 3a. classify employees into salary bands
SELECT emp_name, salary,
	CASE
		WHEN salary < 5000 THEN 'Low'
        WHEN salary BETWEEN 5000 AND 10000 THEN 'Medium'
        WHEN salary > 10000 THEN 'High'
	ELSE 'Uknown'
END AS Salary_band
FROM employees;

-- 4. countries where orion operates and their  number of departments
SELECT c.country_id, c.country_name, COUNT(d.department_name) AS department_count
FROM departments AS d
INNER JOIN employees AS e
ON d.department_id = e.department_id
INNER JOIN countries AS c
ON e.country_id = c.country_id
GROUP BY c.country_id, c.country_name
ORDER BY department_count DESC;

-- 5. high earners- employees earning above average salary
SELECT emp_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 6 department, managers name and employees in the department
SELECT d.department_name, e.manager_name, COUNT(e.employee_id) AS employee_count
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY d.department_name, e.manager_name
ORDER BY employee_count DESC;

/* 7. job analysis
 find average salary for each job
 find job title with average salary greater than 12000
*/
WITH avg_table AS (SELECT job_id, job_title,ROUND(SUM(min_salary + max_salary)/2,0) AS Avg_salary
FROM jobs
GROUP BY job_id, job_title)

SELECT j.job_title, a.Avg_salary
FROM jobs AS j
INNER JOIN Avg_table AS a
ON j.job_id = a.job_id
WHERE avg_salary > 12000
ORDER BY Avg_salary DESC;

-- 8. Ranking employees of each department by their salaries
SELECT e.emp_name, d.department_name, e.salary,
RANK() OVER(PARTITION BY d.department_name ORDER BY e.salary DESC) AS rank_num
FROM employees AS e
INNER JOIN departments as d
ON e.department_id = d.department_id;

-- 9. coutries and their total salary cost
SELECT c.country_name, SUM(e.salary) AS total_salary
FROM employees AS e
INNER JOIN countries AS c
ON e.country_id = c.country_id
GROUP BY country_name
ORDER BY total_salary DESC;

-- 10. job roles with no employees assigned
SELECT j.job_title
FROM jobs AS j
RIGHT JOIN employees AS e
ON j.job_id = e.job_id
WHERE j.job_id NOT IN (SELECT DISTINCT e.job_id FROM employees)
;













