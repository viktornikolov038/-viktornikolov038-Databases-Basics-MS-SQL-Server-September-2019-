--CREATE DATABASE ColonialJourney
USE ColonialJourney

CREATE TABLE Planets(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PlanetId INT FOREIGN KEY (PlanetId) REFERENCES Planets(Id)
)

CREATE TABLE Spaceships(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(30) NOT NULL,
	LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Ucn VARCHAR(10) NOT NULL UNIQUE,
	BirthDate DATE NOT NULL
)

CREATE TABLE Journeys(
	Id INT PRIMARY KEY IDENTITY,
	JourneyStart DATETIME NOT NULL,
	JourneyEnd DATETIME NOT NULL,
	Purpose VARCHAR(11) 
		CHECK(Purpose IN ('Medical', 'Technical', 'Educational', 'Military')),
	DestinationSpaceportId INT NOT NULL 
		FOREIGN KEY (DestinationSpaceportId) REFERENCES Spaceports(Id),
	SpaceshipId INT NOT NULL FOREIGN KEY (SpaceshipId) REFERENCES Spaceships(Id)
)

CREATE TABLE TravelCards(
	Id INT PRIMARY KEY IDENTITY,
	CardNumber CHAR(10) NOT NULL UNIQUE,
	JobDuringJourney VARCHAR(8) 
		CHECK (JobDuringJourney IN ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
	ColonistId INT NOT NULL FOREIGN KEY (ColonistId) REFERENCES Colonists(Id),
	JourneyId INT NOT NULL FOREIGN KEY (JourneyId) REFERENCES Journeys(Id)
)

-- END OF DDL --

-- INSERT02 --
INSERT INTO Planets 
VALUES ('Mars'),
	   ('Earth'),
	   ('Jupiter'),
	   ('Saturn');

INSERT INTO Spaceships 
VALUES ('Golf',	'VW', 3),
	   ('WakaWaka',	'Wakanda', 4),
	   ('Falcon9', 'SpaceX', 1),
	   ('Bed', 'Vidolov', 6);

-- UPDATE03
UPDATE Spaceships
SET LightSpeedRate += 1
WHERE Id BETWEEN 8 AND 12;

-- DELETE04
ALTER TABLE TravelCards
ALTER COLUMN JourneyId INT

DELETE FROM TravelCards
WHERE JourneyId IN (1,2,3)

DELETE FROM Journeys
WHERE Id IN (1,2,3)

-- 05
SELECT CardNumber, JobDuringJourney FROM TravelCards
ORDER BY CardNumber

-- 06
SELECT Id, CONCAT(FirstName, ' ' + LastName), Ucn 
FROM Colonists
ORDER BY FirstName, LastName, Id

-- 07
SELECT Id, FORMAT(JourneyStart, 'dd/MM/yyyy') [JourneyStart], FORMAT(JourneyEnd, 'dd/MM/yyyy') [JourneyEnd]
FROM Journeys
WHERE Purpose = 'Military'
ORDER BY JourneyStart

-- 08
SELECT c.Id, CONCAT(c.FirstName, ' ' + LastName) [full_name] 
FROM Colonists [c]
	JOIN TravelCards [tc] ON tc.ColonistId = c.Id AND tc.JobDuringJourney = 'Pilot'
ORDER BY c.Id

-- 09
SELECT COUNT(*) [count]
FROM Colonists [c]
	JOIN TravelCards [tc] ON tc.ColonistId = c.Id
	JOIN Journeys [j] ON j.Id = tc.JourneyId AND j.Purpose = 'Technical'

-- 10
SELECT TOP (1) s.Name, sp.Name 
FROM Spaceships [s]
	JOIN Journeys [j] ON j.SpaceshipId = s.Id
	JOIN Spaceports [sp] ON sp.Id = j.DestinationSpaceportId
ORDER BY LightSpeedRate DESC

-- 11
SELECT DISTINCT ss.Name, ss.Manufacturer
FROM Spaceships [ss]
	JOIN Journeys [j] ON j.SpaceshipId = ss.Id
	JOIN TravelCards [tc] ON tc.JourneyId = j.Id AND tc.JobDuringJourney = 'Pilot'
	JOIN Colonists [c] ON c.Id = tc.ColonistId
WHERE DATEDIFF(YEAR, c.BirthDate, '2019-01-01') < 30
ORDER BY ss.Name

-- 12
SELECT p.Name, sp.Name
FROM Planets [p]
	JOIN Spaceports [sp] ON sp.PlanetId = p.Id
	JOIN Journeys [j] ON DestinationSpaceportId = sp.Id AND j.Purpose = 'Educational'
ORDER BY sp.Name DESC

-- 13
SELECT p.Name, COUNT(j.Id) [JourneysCount]
FROM Planets [p]
	JOIN Spaceports [sp] ON sp.PlanetId = p.Id
	JOIN Journeys [j] ON DestinationSpaceportId = sp.Id
GROUP BY p.Name
ORDER BY COUNT(j.Id) DESC, p.Name

-- 14
SELECT TOP (1) j.Id, p.Name [PlanetName], sp.Name [SpaceportName], j.Purpose [JourneyPurpose]
FROM Planets [p]
	JOIN Spaceports [sp] ON sp.PlanetId = p.Id
	JOIN Journeys [j] ON DestinationSpaceportId = sp.Id
ORDER BY DATEDIFF(MINUTE, j.JourneyStart, j.JourneyEnd)

-- 15
SELECT TOP (1) Id [JourneyId], JobDuringJourney [JobName] FROM(
SELECT j.Id, tc.JobDuringJourney, DATEDIFF(MINUTE, j.JourneyStart, j.JourneyEnd) [Diff]
FROM Journeys [j]
	JOIN TravelCards [tc] ON tc.JourneyId = j.Id) [tb]
GROUP BY Id, JobDuringJourney, Diff
ORDER BY Diff DESC, COUNT(JobDuringJourney);

-- 16
SELECT * FROM (SELECT JobDuringJourney, CONCAT(FirstName, ' ' + LastName) [FullName], DENSE_RANK() OVER (PARTITION BY tc.JobDuringJourney ORDER BY c.BirthDate) [JobRank]
FROM Colonists [c]
	JOIN TravelCards [tc] ON tc.ColonistId = c.Id) [tb]
WHERE JobRank = 2
-- 17
SELECT p.Name, COUNT(sp.Id) [Count]
FROM Planets [p]
	LEFT JOIN Spaceports [sp] ON sp.PlanetId = p.Id
GROUP BY p.Name
ORDER BY Count DESC, p.Name

-- 18
GO
CREATE OR ALTER FUNCTION udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT AS
BEGIN
	
	DECLARE @count INT = 0;

	SET @count = (SELECT TOP(1) COUNT(*) [count]
	FROM Planets [p] 
		JOIN Spaceports [sp] ON sp.PlanetId = p.Id AND p.Name = @PlanetName
		JOIN Journeys [j] ON j.DestinationSpaceportId = sp.Id
		JOIN TravelCards [tc] ON tc.JourneyId = j.Id
		JOIN Colonists [c] ON c.Id = tc.ColonistId)
	
	RETURN @count;
END
GO
--EXEC dbo.udf_GetColonistsCount 'Otroyphus'

-- 19
GO
CREATE OR ALTER PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(MAX))
AS
	BEGIN
		DECLARE @journeyTrip INT = (SELECT Id FROM Journeys WHERE Id = @JourneyId);

		IF (@journeyTrip IS NULL)
			RAISERROR('The journey does not exist!', 16, 1)

		DECLARE @currentPurpose VARCHAR(MAX) = (SELECT Purpose FROM Journeys WHERE Id = @JourneyId);
		
		IF (@currentPurpose = @NewPurpose)
			RAISERROR('You cannot change the purpose!', 16, 1)

		UPDATE Journeys
		SET Purpose = @NewPurpose
		WHERE Id = @JourneyId
	END
GO

EXEC usp_ChangeJourneyPurpose 196, 'Technical'
SELECT * FROM Journeys
GO

-- 19

CREATE TABLE DeletedJourneys(
	Id INT NOT NULL,
	JourneyStart DATETIME NOT NULL,
	JourneyEnd DATETIME NOT NULL,
	Purpose VARCHAR(11) NOT NULL,
	DestinationSpaceportId INT NOT NULL,
	SpaceshipId INT NOT NULL
)
GO

CREATE TRIGGER tr_JourneysDelete ON Journeys FOR DELETE
AS
  BEGIN
		INSERT INTO DeletedJourneys SELECT * FROM deleted;
  END
