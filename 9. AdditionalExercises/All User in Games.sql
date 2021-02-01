USE Diablo

SELECT G.Name AS Game,
       GT.Name AS 'Game Type',
       Username AS Username,
       Level AS Level,
       Cash AS Cash,
       C.Name AS Character
FROM Games AS G
JOIN GameTypes AS GT on  G.GameTypeId = GT.Id
JOIN UsersGames UG on G.Id = UG.GameId
JOIN Users U on U.Id = UG.UserId
JOIN Characters C on UG.CharacterId = C.Id
ORDER BY Level DESC, Username, G.Name