USE SoftUni

SELECT TOP 5 EmployeeID, JobTitle, A.AddressID, AddressText
FROM Employees AS E
JOIN Addresses AS A ON A.AddressID = E.AddressID
ORDER BY A.AddressID ASC