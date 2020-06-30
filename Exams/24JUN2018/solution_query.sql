-- DDL --
CREATE DATABASE TripService
GO

USE TripService
GO

CREATE TABLE Cities
(
  Id          INT PRIMARY KEY IDENTITY,
  Name        NVARCHAR(20) NOT NULL,
  CountryCode CHAR(2)      NOT NULL,
)
GO

CREATE TABLE Hotels
(
  Id            INT PRIMARY KEY IDENTITY,
  Name          NVARCHAR(30) NOT NULL,
  CityId        INT          NOT NULL
    CONSTRAINT FK_Hotels_Cities FOREIGN KEY (CityId) REFERENCES Cities (Id),
  EmployeeCount INT          NOT NULL,
  BaseRate      DECIMAL(15, 2)
)
GO

CREATE TABLE Rooms
(
  Id      INT PRIMARY KEY IDENTITY,
  Price   DECIMAL(15, 2) NOT NULL,
  Type    NVARCHAR(20)   NOT NULL,
  Beds    INT            NOT NULL,
  HotelId INT            NOT NULL
    CONSTRAINT FK_Rooms_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels (Id),
)
GO

CREATE TABLE Trips
(
  Id          INT PRIMARY KEY IDENTITY,
  RoomId      INT      NOT NULL
    CONSTRAINT FK_Trips_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms (Id),
  BookDate    DATETIME NOT NULL,
  ArrivalDate DATETIME NOT NULL,
  ReturnDate  DATETIME NOT NULL,
  CancelDate  DATETIME,

  CONSTRAINT CHK_IfBeforeArrivalDate CHECK (BookDate < ArrivalDate),
  CONSTRAINT CHK_IfBeforeReturnDate CHECK (ArrivalDate < ReturnDate),
)
GO

CREATE TABLE Accounts
(
  Id         INT PRIMARY KEY IDENTITY,
  FirstName  NVARCHAR(50)  NOT NULL,
  MiddleName NVARCHAR(20),
  LastName   NVARCHAR(50)  NOT NULL,
  CityId     INT           NOT NULL
    CONSTRAINT FK_Accounts_Cities FOREIGN KEY (CityId) REFERENCES Cities (Id),
  BirthDate  DATETIME      NOT NULL,
  Email      NVARCHAR(100) NOT NULL UNIQUE
)
GO

CREATE TABLE AccountsTrips
(
  AccountId INT NOT NULL
    CONSTRAINT FK_AccountsTrips_Accounts FOREIGN KEY (AccountId) REFERENCES Accounts (Id),
  TripId    INT NOT NULL
    CONSTRAINT FK_AccountsTrips_Trips FOREIGN KEY (TripId) REFERENCES Trips (Id),
  Luggage   INT NOT NULL
    CONSTRAINT CHK_Luggage CHECK (Luggage >= 0),
  Id        INT PRIMARY KEY (AccountId, TripId)
)
GO
-- END OF DDL --

