USE SoftUni

SELECT *
INTO EmployeesWithMoreThan30000
FROM Employees
WHERE Salary > 30000

DELETE FROM EmployeesWithMoreThan30000
WHERE ManagerID = 42

UPDATE EmployeesWithMoreThan30000
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM EmployeesWithMoreThan30000
GROUP BY  DepartmentID

