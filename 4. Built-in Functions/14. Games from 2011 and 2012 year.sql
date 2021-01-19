USE Diablo

SELECT TOP 50 [Name], FORMAT(Start, 'yyyy-MM-dd') AS Start
FROM Games
WHERE Start > '2010-12-31' AND Start < '2013-01-01'
ORDER BY Start, [Name]