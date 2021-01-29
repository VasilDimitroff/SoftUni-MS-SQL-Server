USE Bank

CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18,4))
AS
    BEGIN TRANSACTION
        BEGIN TRY
             EXECUTE usp_WithdrawMoney @SenderId, @Amount
             EXECUTE usp_DepositMoney @ReceiverId, @Amount
        END TRY
        BEGIN CATCH
           ROLLBACK
        END CATCH
COMMIT TRANSACTION