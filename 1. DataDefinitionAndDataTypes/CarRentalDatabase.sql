CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    CategoryName NVARCHAR(50) NOT NULL,
    [DailyRate] DECIMAL (4,2),
    WeeklyRate DECIMAL (4,2),
    MonthlyRate DECIMAL (4,2),
    WeekendRate DECIMAL (4,2),
)

CREATE TABLE Cars (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    PlateNumber NVARCHAR(20) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    Model NVARCHAR(20) NOT NULL,
    CarYear INT NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(Id),
    Doors INT,
    Picture VARBINARY(MAX),
    Condition NVARCHAR(50),
    Available BIT NOT NULL
)

CREATE TABLE Employees (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    Title NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(1000)
)

CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    DriverLicenceNumber INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(150),
    City NVARCHAR(30),
    ZIPCode INT,
    Notes NVARCHAR(1000)
)


CREATE TABLE RentalOrders (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
    CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
    CarId INT FOREIGN KEY REFERENCES Cars(Id),
    TankLevel INT NOT NULL,
    KilometrageStart INT,
    KilometrageEnd INT,
    TotalKilometrage INT,
    StartDate DATETIME2,
    EndDate DATETIME2,
    TotalDays INT,
    RateApplied DECIMAL (4,2),
    TaxRate DECIMAL (4,2),
    OrderStatus NVARCHAR(30) NOT NULL,
     Notes NVARCHAR(1000)
)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES ('Sedan', 12.50, 13.50,16.50, 11.00),
       ('Truck', 12.50, 12.50,13.50, 12.00),
       ('Electric', 12.50, 17.50,11.50, 13.00)

INSERT INTO Cars
    (PlateNumber, Manufacturer, Model, CarYear,
     CategoryId, Doors, Picture, Condition, Available)
VALUES ('EV1234MG', 'Audi', 'A4', 1992, 2, 4, NULL, 'Good', 1),
       ('SA3214RE', 'BMW', 'X5', 2005, 1, 2, NULL, 'Excellent', 0),
       ('BU5676GB', 'Lada', 'Niva', 1982, 3, 4, NULL, 'Very Good', 1)


INSERT INTO Employees  (FirstName, LastName, Title, Notes)
VALUES ('Pesho', 'Peshev', 'CEO', 'no notes'),
       ('Tosho', 'Toshev', 'Cashier', 'no notes'),
       ('Tisho', 'Tishev', 'Manager', 'no notes')


INSERT INTO Customers  (DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
VALUES (343242, 'Adam Darski', 'Warsaw street', 'Warsaw', 1234, 'no notes'),
       (343242, 'Corey Taylor', 'Iowa street', 'Iowa', 2244, 'no notes'),
       (343242, 'Shagrath Vortex', 'Oslo street', 'Oslo', 5414, 'no notes')


INSERT INTO RentalOrders
    (EmployeeId, CustomerId, CarId, TankLevel,
     KilometrageStart, KilometrageEnd, TotalKilometrage,
     StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
VALUES (1, 2, 3, 123, 1, 1000, 2000, '1999-01-02', '2008-04-01', 50, 10.30, 10.01, 'Confirmed', 'no notes'),
       (3, 1, 2, 312, 5, 2000, 1000, '1995-01-02', '2006-02-07', 150, 10.12, 10.11, 'Confirmed', 'no notes'),
       (2, 3, 1, 516, 10, 1200, 500, '1998-01-02', '2003-01-05', 250, 10.00, 10.32, 'Confirmed', 'no notes')
