USE Geography
 SELECT ContinentCode,
        CurrencyCode,
        CurrencyUsage
        FROM  (SELECT ContinentCode, CurrencyCode,
                    CurrencyUsage,
                    DENSE_RANK()
                        OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) AS CurrencyRank
        FROM (SELECT
                               C.ContinentCode,
                               C3.CurrencyCode,
                               COUNT(*) AS CurrencyUsage
FROM Continents AS C
JOIN Countries C2 on C.ContinentCode = C2.ContinentCode
JOIN Currencies C3 on C2.CurrencyCode = C3.CurrencyCode
GROUP BY C.ContinentCode, C3.CurrencyCode) AS Res
WHERE CurrencyUsage > 1 ) AS Res2
 WHERE Res2.CurrencyRank = 1
ORDER BY ContinentCode




