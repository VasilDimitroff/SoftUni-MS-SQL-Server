USE SoftUni

SELECT E.FirstName, E.LastName, E.HireDate, D.Name AS DeptName
FROM Employees AS E
JOIN Departments D on E.DepartmentID = D.DepartmentID
WHERE HireDate > '1999-01-01' AND D.Name = 'Sales' OR D.Name = 'Finance'
ORDER BY HireDate ASC