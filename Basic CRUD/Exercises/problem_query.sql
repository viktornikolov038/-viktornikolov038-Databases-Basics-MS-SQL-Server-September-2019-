USE SoftUni
GO
-- Problem 01.
SELECT *
FROM Departments
-- END --

-- Problem 02.
SELECT [Name]
FROM Departments
-- END --

-- Problem 03.
SELECT FirstName, LastName, Salary
FROM Employees
-- END --

-- Problem 04.
SELECT FirstName, LastName, Salary
FROM Employees
-- END --

-- Problem 05.
SELECT FirstName, MiddleName, LastName
FROM Employees
-- END --

-- Problem 06.
SELECT FirstName + '.' + LastName + '@softuni.bg' AS 'Full Email Address'
FROM Employees
-- END --

-- Problem 07.
SELECT DISTINCT Salary
FROM Employees
-- END --

-- Problem 08.
SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'
-- END --

-- Problem 09.
SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000
-- END --

-- Problem 10.
SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [FullName]
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

-- END --

-- Problem 11.
SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL
-- END --

-- Problem 12.
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary >= 50000
ORDER BY Salary DESC
-- END --

-- Problem 13.
SELECT TOP 5 FirstName, LastName
FROM Employees
ORDER BY Salary DESC
-- END --

-- Problem 14.
SELECT FirstName, LastName
FROM Employees
WHERE DepartmentID != 4
-- END --

-- Problem 15.
SELECT *
FROM Employees
ORDER BY Salary DESC, FirstName ASC, LastName DESC, MiddleName ASC
-- END --

-- Problem 16.
CREATE VIEW v_EmployeesSalaries AS
SELECT FirstName, LastName, Salary
FROM Employees

SELECT *
FROM v_EmployeesSalaries
-- END --

-- Problem 17.
CREATE VIEW v_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle AS [Job Title]
FROM Employees

SELECT *
FROM v_EmployeeNameJobTitle
-- END --

-- Problem 18.
SELECT DISTINCT JobTitle
FROM Employees
-- END --

-- Problem 19.
SELECT TOP 10 *
FROM Projects
ORDER BY StartDate, [Name]
-- END --

-- Problem 20.
SELECT TOP 7 FirstName, LastName, HireDate
FROM Employees
ORDER BY HireDate DESC
-- END --

-- Problem 21.
UPDATE Employees
SET Salary *= 1.12
WHERE DepartmentID IN (1, 2, 4, 11)

SELECT Salary
FROM Employees
-- END --

USE Geography
-- Problem 22.
SELECT PeakName
FROM Peaks
ORDER BY PeakName ASC
-- END --

-- Problem 23.
SELECT TOP 30 CountryName, Population
FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY Population DESC, CountryName ASC
-- END --

-- Problem 24.
SELECT CountryName,
       CountryCode,
       CASE
         WHEN CurrencyCode = 'EUR' THEN 'Euro'
         ELSE 'Not Euro'
         END
FROM Countries
ORDER BY CountryName ASC
-- END --

USE Diablo
-- Problem 25.
SELECT [Name]
FROM Characters
ORDER BY [Name] ASC
-- END --