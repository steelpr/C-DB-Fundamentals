CREATE DATABASE Exercise

-- Problem 1.	One-To-One Relationship

CREATE TABLE Persons(
PersonID INT NOT NULL,
FirstName NVARCHAR(50) NOT NULL,	
Salary DECIMAL(15, 2),	
PassportID INT NOT NULL,
)

CREATE TABLE Passports(
PassportID INT NOT NULL,
PassportNumber NVARCHAR(50) NOT NULL
)

INSERT INTO Persons
VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom',	56100.00, 103),
(3, 'Yana', 60200.00, 101)


INSERT INTO Passports
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

ALTER TABLE Persons
ADD CONSTRAINT PK_Persons PRIMARY KEY (PersonID)

ALTER TABLE Passports
ADD CONSTRAINT UC_Passport UNIQUE (PassportID)

ALTER TABLE Passports
ADD CONSTRAINT PK_Passports PRIMARY KEY (PassportID)

ALTER TABLE Persons
ADD CONSTRAINT FK_Passports_Persons FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

-- Problem 2.	One-To-Many Relationship


CREATE TABLE Models(
ModelID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,		
ManufacturerID INT NOT NULL
)

CREATE TABLE Manufacturers(
ManufacturerID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,		
EstablishedOn DATE NOT NULL
)

INSERT INTO Models
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)


INSERT INTO Manufacturers
VALUES
(1, 'BMW', CONVERT(datetime, 07/03/1916, 103)),
(2, 'Tesla', CONVERT(datetime, 01/01/2003, 103)),
(3, 'Lada', CONVERT(datetime, 01/05/1966, 104))

ALTER TABLE Models
ADD CONSTRAINT PK_Models PRIMARY KEY (ModelID)

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_Manufacturers PRIMARY KEY(ManufacturerID)

ALTER TABLE Models
ADD CONSTRAINT FK_Models_Manufacturers FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)

-- Problem 3.	Many-To-Many Relationship

CREATE TABLE Students(
StudentID INT NOT NULL,	
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Exams(
ExamID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams(
StudentID INT NOT NULL,
ExamID INT NOT NULL
)

ALTER TABLE Students
ADD CONSTRAINT PK_Students PRIMARY KEY (StudentID)

ALTER TABLE Exams
ADD CONSTRAINT PK_Exams PRIMARY KEY (ExamID)

ALTER TABLE StudentsExams
ADD CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)

INSERT INTO Students
VALUES
(1, 'Mila'),                                      
(2,	'Toni'),
(3,	'Ron')


INSERT INTO Exams
VALUES
(101, 'SpringMVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g')

INSERT INTO StudentsExams
VALUES
(1,	101),
(1,	102),
(2,	101),
(3,	103),
(2,	102),
(2,	103)


-- Problem 4.	Self-Referencing 

CREATE TABLE Teachers(
TeacherID INT NOT NULL,
[Name] NVARCHAR(50) NOT NULL,	
ManagerID INT ,

CONSTRAINT PK_Teachers PRIMARY KEY (TeacherID)
)

ALTER TABLE Teachers
ADD CONSTRAINT FK_Teachers_ManagerID FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID)

INSERT INTO Teachers
VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia',	106),
(104, 'Ted',	105),
(105, 'Mark', 101),
(106, 'Greta', 101)

SELECT 'Rila', PeakName, Elevation
  FROM Peaks
 WHERE MountainId LIKE 17
ORDER BY Elevation DESC