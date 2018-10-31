CREATE DATABASE Movies

CREATE TABLE Directors(
Id INT PRIMARY KEY,
DirectorName NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX),
)

CREATE TABLE Genres(
Id INT PRIMARY KEY,
GenreName NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Categories(
Id INT PRIMARY KEY,
CategoryName NVARCHAR(50) NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE Movies(
Id INT PRIMARY KEY,
Title NVARCHAR(50) NOT NULL,
DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
CopyrightYear DATE NOT NULL,
Lenght FLOAT,
GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
Raiting INT,
Notes NVARCHAR(MAX)
)

INSERT INTO Directors (Id, DirectorName, Notes)
VALUES
(1, 'Ivan', NULL),
(2, 'Rado', NULL),
(3, 'Tasko', NULL),
(4, 'Vasko', NULL),
(5, 'Cenko', NULL)

INSERT INTO Genres (Id, GenreName, Notes)
VALUES
(1, 'Comedy', NULL),
(2, 'Comedy', NULL),
(3, 'Comedy', NULL),
(4, 'Comedy', NULL),
(5, 'Comedy', NULL)

INSERT INTO Categories (Id, CategoryName, Notes)
VALUES
(1, 'Funny', NULL),
(2, 'Action', NULL),
(3, 'Family', NULL),
(4, 'Romantic', NULL),
(5, 'Animation', NULL)

INSERT INTO Movies(Id, Title, DirectorId,
                   CopyrightYear, Lenght, GenreId,
                   CategoryId, Raiting, Notes)
VALUES
(1, 'Sky', 1, CONVERT(datetime, '22-11-2044', 103), NULL, 3, 1, NULL, NULL),
(2, 'Cops', 2, CONVERT(datetime, '04-11-2010', 103), NULL, 4, 4, NULL, NULL),
(3, 'Animal', 4, CONVERT(datetime, '22-03-2000', 103), NULL, 3, 4, NULL, NULL),
(4, 'Santa Claus', 5, CONVERT(datetime, '25-12-2018', 103), NULL, 5, 4, NULL, NULL),
(5, 'Develop', 2, CONVERT(datetime, '05-07-2018', 103), NULL, 3, 4, NULL, NULL)