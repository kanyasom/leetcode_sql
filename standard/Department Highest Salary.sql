-- Q.184
-- MySQL
SELECT d.name AS Department, e.name as Employee, e.salary
FROM Employee e JOIN Department d ON e.departmentId = d.id
WHERE (e.departmentId, e.salary) IN (SELECT departmentId, MAX(Salary) AS mxSal
FROM Employee 
GROUP BY departmentId)

