USE SoftUni

CREATE TABLE Deleted_Employees (
    EmployeeId INT PRIMARY KEY IDENTITY ,
    FirstName NVARCHAR(50) NOT NULL ,
    LastName NVARCHAR(50) NOT NULL ,
    MiddleName NVARCHAR(50) ,
    JobTitle NVARCHAR(50) NOT NULL ,
    DepartmentId INT NOT NULL,
    Salary DECIMAL(18,4) NOT NULL
)
GO

CREATE TRIGGER tr_EmployeeDelete ON Employees
AFTER DELETE AS
    BEGIN
        INSERT INTO  Deleted_Employees
        SELECT [d].FirstName,[d].LastName, [d].MiddleName, [d].JobTitle, [d].DepartmentId, [d].Salary
        FROM Deleted as [d]
    END
GO