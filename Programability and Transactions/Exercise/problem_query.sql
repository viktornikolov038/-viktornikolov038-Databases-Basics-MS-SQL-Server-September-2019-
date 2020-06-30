USE SoftUni
GO

-- Problem 01.
CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName [First Name], LastName [LastName]
FROM Employees
WHERE Salary > 35000
GO

EXEC usp_GetEmployeesSalaryAbove35000
GO
-- END --

-- Problem 02.
CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber(@salaryAboveToSearch DECIMAL(18, 2))
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary > @salaryAboveToSearch
GO

EXEC usp_GetEmployeesSalaryAboveNumber 48100
GO
-- END --

-- Problem 03.
CREATE OR ALTER PROC usp_GetTownsStartingWith(@townName VARCHAR(50))
AS
SELECT [Name]
FROM Towns
WHERE [Name] LIKE @townName + '%'
GO

EXEC usp_GetTownsStartingWith 'b'
GO
-- END --

-- Problem 04.
CREATE OR ALTER PROC usp_GetEmployeesFromTown(@townName VARCHAR(50))
AS
SELECT e.FirstName [First Name], e.LastName [Last Name]
FROM Employees [e]
       JOIN Addresses [a] ON e.AddressID = a.AddressID
       JOIN Towns [t] ON a.TownID = t.TownID
WHERE t.Name = @townName
GO

EXEC usp_GetEmployeesFromTown 'Sofia'
GO
-- END --

-- Problem 05.
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18, 4))
  RETURNS VARCHAR(10) AS
BEGIN
  DECLARE @output VARCHAR(10);

  IF (@salary < 30000)
    BEGIN
      SET @output = 'Low';
    END

  ELSE
    IF (@salary BETWEEN 30000 AND 50000)
      BEGIN
        SET @output = 'Average';
      END

    ELSE
      BEGIN
        SET @output = 'High';
      END

  RETURN @output
END
GO

EXEC ufn_GetSalaryLevel 45000
GO
-- END --

-- Problem 06.
CREATE OR ALTER PROC usp_EmployeesBySalaryLevel(@level VARCHAR(10))
AS
SELECT FirstName
     , LastName
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @level
GO

EXEC usp_EmployeesBySalaryLevel 'High'
GO
-- END --

-- Problem 07.
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
  RETURNS BIT
BEGIN
  DECLARE @doesContain BIT = 1;
  DECLARE @index INT = 1;

  WHILE (@index < LEN(@word))
  BEGIN
    DECLARE @currentChar CHAR(1) = SUBSTRING(@word, @index, 1);
    DECLARE @indexOfFoundChar INT = CHARINDEX(@currentChar, @setOfLetters, 1)

    IF (@indexOfFoundChar = 0)
      BEGIN
        SET @doesContain = 0;
        BREAK;
      END

    SET @index += 1;
  END

  RETURN @doesContain;
END
GO

SELECT dbo.ufn_IsWordComprised('asd', 'deff')
GO
-- END --

-- Problem 08.
CREATE PROC usp_DeleteEmployeesFromDepartment(@departmentId INT)
AS
  ALTER TABLE Departments
    ALTER COLUMN ManagerId INT
  DELETE
  FROM EmployeesProjects
  WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM Employees
    WHERE DepartmentID = @departmentId
  )

  -- FUCK THIS PROBLEM IN PARTICULAR

  UPDATE Departments
  SET ManagerID = NULL
  WHERE DepartmentID = @departmentId;

  UPDATE Employees
  SET ManagerID = NULL
  WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)
  DELETE
  FROM Employees
  WHERE DepartmentID = @departmentId
  DELETE
  FROM Departments
  WHERE DepartmentID = @departmentId
  SELECT COUNT(*)
  FROM Employees
  WHERE DepartmentID = @departmentId
GO
-- END --

USE Bank
GO
-- 09. --
CREATE PROC usp_GetHoldersFullName
AS
SELECT CONCAT(FirstName, ' ' + LastName) [Full Name]
FROM AccountHolders
GO
-- END --

-- 10. --
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@moreThanMoney DECIMAL(15, 2))
AS
SELECT FirstName, LastName
FROM (
       SELECT FirstName, LastName, SUM(a.Balance) [Sum]
       FROM AccountHolders [ah]
              JOIN Accounts [a] ON a.AccountHolderId = ah.Id
       GROUP BY ah.Id, FirstName, LastName) [t]
