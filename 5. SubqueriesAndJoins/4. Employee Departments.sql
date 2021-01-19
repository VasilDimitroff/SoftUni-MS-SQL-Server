USE SoftUni

SELECT TOP 5 EmployeeID, FirstName, Salary, D.Name AS 'DepartmentName'
FROM Employees
JOIN Departments D on Employees.DepartmentID = D.DepartmentID
WHERE Salary > 15000
ORDER BY D.DepartmentID ASC