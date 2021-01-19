USE Geography

SELECT Res.CountryCode, COUNT(MountainRange) AS 'MountainRanges'
FROM (
        SELECT C.CountryCode, MountainRange
        FROM Countries AS C
        JOIN MountainsCountries MC on C.CountryCode = MC.CountryCode
        JOIN Mountains M on MC.MountainId = M.Id
        WHERE C.CountryCode IN ('BG', 'RU', 'US')
        ) AS Res
GROUP BY Res.CountryCode

