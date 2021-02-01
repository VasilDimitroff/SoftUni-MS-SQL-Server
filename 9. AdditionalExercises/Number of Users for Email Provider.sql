USE Diablo

SELECT [Email Provider], COUNT(*) FROM (SELECT
       SUBSTRING(Email, (CHARINDEX('@', Email, 1) + 1), LEN(Email) - CHARINDEX('@', Email, 1))
        AS [Email Provider]
FROM Users) AS res
GROUP BY [Email Provider]
ORDER BY COUNT(*) DESC, [Email Provider] ASC

