CREATE DATABASE TableRelations
GO

USE TableRelations
GO

-- Problem 01.
CREATE TABLE Passports
(
  PassportID     INT PRIMARY KEY IDENTITY (101,1),
  PassportNumber NVARCHAR(8) NOT NULL UNIQUE,
)

CREATE TABLE Persons
(
  PersonID   INT PRIMARY KEY IDENTITY,
  FirstName  NVARCHAR(30)   NOT NULL,
  Salary     DECIMAL(15, 2) NOT NULL,
  PassportID INT
    CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID) REFERENCES Passports (PassportID),
)

INSERT INTO Passports(PassportNumber)
VALUES ('N34FG21B'),
       ('K65LO4R7'),
       ('ZE657QP2')

INSERT INTO Persons(FirstName, Salary, PassportID)
VALUES ('Roberto', 43300, 102),
       ('Tom', 56100, 103),
       ('Yana', 60200, 101)
GO
-- END --

-- Problem 02.
CREATE TABLE Manufacturers
(
  ManufacturerID INT PRIMARY KEY IDENTITY,
  Name           VARCHAR(20)   NOT NULL,
  EstablishedOn  SMALLDATETIME NOT NULL
)

INSERT INTO Manufacturers(Name, EstablishedOn)
VALUES ('BMW', '07/03/1916'),
       ('Tesla', '01/01/2003'),
       ('Lada', '01/05/1966')

CREATE TABLE Models
(
  ModelID        INT PRIMARY KEY IDENTITY (101,1),
  Name           VARCHAR(15) NOT NULL,
  ManufacturerID INT
    CONSTRAINT FK_Models_Manufacturer FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers (ManufacturerID)
)

INSERT INTO Models(Name, ManufacturerID)
VALUES ('X1', 1),
       ('i6', 1),
       ('Model S', 2),
       ('Model X', 2),
       ('Model 3', 2),
       ('Nova', 3)
-- END --

-- Problem 03.
CREATE TABLE Students
(
  StudentID INT PRIMARY KEY IDENTITY,
  Name      VARCHAR(10) NOT NULL
)

CREATE TABLE Exams
(
  ExamID INT PRIMARY KEY IDENTITY (101,1),
  Name   VARCHAR(15) NOT NULL
)

CREATE TABLE StudentsExams
(
  StudentID INT NOT NULL
    CONSTRAINT FK_Students_Id FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
  ExamID    INT NOT NULL
    CONSTRAINT FK_Exams_Id FOREIGN KEY (ExamID) REFERENCES Exams (ExamID),
  Id        INT PRIMARY KEY (StudentId, ExamId)
)

INSERT INTO Students(Name)
VALUES ('Mila'),
       ('Toni'),
       ('Ron')

INSERT INTO Exams(Name)
VALUES ('SpringMVC'),
       ('Neo4j'),
       ('Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (1, 101),
       (1, 102),
       (2, 101),
       (3, 103),
       (2, 102),
       (2, 103)
GO
-- END --

-- Problem 04.
CREATE TABLE Teachers
(
  TeacherID INT PRIMARY KEY IDENTITY (101,1),
  Name      VARCHAR(10) NOT NULL,
  ManagerID INT
    CONSTRAINT FK_Teachers_Teachers FOREIGN KEY (ManagerID) REFERENCES Teachers (TeacherID) DEFAULT NULL
)

INSERT INTO Teachers(Name, ManagerID)
VALUES ('John', NULL),
       ('Maya', 106),
       ('Silvia', 106),
       ('Ted', 105),
       ('Mark', 101),
       ('Greta', 101)
GO
-- END --

-- Problem 09.
SELECT MountainRange, PeakName, Elevation
FROM Mountains
       LEFT JOIN Peaks ON MountainId = Mountains.Id
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC
-- END --