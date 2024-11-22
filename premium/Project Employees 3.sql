--QUESTION 1077 (Meta)
/*
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key (combination of columns with unique values) of this table.
employee_id is a foreign key (reference column) to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 

Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key (column with unique values) of this table.
Each row of this table contains information about one employee.
 

Write a solution to report the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Output: 
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
Explanation: Both employees with id 1 and 3 have the most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience.
*/


--ANSWER

/*
Approach 1: Using CTE and MAX()
Intuition
For this approach, we get the top N for each category using MAX(). Since both tables are needed to get the max years of experience for each project, we first create such join in a CTE or subquery. CTE is preferred in this solution because we need to use it twice to get the maximum year of experience for each project using MAX() and later join to get only the most experienced employees.

Algorithm
Create a CTE that combines both tables.
In the subquery, filter the results from the CTE using MAX().
In the main query, JOIN the CTE to the subquery to return only the most experienced employees for each project.
*/
WITH project_and_employee AS(
  SELECT t0.project_id, t1.employee_id, experience_years
  FROM Project t0
  JOIN Employee t1
  ON t0.employee_id = t1.employee_id
)
SELECT a.project_id, employee_id
FROM project_and_employee a
JOIN 
    (SELECT project_id, 
            MAX(experience_years) AS max_experience 
     FROM project_and_employee
     GROUP BY 1)b
ON a.project_id = b.project_id
AND a.experience_years = b.max_experience

/*
Approach 2: Using Window Functions
Algorithm
In the subquery, JOIN the two tables and give each record a rank by the experience_years in descending order for each project.
In the main query, SELECT only the project and employee from the subquery with the rank equals 1.
*/

SELECT project_id, employee_id
FROM (
    SELECT p.project_id, 
           p.employee_id, 
           RANK()OVER(PARTITION BY project_id ORDER BY experience_years DESC) AS rnk
    FROM Project p
    JOIN Employee e
    ON p.employee_id = e.employee_id
)a
WHERE rnk = 1