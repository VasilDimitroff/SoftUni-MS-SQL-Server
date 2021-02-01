USE Geography

SELECT PeakName,
       MountainRange AS Mountain,
       CountryName,
       ContinentName
FROM Peaks
JOIN Mountains M on M.Id = Peaks.MountainId
JOIN MountainsCountries MC on M.Id = MC.MountainId
JOIN Countries C on C.CountryCode = MC.CountryCode
JOIN Continents C2 on C.ContinentCode = C2.ContinentCode
ORDER BY PeakName, CountryName

