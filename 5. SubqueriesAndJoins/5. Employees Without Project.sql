USE SoftUni

SELECT TOP 3 E.EmployeeID, FirstName
FROM Employees AS E
LEFT JOIN EmployeesProjects EP on E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects P on EP.ProjectID = P.ProjectID
WHERE P.Name IS NULL
ORDER BY EmployeeID ASC