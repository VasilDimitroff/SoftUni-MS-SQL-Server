USE SoftUni

SELECT TOP 1 AVG(Salary) AS 'MinAverageSalary'
FROM Employees
GROUP BY DepartmentID
ORDER BY AVG(Salary)
