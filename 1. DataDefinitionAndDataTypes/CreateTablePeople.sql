USE Minions

CREATE TABLE People (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(200) NOT NULL,
    Picture VARBINARY(MAX),
    Height DECIMAL(5,2),
    Weight DECIMAL(5,2),
    Gender CHAR(1) NOT NULL CHECK (Gender IN('m', 'f')),
    Birthdate DATETIME2 NOT NULL,
    Biography NVARCHAR(MAX)
)

INSERT INTO People ([Name],Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Tosho', NULL, 523.00,221.00, 'm', '1992-05-12', 'Nai gotiniq' ),
       ('Misho', NULL, 123.00,721.00, 'm', '1999-06-16', 'Velikan' ),
       ('Pesho', NULL, 623.00, 321.00, 'm', '1993-02-18', 'Nai dobriq na CS' ),
       ('Niki', NULL, 823.00, 121.00, 'm', '1995-01-14', 'Mastera' ),
       ('Sasho', NULL, 133.00,921.00, 'm', '1996-08-13', 'Svejarkata' )

