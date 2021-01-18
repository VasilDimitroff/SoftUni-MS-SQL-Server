-- Creating database

CREATE DATABASE ColonialJourney

-- using database
USE ColonialJourney


-- creating tables

CREATE TABLE Planets (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] VARCHAR(50) NOT NULL,
    PlanetId INT NOT NULL FOREIGN KEY REFERENCES Planets(Id)
)

CREATE TABLE Spaceships (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(30) NOT NULL,
    LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists (
    Id INT PRIMARY KEY IDENTITY ,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Ucn VARCHAR(10) NOT NULL UNIQUE,
    BirthDate DATETIME2 NOT NULL
)

CREATE TABLE Journeys (
    Id INT PRIMARY KEY IDENTITY ,
    JourneyStart DATETIME2 NOT NULL ,
    JourneyEnd DATETIME2 NOT NULL ,
    Purpose VARCHAR(11),
    CHECK (Purpose IN ('Medical','Technical','Educational','Military')),
    DestinationSpaceportId INT NOT NULL FOREIGN KEY REFERENCES Spaceports(Id),
    SpaceshipId INT NOT NULL FOREIGN KEY REFERENCES Spaceships(Id)
)

CREATE TABLE TravelCards (
    Id INT PRIMARY KEY IDENTITY ,
    CardNumber CHAR(10) NOT NULL UNIQUE ,
    JobDuringJourney VARCHAR(8),
    CHECK (JobDuringJourney IN ('Pilot','Engineer','Trooper','Cleaner', 'Cook')),
    ColonistId INT NOT NULL FOREIGN KEY REFERENCES Colonists(Id),
    JourneyId INT NOT NULL FOREIGN KEY REFERENCES Journeys(Id)
)

-- database and tables created


-- 2. Insert sample data into the database.
-- Write a query to add records into the corresponding tables.

INSERT INTO Planets([Name])
VALUES ('Mars'),
       ('Earth'),
       ('Jupiter'),
       ('Saturn')

INSERT INTO Spaceships([Name], Manufacturer, LightSpeedRate)
VALUES ('Golf', 'VW', 3),
       ('WakaWaka', 'Wakanda', 4),
       ('Falcon9', 'SpaceX', 1),
       ('Bed', 'Vidolov', 6)


-- 3. Update all spaceships light speed rate with 1 where the Id is between 8 and 12.

UPDATE Spaceships
 SET LightSpeedRate += 1
WHERE Id BETWEEN 8 AND 12


-- 4. Delete first three inserted Journeys

DELETE FROM TravelCards
WHERE JourneyId BETWEEN 1 AND 3

DELETE FROM Journeys
WHERE Id BETWEEN  1 AND 3


-- 5. Extract from the database, all Military journeys in the format "dd/MM/yyyy".
-- Sort the results ASC by journey start.

SELECT Id, FORMAT(JourneyStart, 'dd/MM/yyyy'), FORMAT(JourneyEnd, 'dd/MM/yyyy')
FROM Journeys
WHERE Purpose = 'Military'
ORDER BY JourneyStart ASC

-- 6. Extract from the database all colonists, which have a pilot job.
-- Sort the result by id ASC.

SELECT Colonists.Id, FirstName + ' ' + LastName AS full_name FROM Colonists
JOIN TravelCards TC on Colonists.Id = TC.ColonistId
WHERE TC.JobDuringJourney = 'Pilot'
ORDER BY  Colonists.Id ASC

-- 7. Count all colonists that are on technical journey.

SELECT COUNT(*) AS [count] FROM Colonists
JOIN TravelCards TC on Colonists.Id = TC.ColonistId
JOIN Journeys J on TC.JourneyId = J.Id
WHERE J.Purpose = 'Technical'

-- 8. Extract from the database those spaceships, which have pilots,
-- younger than 30 years old. In other words, 30 years from 01/01/2019.
-- Sort the results alphabetically by spaceship name.

SELECT Spaceships.[Name], Manufacturer FROM Spaceships
JOIN Journeys J on Spaceships.Id = J.SpaceshipId
JOIN TravelCards TC on J.Id = TC.JourneyId
JOIN Colonists C on C.Id = TC.ColonistId
WHERE JobDuringJourney = 'Pilot' AND DATEDIFF(year, BirthDate, '01/01/2019') < 30
ORDER BY Spaceships.[Name] ASC

--9. Extract from the database all planets’ names and their journeys count.
-- Order by journeys count, DESC and by planet name ASC.

SELECT p.Name, COUNT(J.Id)
FROM Planets AS p
JOIN Spaceports S on p.Id = S.PlanetId
JOIN Journeys J on S.Id = J.DestinationSpaceportId
GROUP BY p.Name
ORDER BY COUNT(J.Id) DESC, p.Name

--10.Find all colonists and their job during journey with rank 2.
-- All the selected colonists with rank 2 must be the oldest ones.
-- Use ranking over their job during their journey.

SELECT * FROM (SELECT JobDuringJourney, Colonists.FirstName + ' ' + Colonists.LastName AS FullName, RANK() OVER
    (PARTITION BY TC.JobDuringJourney ORDER BY BirthDate ASC) AS JobRank
FROM Colonists
JOIN TravelCards TC on Colonists.Id = TC.ColonistId) AS result
WHERE result.JobRank = 2


-- 11.Create a user defined function with the name that receives planet name
-- and returns the count of all colonists sent to that planet.

CREATE FUNCTION dbo.udf_GetColonistsCount(@planetName VARCHAR (30))
RETURNS INT
AS
  BEGIN
   DECLARE @colonistsCount INT = (SELECT COUNT(S.Id) FROM Planets
            JOIN Spaceports S on Planets.Id = S.PlanetId
            JOIN Journeys J on S.Id = J.DestinationSpaceportId
            JOIN TravelCards TC on J.Id = TC.JourneyId
            JOIN Colonists C on TC.ColonistId = C.Id
            WHERE Planets.[Name] = @planetName)
        RETURN  @colonistsCount
  END

-- 12. Create a user defined stored procedure, that receives an journey id and purpose,
-- and attempts to change the purpose of that journey.
-- An purpose will only be changed if all of these conditions pass:
    -- If the journey id doesn’t exists, raise an error
    -- If the journey has already that purpose, raise an error

CREATE PROCEDURE  usp_ChangeJourneyPurpose(@journeyId INT, @newPurpose VARCHAR(11))
AS
    DECLARE @findedId INT = (SELECT TOP(1) Id FROM Journeys WHERE Id = @journeyId)
IF (@findedId IS NULL)
    BEGIN
        RAISERROR ('The journey does not exist!', 12, 12)
        RETURN
    END

    DECLARE @currentPurpose VARCHAR(11) = (SELECT TOP (1) Purpose FROM Journeys WHERE Id = @journeyId)
IF (@currentPurpose = @newPurpose)
    BEGIN
        RAISERROR ('You cannot change the purpose!', 13, 13)
        RETURN
    END

UPDATE  Journeys
SET Purpose = @newPurpose
WHERE Id = @journeyId
RETURN

GO

EXEC usp_ChangeJourneyPurpose 4, 'Technical'
EXEC usp_ChangeJourneyPurpose 2, 'Educational'
EXEC usp_ChangeJourneyPurpose 196, 'Technical'