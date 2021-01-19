USE Geography

SELECT COUNT(*) AS [Count]
FROM Countries
LEFT JOIN MountainsCountries MC on Countries.CountryCode = MC.CountryCode
LEFT JOIN Mountains M on MC.MountainId = M.Id
WHERE MountainId IS NULL