USE Bank


CREATE OR ALTER PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
    BEGIN TRANSACTION
        IF(@MoneyAmount < 0)
        BEGIN
            ROLLBACK
            RAISERROR('Invalid amount!', 16, 1)
            RETURN
        END

    UPDATE Accounts
        SET Balance += @MoneyAmount
        WHERE  Id = @AccountId
COMMIT TRANSACTION

GO

EXECUTE usp_DepositMoney 1, 10

