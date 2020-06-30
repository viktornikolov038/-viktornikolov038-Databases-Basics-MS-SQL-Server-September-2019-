-- DDL --
CREATE DATABASE School
USE School

CREATE TABLE Students
(
    Id         INT PRIMARY KEY IDENTITY,
    FirstName  NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(25),
    LastName   NVARCHAR(30) NOT NULL,
    Age        INT
        CONSTRAINT CHK_Age CHECK (Age >= 5 AND AGE <= 100),
    Address    NVARCHAR(50),
    Phone      NCHAR(10)
)

CREATE TABLE Subjects
(
    Id      INT PRIMARY KEY IDENTITY,
    Name    NVARCHAR(20) NOT NULL,
    Lessons INT
        CONSTRAINT CHK_Lessons CHECK (Lessons > 0)
)

CREATE TABLE StudentsSubjects
(
    Id        INT PRIMARY KEY IDENTITY,
    StudentId INT            NOT NULL
        CONSTRAINT FK_StudentSubjects_Students FOREIGN KEY (StudentId) REFERENCES Students (Id),
    SubjectId INT            NOT NULL
        CONSTRAINT FK_StudentsSubjects_Students FOREIGN KEY (SubjectId) REFERENCES Subjects (Id),
    Grade     DECIMAL(15, 2) NOT NULL
        CONSTRAINT CHK_Grade CHECK (Grade >= 2 AND Grade <= 6)
)

CREATE TABLE Exams
(
    Id        INT PRIMARY KEY IDENTITY,
    Date      DATETIME,
    SubjectId INT NOT NULL
        CONSTRAINT FK_Exams_Subjects FOREIGN KEY (SubjectId) REFERENCES Subjects (Id),
)

CREATE TABLE StudentsExams
(
    StudentId INT            NOT NULL
        CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentId) REFERENCES Students (Id),
    ExamId    INT            NOT NULL
        CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamId) REFERENCES Exams (Id),
    Grade     DECIMAL(15, 2) NOT NULL
        CONSTRAINT CHK_Grade_Again CHECK (Grade >= 2 AND Grade <= 6),
    PRIMARY KEY (StudentId, ExamId)
)

CREATE TABLE Teachers
(
    Id        INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(20) NOT NULL,
    LastName  NVARCHAR(20) NOT NULL,
    Address   NVARCHAR(20) NOT NULL,
    Phone     CHAR(10),
    SubjectId INT          NOT NULL
        CONSTRAINT FK_Teachers_Subjects FOREIGN KEY (SubjectId) REFERENCES Subjects (Id)
)

CREATE TABLE StudentsTeachers
(
    StudentId INT NOT NULL
        CONSTRAINT FK_StudentsTeachers_Students FOREIGN KEY (StudentId) REFERENCES Students (Id),
    TeacherId INT NOT NULL
        CONSTRAINT FK_StudentsTeachers_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers (Id),
    PRIMARY KEY (StudentId, TeacherId)
)

-- END OF DDL --

