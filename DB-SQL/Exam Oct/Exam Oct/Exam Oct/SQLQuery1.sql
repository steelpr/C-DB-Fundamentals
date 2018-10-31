CREATE DATABASE ReportService

CREATE TABLE Users(
Id INT PRIMARY KEY IDENTITY,
Username NVARCHAR(30) UNIQUE NOT NULL, 
[Password] NVARCHAR(50) NOT NULL,
[Name] NVARCHAR(50), 
Gender CHAR(1) CHECK(Gender IN ('M', 'F')),
BirthDate DATETIME,
Age INT,
Email NVARCHAR(50) NOT NULL
)

CREATE TABLE Departments(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(25),
LastName NVARCHAR(25),
Gender CHAR(1) CHECK(Gender IN ('M', 'F')),
BirthDate DATETIME,
Age INT,
DepartmentId INT FOREIGN KEY (DepartmentId)
                 REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
DepartmentId INT FOREIGN KEY (DepartmentId)
                 REFERENCES Departments(Id)
)

CREATE TABLE Status(
Id INT PRIMARY KEY IDENTITY,
Label VARCHAR(30) NOT NULL
)

CREATE TABLE Reports(
Id INT PRIMARY KEY IDENTITY,
CategoryId INT FOREIGN KEY (CategoryId) 
			   REFERENCES Categories(Id) NOT NULL,
StatusId INT FOREIGN KEY (StatusId)
             REFERENCES Status(Id) NOT NULL,
OpenDate DATETIME NOT NULL,
CloseDate DATETIME,
[Description] VARCHAR(200),
UserId INT FOREIGN KEY (UserId)
           REFERENCES Users(Id) NOT NULL,
EmployeeId INT FOREIGN KEY (EmployeeId) 
               REFERENCES Employees(Id)
)

INSERT INTO Employees(FirstName, LastName, Gender, Birthdate, DepartmentId)
VALUES
('Marlo', 'O’Malley', 'M', '9/21/1958',	1),
('Niki', 'Stanaghan', 'F', '11/26/1969', 4),
('Ayrton', 'Senna',	'M', '03/21/1960', 9),
('Ronnie', 'Peterson', 'M', '02/14/1944', 9),
('Giovanna', 'Amati', 'F', '07/20/1959', 5)

INSERT INTO Reports (CategoryId, StatusId, OpenDate, CloseDate, Description, UserId, EmployeeId)
VALUES
(1,  1, '04/13/2017', NULL,	 'Stuck Road on Str.133', 6, 2),
(6,	3, '09/05/2015', '12/06/2015', 'Charity trail running', 3, 5),
(14, 2,'09/07/2015', NULL,	 'Falling bricks on Str.58', 5,	2),
(4,	3, '07/03/2017', '07/06/2017', 'Cut off streetlight on Str.11', 1, 1)


UPDATE Reports SET StatusId = 2 
WHERE StatusId = 1 AND CategoryId = 4

DELETE FROM Reports WHERE StatusId = 4

SELECT Username, Age
  FROM Users
ORDER BY Age, Username DESC

SELECT Description, OpenDate
  FROM Reports
 WHERE EmployeeId IS NULL
ORDER BY OpenDate, Description

SELECT e.FirstName, e.LastName, r.Description, FORMAT(r.OpenDate, 'yyyy-MM-dd')
  FROM Employees AS e
  JOIN Reports AS r
    ON r.EmployeeId = e.Id
ORDER BY e.Id, r.OpenDate, r.Id

SELECT c.Name, COUNT(r.CategoryId) AS [ReportsNumber]
  FROM Reports AS r
  JOIN Categories AS c
    ON c.Id = r.CategoryId
GROUP BY c.Name
ORDER BY ReportsNumber DESC, c.Name 

SELECT c.Name, COUNT(e.DepartmentId) 
  FROM Employees AS e
  JOIN Departments AS d
    ON d.Id = e.DepartmentId
  JOIN Categories AS c
    ON c.DepartmentId = d.Id
