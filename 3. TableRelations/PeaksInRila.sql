USE Geography

SELECT MountainRange, PeakName, Elevation FROM Peaks
JOIN Mountains M on Peaks.MountainId = M.Id
WHERE M.MountainRange = 'Rila'
ORDER BY Elevation DESC