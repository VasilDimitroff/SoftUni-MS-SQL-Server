USE Geography

SELECT PeakName, RiverName, LOWER(PeakName + SUBSTRING(RiverName, 2, LEN(RiverName) - 1)) AS MIX
FROM Peaks AS p
         JOIN Rivers AS r
             ON RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY MIX
