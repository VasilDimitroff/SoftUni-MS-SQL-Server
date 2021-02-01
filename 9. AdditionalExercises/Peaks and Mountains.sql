USE Geography

SELECT PeakName,
       MountainRange AS Mountain,
       Elevation
FROM Peaks
JOIN Mountains M on M.Id = Peaks.MountainId
ORDER BY Elevation DESC, Peaks.PeakName