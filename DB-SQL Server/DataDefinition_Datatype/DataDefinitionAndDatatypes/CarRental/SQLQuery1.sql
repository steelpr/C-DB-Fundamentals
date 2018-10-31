CREATE DATABASE CarRental

CREATE TABLE Categories(
Id INT PRIMARY KEY,
CategoryName VARCHAR(50) NOT NULL,
DailyRate VARCHAR(50),
WeeklyRate VARCHAR(50),
MonthlyRate VARCHAR(50),
WeekendRate VARCHAR(50)
)

CREATE TABLE Cars(
Id INT PRIMARY KEY,
PlateNumber INT NOT NULL,
Manufacturer VARCHAR(50) NOT NULL,
Model VARCHAR(50) NOT NULL,
CarYear DATE NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
Doors VARCHAR(50),
Picture VARBINARY(MAX),
Condition VARCHAR(50),
Available VARCHAR(50)
)

CREATE TABLE Employees(
Id INT PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Title NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers(
Id INT PRIMARY KEY,
DriverLicenceNumber INT,
FullName NVARCHAR(50) NOT NULL,
[Address] NVARCHAR(50) NOT NULL,
City NVARCHAR(50) NOT NULL,
ZIPCode INT,
Notes NVARCHAR(MAX)
)

CREATE TABLE RentalOrders(
Id INT PRIMARY KEY,
EmployeeId INT CONSTRAINT FK_RentalOrders_Employees FOREIGN KEY REFERENCES Employees(Id),
CustomerId INT CONSTRAINT FK_RentalOrders_Customers FOREIGN KEY REFERENCES Customers(Id),
CarId INT CONSTRAINT FK_RentalOrders_Cars FOREIGN KEY REFERENCES Cars(Id),
TankLevel INT,
KilometrageStart INT,
KilometrageEnd INT,
TotalKilometrage INT NOT NULL,
StartDate DATE,
EndDate DATE,
TotalDays INT,
RateApplied NVARCHAR(50),
TaxRate BIT NOT NULL,
OrderStatus BIT NOT NULL,
Notes NVARCHAR(MAX)
)


INSERT INTO Categories(Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
(1, 'Cabrio', NULL, NULL, NULL, NULL),
(2, 'Sedan', NULL, NULL, NULL, NULL),
(3, 'Combi', NULL, NULL, NULL, NULL)

INSERT INTO Cars(Id, PlateNumber, Manufacturer,
                 Model, CarYear, CategoryId, Doors, 
                 Picture, Condition, Available)
VALUES
(1, 323232, 'W', 'S', CONVERT(datetime, '31-08-2011', 103), 1, NULL, NULL, NULL, NULL),
(2, 232424, 'T', 'F', CONVERT(datetime, '30-04-2011', 103), 3, NULL, NULL, NULL, NULL),
(3, 4343434, 'Y', 'D', CONVERT(datetime, '31-05-2011', 103), 2, NULL, NULL, NULL, NULL)

INSERT INTO Employees(Id, FirstName, LastName, Title, Notes)
VALUES
(1, 'Ivan', 'Pesho', 'Sale', NULL),
(2, 'Bobi', 'Bobev', 'Sale', NULL),
(3, 'Cenko', 'Cenkov', 'Sale', NULL)

INSERT INTO Customers(Id, DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes)
VALUES
(1, NULL, 'Ivan Pesho', 'Shipka', 'Plovdiv', NULL, NULL),
(2, NULL, 'Bobi Bobev', 'Pobeda', 'Plovdiv', NULL, NULL),
(3, NULL, 'Cenko Cenkov', 'Trakia', 'Plovdiv', NULL, NULL)

INSERT INTO RentalOrders(Id, EmployeeId, CustomerId,
                         CarId, TankLevel, KilometrageStart, 
                         KilometrageEnd, TotalKilometrage,StartDate, 
						 EndDate,TotalDays, RateApplied,TaxRate, 
						 OrderStatus, Notes)
VALUES
(1, 1, 2, 1, NULL, NULL, NULL, 324324, NULL, NULL, NULL, NULL, 1, 1, NULL),
(2, 2, 3, 2, NULL, NULL, NULL, 32323, NULL, NULL, NULL, NULL, 0, 1, NULL),
(3, 3, 2, 3, NULL, NULL, NULL, 454545, NULL, NULL, NULL, NULL, 0, 1, NULL)