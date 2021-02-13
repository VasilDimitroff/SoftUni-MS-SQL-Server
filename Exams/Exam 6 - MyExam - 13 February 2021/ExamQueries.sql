CREATE DATABASE Bitbucket

USE Bitbucket


--1. Create tables

CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY,
    Username VARCHAR(30) NOT NULL,
    Password VARCHAR(30) NOT NULL,
    Email VARCHAR(50) NOT NULL
) 

CREATE TABLE Repositories (
    Id INT PRIMARY KEY IDENTITY,
    Name VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors (
    RepositoryId INT NOT NULL REFERENCES Repositories(Id),
    ContributorId INT NOT NULL REFERENCES Users(Id),
    PRIMARY KEY(RepositoryId, ContributorId)
)

CREATE TABLE Issues (
    Id INT PRIMARY KEY IDENTITY,
    Title VARCHAR(255) NOT NULL,
    IssueStatus CHAR(6) NOT NULL,
    RepositoryId INT NOT NULL REFERENCES Repositories(Id),
    AssigneeId INT NOT NULL REFERENCES Users(Id),
)

CREATE TABLE Commits (
    Id INT PRIMARY KEY IDENTITY,
    Message VARCHAR(255) NOT NULL,
    IssueId INT REFERENCES Issues(Id),
    RepositoryId INT NOT NULL REFERENCES Repositories(Id),
    ContributorId INT NOT NULL REFERENCES Users(Id)
)

CREATE TABLE Files (
     Id INT PRIMARY KEY IDENTITY,
    Name VARCHAR(100) NOT NULL,
    Size DECIMAL(18,2) NOT NULL,
    ParentId INT REFERENCES Files(Id),
    CommitId INT NOT NULL REFERENCES Commits(Id)
)

--2. Insert data

INSERT INTO Files(Name, Size, ParentId, CommitId) VALUES
    ('Trade.idk',	2598.0,	1, 1),
    ('menu.net',	9238.31, 2,	2),
    ('Administrate.soshy',	1246.93, 3,	3),
    ('Controller.php',	7353.15, 4,	4),
    ('Find.java',	9957.86, 5,	5),
    ('Controller.json', 14034.87,	3,	6),
    ('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId) VALUES
 ('Critical Problem with HomeController.cs file', 'open',	1,	4),
 ('Typo fix in Judge.html', 'open',	4,	3),
 ('Implement documentation for UsersService.cs', 'closed',	8,	2),
 ('Unreachable code in Index.cs', 'open',	9,	8)


 --3. Update data

 UPDATE Issues
  SET IssueStatus = 'closed'
  WHERE AssigneeId = 6

  -- 4. Delete data

DELETE FROM RepositoriesContributors WHERE RepositoryId = 3

DELETE FROM Issues WHERE RepositoryId = 3

DELETE FROM Files WHERE CommitId = 36

DELETE FROM Commits WHERE RepositoryId = 3

DELETE FROM Repositories WHERE Name = 'Softuni-Teamwork'

-- 5. Commits

SELECT Id, [Message], RepositoryId, ContributorId FROM Commits
ORDER BY Id, [Message], RepositoryId, ContributorId

--6. Frontend

SELECT Id, Name, Size FROM Files
WHERE Size > 1000 AND Name LIKE '%html%'
ORDER BY Size DESC, Id, Name

-- 7. Issue Assignment

SELECT i.Id, u.Username + ' : ' + i.Title
 FROM Issues AS i
JOIN Users AS u ON i.AssigneeId = u.Id
ORDER BY i.Id DESC, i.AssigneeId

--8. Single Files

SELECT parent.Id,
     parent.Name,
      CAST(parent.Size AS VARCHAR) + 'KB' 
FROM Files AS parent
LEFT JOIN Files AS child ON child.ParentId = parent.Id
WHERE child.ParentId IS NULL
ORDER BY parent.Id, parent.Name, parent.[Size]

-- 9. Commits in Repositories

SELECT TOP 5 rc.RepositoryId, r.Name, COUNT(*)
FROM RepositoriesContributors AS rc
JOIN Repositories AS r ON rc.RepositoryId = r.Id
JOIN Commits AS c ON c.RepositoryId = r.Id
GROUP BY  rc.RepositoryId, r.Name
ORDER BY COUNT(*) DESC, rc.RepositoryId, r.Name


-- 10.Average Size

SELECT Username, AVG(Size)
FROM Commits AS c
LEFT JOIN Users AS u ON c.ContributorId = u.Id
JOIN Files AS f ON f.CommitId = c.Id
GROUP BY ContributorId, u.Username
ORDER BY AVG(Size) DESC, u.Username


-- 11.All User Commits - create function

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @commitsCount INT = (SELECT COUNT(*)
     FROM Commits AS c 
     JOIN Users AS u ON c.ContributorId = u.Id
     WHERE Username = @username)

     RETURN @commitsCount
END

-- example usage
SELECT dbo.udf_AllUserCommits('UnderSinduxrein')


-- 12. Search for files - create stored procedure

CREATE PROCEDURE usp_SearchForFiles(@fileExtension VARCHAR(20)) 
AS
BEGIN
   SELECT Id,
         Name,
         CAST(Size AS VARCHAR) + 'KB' AS Size
   FROM Files
   WHERE Name LIKE '%' + @fileExtension
   ORDER BY Id, Name, Size
END

GO

-- example usage
EXEC usp_SearchForFiles 'txt'