WHERE [Sum] > @moreThanMoney
ORDER BY FirstName, LastName

EXEC usp_GetHoldersWithBalanceHigherThan 10000
-- 11. --
GO
CREATE OR ALTER FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(15, 2), @yearlyInterestRate FLOAT, @numberOfYears INT)
  RETURNS DECIMAL(15, 4)
BEGIN
  DECLARE @result DECIMAL(15, 4) = @sum * (POWER(1 + @yearlyInterestRate, @numberOfYears));
  RETURN @result
END
GO
-- END --

-- 12. --
CREATE OR ALTER PROC usp_CalculateFutureValueForAccount(@accountId INT, @interestRate DECIMAL(15, 2))
AS
SELECT TOP (1) ac.Id                                                     [Account Id]
             , ac.FirstName                                              [First Name]
             , ac.LastName                                               [Last Name]
             , a.Balance                                                 [Current Balance]
             , dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5) [Balance in 5 years]
FROM AccountHolders [ac]
       JOIN Accounts [a] ON a.AccountHolderId = ac.Id AND ac.Id = @accountId;
GO

EXEC usp_CalculateFutureValueForAccount 1, 0.1
-- END --

USE Diablo
GO
-- 13. --
GO
CREATE OR ALTER FUNCTION ufn_CashInUsersGames(@gameName VARCHAR(MAX))
  RETURNS TABLE AS
    RETURN
    SELECT SUM(Cash) [Cash]
    FROM (SELECT u.Username, ug.Cash, ROW_NUMBER() OVER (ORDER BY ug.Cash DESC) [row], g.Name [GameName]
          FROM Users [u]
                 JOIN UsersGames [ug] ON ug.UserId = u.Id
                 JOIN Games [g] ON g.Id = ug.GameId AND g.Name = @gameName) [tmptb]
    WHERE row % 2 <> 0
    GROUP BY GameName
GO
SELECT *
FROM dbo.ufn_CashInUsersGames('Amsterdam')
-- END --

USE Bank
GO
-- 14. --
CREATE TABLE Logs
(
  LogId     INT PRIMARY KEY IDENTITY,
  AccountId INT            NOT NULL,
  OldSum    DECIMAL(15, 2) NOT NULL,
  NewSum    DECIMAL(15, 2) NOT NULL
)
GO

CREATE OR ALTER TRIGGER tr_TableLogs
  ON Accounts
  INSTEAD OF UPDATE
  AS
BEGIN
  INSERT INTO Logs
  SELECT a.Id, a.Balance, i.Balance
  FROM inserted [i]
         JOIN Accounts [a] ON a.Id = i.Id
END

UPDATE Accounts
SET Balance += 4
WHERE Id = 2

SELECT *
FROM Logs

SELECT *
FROM Accounts
-- END --

-- 15. --
CREATE TABLE NotificationEmails
(
  Id        INT PRIMARY KEY IDENTITY,
  Recipient INT NOT NULL,
  [Subject] VARCHAR(100),
  Body      VARCHAR(100)
)
GO

CREATE OR ALTER TRIGGER tr_Emails
  ON Logs
  FOR INSERT
  AS
BEGIN
  DECLARE @recipient INT = (SELECT TOP (1) i.AccountId FROM inserted [i]);
  DECLARE @sumBeforeTransaction DECIMAL(15, 2) = (SELECT TOP (1) i.OldSum FROM inserted [i]);
  DECLARE @sumAfterTransaction DECIMAL(15, 2) = (SELECT TOP (1) i.NewSum FROM inserted [i]);
  DECLARE @dateOfChange DATETIME2 = GETDATE();

  INSERT INTO NotificationEmails
  VALUES (@recipient, CONCAT('Balance change for account: ', @recipient),
          CONCAT('On ', FORMAT(@dateOfChange, 'MMM dd yyyy hh:mmtt'), ' your balance was changed from ',
                 @sumBeforeTransaction, ' to ', @sumAfterTransaction))
END
-- END --
GO


-- 16. --
CREATE OR ALTER PROC usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(15, 4))
AS
BEGIN TRANSACTION

IF (EXISTS(SELECT *
           FROM Accounts
           WHERE Id = @AccountId))
  BEGIN
    IF (@MoneyAmount <= 0)
      BEGIN
        ROLLBACK;
        RETURN;
      END

    UPDATE Accounts
    SET Balance += @MoneyAmount
    WHERE Id = @AccountId
  END

