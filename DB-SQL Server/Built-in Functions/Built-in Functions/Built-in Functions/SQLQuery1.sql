-- Problem 1.	Find Names of All Employees by First Name

SELECT FirstName, LastName
  FROM Employees
 WHERE FirstName LIKE 'SA%'

 -- Find Names of All employees by Last Name 

 SELECT FirstName, LastName
   FROM Employees
WHERE LastName LIKE '%ei%'

-- Problem 3.	Find First Names of All Employees

SELECT FirstName
  FROM Employees
 WHERE DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005 AND
                     DepartmentID = 3 OR DepartmentID = 10

-- Problem 4.	Find All Employees Except Engineers

SELECT FirstName, LastName
  FROM Employees
 WHERE JobTitle NOT LIKE '%engineer%'

 -- Problem 5.	Find Towns with Name Length
 
 SELECT [Name] 
   FROM Towns
  WHERE LEN([Name]) IN  (5, 6)
ORDER BY [Name]

-- Find Towns Starting With

SELECT TownID,[Name]
  FROM Towns
WHERE [Name] LIKE 'M%' OR [Name] LIKE 'K%' OR [Name] LIKE 'B%' OR [Name] LIKE 'E%'
ORDER BY [Name]

-- Find Towns Not Starting With

SELECT TownID, [Name]  
  FROM Towns
 WHERE [Name] NOT LIKE 'R%' AND [Name] NOT LIKE 'B%' AND [Name] NOT LIKE 'D%'
ORDER BY [Name]

-- Problem 8.	Create View Employees Hired After 2000 Year

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
  FROM Employees
 WHERE DATEPART(YEAR, HireDate) > 2000

 -- Problem 9.	Length of Last Name

 SELECT FirstName, LastName
   FROM Employees
  WHERE LEN(LastName) = 5

  -- Problem 10.	Countries Holding �A� 3 or More Times


SELECT CountryName, ISOCode
  FROM Countries
 WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

-- Mix of Peak and River Names

SELECT PeakName, RiverName,(
SELECT LOWER(CONCAT(SUBSTRING(PeakName, 1 , LEN(PeakName) - 1), RiverName)) 
) [Mix]
  FROM Peaks, Rivers
 WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
 ORDER BY Mix



 -- Problem 12.	Games from 2011 and 2012 year

SELECT TOP (50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
  FROM Games
 WHERE DATEPART(YEAR, [Start]) LIKE '2011' OR DATEPART(YEAR, [Start]) LIKE '2012'
ORDER BY [Start]

-- User Email Providers

SELECT UserName, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Email Provider]
  FROM Users
ORDER BY [Email Provider], Username

-- Get Users with IPAdress Like Pattern

SELECT Username, IpAddress
  FROM Users
 WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- Show All Games with Duration and Part of the Day

SELECT [Name],
CASE
    WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
    ELSE 'Evening'
END AS [Part of the Day],
CASE
    WHEN Duration <= 3 THEN 'Extra Short '
    WHEN Duration BETWEEN 4 AND 6 THEN 'Short '
    WHEN Duration > 6 THEN 'Long'
    ELSE 'Extra Long'
END AS [Duration]
FROM Games
ORDER BY [Name], Duration, [Part of the Day]

-- Orders Table

SELECT ProductName, OrderDate,
       DATEADD(DAY, 3 , OrderDate) [Pay Due],
       DATEADD(MONTH, 1, OrderDate) [Deliver Due]
FROM Orders

-- People Table

CREATE TABLE People(
Id INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
Birthdate DATETIME NOT NULL
)

INSERT INTO People
VALUES
(1,	'Victor', '2000-12-07 00:00:00.000'),
(2,	'Steven',	'1992-09-10 00:00:00.000'),
(3,	'Stephen', '1910-09-19 00:00:00.000'),
(4,	'John', '2010-01-06 00:00:00.000')

SELECT [Name],
      DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age In Years],
	  DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age In Months],
	  DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age In Days],
	  DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age In Minutes]
FROM People

