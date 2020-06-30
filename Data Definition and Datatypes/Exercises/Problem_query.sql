-- Problem 01.
CREATE DATABASE Minions
GO
-- End --

-- Problem 02.
USE Minions
GO

CREATE TABLE Minions
(
  Id   INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(30),
  Age  INT,
)

CREATE TABLE Towns
(
  Id   INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(30),
)
GO
-- END --

-- Problem 03.
USE Minions
GO

ALTER TABLE Minions
  ADD TownId INT
ALTER TABLE Minions
  ADD CONSTRAINT TownId FOREIGN KEY (Id) REFERENCES Towns (Id)
GO
-- END -- 

-- Problem 04.
USE Minions
GO

INSERT INTO Towns (Name)
VALUES ('Sofia'),
       ('Plovdiv'),
       ('Varna');

INSERT INTO Minions (Name, Age, TownId)
VALUES ('Kevin', 22, 1),
       ('Bob', 15, 3),
       ('Kevin', NULL, 2)
GO
-- END --

-- Problem 05.
USE Minions
GO

TRUNCATE TABLE Minions
GO
-- END --

-- Problem 06.
USE master
GO

DROP TABLE Minions
DROP TABLE Towns
GO
-- Problem 07.

USE Minions
GO

CREATE TABLE People
(
  Id        INT IDENTITY,
  Name      NVARCHAR(200) NOT NULL,
  Picture   VARBINARY(2000),
  Height    FLOAT(2),
  Weight    FLOAT(2),
  Gender    CHAR          NOT NULL CHECK (Gender = 'm' OR Gender = 'f'),
  Birthdate DATETIME      NOT NULL,
  Biography NVARCHAR(MAX),
)

