USE Gringotts;
GO

-- Problem 01.
SELECT COUNT(*) AS [Count]
FROM WizzardDeposits;

-- Problem 02.
SELECT MAX(MagicWandSize)
FROM WizzardDeposits;

-- Problem 03.
SELECT DepositGroup,
       MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY DepositGroup;

-- Problem 04.
SELECT TOP (2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize);

-- Problem 04.
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
GROUP BY DepositGroup;

-- Problem 05.
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
GROUP BY DepositGroup;

-- Problem 06.
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup;

-- Problem 07.
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC;

-- Problem 08.
SELECT DepositGroup,
       MagicWandCreator,
       MIN(DepositCharge)
FROM WizzardDeposits
GROUP BY DepositGroup,
         MagicWandCreator
ORDER BY MagicWandCreator,
         DepositGroup;

-- Problem 09.
SELECT AgeGroup,
       COUNT(AgeGroup)
FROM (
       SELECT CASE
                WHEN Age BETWEEN 0 AND 10
                  THEN '[0-10]'
                WHEN Age BETWEEN 11 AND 20
                  THEN '[11-20]'
                WHEN Age BETWEEN 21 AND 30
                  THEN '[21-30]'
                WHEN Age BETWEEN 31 AND 40
                  THEN '[31-40]'
                WHEN Age BETWEEN 41 AND 50
                  THEN '[41-50]'
                WHEN Age BETWEEN 51 AND 60
                  THEN '[51-60]'
                ELSE '[61+]'
                END AS AgeGroup
       FROM WizzardDeposits
     ) AS AgeTable
GROUP BY AgeGroup;

-- Problem 10.
SELECT LEFT(FirstName, 1) AS Letter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1);

-- Problem 11.
SELECT DepositGroup,
       IsDepositExpired,
       AVG(DepositInterest) AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '01-01-1985'
GROUP BY DepositGroup,
         IsDepositExpired
ORDER BY DepositGroup DESC,
         IsDepositExpired;

-- Problem 12.

SELECT SUM(k.Diff) [Diff]
FROM (
       SELECT wd.DepositAmount -
              (
                SELECT w.DepositAmount
                FROM WizzardDeposits AS w
                WHERE w.Id = wd.Id + 1
              ) AS Diff
       FROM WizzardDeposits AS wd
     ) AS k;

-- Problem 13.
SELECT DepartmentID,
       SUM(Salary) [TotalSalary]
FROM Employees
GROUP BY DepartmentID;

-- Problem 14.
SELECT DepartmentID,
       MIN(Salary) [TotalSalary]
FROM Employees
WHERE DepartmentID IN (2, 5, 7)
  AND YEAR(HireDate) >= 2000
GROUP BY DepartmentID;

-- Problem 15.
SELECT * INTO NewTB
FROM Employees
WHERE Salary > 30000;
GO

DELETE
FROM NewTB
WHERE ManagerID = 42;
GO

UPDATE NewTB
SET Salary+=5000
WHERE DepartmentID = 1;
GO

SELECT DepartmentID,
       AVG(Salary)
FROM NewTB
GROUP BY DepartmentID;

-- Problem 16.
SELECT DepartmentID,
       MAX(Salary) [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000;

-- Problem 17.
SELECT COUNT(*)
FROM Employees
WHERE ManagerID IS NULL;

-- Problem 18.
USE SoftUni
GO

SELECT DepartmentID, Salary
FROM (
       SELECT DepartmentID,
              Salary,
              DENSE_RANK() over (partition by DepartmentID order by Salary DESC) [Rank]
       FROM Employees) [k]
WHERE Rank = 3
GROUP BY DepartmentID, Salary


-- Problem 19.
SELECT TOP (10) FirstName, LastName, k.DepartmentID
FROM Employees AS [k]
       JOIN
     (SELECT DepartmentID, AVG(Salary) AS [Avg]
      FROM Employees
      GROUP BY DepartmentID) AS [r] ON r.DepartmentID = k.DepartmentID
WHERE Salary > Avg