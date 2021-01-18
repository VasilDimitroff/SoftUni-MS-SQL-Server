-- Creating Database
CREATE DATABASE Airport

-- Use Database
USE Airport

-- 1. Creating tables

CREATE TABLE Planes (
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30) NOT NULL,
    Seats INT NOT NULL,
    [Range] INT NOT NULL
)

CREATE TABLE Flights (
    Id INT PRIMARY KEY IDENTITY,
    DepartureTime DATETIME2,
    ArrivalTime DATETIME2,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    PlaneId INT FOREIGN KEY REFERENCES Planes(Id)
)

CREATE TABLE Passengers (
    Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Age INT NOT NULL,
    Address VARCHAR(30) NOT NULL,
    PassportId CHAR(11) NOT NULL
)

CREATE TABLE LuggageTypes (
    Id INT PRIMARY KEY IDENTITY,
    Type VARCHAR(30) NOT NULL
)

CREATE TABLE Luggages (
    Id INT PRIMARY KEY IDENTITY,
    LuggageTypeId INT NOT NULL FOREIGN KEY REFERENCES LuggageTypes(Id),
    PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id)
)

CREATE TABLE Tickets (
    Id INT PRIMARY KEY IDENTITY,
    PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id),
    FlightId INT NOT NULL FOREIGN KEY REFERENCES Flights(Id),
    LuggageId INT NOT NULL FOREIGN KEY REFERENCES Luggages(Id),
    Price DECIMAL(18,2) NOT NULL
)

-- Tables created


--2. Insert Data

INSERT INTO Planes([Name], Seats, [Range])
VALUES ('Airbus 336', 112, 5132),
       ('Airbus 330', 432, 5325),
       ('Boeing 369', 231, 2355),
       ('Stelt 297', 254, 2143),
       ('Boeing 338', 165, 5111),
       ('Airbus 558', 387, 1342),
       ('Boeing 128', 345, 5541)

INSERT INTO LuggageTypes (Type)
VALUES ('Crossbody Bag'),
       ('School Backpack'),
       ('Shoulder Bag')

-- Data Inserted


-- 3. Make all flights to "Carlsbad" 13% more expensive.

UPDATE
    Tickets
SET Price = Price + Price * 0.13
    FROM Tickets
JOIN Flights AS f
    ON Tickets.FlightId = f.Id
WHERE Destination = 'Carlsbad'

-- Data Updated


-- 4. Delete all flights to "Ayn Halagim".

DELETE FROM Tickets
WHERE FlightId = 30

DELETE FROM Flights
WHERE Destination = 'Ayn Halagim'

-- Data deleted


-- 5. Select all flights and order them by Origin ASC and Destination DESC

SELECT Origin, Destination FROM Flights
ORDER BY Origin ASC, Destination DESC


-- 6. Select all of the planes, which name contains "tr".
-- Order them by id ASC, name ASC, seats ASC and range ASC.

SELECT * FROM Planes
WHERE [Name] LIKE '%tr%'
ORDER BY  Id, [Name], Seats, [Range]

-- 7. Select the total profit for each flight.
-- Order them by total price DESC, flight id ASC.

SELECT FlightId, SUM(Price) AS Price FROM Tickets
JOIN Passengers P on Tickets.PassengerId = P.Id
GROUP BY FlightId
ORDER BY Price DESC, FlightId

-- 8. Select top 10 records from passengers along with the price for their tickets.
-- Order them by price DESC, first name ASC and last name ASC.

SELECT FirstName, LastName, Price FROM Passengers
JOIN Tickets T ON Passengers.Id = T.PassengerId
ORDER BY Price DESC , FirstName, LastName

-- 9. Select luggage type and how many times was used by persons.
-- Sort by count DESC and luggage type ASC.

SELECT Type, COUNT(PassengerId) AS MostUsedLuggage
    FROM Luggages
JOIN LuggageTypes LT on Luggages.LuggageTypeId = LT.Id
GROUP BY LuggageTypeId, Type
ORDER BY COUNT(PassengerId) DESC, Type ASC

-- 10. Select the full name of the passengers with their trips (origin - destination).
-- Order them by full name ASC, origin ASC and destination ASC.

SELECT CONCAT(FirstName,' ', LastName) AS 'Full Name',
       Origin, Destination
    FROM Passengers AS p
JOIN Tickets AS t ON t.PassengerId = p.Id
JOIN Flights AS f ON t.FlightId = f.Id
ORDER BY [Full Name], Origin, Destination

-- 11. Select all people who don't have tickets. Select first name, last name and age.
-- Order by age DESC, first name ASC and last name ASC.

SELECT FirstName AS 'First Name',
       LastName AS 'Last Name',
       Age
FROM Passengers
LEFT JOIN Tickets AS T on Passengers.Id = T.PassengerId
WHERE T.PassengerId IS NULL
ORDER BY Age DESC, FirstName, LastName

-- 12. Select all passengers who don't have luggage's. Select their passport id and address.
-- Order the results by passport id ASC and address ASC.