-- SECOND SECTION --
--Problem 02.--
INSERT INTO Teachers
VALUES ('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
       ('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', 2),
       ('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
       ('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)

INSERT INTO Subjects
VALUES ('Geometry', 12),
       ('Health', 10),
       ('Drama', 7),
       ('Sports', 9)
-- END --

--Problem 03.--
UPDATE StudentsSubjects
SET Grade = 6.00
WHERE SubjectId IN (1, 2)
  AND Grade >= 5.50;
-- END --

--Problem 04.--
ALTER TABLE StudentsTeachers
    DROP CONSTRAINT FK_StudentsTeachers_Teachers;

ALTER TABLE StudentsTeachers
    ADD CONSTRAINT
        FK_StudentsTeachers_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers (Id) ON DELETE CASCADE

DELETE
FROM Teachers
WHERE Phone LIKE '%72%'
-- END --

-- THIRD SECTION --
--Problem 05.--
SELECT FirstName, LastName, Age
FROM Students
WHERE Age >= 12
ORDER BY FirstName, LastName
-- END --

--Problem 06.--
SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) [Full Name], Address
FROM Students
WHERE Address LIKE '%road%'
ORDER BY FirstName, LastName, Address
-- END --

--Problem 07.--
SELECT FirstName, Address, Phone
FROM Students
WHERE MiddleName IS NOT NULL
  AND Phone LIKE '42%'
ORDER BY FirstName
-- END --

--Problem 08.--
SELECT FirstName, LastName, COUNT(sc.TeacherId) [TeachersCount]
FROM Students [s]
         JOIN StudentsTeachers [sc] ON sc.StudentId = s.Id
GROUP BY FirstName, LastName
-- END --

--Problem 09.--
SELECT CONCAT(FirstName, ' ', LastName) [FullName]
     ,CONCAT(s.Name, '-', s.Lessons)    [Subjects]
     ,COUNT(st.StudentId)               [Students]
FROM Teachers [t]
         JOIN Subjects [s] ON s.Id = t.SubjectId
         JOIN StudentsTeachers [st] ON t.Id = st.TeacherId
GROUP BY FirstName, LastName, s.Name, s.Lessons
ORDER BY Students DESC
-- END --

--Problem 10.--
SELECT DISTINCT CONCAT(FirstName, ' ', LastName) [Full Name]
FROM Students [s]
         LEFT JOIN StudentsExams [se] ON se.StudentId = s.Id
WHERE se.StudentId IS NULL
ORDER BY [Full Name]
-- END --

--Problem 11.--
SELECT TOP (10) t.FirstName, t.LastName, COUNT(st.StudentId) [StudentCount]
FROM Teachers [t]
         JOIN StudentsTeachers [st] ON st.TeacherId = t.Id
GROUP BY t.FirstName, t.LastName
ORDER BY StudentCount DESC, FirstName
-- END --

--Problem 12.--
SELECT TOP (10) FirstName, LastName, FORMAT(ROUND(AVG(se.Grade), 2), '#.00') [Grade]
FROM Students [s]
         JOIN StudentsExams [se] ON se.StudentId = s.Id
GROUP BY s.FirstName, s.LastName
ORDER BY Grade DESC, FirstName, LastName
-- END --

--Problem 13.--
SELECT FirstName,
       LastName,
       Grade --, Rank
FROM (SELECT s.FirstName,
             s.LastName,
             ss.Grade,
             DENSE_RANK() OVER (PARTITION BY s.FirstName, s.LastName ORDER BY Grade DESC, ss.Id) [Rank]
      FROM Students [s]
               JOIN StudentsSubjects [ss] ON ss.StudentId = s.Id
               JOIN Subjects [sb] ON sb.Id = ss.SubjectId) [tmp]
WHERE Rank = 2
ORDER BY FirstName, LastName
-- END --

--Problem 14.--
SELECT DISTINCT CONCAT(FirstName, ' ' + MiddleName, ' ', LastName) [Full Name]
FROM Students [s]
         LEFT JOIN StudentsSubjects [ss] ON s.Id = ss.StudentId
WHERE ss.StudentId IS NULL
ORDER BY [Full Name]
-- END --

--Problem 15.--
SELECT [Teacher Full Name],
       [Subject Name],
       [Student Full Name],
       Grade --,Rank
FROM (SELECT CONCAT(t.FirstName, ' ' + t.LastName)  [Teacher Full Name],
             s.Name                                 [Subject Name],
             CONCAT(st.FirstName, ' ', st.LastName) [Student Full Name],
             FORMAT(AVG(ss.Grade), '#.00')          [Grade]
      FROM Teachers [t]
               JOIN Subjects [s] ON s.Id = t.SubjectId
               JOIN StudentsSubjects [ss] ON ss.SubjectId = s.Id
               JOIN Students [st] ON st.Id = ss.StudentId) [tmp]
WHERE Rank = 1
ORDER BY [Subject Name], [Teacher Full Name], Grade DESC
-- END --

-- Problem 16.--
SELECT sb.Name, AVG(ss.Grade) [AverageGrade]
FROM Subjects [sb]
         JOIN StudentsSubjects [ss] ON ss.SubjectId = sb.Id
GROUP BY sb.Id, sb.Name
ORDER BY sb.Id
-- END --

--Problem 17.--
SELECT Quarter, Name, COUNT(StudentId) [Count]
FROM (SELECT IIF(e.Date IS NULL, 'TBA', CONCAT('Q', DATEPART(QUARTER, e.Date))) [Quarter],
             s.Name,
             se.StudentId
      FROM Exams [e]
               JOIN StudentsExams [se] ON se.ExamId = e.Id
               JOIN Subjects [s] ON s.Id = e.SubjectId
      WHERE se.Grade >= 4.00) [tb]
GROUP BY Quarter, Name
ORDER BY Quarter
-- END --

--Problem 18.--
GO
CREATE OR ALTER FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(15, 2))
RETURNS VARCHAR(MAX) AS
BEGIN
    DECLARE @studentFoundId INT = (SELECT TOP 1 Id FROM Students Where Id = @studentId);
    DECLARE @output VARCHAR(MAX)

    IF (@studentFoundId IS NULL)
        BEGIN
            SET @output = 'The student with provided id does not exist in the school!';
            RETURN @output;
        END

    IF (@grade > 6.00)
        BEGIN
            SET @output = 'Grade cannot be above 6.00!';
            RETURN @output;
        END

    DECLARE @gradeCount INT = (
        SELECT COUNT(*) [count]
        FROM StudentsExams [se]
                 JOIN Students [s] ON s.Id = se.StudentId AND s.Id = @studentId
        WHERE se.Grade BETWEEN 5.50 AND 5.50 + 0.50
    )

    DECLARE @studentName VARCHAR(MAX) = (SELECT FirstName FROM Students WHERE Id = @studentId);
    SET @output = CONCAT('You have to update ', @gradeCount, ' grades for the student ', @studentName);
    RETURN @output;

END
GO
SELECT dbo.udf_ExamGradesToUpdate(121, 5.50)
GO
-- END --

--Problem 19.--
CREATE OR ALTER PROC usp_ExcludeFromSchool(@StudentId INT)
AS
DECLARE @student INT = (SELECT Id
                        FROM Students
                        WHERE Id = @StudentId);

IF (@student IS NULL)
    BEGIN
        RAISERROR ('This school has no student with the provided id!',16,1)
    END

    ALTER TABLE StudentsTeachers
        DROP CONSTRAINT FK_StudentsTeachers_Students;

    ALTER TABLE StudentsSubjects
        DROP CONSTRAINT FK_StudentsSubjects_Students;

    ALTER TABLE StudentsExams
        DROP CONSTRAINT FK_StudentsExams_Students;


    ALTER TABLE StudentsTeachers
        ADD CONSTRAINT FK_ST_S FOREIGN KEY (StudentId) REFERENCES Students (Id) ON DELETE CASCADE

    ALTER TABLE StudentsSubjects
        ADD CONSTRAINT FK_SS_S FOREIGN KEY (StudentId) REFERENCES Students (Id) ON DELETE CASCADE

    ALTER TABLE StudentsExams
        ADD CONSTRAINT FK_SE_S FOREIGN KEY (StudentId) REFERENCES Students (Id) ON DELETE CASCADE
    DELETE
    FROM Students
    WHERE Id = @StudentId
    EXEC usp_ExcludeFromSchool 1
    SELECT COUNT(*)
    FROM Students

GO
-- END --

--Problem 20.--
CREATE TABLE ExcludedStudents
(
    StudentId   INT          NOT NULL,
    StudentName VARCHAR(100) NOT NULL
)
GO

CREATE TRIGGER tr_Exclusion
    ON Students
    FOR DELETE
    AS
    INSERT INTO ExcludedStudents
    SELECT Id, CONCAT(FirstName, ' ', LastName) [name]
    FROM deleted;
-- END --
