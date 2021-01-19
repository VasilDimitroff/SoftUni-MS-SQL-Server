USE SoftUni

SELECT TOP 50 FirstName, LastName,T.Name AS Town, AddressText
FROM Employees
JOIN Addresses A on Employees.AddressID = A.AddressID
JOIN Towns T on A.TownID = T.TownID
ORDER BY FirstName, LastName
