USE Geography

SELECT CountryName,
       ContinentName,
       ISNULL(COUNT(RiverId), 0) AS RiversCount,
       ISNULL(SUM(Length), 0) AS TotalLength
       FROM Countries
LEFT JOIN CountriesRivers CR on Countries.CountryCode = CR.CountryCode
LEFT JOIN Rivers R2 on CR.RiverId = R2.Id
LEFT JOIN Continents C on Countries.ContinentCode = C.ContinentCode
GROUP BY CountryName, ContinentName
ORDER BY  COUNT(RiverId) DESC, TotalLength DESC, CountryName