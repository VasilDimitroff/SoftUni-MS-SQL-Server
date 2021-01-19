USE Geography

SELECT TOP 5 result.CountryName,
       MAX(Elevation) AS 'HighestPeakElevation',
       MAX(Length) AS 'LongestRiverLength'
FROM (SELECT CountryName, Elevation, R2.Length FROM Countries
LEFT JOIN MountainsCountries MC on Countries.CountryCode = MC.CountryCode
LEFT JOIN Mountains M on M.Id = MC.MountainId
LEFT JOIN Peaks P on M.Id = P.MountainId
LEFT JOIN CountriesRivers CR on Countries.CountryCode = CR.CountryCode
LEFT JOIN Rivers R2 on CR.RiverId = R2.Id) AS result
GROUP BY CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, CountryName ASC