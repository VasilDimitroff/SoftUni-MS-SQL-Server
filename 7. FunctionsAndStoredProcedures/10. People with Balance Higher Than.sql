USE Bank

CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@amount DECIMAL(18,4))
AS
    BEGIN
        SELECT FirstName AS [First Name],
       LastName AS [Last Name]
        FROM AccountHolders AS AH
        JOIN Accounts A on AH.Id = A.AccountHolderId
        GROUP BY  FirstName, LastName
        HAVING SUM(Balance) > @amount
    ORDER BY FirstName, LastName
    END

EXECUTE usp_GetHoldersWithBalanceHigherThan 2000




SELECT * FROM AccountHolders
SELECT * FROM Accounts