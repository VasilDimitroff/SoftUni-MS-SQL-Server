USE Bank

CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
BEGIN TRANSACTION
    DECLARE @targetAmount DECIMAL (18,4) =
        (SELECT Balance FROM Accounts WHERE Id = @AccountId)

    IF(@targetAmount < @MoneyAmount)
        BEGIN
           RAISERROR ('Not enough money!', 15, 1)
        RETURN
        END

    UPDATE Accounts
    SET Balance -= @MoneyAmount
    WHERE  Id = @AccountId
COMMIT TRANSACTION

