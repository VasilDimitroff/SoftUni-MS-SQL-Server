USE SoftUni

SELECT TOP 50 E.EmployeeID,
       E.FirstName + ' ' + E.LastName AS 'EmployeeName',
       E2.FirstName + ' ' + E2.LastName AS 'ManagerName',
       D.Name AS 'DepartmentName'
FROM Employees AS E
JOIN Employees AS E2 ON E.ManagerID = E2.EmployeeID
JOIN Departments D on E.DepartmentID = D.DepartmentID
ORDER BY E.EmployeeID