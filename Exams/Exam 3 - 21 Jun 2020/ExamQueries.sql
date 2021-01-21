CREATE DATABASE TripService

USE TripService


-- 1.
CREATE TABLE  Cities (
    Id INT PRIMARY KEY IDENTITY ,
    Name NVARCHAR(20) NOT NULL,
    CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels (
    Id INT PRIMARY KEY IDENTITY ,
    Name NVARCHAR(30) NOT NULL ,
    CityId INT NOT NULL REFERENCES Cities(Id),
    EmployeeCount INT NOT NULL ,
    BaseRate DECIMAL (18,2)
)

CREATE TABLE Rooms (
    Id INT PRIMARY KEY IDENTITY ,
    Price DECIMAL(18,2) NOT NULL ,
    [Type] NVARCHAR(20) NOT NULL,
    Beds INT NOT NULL,
    HotelId INT NOT NULL REFERENCES Hotels(Id)
)

CREATE TABLE Trips (
    Id INT PRIMARY KEY IDENTITY ,
    RoomId INT NOT NULL REFERENCES Rooms(Id),
    BookDate DATETIME NOT NULL,
    ArrivalDate DATETIME NOT NULL,
    ReturnDate DATETIME NOT NULL,
    CancelDate DATETIME,

    CONSTRAINT bookDate_beforeArrivalDate CHECK (BookDate < ArrivalDate),
    CONSTRAINT arrivalDate_beforeReturnDate CHECK (ArrivalDate < Trips.ReturnDate)
)

CREATE TABLE  Accounts (
    Id INT PRIMARY KEY IDENTITY ,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(20),
    LastName NVARCHAR(50) NOT NULL,
    CityId INT NOT NULL REFERENCES Cities(Id),
    BirthDate DATE NOT NULL ,
    Email VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE AccountsTrips (
    AccountId INT NOT NULL REFERENCES Accounts(Id),
    TripId INT NOT NULL REFERENCES Trips(Id),
    Luggage INT NOT NULL CHECK (Luggage >= 0),
    PRIMARY KEY (AccountId, TripId)
)

-- 2.

INSERT INTO Accounts (FirstName, MiddleName, LastName, CityId, BirthDate, Email)
VALUES  ('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
        ('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
        ('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
        ('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO Trips (RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
VALUES (101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
       (102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
       (103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
       (104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
       (109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)


-- 3.
UPDATE Rooms
SET Price = Price + Price * 0.14
WHERE HotelId IN (5, 7, 9)


-- 4.
DELETE FROM Trips
WHERE Id = 47

DELETE FROM AccountsTrips
WHERE AccountId = 47


-- 5.
SELECT FirstName,
       LastName,
       FORMAT(BirthDate, 'MM-dd-yyyy') AS BirthDate,
       C.Name AS Hometown,
       Email
FROM Accounts
JOIN Cities C on Accounts.CityId = C.Id
WHERE Email LIKE 'e%'
ORDER BY C.Name

-- 6.
SELECT C.Name, COUNT(*) AS Hotels
FROM Cities AS C
JOIN Hotels H on C.Id = H.CityId
GROUP BY  C.Name
ORDER BY Hotels DESC, C.Name


--7.
SELECT Accounts.Id,
       FirstName + ' ' + LastName AS FullName,
       MAX(DATEDIFF(day, ArrivalDate, ReturnDate))  AS 'Longest Trip',
       MIN(DATEDIFF(day, ArrivalDate, ReturnDate))  AS 'Shortest Trip'
FROM Accounts
JOIN AccountsTrips on Accounts.Id = AccountsTrips.AccountId
JOIN Trips on AccountsTrips.TripId = Trips.Id
WHERE Accounts.MiddleName IS NULL AND CancelDate IS NULL
    GROUP BY Accounts.Id, Accounts.FirstName, Accounts.LastName
ORDER BY [Longest Trip] DESC, [Shortest Trip]

-- 8.
SELECT TOP 10 C.Id,
              C.Name AS City,
              C.CountryCode AS Country,
              COUNT(*) AS 'Accounts'
FROM Accounts AS A
JOIN Cities C on A.CityId = C.Id
GROUP BY C.Id, C.Name, C.CountryCode
ORDER BY Accounts DESC

-- 9.
SELECT A.Id, Email, C.Name, COUNT(*) AS 'Trips'
FROM Accounts AS A
JOIN AccountsTrips T on A.Id = T.AccountId
JOIN Trips T2 on T.TripId = T2.Id
JOIN Rooms R2 on T2.RoomId = R2.Id
JOIN Hotels H on R2.HotelId = H.Id
JOIN Cities C on A.CityId = C.Id
WHERE A.CityId = H.CityId
GROUP BY A.Id, Email, C.Name
ORDER BY Trips DESC, A.Id


--10.
SELECT * FROM (SELECT T2.Id,
       FirstName + ' ' + ISNULL(MiddleName + ' ','') + LastName AS 'Full Name',
       C.Name AS 'From',
       C1.Name AS 'To',
CASE
    WHEN CancelDate IS NOT NULL THEN 'Canceled'
    ELSE CAST(DATEDIFF(day, ArrivalDate, ReturnDate) AS NVARCHAR(20)) + ' days'
END AS Duration
FROM Accounts AS A
JOIN AccountsTrips AS T on A.Id = T.AccountId
JOIN Trips AS T2 on T.TripId = T2.Id
JOIN Rooms AS R2 on T2.RoomId = R2.Id
JOIN Hotels AS H on R2.HotelId = H.Id
JOIN Cities AS C1 ON H.CityId = C1.Id
JOIN Cities AS C on C.Id = A.CityId) AS result

ORDER BY [Full Name], result.Id


--11.
CREATE FUNCTION  udf_GetAvailableRoom(@HotelId INT, @Date DATETIME, @People INT)
RETURNS VARCHAR(150)
AS
    BEGIN
       DECLARE @searchedRoomId INT

       SELECT TOP 1 @searchedRoomId = R.Id FROM Rooms AS R
        JOIN Trips T on R.Id = T.RoomId
        WHERE HotelId = @HotelId
          AND @Date NOT BETWEEN  ArrivalDate AND ReturnDate
       AND T.CancelDate IS NULL
        AND Beds > @People
        ORDER BY R.Price DESC

        IF (@searchedRoomId IS NULL)
            BEGIN
                RETURN 'No rooms available'
            END


        -- find type
        DECLARE @searchedType VARCHAR(50)

        SELECT TOP 1 @searchedType = R.Type FROM Rooms AS R
        JOIN Trips T on R.Id = T.RoomId
        WHERE HotelId = @HotelId
          AND @Date NOT BETWEEN  ArrivalDate AND ReturnDate
        AND T.CancelDate IS NULL
        AND Beds > @People
        ORDER BY R.Price DESC

        -- find bed count
        DECLARE @bedsCount VARCHAR(50)
           SELECT TOP 1  @bedsCount = R.Beds FROM Rooms AS R
        JOIN Trips T on R.Id = T.RoomId
        WHERE HotelId = @HotelId
          AND @Date NOT BETWEEN  ArrivalDate AND ReturnDate
        AND T.CancelDate IS NULL
        AND Beds > @People
        ORDER BY R.Price DESC

        -- find room price
        DECLARE @roomPrice DECIMAL(18,2)
        SELECT TOP 1  @roomPrice = R.Price FROM Rooms AS R
        JOIN Trips T on R.Id = T.RoomId
        WHERE HotelId = @HotelId
          AND @Date NOT BETWEEN  ArrivalDate AND ReturnDate
        AND T.CancelDate IS NULL
        AND Beds > @People
        ORDER BY R.Price DESC

       SELECT TOP 1  @roomPrice = R.Price FROM Rooms AS R
        JOIN Trips T on R.Id = T.RoomId
        WHERE HotelId = @HotelId
          AND @Date NOT BETWEEN  ArrivalDate AND ReturnDate
        AND T.CancelDate IS NULL
        AND Beds > @People
        ORDER BY R.Price DESC

        -- find hotel base rate

        DECLARE @targetBaseRate DECIMAL (18,2)
             SELECT TOP 1 @targetBaseRate = BaseRate
             FROM Hotels WHERE Id = @HotelId

        -- find total price
        DECLARE @totalPrice DECIMAL (18,2)
        SET @totalPrice = (@roomPrice + @targetBaseRate) * @People

       DECLARE @totalPriceAsVARCHAR VARCHAR(15)
       SET @totalPriceAsVARCHAR = CAST(@totalPrice AS VARCHAR(15))
       RETURN 'Room ' + cast(@searchedRoomId AS VARCHAR(5)) +': ' + @searchedType + ' ' + '(' + CAST(@bedsCount as VARCHAR(5)) + ' beds)' + ' - ' + '$' + @totalPriceAsVARCHAR
    END


--12.
CREATE PROCEDURE usp_SwitchRoom(@TripId INT, @TargetRoomId INT )
AS
    BEGIN
        DECLARE @roomHotelId INT
        SET @roomHotelId = (SELECT TOP 1 H.Id FROM Rooms
        JOIN Trips T on Rooms.Id = T.RoomId
        JOIN Hotels H on Rooms.HotelId = H.Id
        WHERE Rooms.Id = @TargetRoomId)

        DECLARE @tripHotelId INT
        SET @tripHotelId = (SELECT TOP 1 H2.Id FROM Trips
        JOIN Rooms R2 on R2.Id = Trips.RoomId
        JOIN Hotels H2 on R2.HotelId = H2.Id
        WHERE Trips.Id = @TripId)

        IF (@roomHotelId != @tripHotelId)
        BEGIN
             THROW 50001,'Target room is in another hotel!',1
        END

        DECLARE @bedsNeeded INT
        SET @bedsNeeded = ( SELECT COUNT(TripId) FROM  Trips
        JOIN AccountsTrips A on Trips.Id = A.TripId
        JOIN Accounts A2 on A.AccountId = A2.Id
        WHERE @TripId = Trips.Id
        GROUP BY TripId)

        DECLARE @bedsExisting INT
        SET @bedsExisting = (SELECT Beds FROM Rooms WHERE Id = @TargetRoomId)

        IF(@bedsNeeded > @bedsExisting)
        BEGIN
            throw 50002,'Not enough beds in target room!',1
        END

        UPDATE Trips
        SET RoomId = @TargetRoomId
           WHERE Id = @TripId

    END