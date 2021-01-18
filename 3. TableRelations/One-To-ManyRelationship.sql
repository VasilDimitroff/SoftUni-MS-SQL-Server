USE TableRelations

CREATE TABLE Manufacturers (
    ManufacturerID INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(40) NOT NULL,
    EstablishedOn DATETIME2 NOT NULL
)

CREATE TABLE Models (
    ModelID INT PRIMARY KEY IDENTITY(101,1),
    [Name] NVARCHAR(40) NOT NULL,
    ManufacturerID INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)