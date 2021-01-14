CREATE DATABASE Movies

CREATE TABLE Directors (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    DirectorName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(1000)
)

CREATE TABLE Genres (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    GenreName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(1000)
)

CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    CategoryName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(1000)
)

CREATE TABLE Movies (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Title NVARCHAR(50) NOT NULL,
    DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
    CopyrightYear INT,
    Length INT,
    GenreId INT FOREIGN KEY REFERENCES Genres(Id),
    CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
    Rating TINYINT,
    Notes NVARCHAR(1000)
)

INSERT INTO Directors (DirectorName, Notes)
VALUES ('Bai Tosho', 'The greatest director in the world'),
       ('Qnaki Stoilov', 'The greatest comedy actor'),
       ('Boiko Borisov', 'The greatest clown'),
       ('Volen Siderov', 'The greatest drugman in Holywoood'),
       ('Ivan Kostov', 'The most blue politician')

INSERT INTO Genres (GenreName, Notes)
VALUES ('Drama', 'Most sad genre'),
       ('Action', 'Boom-boom'),
       ('Comedy', 'ha-ha in this genre'),
       ('Cartoon', 'All kids on the horo'),
       ('Serial', 'Everyday on your TV')

INSERT INTO Categories (CategoryName, Notes)
VALUES ('18+', 'Indentity card need'),
       ('For Kids', 'For the youngest'),
       ('Family', 'For you and your wife'),
       ('Friends', 'All friends'),
       ('Daily', 'Everyday shows')

INSERT INTO Movies
    (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES ('The last mochican', 2, 1999, 123, 1, 3, 10, 'no notes'),
       ('Vinetu', 3, 2001, 213, 2, 1, 3, 'no notes'),
       ('Indiana Jones', 1, 1995, 223, 2, 2, 9, 'no notes'),
       ('Spiderman 2', 5, 2004, 90, 2, 4, 10, 'no notes'),
       ('Batman Forever', 4, 1991, 83, 2, 5, 4, 'no notes')
