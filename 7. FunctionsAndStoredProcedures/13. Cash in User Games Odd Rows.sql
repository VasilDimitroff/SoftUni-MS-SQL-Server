USE Diablo

CREATE FUNCTION ufn_CashInUsersGames(@gameName VARCHAR(100))
RETURNS TABLE
AS
    RETURN
       SELECT SUM(Cash) AS [SumCash] FROM (
        SELECT Cash, G.Name, ROW_NUMBER() OVER (PARTITION BY G.Name ORDER BY Cash DESC) AS [Rank]
            FROM Games AS G
        JOIN UsersGames UG on G.Id = UG.GameId)
            AS result
        WHERE [Rank] % 2 != 0 AND Name = @gameName
