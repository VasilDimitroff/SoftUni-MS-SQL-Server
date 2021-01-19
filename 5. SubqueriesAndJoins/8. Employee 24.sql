USE SoftUni


SELECT E.EmployeeID, FirstName,
    CASE
        WHEN P.StartDate > '2004-12-31' THEN NULL
        ELSE P.Name
    END
    AS 'ProjectName'
FROM Employees AS E
JOIN EmployeesProjects EP on E.EmployeeID = EP.EmployeeID
JOIN Projects P on EP.ProjectID = P.ProjectID
WHERE E.EmployeeID = 24
