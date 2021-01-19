USE Geography

 SELECT  * FROM (
     SELECT C.CountryCode, MountainRange, PeakName, Elevation
FROM Countries AS C
JOIN MountainsCountries MC on C.CountryCode = MC.CountryCode
JOIN Mountains M on M.Id = MC.MountainId
JOIN Peaks P on M.Id = P.MountainId
WHERE C.CountryCode = 'BG'
     ) AS Result
WHERE Result.Elevation > 2835
ORDER BY Result.Elevation DESC