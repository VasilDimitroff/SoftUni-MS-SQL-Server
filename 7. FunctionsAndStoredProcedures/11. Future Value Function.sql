USE Bank

CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18,4), @interestRate FLOAT, @years INT)
RETURNS DECIMAL(18,4)
AS
    BEGIN
        DECLARE @totalResult DECIMAL(18,4)
        SET @totalResult = @sum * POWER((1 + @interestRate), @years)
        RETURN  @totalResult
    END