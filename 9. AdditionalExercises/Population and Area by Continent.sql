USE Geography

SELECT ContinentName,
       SUM(AreaInSqKm) AS CountriesArea,
       SUM(CAST(Population AS BIGINT)) AS CountriesPopulation
    FROM Countries AS Co
JOIN Continents C on Co.ContinentCode = C.ContinentCode
GROUP BY ContinentName
ORDER BY CountriesPopulation DESC
