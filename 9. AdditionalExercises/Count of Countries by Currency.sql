USE Geography

SELECT C.CurrencyCode AS CurrencyCode,
       C.Description AS Currency,
       COUNT(CountryName) AS NumberOfCountries
FROM Countries
RIGHT JOIN Currencies C on Countries.CurrencyCode = C.CurrencyCode
GROUP BY C.CurrencyCode,Description
ORDER BY NumberOfCountries DESC, Description ASC