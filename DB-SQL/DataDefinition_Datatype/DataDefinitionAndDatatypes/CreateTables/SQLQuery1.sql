CREATE TABLE Minions(
Id INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL,
Age INT  
)

CREATE TABLE Towns(
Id INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(200) NOT NULL,
Picture BINARY(2048) ,
Height FLOAT(2),
[Weight] FLOAT(2),
Gender VARCHAR(1) NOT NULL, 
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX)
)

INSERT INTO People ([Name], 
                    Picture, Height, 
					[Weight], Gender, 
					Birthdate, Biography)
VALUES
('Kevin', NULL, 102, 90, 'm', CONVERT(datetime, '22-05-2018', 103), NULL ),
('Bob', NULL, 31, 90, 'f', CONVERT(datetime, '02-02-2018', 103), NULL ),
('Steward', NULL, 54, 77, 'm', CONVERT(datetime, '01-05-2018', 103), NULL),
('Ivan', NULL, 76, 76, 'm', CONVERT(datetime, '22-05-2018', 103), NULL ),
('Rado', NULL, 98, 55, 'm', CONVERT(datetime, '22-05-2018', 103), NULL )