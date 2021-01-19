USE Geography

SELECT TOP 5 CountryName, RiverName
FROM Countries
LEFT JOIN CountriesRivers CR on Countries.CountryCode = CR.CountryCode
LEFT JOIN Rivers R2 on CR.RiverId = R2.Id
LEFT JOIN Continents C on Countries.ContinentCode = C.ContinentCode
WHERE C.ContinentCode = 'AF'
ORDER BY Countries.CountryName ASC