SELECT PassportId, Address FROM Passengers
LEFT JOIN Luggages AS L ON L.PassengerId = Passengers.Id
WHERE L.PassengerId IS NULL
ORDER BY PassportId ASC, Address ASC

-- 13. Select all passengers and their count of trips.
-- Select the first name, last name and count of trips.
-- Order the results by total trips DESC, first name ASC and last name ASC.

SELECT FirstName AS 'First Name',
       LastName AS 'Last Name',
       COUNT(F.Destination) AS 'Total Trips'
FROM Passengers
JOIN Tickets T ON Passengers.Id = T.PassengerId
JOIN Flights F ON T.FlightId = F.Id
GROUP BY FirstName, LastName
ORDER BY COUNT(F.Destination) DESC, FirstName ASC, LastName ASC

-- 14. Select all passengers who have trips.
-- Select full name, plane name, trip in format {origin} - {destination}, luggage type.
-- Order by full name ASC, name ASC, origin ASC, destination ASC and luggage type ASC.

SELECT FirstName + ' ' + LastName AS 'Full Name',
       P2.[Name] AS 'Plane Name',
       CONCAT(Origin,' - ', Destination) AS Trip,
       LT.Type AS 'Luggage Type'
       FROM  Passengers AS p
JOIN Tickets T ON p.Id = T.PassengerId
JOIN Flights F ON F.Id = T.FlightId
JOIN Planes P2 ON F.PlaneId = P2.Id
JOIN Luggages L ON T.LuggageId = L.Id
JOIN LuggageTypes LT ON LT.Id = L.LuggageTypeId
ORDER BY [Full Name], [Plane Name], Origin, Destination, [Luggage Type]

--15. Select all passengers who have flights with first name, last name, destination, price for the ticket.
-- Take only the ticket with highest price for user.
-- Order the results by price DESC, first name ASC, last name ASC and destination ASC.

SELECT FirstName, LastName, Destination, Price FROM Passengers AS p
JOIN Tickets T ON p.Id = T.PassengerId
JOIN Flights F ON F.Id = T.FlightId
GROUP BY FirstName, LastName, Destination, Price
ORDER BY Price DESC, FirstName ASC, LastName ASC, Destination ASC

-- 16. Select all destinations and trips count to them.
-- Sort the result by trips count DESC and destination name ASC.

SELECT F.Destination, COUNT(FlightId) AS FliesCount FROM Tickets
JOIN Flights F on Tickets.FlightId = F.Id
GROUP BY F.Destination, FlightId
ORDER BY COUNT(FlightId) DESC, Destination ASC

-- 17. Select all planes with their name, seats count and passengers count.
-- Order the results by passengers count DESC, plane name ASC and seats ASC

SELECT Planes.Name, Seats, COUNT(F.Id) FROM Planes
JOIN Flights F on Planes.Id = F.PlaneId
JOIN Tickets T on F.Id = T.FlightId
GROUP BY Planes.Name, Seats
ORDER BY COUNT(F.Id) DESC, Planes.Name ASC, Seats ASC

-- 18. Create a UDF, that receives an origin, destination and people count.
-- The function must return the total price in format "Total price {price}"
-- If people count is less or equal to zero return – "Invalid people count!"
-- If flight is invalid return – "Invalid flight!"

CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(50), @destination VARCHAR(50), @peopleCount INT)
RETURNS VARCHAR(50)
    BEGIN
        IF (@peopleCount <= 0)
        BEGIN
            RETURN 'Invalid people count!'
        END
       IF ( (SELECT COUNT(*)
        FROM Flights
        WHERE Origin = @origin AND Destination = @destination) <= 0)
        BEGIN
            RETURN 'Invalid flight!'
        END
           DECLARE @totalPrice DECIMAL(18,2)

                SET @totalPrice =
                    (SELECT TOP (1) SUM (Price) FROM Flights
                    JOIN Tickets ON Tickets.FlightId = Flights.ID
                    WHERE Flights.Destination = @destination AND Flights.Origin = @origin
                    GROUP BY Tickets.FlightId) * @peopleCount
        DECLARE @result VARCHAR (30) = CAST(@totalPrice AS VARCHAR(30))

        RETURN ('Total price' + ' ' + @result)
    END
GO

-- Test the function

SELECT dbo.udf_CalculateTickets
    ('Kolyshley','Rancabolang', 33)
SELECT dbo.udf_CalculateTickets
    ('Kolyshley','Rancabolang', -1)
SELECT dbo.udf_CalculateTickets
    ('Invalid','Rancabolang', 33)

-- 19.Create a user defined stored procedure - it must cancel all flights
-- on which the arrival time is before the departure time.
-- Cancel means you need to leave the departure and arrival time empty.
-- NOTE : It works as in the example, but the task is wrong!


CREATE PROC usp_CancelFlights
AS
    UPDATE Flights
        SET ArrivalTime = NULL
        WHERE DATEDIFF(second, DepartureTime, ArrivalTime) > 0
    UPDATE Flights
        SET DepartureTime = NULL
        WHERE DATEDIFF(second, DepartureTime, ArrivalTime)> 0
GO

-- Run the procedure
EXEC usp_CancelFlights