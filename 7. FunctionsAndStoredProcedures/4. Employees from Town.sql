USE SoftUni

CREATE PROCEDURE usp_GetEmployeesFromTown(@townName VARCHAR(50))
AS
    BEGIN
        SELECT FirstName,LastName
        FROM Employees
        JOIN Addresses A on Employees.AddressID = A.AddressID
        JOIN Towns T on A.TownID = T.TownID
        WHERE T.Name = @townName
    END