USE Diablo

SELECT I.Name AS Item,
       Price AS Price,
       MinLevel AS MinLevel,
       GT.Name AS [Forbidden Game Type]
FROM Items AS I
LEFT JOIN GameTypeForbiddenItems GTFI on I.Id = GTFI.ItemId
LEFT JOIN GameTypes GT on GTFI.GameTypeId = GT.Id
ORDER BY [Forbidden Game Type]  DESC, I.Name ASC