ELSE
  BEGIN
    ROLLBACK;
    RETURN;
  END

COMMIT

GO
-- END --

-- 17. --
CREATE OR ALTER PROC usp_WithdrawMoney(@accountId INT, @moneyAmount DECIMAL(15, 4))
AS
BEGIN TRANSACTION
UPDATE Accounts
SET Balance = Balance - @moneyAmount
WHERE Id = @accountId

IF @@ROWCOUNT <> 1
  BEGIN
    ROLLBACK;
    RETURN;
  END
COMMIT
GO
-- END --

-- 18. --
CREATE OR ALTER PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4))
AS
BEGIN TRANSACTION

IF (@Amount <= 0)
  BEGIN
    ROLLBACK
  END

EXEC usp_WithdrawMoney @SenderId, @Amount;
EXEC usp_DepositMoney @ReceiverId, @Amount;

COMMIT
GO
-- END --

-- 20. --
DECLARE @stamatCash DECIMAL(15, 2)
  = (SELECT Cash
     FROM Users [u]
            JOIN UsersGames [ug] ON ug.UserId = u.Id AND ug.GameId = 87 AND u.Id = 9)

DECLARE @itemsPrice DECIMAL(15, 2)
  = (SELECT SUM(Price)
     FROM Items
     WHERE MinLevel BETWEEN 11 AND 12)

BEGIN TRANSACTION
  IF (@stamatCash >= @itemsPrice)
    BEGIN
      UPDATE UsersGames
      SET Cash -= @itemsPrice
      WHERE UserId = 9
        AND GameId = 87

      INSERT INTO UserGameItems
      SELECT Id, 87
      FROM Items
      WHERE MinLevel BETWEEN 11 AND 12
    END

  ELSE
    BEGIN
      ROLLBACK
      RETURN
    END

  SET @stamatCash = (SELECT Cash
                     FROM Users [u]
                            JOIN UsersGames [ug] ON ug.UserId = u.Id AND ug.GameId = 87 AND u.Id = 9)

  SET @itemsPrice = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)

  IF (@stamatCash >= @itemsPrice)
    BEGIN
      UPDATE UsersGames
      SET Cash -= @itemsPrice
      WHERE UserId = 9
        AND GameId = 87

      INSERT INTO UserGameItems
      SELECT Id, 87
      FROM Items
      WHERE MinLevel BETWEEN 19 AND 21
    END

  ELSE
    BEGIN
      ROLLBACK
      RETURN
    END
COMMIT

SELECT i.Name [Item Name]
FROM UserGameItems [ugi]
       JOIN Items [i] ON i.Id = ugi.ItemId
       JOIN UsersGames [ug] ON ug.Id = ugi.UserGameId
       JOIN Users [u] ON u.Id = ug.UserId
WHERE u.Id = 9
ORDER BY [Item Name]
-- END --

-- 21. --
USE SoftUni
GO

CREATE OR ALTER PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION

DECLARE @employeeProjectsCount INT = (SELECT COUNT(EmployeeID)
                                      FROM EmployeesProjects
                                      WHERE EmployeeID = @emloyeeId)

IF (@employeeProjectsCount >= 3)
  BEGIN
    ROLLBACK
    RAISERROR ('The employee has too many projects!', 16, 1)
    RETURN
  END

INSERT INTO EmployeesProjects
VALUES (@emloyeeId, @projectID)
COMMIT
  -- END --

  -- 22. --
  CREATE TABLE Deleted_Employees
  (
    EmployeeId   INT PRIMARY KEY IDENTITY,
    FirstName    VARCHAR(30)    NOT NULL,
    LastName     VARCHAR(30)    NOT NULL,
    MiddleName   VARCHAR(30),
    JobTitle     VARCHAR(50),
    DepartmentId INT            NOT NULL,
    Salary       DECIMAL(15, 2) NOT NULL
  )
GO

CREATE OR ALTER TRIGGER tr_DeletedEmp
  ON Employees
  FOR DELETE
  AS
BEGIN
  INSERT INTO Deleted_Employees
  SELECT FirstName,
         LastName,
         MiddleName,
         JobTitle,
         DepartmentID,
         Salary
  FROM deleted
END
GO

DELETE
FROM Employees
WHERE EmployeeID = 3
SELECT *
FROM Deleted_Employees

-- END --