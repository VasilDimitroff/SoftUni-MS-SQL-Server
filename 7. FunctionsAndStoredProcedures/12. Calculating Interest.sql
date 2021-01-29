USE Bank

CREATE PROCEDURE usp_CalculateFutureValueForAccount (@accountId INT, @interestRate FLOAT)
AS
    BEGIN
        SELECT A.Id,
               FirstName AS [FirstName],
               LastName AS [Last Name],
               Balance AS [Current Balance],
               dbo.ufn_CalculateFutureValue(Balance, @interestRate, 5) AS [Balance in 5 years]
        FROM Accounts AS A
        JOIN AccountHolders AH on AH.Id = A.AccountHolderId
        WHERE A.Id = @accountId
    END


EXECUTE dbo.usp_CalculateFutureValueForAccount 1, 0.1