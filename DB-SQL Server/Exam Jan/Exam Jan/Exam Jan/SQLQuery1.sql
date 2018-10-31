CREATE DATABASE RentACar

CREATE TABLE Clients(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(30) NOT NULL,
Gender CHAR(1) CHECK(Gender IN ('M', 'F')),
BirthDate DATETIME,
CreditCard NVARCHAR(30) NOT NULL,
CardValidity DATETIME,
Email NVARCHAR(50) NOT NULL
)

CREATE TABLE Towns(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Offices(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(40),
ParkingPlaces INT,
TownId INT FOREIGN KEY (TownId)
        REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Models(
Id INT PRIMARY KEY IDENTITY,
Manufacturer NVARCHAR(50) NOT NULL,
Model NVARCHAR(50) NOT NULL,
ProductionYear DATETIME,
Seats INT,
Class NVARCHAR(10),
Consumption DECIMAL(14, 2)
)

CREATE TABLE Vehicles(
Id INT PRIMARY KEY IDENTITY,
ModelId INT FOREIGN KEY (ModelId) 
        REFERENCES Models(Id) NOT NULL,
OfficeId INT FOREIGN KEY (OfficeId)
            REFERENCES Offices(Id) NOT NULL,
Mileage INT
)

CREATE TABLE Orders(
Id INT PRIMARY KEY IDENTITY,
ClientId INT FOREIGN KEY (ClientId)
            REFERENCES Clients(Id) NOT NULL,
TownId INT FOREIGN KEY (TownId)
            REFERENCES Towns(Id) NOT NULL,
VehicleId INT FOREIGN KEY (VehicleId)
            REFERENCES Vehicles(Id) NOT NULL,
CollectionDate DATETIME NOT NULL,
CollectionOfficeId INT FOREIGN KEY (CollectionOfficeId)
            REFERENCES Offices(Id) NOT NULL,
ReturnDate DATETIME,
ReturnOfficeId INT FOREIGN KEY (CollectionOfficeId)
            REFERENCES Offices(Id),
Bill DECIMAL(14, 2),
TotalMileage INT
)

INSERT INTO Models(Manufacturer, Model,	ProductionYear,	Seats, Class, Consumption)
VALUES
('Chevrolet', 'Astro', '2005-07-27 00:00:00.000', 4, 'Economy', 12.60),
('Toyota', 'Solara', '2009-10-15 00:00:00.000',	7, 'Family', 13.80),
('Volvo', 'S40', '2010-10-12 00:00:00.000',	3, 'Average', 11.30),
('Suzuki', 'Swift', '2000-02-03 00:00:00.000',	7, 'Economy', 16.20)

INSERT INTO Orders(ClientId, TownId, VehicleId,	CollectionDate, CollectionOfficeId,	ReturnDate, ReturnOfficeId, Bill, TotalMileage)
VALUES
(17, 2, 52,  CONVERT(date, '2017-08-08', 102), 30, CONVERT(date, '2017-09-04', 102), 42, 2360.00, 7434),
(78, 17, 50, CONVERT(date, '2017-04-22', 102), 10, CONVERT(date, '2017-05-09', 102), 12, 2326.00, 7326),
(27, 13, 28, CONVERT(date, '2017-04-25', 102), 21, CONVERT(date, '2017-05-09', 102), 34, 597.00, 1880)

UPDATE Models
   SET Class = 'Luxury'
 WHERE Consumption > 20

 DELETE FROM Orders WHERE ReturnDate IS NULL

 SELECT Manufacturer, Model
   FROM Models
ORDER BY Manufacturer, Id DESC

SELECT FirstName, LastName
  FROM Clients
 WHERE YEAR(BirthDate) BETWEEN 1977 AND 1994
ORDER BY FirstName, LastName, Id 

SELECT t.Name, o.Name, o.ParkingPlaces 
  FROM Offices AS o
  JOIN Towns AS t
    ON t.Id = o.TownId
 WHERE o.ParkingPlaces > 25
ORDER BY t.Name, o.Id

SELECT m.Model, m.Seats, v.Mileage
  FROM Vehicles AS v
  JOIN Models AS m
    ON m.Id = v.ModelId
 WHERE v.Id NOT IN(
	SELECT VehicleId
	  FROM Orders
	 WHERE ReturnDate IS NULL
 )
ORDER BY v.Mileage, m.Seats DESC , m.Id

SELECT t.Name AS TownName, COUNT(o.TownId) AS OfficesNumber
  FROM Towns AS t
  JOIN Offices AS o
    ON o.TownId = t.Id
GROUP BY t.Name
ORDER BY OfficesNumber DESC, TownName
  
 SELECT m.Manufacturer, m.Model, COUNT(o.VehicleId) AS TimesOrdered
   FROM Vehicles AS v
   JOIN Models AS m
     ON m.Id = v.ModelId
   LEFT JOIN Orders AS o
     ON o.VehicleId = v.Id
GROUP BY m.Manufacturer, m.Model
ORDER BY TimesOrdered DESC, m.Manufacturer DESC, m.Model

SELECT c.FirstName + ' ' + c.LastName AS Names, m.Class
  FROM Orders AS o
  JOIN Clients AS c
    ON c.Id = o.ClientId
  JOIN Vehicles AS v
    ON v.Id = o.VehicleId
  JOIN Models AS m
    ON m.Id = v.ModelId
 WHERE 
ORDER BY Names, m.Class, c.Id

DROP FUNCTION udf_CheckForVehicle(@townName NVARCHAR(MAX), @seatsNumber INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @result NVARCHAR(MAX) 
			SET @result = (
		SELECT TOP (1) CONCAT(o.Name, ' ', '-', ' ', m.Model) AS OfficeName
		  FROM Vehicles AS v
		  JOIN Models AS m
		    ON m.Id = v.ModelId
		  JOIN Offices AS o
		    ON o.Id = v.OfficeId
		  JOIN Towns AS t
		    ON t.Id = o.TownId 
	  WHERE m.Seats = @seatsNumber AND t.Name = @townName
	  ORDER BY OfficeName)

	IF(@result IS NULL)
	BEGIN
		SET @result = ('NO SUCH VEHICLE FOUND');
	END
	RETURN @result
END

SELECT dbo.udf_CheckForVehicle ('La Escondida', 9) 

CREATE PROC usp_MoveVehicle(@vehicleId INT, @officeId INT) AS
BEGIN TRY
	DECLARE @count INT = (
	SELECT COUNT(Id)
		  FROM Vehicles
	     WHERE OfficeId = @officeId
		GROUP BY OfficeId)
	
	 DECLARE @park INT = ( SELECT ParkingPlaces FROM
	 Offices WHERE Id = @officeId)

	 IF(@park > @count)
	 BEGIN
		UPDATE Vehicles SET OfficeId = @officeId
		WHERE Id = @vehicleId
	 END
END TRY
BEGIN CATCH
	PRINT 'Not enough room in this office!';
	ROLLBACK;
END CATCH

EXEC usp_MoveVehicle 7, 32;
SELECT OfficeId FROM Vehicles WHERE Id = 7

CREATE TRIGGER tr_Mileage
ON Orders
AFTER UPDATE
AS
BEGIN
	DECLARE @newmMleage INT = (
	SELECT TotalMileage FROM inserted
	)

	DECLARE @id INT = (
	SELECT VehicleId FROM inserted
	)


	UPDATE Vehicles SET Mileage += @newmMleage
	 WHERE Id = @id
END

UPDATE Orders
SET
TotalMileage = 100
WHERE Id = 40;

UPDATE Orders
SET
TotalMileage = 100
WHERE Id = 16;

SELECT Mileage FROM Vehicles
WHERE Id = 25
