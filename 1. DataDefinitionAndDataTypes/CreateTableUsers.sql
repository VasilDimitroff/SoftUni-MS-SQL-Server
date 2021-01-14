USE Minions

CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY,
    Username VARCHAR(30) UNIQUE NOT NULL,
    Password VARCHAR(26) NOT NULL,
    ProfilePicture VARBINARY(900),
    LastLoginTime DATETIME2 NOT NULL,
    IsDeleted VARCHAR(5) NOT NULL CHECK (IsDeleted IN('true', 'false'))
)

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES('Tisho20','qwerty', NULL, '1993-06-01', 'false'),
      ('Misho20','gfrty', NULL, '1999-03-02', 'true'),
      ('Gosho20','qwesdrty', NULL, '1991-07-04', 'false'),
      ('Pesho20','sdwerty', NULL, '1999-09-03', 'true'),
      ('Vesko20','qdfegrty', NULL, '1994-01-08', 'false')


