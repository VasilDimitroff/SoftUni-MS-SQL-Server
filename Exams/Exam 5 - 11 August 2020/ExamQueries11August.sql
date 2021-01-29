CREATE DATABASE Bakery

USE Bakery

-- 1. Create tables

CREATE TABLE  Countries (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] NVARCHAR(50) UNIQUE ,
)

CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY ,
    FirstName NVARCHAR(25),
    LastName NVARCHAR(25),
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    Age INT,
    PhoneNumber CHAR(10),
    CountryId INT REFERENCES Countries(Id)
)

CREATE TABLE Products (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] NVARCHAR(25) UNIQUE ,
    Description NVARCHAR(250),
    Recipe NVARCHAR(MAX),
    Price DECIMAL(18,4) CHECK (Price >= 0)
)

CREATE TABLE Feedbacks (
    Id INT PRIMARY KEY IDENTITY ,
    Description NVARCHAR(255),
    Rate DECIMAL(4,2) CHECK (Rate BETWEEN 0 AND 10),
    ProductId INT REFERENCES Products(Id),
    CustomerId INT REFERENCES Customers(Id)
)

CREATE TABLE Distributors (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] NVARCHAR(25) UNIQUE ,
    AddressText NVARCHAR(30),
    Summary NVARCHAR(200),
    CountryId INT REFERENCES Countries(Id)
)

CREATE TABLE Ingredients (
    Id INT PRIMARY KEY IDENTITY ,
    [Name] NVARCHAR(30),
    Description NVARCHAR(200),
    OriginCountryId INT REFERENCES Countries(Id),
    DistributorId INT REFERENCES Distributors(Id)
)

CREATE TABLE ProductsIngredients (
    ProductId INT NOT NULL REFERENCES Products(Id),
    IngredientId INT NOT NULL REFERENCES Ingredients(Id),
    PRIMARY KEY (ProductId, IngredientId)
)

-- 2. Insert data

INSERT INTO Distributors([Name], CountryId, AddressText, Summary)
VALUES ('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
       ('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
       ('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
       ('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
       ('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

INSERT INTO Customers(FirstName, LastName, Age, Gender, PhoneNumber, CountryId)
VALUES ('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
       ('Kendra', 'Loud', 22, 'F', '0063631526', 11),
       ('Lourdes', 'Bauswell', 50, 'M', '0139037043',8),
       ('Hannah', 'Edmison', 18, 'F', '0043343686',1),
       ('Tom', 'Loeza', 31, 'M', '0144876096',23),
       ('Queenie', 'Kramarczyk', 30, 'F', '0064215793',29),
       ('Hiu', 'Portaro', 25, 'M', '0068277755',16),
       ('Josefa', 'Opitz', 43, 'F', '0197887645',17)


-- 3. Update

UPDATE Ingredients
SET DistributorId = 35
WHERE Name IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8

-- 4. Delete data

DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5

-- QUERYING PART

-- 5.Products by Price

SELECT [Name], Price, Description FROM Products
ORDER BY  Price DESC, [Name] ASC

-- 6.Negative Feedback

SELECT ProductId, Rate, Description, CustomerId, Age, Gender FROM Feedbacks AS F
JOIN Customers C on F.CustomerId = C.Id
WHERE Rate < 5.0
ORDER BY ProductId DESC, Rate

-- 7.Customers without Feedback

SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName,
       PhoneNumber,
       Gender
FROM Customers
LEFT JOIN Feedbacks F on Customers.Id = F.CustomerId
WHERE F.Id IS NULL
ORDER BY CustomerId

-- 8.Customers by Criteria

SELECT FirstName, Age, PhoneNumber FROM Customers
JOIN Countries C on Customers.CountryId = C.Id
WHERE Age >= 21
  AND (FirstName LIKE '%an%' OR PhoneNumber LIKE '%38')
    AND C.Name != 'Greece'
ORDER BY FirstName, Age DESC


-- 9. Middle Range Distributors

SELECT Distributors.Name,	I.Name,	P.Name, AVG(Rate) FROM Distributors
JOIN Ingredients I on Distributors.Id = I.DistributorId
JOIN ProductsIngredients PI on I.Id = PI.IngredientId
JOIN Products P on PI.ProductId = P.Id
JOIN Feedbacks F on P.Id = F.ProductId
WHERE F.Rate BETWEEN 5 AND 8 AND P.Name IS NOT NULL
GROUP BY Distributors.Name,	I.Name,	P.Name
ORDER BY Distributors.Name,	I.Name,	P.Name

-- 10.Country Representative - NOT fully SOLVED

SELECT  C.Name, D.Name
FROM Countries C
JOIN Ingredients I ON I.OriginCountryId = C.Id
JOIN Distributors D on C.Id = D.CountryId
GROUP BY C.Name, D.Name
ORDER BY C.Name, D.Name

-- 11.Customers with Countries

CREATE VIEW  v_UserWithCountries
AS
    SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName,
           Age,
           Gender,
           C.Name FROM Customers
    JOIN Countries C on Customers.CountryId = C.Id

-- 12. Delete Products Trigger

CREATE TRIGGER tr_DeleteRelations ON Products INSTEAD OF DELETE
    AS

    DELETE PI
    FROM ProductsIngredients PI
    JOIN deleted ON PI.ProductId = deleted.Id
    WHERE PI.ProductId = deleted.Id

    DELETE f
    FROM Feedbacks f
    JOIN deleted ON f.ProductId = deleted.Id
    WHERE f.ProductId = deleted.Id

    DELETE P FROM Products AS P
    JOIN deleted ON P.Id = deleted.Id

GO

-- example usage
DELETE FROM Products WHERE Id = 7