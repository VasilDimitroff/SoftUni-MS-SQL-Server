USE Diablo

SELECT * FROM (
    SELECT Name,
           Price,
           MinLevel,
           Strength,
           Defence,
           Speed,
           Luck,
           Mind
    FROM Items
    JOIN [Statistics] S on S.Id = Items.StatisticId
    GROUP BY Name, Price, MinLevel, Strength, Defence, Speed, Luck, Mind
        ) AS result
WHERE Mind > (SELECT AVG(Mind) FROM [Statistics])
AND Luck > (SELECT AVG(Luck) FROM [Statistics])
AND Speed > (SELECT AVG(Speed) FROM [Statistics])
ORDER BY Name