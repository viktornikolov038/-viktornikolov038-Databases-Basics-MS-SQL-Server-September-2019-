USE SoftUni
GO

-- Problem 01.
SELECT TOP (5) e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText
FROM Employees [e]
       LEFT JOIN Addresses [a] on e.AddressID = a.AddressID
ORDER BY a.AddressID ASC
-- END --

-- Problem 02.
SELECT TOP (50) e.FirstName, e.LastName, t.Name, a.AddressText
FROM Employees [e]
       LEFT JOIN Addresses [a] on e.AddressID = a.AddressID
       LEFT JOIN Towns t on a.TownID = t.TownId
ORDER BY e.FirstName ASC, e.LastName ASC
-- END --

-- Problem 03.
SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name [DepartmentName]
FROM Employees [e]
       LEFT JOIN Departments d on e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY e.EmployeeID
-- END --

-- Problem 04.
SELECT TOP (5) e.EmployeeID, e.FirstName, e.Salary, d.Name [DepartmentName]
FROM Employees [e]
       LEFT JOIN Departments d on e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID
-- END --

-- Problem 05.
SELECT TOP (3) e.EmployeeID, e.FirstName
FROM Employees [e]
       LEFT JOIN EmployeesProjects [ep] ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID ASC;
-- END --

-- Problem 06.
SELECT e.FirstName, e.LastName, e.HireDate, d.Name [DeptName]
FROM Employees [e]
       JOIN Departments [d]
            ON (e.DepartmentID = d.DepartmentID AND e.HireDate > YEAR('1999') AND d.Name IN ('Sales', 'Finance'))
ORDER BY e.HireDate
-- END --

-- Problem 07.
SELECT TOP (5) e.EmployeeID, e.FirstName, p.Name [ProjectName]
FROM Employees [e]
       JOIN EmployeesProjects [ep] on e.EmployeeID = ep.EmployeeID
       JOIN Projects [p] on ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002-08-13'
  AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC
-- END --

-- Problem 08.
SELECT YEAR('2005')

SELECT e.EmployeeID,
       e.FirstName,
       CASE
         WHEN p.StartDate >= '2005-01-01' THEN NULL
         ELSE p.Name
         END AS [ProjectName]
FROM Employees [e]
       INNER JOIN EmployeesProjects [ep] ON e.EmployeeID = ep.EmployeeID AND e.EmployeeID = 24
       INNER JOIN Projects [p] ON ep.ProjectID = p.ProjectID
-- END --

-- Problem 09.
SELECT e.EmployeeID, e.FirstName, em.EmployeeID, em.FirstName
FROM Employees [e]
       INNER JOIN Employees [em] ON e.ManagerID = em.EmployeeID AND em.EmployeeID IN (3, 7)
ORDER BY e.EmployeeID ASC
-- END --

-- Problem 10.
SELECT TOP (50) e.EmployeeID,
                e.FirstName + ' ' + e.LastName   [EmployeeName],
                em.FirstName + ' ' + em.LastName [ManagerName],
                d.Name                           [DepartmentName]
FROM Employees [e]
       INNER JOIN Departments [d] on e.DepartmentID = d.DepartmentId
       INNER JOIN Employees [em] on e.ManagerID = em.EmployeeID
ORDER BY e.EmployeeID
-- END --

-- Problem 11.
SELECT TOP (1) AVG(Salary) [MinAverageSalary]
FROM Employees
GROUP BY DepartmentID
ORDER BY MinAverageSalary
-- END --

-- Problem 12.
USE Geography

SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Countries [c]
       JOIN MountainsCountries [mc] ON c.CountryCode = mc.CountryCode AND c.CountryCode = 'BG'
       JOIN Mountains [m] ON mc.MountainId = m.Id
       JOIN Peaks [p] ON m.Id = p.MountainId AND p.Elevation > 2835
ORDER BY p.Elevation DESC
-- END --

-- Problem 13.
SELECT c.CountryCode, COUNT(mc.MountainId) [MountainRanges]
FROM Countries [c]
       INNER JOIN MountainsCountries [mc] ON c.CountryCode = mc.CountryCode AND c.CountryCode IN ('BG', 'RU', 'US')
GROUP BY c.CountryCode
-- END --

-- Problem 14.
SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries [c]
       LEFT JOIN CountriesRivers [cr] ON c.CountryCode = cr.CountryCode
       LEFT JOIN Rivers [r] ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName ASC
-- END --

-- Problem 15.
SELECT ContinentCode, CurrencyCode, CurrencyUsage FROM(SELECT ContinentCode,
	   CurrencyCode,
	   COUNT(CurrencyCode)[CurrencyUsage],
	   DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) [Rank]
FROM Countries
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(CurrencyCode) > 1) [t]
WHERE Rank = 1
-- END --

-- Problem 16.
SELECT COUNT(*) [CountryCode]
FROM Countries [c]
	LEFT JOIN MountainsCountries [mc] ON c.CountryCode = mc.CountryCode
WHERE mc.MountainId IS NULL
-- END --

-- Problem 17.
SELECT TOP(5)c.CountryName
	,MAX(p.Elevation) [PeakElevation]
	,MAX(r.Length) [RiverLength]
FROM Countries [c]
	LEFT JOIN CountriesRivers [cr] ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers [r] ON r.Id = cr.RiverId
	LEFT JOIN MountainsCountries [mc] ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains [m] ON m.Id = mc.MountainId
	LEFT JOIN Peaks [p] ON m.Id = p.MountainId
GROUP BY c.CountryName
ORDER BY PeakElevation DESC, RiverLength DESC, CountryName ASC
-- END --

-- Problem 18.
SELECT TOP (5) CountryName
	,[Highest Peak Name]
	,[Highest Peak Elevation]
	,[Mountain]
FROM (SELECT c.CountryName
		,CASE
			WHEN p.PeakName IS NULL THEN '(no highest peak)'
			ELSE p.PeakName
			END AS [Highest Peak Name]
		,CASE
			WHEN MAX(p.Elevation) IS NULL THEN '0'
			ELSE MAX(p.Elevation)
			END AS [Highest Peak Elevation]
		,CASE
			WHEN m.MountainRange IS NULL THEN '(no mountain)'
			ELSE m.MountainRange
			END AS [Mountain],
		DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY MAX(p.ELEVATION) DESC) [Rank]
	FROM Countries [c]
		LEFT JOIN MountainsCountries [mc] ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains [m] ON m.Id = mc.MountainId
		LEFT JOIN Peaks [p] ON m.Id = p.MountainId
	GROUP BY c.CountryName, p.PeakName, m.MountainRange) [t]
WHERE t.[Rank] = 1
ORDER BY t.CountryName, t.[Highest Peak Name]
-- END --