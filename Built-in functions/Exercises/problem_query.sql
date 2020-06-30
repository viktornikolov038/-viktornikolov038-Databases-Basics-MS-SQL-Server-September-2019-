USE SoftUni;
GO

-- Problem 01.
SELECT FirstName,
       LastName
FROM Employees
WHERE LOWER(FirstName) LIKE '%sa';
-- END --

-- Problem 02.
SELECT FirstName,
       LastName
FROM Employees
WHERE LastName LIKE '%ei%';
-- END --

-- Problem 03.
SELECT FirstName
FROM Employees
WHERE DepartmentID IN (3, 10)
  AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005;
-- END --

-- Problem 04.
SELECT FirstName,
       LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%';
-- END --

-- Problem 05.
SELECT [Name]
FROM Towns
WHERE LEN([Name]) BETWEEN 5 AND 6
ORDER BY [Name] ASC;
-- END --

-- Problem 06.
SELECT [TownID],
       [Name]
FROM Towns
WHERE [Name] LIKE '[mkbe]%'
ORDER BY [Name];
-- END --

-- Problem 07.
SELECT [TownID],
       [Name]
FROM Towns
WHERE [Name] LIKE '[^rbd]%'
ORDER BY [Name];
-- END --
GO
-- Problem 08.
CREATE VIEW v_EmployeesHiredAfter2000
AS
SELECT FirstName,
       LastName
FROM Employees
WHERE YEAR(HireDate) > YEAR('2000-01-01');
GO

SELECT *
FROM v_EmployeesHiredAfter2000
-- END --

-- Problem 09.
SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5
-- END --

-- Problem 10.
SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       DENSE_RANK() over (partition by Salary ORDER BY EmployeeID)
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC
-- END --

-- Problem 11.
SELECT *
FROM (
       SELECT EmployeeID,
              FirstName,
              LastName,
              Salary,
              DENSE_RANK() over (partition by Salary ORDER BY EmployeeID) AS Rank
       FROM Employees
       WHERE Salary BETWEEN 10000 AND 50000) AS MyTable
WHERE Rank = 2
ORDER BY Salary DESC
-- END --

-- Problem 12.
SELECT CountryName, IsoCode
FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode
-- END --

-- Problem 13.
SELECT p.PeakName,
       r.RiverName,
       LOWER(CONCAT(p.PeakName, SUBSTRING(r.RiverName, 2, LEN(r.RiverName)))) AS Mix
FROM Peaks AS p,
     Rivers AS r
WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY Mix
-- END --