GROUP BY c.Name
ORDER BY c.Name

SELECT DISTINCT CONCAT(FirstName, ' ', LastName) AS Name, COUNT(r.EmployeeId) AS UsersNumber
  FROM Employees AS e
  LEFT JOIN Reports AS r
    ON r.EmployeeId = e.Id
GROUP BY CONCAT(FirstName, ' ', LastName)
ORDER BY UsersNumber DESC, CONCAT(FirstName, ' ', LastName)

SELECT r.OpenDate, r.Description, u.Email
  FROM Reports AS r
  JOIN Categories AS c
    ON c.Id = r.CategoryId
  JOIN Users AS u
    ON u.Id = r.UserId
 WHERE r.CloseDate IS NULL AND LEN(r.Description) > 20
                           AND  r.Description LIKE '%str%'
						   AND c.DepartmentId IN (1, 4, 5)
ORDER BY r.OpenDate, u.Email,  r.Id

SELECT DISTINCT c.Name AS CategoryName
	     FROM Categories AS c
	     JOIN Reports AS r
	       ON r.CategoryId = c.Id
	     JOIN Users AS u 
	       ON u.Id = r.UserId
	    WHERE DAY(u.BirthDate) = DAY(r.OpenDate) AND MONTH(u.BirthDate) = MONTH(r.OpenDate)
	 ORDER BY CategoryName


SELECT DISTINCT Username
  FROM Users AS u
  JOIN Reports AS r
    ON r.UserId = u.Id
 WHERE LEFT(Username, 1) LIKE '[0-9]' AND
       r.CategoryId LIKE LEFT(Username, 1) OR
	   RIGHT(Username, 1) LIKE '[0-9]' AND
	   r.CategoryId LIKE RIGHT(Username, 1)
ORDER BY Username 

SELECT E.Firstname+' '+E.Lastname AS FullName, 
	   ISNULL(CONVERT(varchar, CC.ReportSum), '0') + '/' +        
       ISNULL(CONVERT(varchar, OC.ReportSum), '0') AS [Stats]
FROM Employees AS E
JOIN (SELECT EmployeeId,  COUNT(1) AS ReportSum
	  FROM Reports R
	  WHERE  YEAR(OpenDate) = 2016
	  GROUP BY EmployeeId) AS OC ON OC.Employeeid = E.Id
LEFT JOIN (SELECT EmployeeId,  COUNT(1) AS ReportSum
	       FROM Reports R
	       WHERE  YEAR(CloseDate) = 2016
	       GROUP BY EmployeeId) AS CC ON CC.Employeeid = E.Id
ORDER BY FullName

CREATE FUNCTION udf_GetReportsCount(@employeeId INT, @statusId INT)
RETURNS INT
AS 
BEGIN
DECLARE @count INT

	 SET @count = (
	 SELECT COUNT(Description)
	  FROM Reports
     WHERE EmployeeId = @employeeId AND StatusId = @statusId
	 )

	 RETURN @count
END

SELECT Id, FirstName, Lastname, dbo.udf_GetReportsCount(Id, 2) AS ReportsCount
FROM Employees
ORDER BY Id

CREATE PROC usp_AssignEmployeeToReport(@employeeId INT, @reportId INT) AS
BEGIN
	BEGIN TRY
		SELECT COUNT(r.Description)
		  FROM Reports AS r
		JOIN Categories AS c
		  ON c.Id = r.CategoryId
	 JOIN Employees AS e
		   ON e.DepartmentId = c.DepartmentId
	    WHERE e.Id = @employeeId AND r.Id = @reportId AND
		     e.DepartmentId = c.DepartmentId
	END TRY
	BEGIN CATCH
		PRINT 'Employee doesn''t belong to the appropriate department!';
		THROW;
		ROLLBACK;
	END CATCH
END


EXEC usp_AssignEmployeeToReport 17, 2;
SELECT EmployeeId FROM Reports  WHERE Id = 2
