USE SoftUni

CREATE PROCEDURE usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION

    DECLARE @targetEmployyeProjectsCount INT = (SELECT Count(ProjectID) AS CountProjects FROM EmployeesProjects
    WHERE EmployeeID = @emloyeeId
    GROUP BY EmployeeID)

     IF(@targetEmployyeProjectsCount >= 3)
         BEGIN
              RAISERROR ('The employee has too many projects!', 16, 1)
            RETURN
         END

    INSERT INTO EmployeesProjects (EmployeeID, ProjectID)
    VALUES(@emloyeeId, @projectID)
COMMIT

GO
