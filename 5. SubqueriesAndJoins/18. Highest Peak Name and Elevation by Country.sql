USE Geography

SELECT TOP 5 CountryName,
       [Highest Peak Name],
       [Highest Peak Elevation],
       Mountain FROM
    (
SELECT CountryName,
       [Highest Peak Name],
       [Highest Peak Elevation],
       Mountain,
       RANK() OVER (PARTITION BY CountryName ORDER BY [Highest Peak Elevation] DESC) AS [Rank]
FROM (SELECT CountryName,
             ISNULL(PeakName, '(no highest peak)') AS 'Highest Peak Name',
             ISNULL(MAX(Elevation), 0)           AS 'Highest Peak Elevation',
             ISNULL(MountainRange, '(no mountain)')                       AS Mountain
      FROM Countries
               LEFT JOIN MountainsCountries MC on Countries.CountryCode = MC.CountryCode
               LEFT JOIN Mountains M on MC.MountainId = M.Id
               LEFT JOIN Peaks P on M.Id = P.MountainId
      GROUP BY CountryName, PeakName, MountainRange
     ) AS res ) AS Res2
WHERE Res2.Rank = 1
ORDER BY  CountryName, 'Highest Peak Name'