-- Insert 02.
INSERT INTO Accounts(FirstName, MiddleName, LastName, CityId, BirthDate, Email)
VALUES ('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
       ('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
       ('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
       ('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg');

INSERT INTO Trips(RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
VALUES (101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
       (102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
       (103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
       (104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
       (109, '2017-08-07', '2017-08-28', '2017-08-29', NULL);
-- END OF INSERT --

-- Update 03.
UPDATE Rooms
SET Price *= 1.14
WHERE HotelId IN (5, 7, 9);
-- END OF UPDATE --

-- Delete 04.
DELETE
FROM AccountsTrips
WHERE AccountId = 47;
-- END OF DELETE --

-- QUERYING --
-- 05. --
SELECT Id, Name
FROM Cities
WHERE CountryCode = 'BG'
ORDER BY Name ASC
-- END OF 05. --

-- 06. --
SELECT CONCAT(FirstName, ' ' + MiddleName, ' ', LastName) AS [Full Name],
       DATEPART(YEAR, BirthDate)                             [BirthYear]
FROM Accounts
WHERE DATEPART(YEAR, BirthDate) > 1991
ORDER BY BirthYear DESC, FirstName
-- END OF 06. --

-- 07. --
SELECT a.FirstName, a.LastName, FORMAT(a.BirthDate, 'MM-dd-yyyy'), c.Name [Hometown], a.Email
FROM Accounts [a]
       JOIN Cities [c] ON c.Id = a.CityId
WHERE a.Email LIKE 'e%'
ORDER BY Hometown DESC
-- END OF 07. --

-- 08. --
SELECT c.Name [City], COUNT(h.Id) [Hotels]
FROM Cities [c]
       FULL JOIN Hotels [h] ON h.CityId = c.Id
GROUP BY c.Name
ORDER BY Hotels DESC, c.Name
-- END OF 08. --

-- 09. --
SELECT r.Id, r.Price, h.Name, c.Name
FROM Rooms [r]
       JOIN Hotels [h] ON h.Id = r.HotelId
       JOIN Cities [c] ON c.Id = h.CityId
WHERE r.Type = 'First Class'
ORDER BY r.Price DESC, r.Id
-- END OF 09. --

-- 10. --
SELECT a.Id                                           [AccountId]
     ,CONCAT(a.FirstName, ' ', a.LastName)            [FullName]
     ,MAX(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) [LongestTrip]
     ,MIN(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) [ShortestTrip]
FROM Accounts [a]
       JOIN AccountsTrips [ac] ON a.Id = ac.AccountId AND a.MiddleName IS NULL
       JOIN Trips [t] ON t.Id = ac.TripId AND t.CancelDate IS NULL
GROUP BY a.Id, CONCAT(a.FirstName, ' ', a.LastName)
ORDER BY LongestTrip DESC, AccountId
-- END OF 10. --

-- 11. --
SELECT TOP (5) c.Id, Name [City], c.CountryCode [Country], COUNT(a.Id) [Accounts]
FROM Cities [c]
       JOIN Accounts [a] ON a.CityId = c.Id
GROUP BY c.Id, c.Name, c.CountryCode
ORDER BY COUNT(a.Id) DESC
-- END OF 11. --

-- 12. --
SELECT a.Id, a.Email, c.Name [City], COUNT(c.Name) [Trips]
FROM Accounts [a]
       JOIN AccountsTrips [ac] ON ac.AccountId = a.Id
       JOIN Trips [t] ON t.Id = ac.TripId
       JOIN Rooms [r] ON r.Id = t.RoomId
       JOIN Hotels [h] ON h.Id = r.HotelId
       JOIN Cities [c] ON h.CityId = c.Id AND a.CityId = h.CityId
GROUP BY a.Id, a.Email, c.Name
ORDER BY [Trips] DESC, a.Id
-- END OF 12. --

-- 13. --
SELECT TOP (10) c.Id, c.Name, SUM(h.BaseRate + r.Price) [Total Revenue], COUNT(t.Id) [Trips]
FROM Cities [c]
       JOIN Hotels [h] ON c.Id = h.CityId
       JOIN Rooms [r] ON h.Id = r.HotelId
       JOIN Trips [t] ON r.Id = t.RoomId AND YEAR(t.BookDate) = DATEPART(YEAR, '2016-01-01')
GROUP BY c.Id, c.Name
ORDER BY [Total Revenue] DESC, Trips DESC
-- END OF 13. --

-- 14. --
SELECT at.TripId,
       h.[Name] [HotelName],
       r.[Type] [RoomType],
       CASE
         WHEN t.CancelDate IS NULL THEN SUM(h.BaseRate + r.Price)
         ELSE 0
         END    [Revenue]
FROM Trips [t]
       JOIN Rooms [r] ON r.Id = t.RoomId
       JOIN Hotels [h] ON h.Id = r.HotelId
       JOIN AccountsTrips [at] ON t.Id = at.TripId
GROUP BY at.TripId, h.Name, r.Type, t.CancelDate
ORDER BY r.[Type], at.TripId
-- END OF 14. --

-- 15. --
WITH MostTravelers_CTE (Id, Email, CountryCode, Trips, [Rank])
       AS
       (SELECT a.Id
             , a.Email
             , c.CountryCode
             , COUNT(*)                                                                    [Trips]
             , DENSE_RANK() OVER (PARTITION BY c.CountryCode ORDER BY COUNT(*) DESC, a.Id) [Rank]
        FROM Accounts [a]
               JOIN AccountsTrips [atr] ON a.Id = atr.AccountId
               JOIN Trips [t] ON atr.TripId = t.Id
               JOIN Rooms [r] ON t.RoomId = r.Id
               JOIN Hotels [h] ON r.HotelId = h.Id
               JOIN Cities [c] ON h.CityId = c.Id
        GROUP BY a.Id, a.Email, c.CountryCode)

SELECT Id, Email, CountryCode, Trips
FROM MostTravelers_CTE
WHERE [Rank] = 1
ORDER BY Trips DESC, Id
-- END OF 15. --

-- 16. --
SELECT atr.TripId,
       SUM(atr.Luggage) [Luggage],
       CASE
         WHEN SUM(atr.Luggage) > 5 THEN CONCAT('$', (SUM(atr.Luggage) * 5))
         ELSE '$0'
         END            [Fee]
FROM AccountsTrips [atr]
       JOIN Trips [t] ON t.Id = atr.TripId AND atr.Luggage > 0
GROUP BY atr.TripId
ORDER BY SUM(atr.Luggage) DESC
-- END OF 16. --

-- 17. --
SELECT atr.TripId
     , CONCAT(A.FirstName, ' ' + A.MiddleName, ' ', A.LastName) [Full Name]
     , ac.Name                                                  [From]
     , c.Name                                                   [To]
     , CASE
         WHEN t.CancelDate IS NULL THEN CONCAT(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate), ' ', 'days')
         ELSE 'Canceled'
  END                                                           [Duration]
FROM AccountsTrips [atr]
       JOIN Accounts [a] ON a.Id = atr.AccountId
       JOIN Trips [t] ON t.Id = atr.TripId
       JOIN Rooms [r] ON r.Id = t.RoomId
       JOIN Hotels [h] ON h.Id = r.HotelId
       JOIN Cities [c] ON c.Id = h.CityId
       JOIN Cities [ac] ON ac.Id = a.CityId
ORDER BY [Full Name], atr.TripId
-- END OF 17. --
GO

-- 18. --
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATETIME, @People INT)
  RETURNS VARCHAR(MAX)
BEGIN
  DECLARE @BookedRooms TABLE
                       (
                         Id INT
                       );
  INSERT INTO @BookedRooms
  SELECT r.Id
  FROM Rooms [r]
         JOIN Trips [t] ON t.RoomId = r.Id
  WHERE R.HotelId = @HotelId
    AND @Date BETWEEN T.ArrivalDate AND T.ReturnDate
    AND T.CancelDate IS NULL

  DECLARE @Rooms TABLE
                 (
                   Id         INT,
                   Price      DECIMAL(15, 2),
                   Type       VARCHAR(20),
                   Beds       INT,
                   TotalPrice DECIMAL(15, 2)
                 )
  INSERT INTO @Rooms
  SELECT TOP 1 R.Id,
               R.Price,
               R.Type,
               R.Beds,
               @People * (H.BaseRate + R.Price) AS TotalPrice
  FROM Rooms R
         LEFT JOIN Hotels H on R.HotelId = H.Id
  WHERE R.HotelId = @HotelId
    AND R.Beds >= @People
    AND R.Id NOT IN (SELECT Id
                     FROM @BookedRooms)
  ORDER BY TotalPrice DESC

  DECLARE @RoomCount INT = (SELECT COUNT(*)
                            FROM @Rooms)
  IF (@RoomCount < 1)
    BEGIN
      RETURN 'No rooms available'
    END

  DECLARE @Result VARCHAR(MAX) = (SELECT CONCAT('Room ', Id, ': ', Type, ' (', Beds, ' beds) - ', '$', TotalPrice)
                                  FROM @Rooms)

  RETURN @Result
END
GO

--SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
-- END OF 18. --
GO