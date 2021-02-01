USE Diablo

SELECT * FROM
              (SELECT Username,
       G.Name AS Game,
       COUNT(UserGameId) AS [Items Count],
       ROUND(COUNT(UserGameId) * AVG(Price), 2) AS [Items Price]
FROM Users
JOIN UsersGames UG on Users.Id = UG.UserId
JOIN UserGameItems UGI on UG.Id = UGI.UserGameId
JOIN Items I on I.Id = UGI.ItemId
JOIN Games G on UG.GameId = G.Id
GROUP BY Username, G.Name
) AS res
WHERE [Items Count] >= 10
ORDER BY [Items Count] DESC, [Items Price] DESC
