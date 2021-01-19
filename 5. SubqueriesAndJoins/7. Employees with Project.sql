USE SoftUni

SELECT TOP 5 Employees.EmployeeID, FirstName, P.Name AS 'ProjectName' FROM Employees
JOIN EmployeesProjects EP on Employees.EmployeeID = EP.EmployeeID
JOIN Projects P on EP.ProjectID = P.ProjectID
WHERE StartDate > '2002-08-13' AND EndDate IS NULL
ORDER BY  Employees.EmployeeID ASC