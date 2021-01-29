USE SoftUni

CREATE PROCEDURE  usp_GetEmployeesSalaryAboveNumber (@salary DECIMAL(18,4))
AS
    BEGIN
        SELECT FirstName,LastName
        FROM Employees
        WHERE Salary >= @salary
    END