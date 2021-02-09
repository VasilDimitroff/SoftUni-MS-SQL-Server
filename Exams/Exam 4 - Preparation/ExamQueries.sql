CREATE DATABASE School

USE School

-- 1.Database Design

CREATE TABLE Students (
    Id INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(25),
    LastName NVARCHAR(30) NOT NULL,
    Age INT CHECK (Age >= 5 AND Age <= 100),
    Address NVARCHAR(50),
    Phone NCHAR(10) 
)

CREATE TABLE Subjects (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(20) NOT NULL,
    Lessons INT NOT NULL CHECK(Lessons > 0)
)

CREATE TABLE StudentsSubjects (
    Id INT PRIMARY KEY IDENTITY,
    StudentId INT NOT NULL REFERENCES Students(Id),
    SubjectId INT NOT NULL REFERENCES Subjects(Id),
    Grade DECIMAL(18,2) NOT NULL CHECK (Grade BETWEEN 2 AND 6)
)

CREATE TABLE Exams (
    Id INT PRIMARY KEY IDENTITY,
    [Date] DATETIME ,
    SubjectId INT NOT NULL REFERENCES Subjects(Id)
)

CREATE TABLE StudentsExams (
    StudentId INT NOT NULL REFERENCES Students(Id),
    ExamId INT NOT NULL REFERENCES Exams(Id),
    Grade DECIMAL(18,2) NOT NULL CHECK (Grade BETWEEN 2 AND 6),
    PRIMARY KEY(StudentId, ExamId)
)

CREATE TABLE Teachers (
    Id INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Address NVARCHAR(20) NOT NULL,
    Phone NCHAR(10),
    SubjectId INT NOT NULL REFERENCES Subjects(Id)
)

CREATE TABLE StudentsTeachers (
    StudentId INT NOT NULL REFERENCES Students (Id),
    TeacherId INT NOT NULL REFERENCES Teachers (Id),   
    PRIMARY KEY (StudentId, TeacherId)
)


-- 2. Insert some sample data into the database.
INSERT INTO Teachers(FirstName, LastName, Address, Phone, SubjectId) VALUES
('Ruthanne', 'Bamb','84948 Mesta Junction',	'3105500146', 6),
('Gerrard', 'Lowin', '370 Talisman Plaza','3324874824',	2),
('Merrile', 'Lambdin',	'81 Dahle Plaza', '4373065154',	5),
('Bert', 'Ivie', '2 Gateway Circle',	'4409584510', 4)

INSERT INTO Subjects([Name], Lessons)
 VALUES 
('Geometry', 12),
('Health', 10),
('Drama', 7),
('Sports', 9)


-- 3. Make all grades 6.00, where the subject id is 1 or 2,
-- if the grade is above or equal to 5.50

UPDATE StudentsSubjects
SET Grade = 6.00
WHERE ((SubjectId IN (1, 2)) AND Grade >= 5.50)

-- 4. Delete all teachers, whose phone number contains ‘72’.

DELETE st
FROM StudentsTeachers AS st
INNER JOIN Teachers AS T
  ON st.TeacherId = T.Id
WHERE T.Phone LIKE '%72%'

DELETE FROM Teachers
WHERE Phone LIKE '%72%'

-- 5. Select all students where age is above or equal to 12. 
--Order them by first name (alphabetically), then by last name (alphabetically).

SELECT FirstName, LastName, Age 
FROM Students
WHERE Age >= 12
ORDER BY FirstName, LastName

-- 6. Select all students and the count of teachers each one has. 

SELECT s.FirstName, s.LastName, COUNT(*) AS TeachersCount
FROM Students AS s
JOIN StudentsTeachers AS st ON s.Id = st.StudentId
GROUP BY s.FirstName, s.LastName

-- 7. Find all students, who have not attended an exam. Select full name
-- Order the results by full name ASC.

SELECT FirstName + ' ' + LastName AS [Full Name] 
FROM Students AS s
LEFT JOIN StudentsExams AS se ON s.Id = se.StudentId
WHERE Grade IS NULL
ORDER BY FirstName, LastName

-- 8. Find top 10 students, who have highest average grades from the exams.
--Format the grade, two symbols after the decimal point.
-- Order  by grade DESC, then by first name ASC, then by last name (ascending)

SELECT TOP 10 FirstName AS [First Name],
    LastName AS [Last Name],
    CAST((ROUND(AVG(Grade), 2)) AS DECIMAL(4,2)) AS [Grade]
FROM Students AS s
JOIN StudentsExams AS se ON se.StudentId = s.Id
GROUP BY FirstName, LastName
ORDER BY [Grade] DESC, FirstName, LastName

-- 9. Find all students who don’t have any subjects. Select their full name. 
-- Order the result by full name

SELECT FirstName + ' ' + ISNULL( MiddleName + ' ', '')  + LastName  AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsSubjects AS ss ON ss.StudentId = s.Id
WHERE SubjectId IS NULL
ORDER BY [Full Name]

USE School

-- 10. Find the average grade for each subject. Select the subject name and the average grade. 
--Sort them by subject id (ascending).

SELECT [Name], 
        AVG(Grade)  AS AverageGrade
FROM Subjects AS s
JOIN StudentsSubjects AS ss ON s.Id = ss.SubjectId
GROUP BY [SubjectId], [Name]
ORDER BY SubjectId

-- 11. Create function

CREATE FUNCTION udf_ExamGradesToUpdate (@studentId INT, @grade DECIMAL (18,2))
RETURNS VARCHAR(250)
AS
BEGIN

  DECLARE @targetStudentId INT = (SELECT COUNT(*) 
		FROM Students
		WHERE Id = @studentId)

  IF (@targetStudentId = 0)
  BEGIN
    RETURN 'The student with provided id does not exist in the school!';
  END

  IF(@grade > 6.00)
  BEGIN
   RETURN 'Grade cannot be above 6.00!';
  END

  DECLARE @gradesCount INT = (SELECT COUNT(*) FROM 
    Students AS s
  JOIN StudentsExams AS se ON s.Id = se.StudentId
  WHERE Grade >= @grade AND Grade <= (@grade + 0.50) AND s.Id = @studentId)

  DECLARE @studentName VARCHAR(50) = (SELECT TOP 1 [FirstName] 
	FROM Students 
	WHERE Id = @studentId)

  DECLARE @gradesCountAsVarchar VARCHAR(15) = CAST(@gradesCount AS VARCHAR(15)) 

  RETURN 'You have to update ' + @gradesCountAsVarchar + ' grades for the student ' + @studentName
END

GO

--- example usage

SELECT dbo.udf_ExamGradesToUpdate(12, 6.20)
SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)
SELECT dbo.udf_ExamGradesToUpdate(121, 5.50)

-- 12. Create Stored Procedure

CREATE PROCEDURE usp_ExcludeFromSchool (@studentId INT)
AS
BEGIN
DECLARE @targetStudentId INT = (
	SELECT COUNT(*) FROM Students WHERE Id = @studentId)

	IF(@targetStudentId = 0)
	BEGIN
		THROW 50005, N'This school has no student with the provided id!', 1;
		RETURN
	END

	DELETE FROM StudentsExams WHERE StudentId = @studentId
	DELETE FROM StudentsTeachers WHERE StudentId = @studentId
	DELETE FROM StudentsSubjects WHERE StudentId = @studentId
	DELETE FROM Students WHERE Id = @studentId
END

-- example usages

EXEC dbousp_ExcludeFromSchool 1
SELECT COUNT(*) FROM Students

EXEC dbousp_ExcludeFromSchool 301