INSERT INTO People(Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Pesho', 21412, 1.80, 90.4, 'm', '07-07-1997', 'something'),
       ('Maria', 2121412, 1.61, 55.4, 'f', '07-07-1997', '1something'),
       ('Lilly', 233312, 1.68, 62.5, 'f', '07-07-1997', '2something'),
       ('Gosho', 1412, 1.75, 80.4, 'f', '07-07-1997', '3something'),
       ('IDK', NULL, 1.99, 111.2, 'm', '07-07-1997', '4something')
GO
-- END -- 

-- Problem 08.
USE Minions
GO

CREATE TABLE Users
(
  Id            INT IDENTITY,
  Username      VARCHAR(30) NOT NULL UNIQUE CHECK (LEN(Username) >= 3),
  Password      VARCHAR(28) NOT NULL CHECK (LEN(Password) >= 5),
  Picture       VARBINARY(900),
  LastLoginTime DATETIME DEFAULT GETDATE(),
  IsDeleted     BIT,
)

INSERT INTO Users(Username, Password, Picture, LastLoginTime, IsDeleted)
VALUES ('uname1', 'xas14444', 323, '02-01-2019', 0),
       ('uname2', 'adgadgadgadga', NULL, '02-01-2019', 0),
       ('uname3', 'test1243', NULL, NULL, 1),
       ('uname4', 'testtt', 666, '02-01-2019', 1),
       ('uname5', '000000', 200, NULL, 0)
GO
-- END --

-- Problem 13.
USE Minions
GO

CREATE TABLE Directors
(
  Id    INT PRIMARY KEY IDENTITY,
  Name  NVARCHAR(30) NOT NULL,
  Notes NVARCHAR(2000)
)

CREATE TABLE Genres
(
  Id    INT PRIMARY KEY IDENTITY,
  Name  NVARCHAR(20) NOT NULL,
  Notes NVARCHAR(2000)
)

CREATE TABLE Categories
(
  Id    INT PRIMARY KEY IDENTITY,
  Name  NVARCHAR(20) NOT NULL,
  Notes NVARCHAR(100)
)

CREATE TABLE Movies
(
  Id            INT PRIMARY KEY IDENTITY,
  Title         NVARCHAR(30) NOT NULL,
  DirectorId    INT          NOT NULL FOREIGN KEY (DirectorId) REFERENCES Directors (Id),
  CopyrightYear DATE         NOT NULL,
  Length        BIGINT       NOT NULL,
  GenreId       INT          NOT NULL FOREIGN KEY (GenreId) REFERENCES Genres (Id),
  CategoryId    INT          NOT NULL FOREIGN KEY (CategoryId) REFERENCES Categories (Id),
  Rating        INT          NOT NULL CHECK (Rating <= 5 AND Rating >= 0),
  Notes         VARCHAR(500) NOT NULL,
)


INSERT INTO Categories(Name, Notes)
VALUES ('Horror', 'Sample1 note'),
       ('Comedy', '2Sample2 note'),
       ('Action', 'Sample3 note'),
       ('Thriller', 'Sample4 note'),
       ('Documentary', 'Sample5 note')

INSERT INTO Directors(Name, Notes)
VALUES ('Pesho Peshov', 'SN1'),
       ('Gosho', 'SN2'),
       ('Maria', 'SN3'),
       ('Lilly', 'SN4'),
       ('Vili', 'SN5')

INSERT INTO Genres(Name, Notes)
VALUES ('Horror', 'Sample1 note'),
       ('Comedy', '2Sample2 note'),
       ('Action', 'Sample3 note'),
       ('Thriller', 'Sample4 note'),
       ('Documentary', 'Sample5 note')

INSERT INTO Movies(Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES ('Movie1', 2, '1994', 130, 1, 2, 4, 'sample description'),
       ('Movie2', 2, '2005', 90, 2, 3, 4, 'sample description'),
       ('Movie3', 2, '2013', 120, 3, 1, 4, 'sample description'),
       ('Movie4', 2, '1996', 60, 4, 4, 4, 'sample description'),
       ('Movie5', 2, '1990', 130, 5, 5, 4, 'sample description')
GO
-- END --

-- Problem 14.
DROP DATABASE Minions
GO

CREATE DATABASE CarRental
GO

USE CarRental
GO

CREATE TABLE Categories
(
  Id          INT PRIMARY KEY IDENTITY,
  Name        NVARCHAR(20)   NOT NULL,
  DailyRate   DECIMAL(15, 2) NOT NULL,
  WeeklyRate  DECIMAL(15, 2) NOT NULL,
  MonthlyRate DECIMAL(15, 2) NOT NULL,
  WeekendRate DECIMAL(15, 2) NOT NULL,
)

CREATE TABLE Cars
(
  Id           INT PRIMARY KEY IDENTITY,
  Plate        NVARCHAR(8) NOT NULL,
  Manufacturer VARCHAR(20) NOT NULL,
  Model        VARCHAR(20) NOT NULL,
  Year         DATETIME    NOT NULL,
  CategoryId   INT         NOT NULL FOREIGN KEY (CategoryId) REFERENCES Categories (Id),
  Doors        INT         NOT NULL,
  Picture      VARBINARY(6000),
  Condition    NVARCHAR(1000),
  Available    BIT         NOT NULL,
)

CREATE TABLE Customers
(
  Id                  INT PRIMARY KEY IDENTITY,
  DriverLicenseNumber VARCHAR(16)  NOT NULL,
  FullName            NVARCHAR(50) NOT NULL,
  Address             NVARCHAR(80) NOT NULL,
  City                NVARCHAR(30) NOT NULL,
  ZipCode             INT          NOT NULL
    CONSTRAINT CHK_ZIPCODE_LENGTH CHECK (LEN(ZipCode) >= 4 AND LEN(ZipCode) <= 6),
  Notes               NVARCHAR(80)
)

CREATE TABLE Employees
(
  Id        INT PRIMARY KEY IDENTITY,
  FirstName NVARCHAR(30) NOT NULL,
  LastName  NVARCHAR(30) NOT NULL,
  Title     NVARCHAR(20) NOT NULL,
  Notes     NVARCHAR(200)
)

CREATE TABLE RentalOrders
(
  Id               INT PRIMARY KEY IDENTITY,
  EmployeeId       INT            NOT NULL
    CONSTRAINT FK_EmployeeId_Emloyees FOREIGN KEY (EmployeeId) REFERENCES Employees (Id),
  CustomerId       INT            NOT NULL
    CONSTRAINT FK_CustomerId_Customers FOREIGN KEY (CustomerId) REFERENCES Customers (Id),
  CarId            INT            NOT NULL
    CONSTRAINT FK_CarId_Cars FOREIGN KEY (CarId) REFERENCES Cars (Id),
  TankLevel        INT            NOT NULL,
  KilometrageStart DECIMAL(15, 2) NOT NULL,
  KilometrageEnd   DECIMAL(15, 2) NOT NULL,
  TotalKilometrage DECIMAL(15, 2) NOT NULL,
  StartDate        DATETIME2      NOT NULL,
  EndDate          DATETIME2      NOT NULL,
  TotalDays        INT            NOT NULL,
  RateApplied      DECIMAL(15, 2) NOT NULL,
  TaxApplied       DECIMAL(15, 2) NOT NULL,
  OrderStatus      NVARCHAR(20)   NOT NULL,
  Notes            NVARCHAR(200),
)

INSERT INTO Categories(Name, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES ('Exotic', 220.33, 1102.44, 4000, 390.12),
       ('VIP', 200.44, 800, 3000, 240.33),
       ('Budget', 90.44, 400, 800, 170)

INSERT INTO Cars(Plate, Manufacturer, Model, Year, CategoryId, Doors, Picture, Condition, Available)
VALUES ('CSS070', 'Honda', 'Civic', '08-03-1997', 3, 3, 12412, 'Excellent', 1),
       ('CB212AN', 'MB', 'EClass', '2005', 2, 4, 1241, 'Good', 1),
       ('12441', 'Aston Martin', 'Vantage', '2011', 1, 2, 2312, 'Perfect', 0)

INSERT INTO Customers(DriverLicenseNumber, FullName, Address, City, ZipCode, Notes)
VALUES ('0021x', 'Petko Petkov', 'adress1', 'Sofia', 1220, NULL),
       ('AW212', 'Mimi Marinova', 'address2', 'Varna', 2121, 'IDK'),
       ('QQ212X', 'Alexandra Elenova', 'address3', 'Plovdinv', 1000, NULL)

INSERT INTO Employees(FirstName, LastName, Title, Notes)
VALUES ('Andrey', 'Andreev', 'CEO', 'None'),
       ('Maraya', 'Lilova', 'Manager', 'NULL'),
       ('Bogdan', 'Spasov', 'Sales', 'NULL')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage,
                         StartDate, EndDate, TotalDays, RateApplied, TaxApplied, OrderStatus, Notes)
VALUES (1, 1, 1, 40, 220.43, 290.11, 14131.13, '07-01-2019', '09-01-2019', 2, 2.3, 1.1, 'Done', 'SomeText'),
       (2, 2, 2, 100, 222, 333, 4444, '02-01-2019', '07-01-2019', 5, 2, 2, 'Done', NULL),
       (3, 3, 3, 60, 444, 888, 34444, '03-01-2019', '11-01-2019', 8, 2, 2, 'Done', NULL)
GO
-- END --

-- Problem 15.
DROP DATABASE CarRental
GO

CREATE DATABASE HotelDB
GO

USE HotelDB
GO

CREATE TABLE Employees
(
  Id        INT PRIMARY KEY IDENTITY,
  FirstName NVARCHAR(30) NOT NULL,
  LastName  NVARCHAR(50) NOT NULL,
  Title     NVARCHAR(30) NOT NULL,
  Notes     NVARCHAR(200)
)

INSERT INTO Employees(FirstName, LastName, Title, Notes)
VALUES ('Mirela', 'Arabadzhyska', 'Manager', NULL),
       ('Alexander', 'Marinov', 'Receptionist', 'Sample Note'),
       ('Renetta', 'Purvanova', 'Manager', NULL)

CREATE TABLE Customers
(
  Id              INT PRIMARY KEY IDENTITY,
  AccountNumber   NVARCHAR(20) NOT NULL UNIQUE,
  FirstName       NVARCHAR(30) NOT NULL,
  LastName        NVARCHAR(50) NOT NULL,
  PhoneNumber     NVARCHAR(12) NOT NULL UNIQUE,
  EmergencyName   NVARCHAR(25),
  EmergencyNumber NVARCHAR(12) NOT NULL,
  Notes           NVARCHAR(200),
)

INSERT INTO Customers(AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
VALUES ('9129139BB', 'Cvetelina', 'Nikolova', '088128128', 'SampleName', '9999', NULL),
       ('121221AWW', 'Marietta', 'Benettova', '1231231', 'SampleName', '12313', 'SampleNote'),
       ('222AE3341', 'Victor', 'Victorov', '222231', 'SampleName', '22222', 'SampleNote')

CREATE TABLE RoomStatus
(
  Id         INT PRIMARY KEY IDENTITY,
  RoomStatus NVARCHAR(15) NOT NULL UNIQUE,
  Notes      NVARCHAR(100)
)

INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES ('Available', NULL),
       ('Booked', NULL),
       ('Unavailable', NULL)

CREATE TABLE RoomTypes
(
  Id       INT PRIMARY KEY IDENTITY,
  RoomType NVARCHAR(20) NOT NULL UNIQUE,
  Notes    NVARCHAR(100)
)

INSERT INTO RoomTypes(RoomType, Notes)
VALUES ('Presidential', NULL),
       ('VIP', NULL),
       ('Regular', NULL)

CREATE TABLE BedTypes
(
  Id      INT PRIMARY KEY IDENTITY,
  BedType NVARCHAR(10) NOT NULL UNIQUE,
  Notes   NVARCHAR(100)
)

INSERT INTO BedTypes(BedType, Notes)
VALUES ('KingSize', NULL),
       ('Large', NULL),
       ('Medium', NULL)

CREATE TABLE Rooms
(
  Id         INT PRIMARY KEY IDENTITY,
  RoomNumber INT            NOT NULL
    CONSTRAINT U_RoomNumber UNIQUE,
  RoomType   INT            NOT NULL
    CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY (RoomType) REFERENCES RoomTypes (Id),
  BedType    INT            NOT NULL
    CONSTRAINT FK_Rooms_BedTypes FOREIGN KEY (BedType) REFERENCES BedTypes (Id),
  Rate       DECIMAL(15, 2) NOT NULL,
  RoomStatus INT            NOT NULL
    CONSTRAINT FK_Rooms_RoomStatus FOREIGN KEY (RoomStatus) REFERENCES RoomStatus (Id),
  Notes      NVARCHAR(100)
)

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES (414, 1, 1, 444.44, 1, 'SampleNote'),
       (131, 2, 2, 1313.44, 2, NULL),
       (007, 3, 3, 220, 3, NULL)

CREATE TABLE Payments
(
  Id                INT PRIMARY KEY IDENTITY,
  EmployeeId        INT            NOT NULL
    CONSTRAINT FK_Payments_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees (Id),
  PaymentDate       DATETIME2      NOT NULL,
  AccountNumber     INT
    CONSTRAINT FK_Payments_Customers FOREIGN KEY (AccountNumber) REFERENCES Customers (Id),
  FirstDateOccupied DATETIME2      NOT NULL,
  LastDateOccupied  DATETIME2      NOT NULL,
  TotalDays         INT            NOT NULL,
  AmountCharged     DECIMAL(15, 2) NOT NULL,
  TaxRate           DECIMAL(15, 2) NOT NULL,
  TaxAmount         DECIMAL(15, 2) NOT NULL,
  PaymentTotal      DECIMAL(15, 2) NOT NULL,
  Notes             NVARCHAR(200)  NOT NULL,
)

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays,
                     AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
VALUES (1, '03-01-2019', 1, '01-01-2019', '05-01-2019', 4, 444, 4, 4, 488, 'SampleNote'),
       (2, '03-01-2019', 2, '01-01-2019', '05-01-2019', 4, 444, 4, 4, 488, 'SampleNote'),
       (3, '03-01-2019', 3, '01-01-2019', '05-01-2019', 4, 444, 4, 4, 488, 'SampleNote')

CREATE TABLE Occupancies
(
  Id            INT PRIMARY KEY IDENTITY,
  EmployeeId    INT            NOT NULL
    CONSTRAINT FK_Occupancies_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees (Id),
  DateOccupied  DATETIME2      NOT NULL,
  AccountNumber INT            NOT NULL
    CONSTRAINT FK_Occupancies_Customers FOREIGN KEY (AccountNumber) REFERENCES Customers (Id),
  RoomNumber    INT            NOT NULL
    CONSTRAINT FK_Occupancies_Rooms FOREIGN KEY (RoomNumber) REFERENCES Rooms (Id),
  RateApplied   DECIMAL(15, 2) NOT NULL,
  PhoneCharge   DECIMAL(15, 2) NOT NULL,
  Notes         VARCHAR(200)   NOT NULL,
)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES (1, '03-01-2019', 1, 1, 444, 44, 'SampleNote'),
       (2, '03-01-2019', 2, 2, 444, 44, 'SampleNote'),
       (3, '03-01-2019', 3, 3, 444, 44, 'SampleNote')
-- END --

-- Problem 16.
USE master
DROP DATABASE HotelDB
CREATE DATABASE SoftUni
USE SoftUni

CREATE TABLE Towns
(
  Id   INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(30) NOT NULL
)

CREATE TABLE Addresses
(
  Id          INT PRIMARY KEY IDENTITY,
  AddressText NVARCHAR(40) NOT NULL,
  AddressId   INT          NOT NULL
    CONSTRAINT FK_Addresses_Towns FOREIGN KEY (AddressId) REFERENCES Towns (Id)
)

CREATE TABLE Departments
(
  Id   INT PRIMARY KEY IDENTITY,
  Name NVARCHAR(20) NOT NULL,
)

CREATE TABLE Employees
(
  Id           INT PRIMARY KEY IDENTITY,
  FirstName    VARCHAR(20)    NOT NULL,
  MiddleName   VARCHAR(20)    NOT NULL,
  LastName     VARCHAR(20)    NOT NULL,
  JobTitle     VARCHAR(20)    NOT NULL,
  DepartmentId INT            NOT NULL
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments (Id),
  HireDate     DATETIME       NOT NULL,
  Salary       DECIMAL(15, 2) NOT NULL,
  AddressId    INT
    CONSTRAINT FK_Employees_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses (Id)
)
GO
-- END --

-- Problem 18.

--Ivan Ivanov Ivanov.NET Developer Software Development 01/02/2013 3500.00
--Petar Petrov Petrov Senior Engineer Engineering 02/03/2004 4000.00
--Maria Petrova Ivanova Intern Quality Assurance 28/08/2016 525.25
--Georgi Teziev Ivanov CEO Sales 09/12/2007 3000.00
--Peter Pan Pan Intern Marketing 28/08/2016 599.88

INSERT INTO Towns(Name)
VALUES ('Sofia'),
       ('Plovdiv'),
       ('Varna'),
       ('Burgas')

INSERT INTO Departments(Name)
VALUES ('Engineering'),
       ('Sales'),
       ('Marketing'),
       ('Software Development'),
       ('Quality Assurance')

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '01/02/2013', 3500),
       ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '02/03/2004', 4000),
       ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08/08/2016', 525.25),
       ('Gorgi', 'Terziev', 'Ivanov', 'CEO', 2, '09/12/2007', 3000),
       ('Peter', 'Pan', 'Pan', 'Intern', 3, '11/08/2016', 599.88)
GO
-- END --

-- Problem 19.
SELECT *
FROM Towns

SELECT *
FROM Departments

SELECT *
FROM Employees
-- END --

-- Problem 20.
SELECT *
FROM Towns
ORDER BY Name ASC

SELECT *
FROM Departments
ORDER BY Name ASC

SELECT *
FROM Employees
ORDER BY Salary DESC
-- END --

-- Problem 21.
SELECT Name
FROM Towns
ORDER BY Name ASC

SELECT Name
FROM Departments
ORDER BY Name ASC

SELECT FirstName, LastName, JobTitle, Salary
FROM Employees
ORDER BY Salary DESC
-- END --

-- Problem 22.
UPDATE Employees
SET Salary = Salary * 1.1

SELECT Salary
FROM Employees
-- END --

-- Problem 23.
USE HotelDB
GO

UPDATE Payments
SET TaxRate = TaxRate * 0.97

SELECT TaxRate
FROM Payments
GO
-- END --

-- Problem 24.
TRUNCATE TABLE Occupancies
GO
-- END --

USE master
DROP DATABASE Demo

CREATE DATABASE Demo