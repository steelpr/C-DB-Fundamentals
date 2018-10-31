CREATE DATABASE Hotel

CREATE TABLE Employees(
Id INT PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Title NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers(
AccountNumber INT PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
PhoneNumber INT NOT NULL,
EmergencyName NVARCHAR(50) NOT NULL,
EmergencyNumber NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomStatus(
Id INT PRIMARY KEY IDENTITY,
RoomStatus BIT,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomTypes(
Id INT PRIMARY KEY,
RoomType NVARCHAR(20),
Notes NVARCHAR(MAX)
)

CREATE TABLE BedTypes(
Id INT PRIMARY KEY,
BedType NVARCHAR(20),
Notes NVARCHAR(MAX)
)

CREATE TABLE Rooms(
RoomNumber INT PRIMARY KEY,
RoomType INT CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY REFERENCES RoomTypes(Id),
BedType INT CONSTRAINT FK_Rooms_BedTypes FOREIGN KEY REFERENCES BedTypes(Id),
Rate VARCHAR(20),
RoomStatus INT CONSTRAINT FK_Rooms_RoomStatus FOREIGN KEY REFERENCES RoomStatus(Id),
Notes NVARCHAR(MAX)
)

CREATE TABLE Payments(
Id INT PRIMARY KEY,
EmployeeId INT CONSTRAINT FK_Payments_Employees FOREIGN KEY REFERENCES Employees(Id),
PaymentDate DATE,
AccountNumber INT CONSTRAINT FK_Payments_Customers FOREIGN KEY REFERENCES Customers(AccountNumber),
FirstDateOccupied DATE,
LastDateOccupied DATE,
TotalDays INT NOT NULL,
AmountCharged DECIMAL(15, 2) NOT NULL,
TaxRate BIT NOT NULL,
TaxAmount DECIMAL(15, 2) NOT NULL,
PaymentTotal DECIMAL(15, 2) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Occupancies (
Id INT PRIMARY KEY,
EmployeeId INT CONSTRAINT FK_Occupancies_Employees FOREIGN KEY REFERENCES Employees(Id),
DateOccupied DATE,
AccountNumber INT CONSTRAINT FK_Occupancies_Customers FOREIGN KEY REFERENCES Customers(AccountNumber),
RoomNumber INT CONSTRAINT FK_Occupancies_Rooms FOREIGN KEY REFERENCES Rooms(RoomNumber),
RateApplied BIT NOT NULL,
PhoneCharge BIT,
Notes NVARCHAR(MAX)
)

INSERT INTO Employees(Id, FirstName, LastName, Title, Notes)
VALUES
(1, 'Ivan', 'Ivanov', 'Hotel', NULL),
(2, 'Ivan', 'Ivanov', 'Hotel', NULL),
(3, 'Ivan', 'Ivanov', 'Hotel', NULL)

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
VALUES
(1, 'Ivan', 'Ivanov', 435435435, 'CDSF', 43434, NULL),
(2, 'Ivan', 'Ivanov', 435435435, 'CDSF', 43434, NULL),
(3, 'Ivan', 'Ivanov', 435435435, 'CDSF', 43434, NULL)

INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES
(1, NULL),
(2, NULL),
(3, NULL)

INSERT INTO RoomTypes(Id, RoomType, Notes)
VALUES
(1, 'OK', NULL),
(2, 'OK', NULL),
(3, 'OK', NULL)

INSERT INTO BedTypes (Id, BedType, Notes)
VALUES
(1, 'OK', NULL),
(2, 'OK', NULL),
(3, 'OK', NULL)

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES
(1, 1, 2, NULL, NULL, NULL),
(2, 2, 1, NULL, NULL, NULL),
(3, 3, 3, NULL, NULL, NULL)

INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied,
                      TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
VALUES
(1, 1, NULL, NULL, NULL, NULL, 5, 232.34, 21.21, 22.43, 343.33, NULL),
(2, 2,NULL, NULL, NULL, NULL, 5, 32323.54, 43.21, 646.43, 464.33, NULL),
(3, 3, NULL, NULL, NULL, NULL, 5, 4343.34, 55.21, 22.43, 6456464.33, NULL)

INSERT INTO Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
(1, 1, NULL, NULL, NULL, 1, 1, NULL),
(2, 2,NULL, NULL, NULL, 0, 1, NULL),
(3, 3, NULL, NULL, NULL, 1, 1, NULL)

UPDATE Payments
SET TaxRate -= TaxRate * 3  / 100

SELECT TaxRate FROM Payments

TRUNCATE TABLE Occupancies