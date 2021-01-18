CREATE DATABASE TableRelations

USE TableRelations

CREATE  TABLE Passports (
    PassportID INT PRIMARY KEY IDENTITY(101, 1),
    PassportNumber NVARCHAR(30) NOT NULL
)

CREATE  TABLE Persons (
    PersonID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(30) NOT NULL,
    Salary DECIMAL(18,2) NOT NULL,
    PassportID INT NOT NULL FOREIGN KEY REFERENCES Passports(PassportID)
)