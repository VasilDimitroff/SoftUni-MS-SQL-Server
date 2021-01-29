USE SoftUni

CREATE PROCEDURE usp_EmployeesBySalaryLevel (@salaryLevel VARCHAR(7))
AS
    BEGIN
        SELECT FirstName,LastName FROM (SELECT FirstName,
               LastName,
               [dbo].ufn_GetSalaryLevel(Salary) AS SalaryLevel
        FROM Employees) AS result
        WHERE SalaryLevel = @salaryLevel
    END

EXECUTE usp_EmployeesBySalaryLevel 'High'