USE SoftUni

CREATE PROCEDURE usp_GetTownsStartingWith (@pattern VARCHAR(50))
AS
    BEGIN
        SELECT [Name]
        FROM Towns
        WHERE [Name] LIKE  @pattern + '%'
    END