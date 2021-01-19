USE SoftUni

SELECT E.EmployeeID, E.FirstName, E.ManagerID, E2.FirstName AS 'ManagerName'
FROM Employees AS E
JOIN Employees AS E2  ON E.ManagerID = E2.EmployeeID
WHERE E.ManagerID = 3 OR E.ManagerID = 7
ORDER BY E.EmployeeID ASC
