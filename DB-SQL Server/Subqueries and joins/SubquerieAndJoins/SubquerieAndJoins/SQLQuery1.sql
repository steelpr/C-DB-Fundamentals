-- Problem 1.	Employee Address

SELECT TOP (5) EmployeeID, JobTitle, e.AddressID, a.AddressText
      FROM Employees AS e
INNER JOIN Addresses AS a
        ON e.AddressID = a.AddressID
  ORDER BY e.AddressID ASC

-- Problem 2.	Addresses with Towns

SELECT TOP (50) FirstName, LastName, t.Name , a.AddressText
      FROM Employees AS e
INNER JOIN Addresses AS a
        ON a.AddressID = e.AddressID
INNER JOIN Towns AS t
        ON t.TownID = a.TownID
  ORDER BY FirstName, LastName

-- Problem 3.	Sales Employee

    SELECT EmployeeID, FirstName, LastName, d.Name
      FROM Employees AS e
INNER JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
	 WHERE d.Name = 'Sales'
  ORDER BY EmployeeID

-- Problem 4.	Employee Departments

SELECT TOP (5) EmployeeID, FirstName, Salary, d.Name AS DepartmentName
      FROM Employees AS e
INNER JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
	 WHERE e.Salary > 15000
  ORDER BY e.DepartmentID

-- Problem 5.	Employees Without Project

      SELECT TOP (3) e.EmployeeID , e.FirstName
            FROM EmployeesProjects AS ep
RIGHT OUTER JOIN Employees as e
              ON e.EmployeeID = ep.EmployeeID
           WHERE ep.EmployeeID IS NULL

-- Problem 6.	Employees Hired After

SELECT FirstName, LastName, HireDate, d.Name
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID 
 WHERE HireDate > '01/01/1999' AND Name = 'Sales' OR Name = 'Finance'
ORDER BY HireDate

-- Problem 7.	Employees with Project

SELECT TOP (5) ep.EmployeeID, e.FirstName, p.Name
      FROM EmployeesProjects AS ep
      JOIN Employees AS e
        ON e.EmployeeID = ep.EmployeeID
      JOIN Projects AS p
        ON p.ProjectID = ep.ProjectID
	 WHERE p.StartDate > CONVERT(DATE, '13/08/2002', 103) AND p.EndDate IS NULL
  ORDER BY EmployeeID

-- Problem 8.	Employee 24

 SELECT e.EmployeeID, e.FirstName,
   CASE 
       WHEN p.StartDate > '2004/12/31' THEN NULL
       ELSE p.Name
    END
   FROM EmployeesProjects AS ep
   JOIN Employees AS e
     ON e.EmployeeID = ep.EmployeeID
   JOIN Projects AS p
     ON p.ProjectID = ep.ProjectID

  WHERE ep.EmployeeID = 24

-- Problem 9.	Employee Manager

SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName
  FROM Employees AS e
  JOIN Employees AS m 
    ON m.EmployeeID = e.ManagerID
 WHERE e.ManagerID LIKE '[3, 7]'
 ORDER BY EmployeeID

-- Problem 10.	Employee Summary

SELECT TOP (50) e.EmployeeID, CONCAT(e.FirstName,' ', e.LastName) AS EmployeeName,
                              CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
				              d.Name AS DepartmentName
      FROM Employees AS e
      JOIN Employees AS m
        ON m.EmployeeID = e.ManagerID
      JOIN Departments AS d
        ON d.DepartmentID = e.DepartmentID
 ORDER BY EmployeeID

-- Problem 11.	Min Average Salary

SELECT MIN(s.avg) AS MinAverageSalary
  FROM(
SELECT AVG(Salary) AS avg
  FROM Employees
GROUP BY DepartmentID
) AS s

-- Problem 12.	Highest Peaks in Bulgaria

   SELECT CountryCode, m.MountainRange, p.PeakName, p.Elevation
     FROM MountainsCountries AS mc
     JOIN Mountains AS m
       ON m.Id = mc.MountainId
     JOIN Peaks AS p
       ON p.MountainId = m.Id
    WHERE CountryCode = 'BG' AND p.Elevation > 2835
 ORDER BY Elevation DESC

-- Problem 13.	Count Mountain Ranges

SELECT c.CountryCode, COUNT(m.MountainId)
  FROM Countries AS c
  JOIN MountainsCountries AS m
    ON m.CountryCode = c.CountryCode
 WHERE c.CountryCode IN ('BG', 'RU', 'US')
 GROUP BY c.CountryCode

-- Problem 14.	Countries with Rivers

SELECT TOP (5) cnt.CountryName, river.RiverName
      FROM CountriesRivers AS criver
RIGHT JOIN Countries AS cnt
        ON cnt.CountryCode = criver.CountryCode
 LEFT JOIN Rivers AS river
        ON river.Id = criver.RiverId
  WHERE cnt.ContinentCode = 'AF'
  ORDER BY CountryName

-- Continents and Currencies

    WITH CTE_ContinentInfo (ContinentCode, CurrencyCode, CurrencyUsage) AS (
  SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS CurrencyUsage
    FROM Countries
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(CurrencyCode) > 1)

SELECT c.ContinentCode, ct.CurrencyCode, c.m AS CurrencyUsage
  FROM(
 SELECT ContinentCode, MAX(CurrencyUsage) AS m
  FROM CTE_ContinentInfo
GROUP BY ContinentCode) AS c
JOIN CTE_ContinentInfo AS ct
  ON ct.ContinentCode = c.ContinentCode AND
     ct.CurrencyUsage = c.m

-- Problem 16.	Countries without any Mountains

   SELECT COUNT(*) AS CountryCode
     FROM Countries AS e
LEFT JOIN MountainsCountries AS m
       ON m.CountryCode = e.CountryCode
    WHERE m.CountryCode IS NULL
  
-- Problem 17.	Highest Peak and Longest River by Country

SELECT TOP (5) CountryName, MAX(p.Elevation)  AS HighestPeakElevation, MAX(r.Length) AS LongestRiverLength
      FROM Countries AS c
      JOIN MountainsCountries AS mc
        ON mc.CountryCode = c.CountryCode
      JOIN Peaks AS p
        ON p.MountainId = mc.MountainId
      JOIN CountriesRivers AS cr
        ON cr.CountryCode = c.CountryCode
      JOIN Rivers AS r
        ON r.Id = cr.RiverId
  GROUP BY c.CountryName
  ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, CountryName

-- Highest Peak Name and Elevation by Country

WITH CTE_CountriesInfo(CountryName, PeakName, Elevation, Mountain) AS(
SELECT c.CountryName, p.PeakName, MAX(p.Elevation), m.MountainRange
  FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
   ON mc.CountryCode = c.CountryCode
   LEFT JOIN Mountains AS m
  ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p
  ON p.MountainId = m.Id
GROUP BY c.CountryName, p.PeakName, m.MountainRange)

SELECT TOP(5) e.CountryName,
        ISNULL(cci.PeakName, '(no highest peak)') AS [Highest Peak Name],
		ISNULL(cci.Elevation, 0) AS [Highest Peak Elevation],
		ISNULL(cci.Mountain, '(no mountain)') AS [Mountain]
	FROM(
	SELECT CountryName, MAX(Elevation) AS MaxElevation
	  FROM  CTE_CountriesInfo
		  GROUP BY CountryName) AS e
	  LEFT JOIN  CTE_CountriesInfo AS cci ON cci.CountryName = e.CountryName AND cci.Elevation = e.MaxElevation
	  ORDER BY e.CountryName, cci.PeakName