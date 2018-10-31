-- Problem 1. Employees with Salary Above 35000

CREATE PROC usp_GetEmployeesSalaryAbove35000 AS 
	  BEGIN
			SELECT FirstName, LastName
			  FROM Employees
			 WHERE Salary > 35000
	  END

EXEC usp_GetEmployeesSalaryAbove35000

-- Problem 2. Employees with Salary Above Number

CREATE PROC usp_GetEmployeesSalaryAboveNumber @number DECIMAL(18, 4) AS
BEGIN
	SELECT FirstName, LastName
	  FROM Employees
	 WHERE Salary >= @number
END

EXEC usp_GetEmployeesSalaryAboveNumber 48100

-- Problem 3. Town Names Starting With

ALTER PROC usp_GetTownsStartingWith @startingChar VARCHAR(20) AS
BEGIN
	SELECT [Name]
	  FROM Towns
	 WHERE [Name] LIKE @startingChar + '%'
END

EXEC usp_GetTownsStartingWith 'b'

-- Problem 4. Employees from Town

CREATE OR ALTER PROC usp_GetEmployeesFromTown @town VARCHAR(50) AS
BEGIN
	SELECT FirstName, LastName
	  FROM Employees AS e
	  JOIN Addresses AS a 
	    ON a.AddressID = e.AddressID
	  JOIN Towns AS t
	    ON t.TownID = a.TownID
	 WHERE t.Name LIKE @town + '%'
END

EXEC usp_GetEmployeesFromTown 'Sof'

-- Problem 5. Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS CHAR(7)
AS 
BEGIN
DECLARE @salaryL CHAR(7)

	IF(@salary < 30000)
		BEGIN
		SET @salaryL = 'Low'
	END
	ELSE IF (@salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @salaryL = 'Average'
	END
	ELSE
	BEGIN
		SET @salaryL = 'High'
	END 

	RETURN @salaryL
END

SELECT Salary, dbo.ufn_GetSalaryLevel (Salary) AS [Salary Level]
  FROM Employees

-- Problem 6. Employees by Salary Level

CREATE PROC usp_EmployeesBySalaryLevel @slaryLevel VARCHAR(30) AS
BEGIN
	SELECT FirstName, LastName
	  FROM Employees
	 WHERE dbo.ufn_GetSalaryLevel(Salary) LIKE @slaryLevel
END

EXEC usp_EmployeesBySalaryLevel 'High'

-- Problem 7. Define Function

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX)) 
RETURNS BIT
AS
BEGIN 
DECLARE @index INT = 1
DECLARE @letter VARCHAR(1)
DECLARE @string INT = 0

WHILE(@index <= LEN(@word))
BEGIN
	SET @letter = SUBSTRING(@word, @index, 1)
	SET @string = CHARINDEX(@letter, @setOfLetters)

	IF(@string = 0)
	BEGIN
		RETURN @string
	END
	ELSE
	BEGIN 
		SET @index +=1;
	END
END
RETURN @string;
END

SELECT dbo.ufn_IsWordComprised ('oistmiahf', 'HALVES')

-- Delete Employees and Departments

BEGIN TRAN
CREATE PROC usp_DeleteEmployeesFromDepartment(@departmentId INT) AS
BEGIN
	DELETE FROM EmployeesProjects
	      WHERE EmployeeID IN(SELECT EmployeeID 
		                        FROM Employees
							   WHERE DepartmentID = @departmentId)

ALTER TABLE Departments
ALTER COLUMN ManagerID INT

UPDATE Employees
  SET ManagerID = NULL
WHERE ManagerID IN (SELECT EmployeeID
                      FROM Employees
					 WHERE DepartmentID = @departmentId)

UPDATE Departments
   SET ManagerID = NULL
 WHERE ManagerID IN(SELECT EmployeeID
                      FROM Employees
					 WHERE DepartmentID = @departmentId)
DELETE FROM Employees
 WHERE DepartmentID = @departmentId

DELETE FROM Departments
      WHERE DepartmentID = @departmentId

SELECT COUNT(*)
  FROM Employees
 WHERE DepartmentID = @departmentId
END

ROLLBACK TRAN

-- Problem 9. Find Full Name

CREATE PROC usp_GetHoldersFullName AS
BEGIN
	SELECT CONCAT(FirstName, ' ', LastName)
	  FROM AccountHolders
END

EXEC usp_GetHoldersFullName

--Problem 10. People with Balance Higher Than

CREATE PROC usp_GetHoldersWithBalanceHigherThan (@cash DECIMAL(15, 4)) AS
BEGIN 
	WITH CTE_BallanceByAccount (Id, Balance) AS(
	SELECT AccountHolderId, SUM(Balance)
	  FROM Accounts 
	GROUP BY AccountHolderId
	)
	
	SELECT a.FirstName, a.LastName
	  FROM CTE_BallanceByAccount AS c
	  JOIN AccountHolders AS a
	    ON a.Id = c.Id
	 WHERE c.Balance > @cash
  ORDER BY a.LastName,a.FirstName
END

--Problem 11. Future Value Function

CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
DECLARE @result DECIMAL(18, 4)

SET @result = @sum * POWER((1 + @yearlyInterestRate), @numberOfYears)

RETURN @result
END

SELECT dbo.ufn_CalculateFutureValue (1000, 0.1, 5)

--Problem 12. Calculating Interest

CREATE PROC usp_CalculateFutureValueForAccount(@accountId INT, @interestRate FLOAT) AS
BEGIN
	SELECT TOP(1) a.Id, ah.FirstName, ah.LastName, a.Balance, dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5) AS [Balance in 5 years]
	  FROM AccountHolders AS ah
	  JOIN Accounts AS a
	    ON a.AccountHolderId = ah.Id
     WHERE ah.Id = @accountId
END

EXEC usp_CalculateFutureValueForAccount 1, 0.1

--Scalar Function: Cash in User Games Odd Rows

CREATE FUNCTION ufn_CashInUsersGames(@gameName VARCHAR(70))
RETURNS TABLE
AS
RETURN(
	SELECT SUM(e.Cash) AS sumCash
	  FROM(
	SELECT g.id, ug.Cash, ROW_NUMBER() OVER(ORDER BY ug.Cash DESC) AS rowNumber
	  FROM Games AS g
	  JOIN UsersGames AS ug
	    ON ug.GameId = g.Id
     WHERE g.Name = @gameName) AS e
	 WHERE e.rowNumber % 2 = 1
	 )

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')

-- Problem 14. Create Table Logs

CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccountId INT,
OldSum DECIMAL(15,2),
NewSum DECIMAL(15,2)
)

CREATE TRIGGER tr_Accounts 
            ON Accounts
AFTER UPDATE
AS
BEGIN
	DECLARE @accountId INT = (
	SELECT Id FROM inserted
	)

	DECLARE @oldSum DECIMAL(15, 2) = (
	SELECT Balance FROM deleted
	)

	DECLARE @newSum DECIMAL(15, 2) = (
	SELECT Balance FROM inserted
	)

	INSERT INTO Logs
	VALUES
	(@accountId, @oldSum, @newSum)
END

SELECT * FROM Logs

UPDATE Accounts SET Balance = 100 WHERE Id  = 1

-- Problem 15. Create Table Emails

CREATE TABLE NotificationEmails(
Id INT PRIMARY KEY IDENTITY,
Recipient INT,
[Subject] VARCHAR(MAX),
Body VARCHAR(MAX)
)

CREATE TRIGGER tr_Emails
            ON Accounts
AFTER UPDATE
AS
BEGIN
	DECLARE @AccountId INT = (
	SELECT Id FROM inserted
	)

	DECLARE @oldSum DECIMAL(15, 2) = (
	SELECT Balance FROM deleted
	)

	DECLARE @newSum DECIMAL(15,2) = (
	SELECT Balance FROM inserted
	)
	DECLARE @subject VARCHAR(MAX) = (
	CONCAT('Balance change for account:', ' ', @accountId)
	)

	DECLARE @body VARCHAR(MAX) = (
	CONCAT('On', ' ',  GETDATE(), 'your balance was changed from', ' ',  @oldSum, ' ',  'to', ' ', @newSum, '.')
	)

	INSERT NotificationEmails
	VALUES
	(@accountID, @subject, @body)
END

UPDATE Accounts SET Balance = 100 WHERE ID = 1

SELECT * FROM NotificationEmails

-- Problem 16. Deposit Money

CREATE PROC usp_DepositMoney (@accountId INT, @moneyAmount DECIMAL(18, 4)) AS
BEGIN
	BEGIN TRAN
			BEGIN
				UPDATE Accounts SET Balance += @moneyAmount
				WHERE Id = @accountId
			
				IF(@@ROWCOUNT<>1)
				BEGIN
					RAISERROR('Error', 16, 1);
					ROLLBACK;
					RETURN;
				END
		COMMIT
	END
END

	EXEC usp_DepositMoney 1, 10

-- Problem 17. Withdraw Money

CREATE PROC usp_WithdrawMoney (@accountId INT, @moneyAmmount DECIMAL(18, 4)) AS
BEGIN
	BEGIN TRAN 
		UPDATE Accounts SET Balance -= @moneyAmmount
		 WHERE Id = @accountId
	
	IF(@@ROWCOUNT <> 1)
	BEGIN
		RAISERROR('Error', 16, 1);
		ROLLBACK;
		RETURN;
	END
	COMMIT
END

-- Problem 18. Money Transfer

CREATE PROC usp_TransferMoney (@senderId INT, @receiverId INT, @amount DECIMAL(15, 4)) AS
BEGIN
	BEGIN TRAN
		 EXEC usp_WithdrawMoney @senderId, @amount

		 EXEC usp_DepositMoney @receiverId, @amount

	COMMIT
END

EXEC usp_TransferMoney 5, 1, 5000

-- Problem 21. Employees with Three Projects

CREATE PROC usp_AssignProject (@employeeId INT, @projectId INT) AS
BEGIN
	DECLARE @projects INT = (
	SELECT  COUNT(ProjectID)
	  FROM EmployeesProjects
	  WHERE EmployeeID = @employeeId
	GROUP BY EmployeeID)

	IF(@projects >= 3)
	BEGIN
	RAISERROR('The employee has too many projects!', 16, 1);
	ROLLBACK;
	END
	ELSE
	BEGIN
		INSERT INTO EmployeesProjects
		VALUES 
		(@employeeId, @projectId)
	END
END

-- Problem 22. Delete Employees

CREATE TABLE Deleted_Employees(
EmployeeId INT,
FirstName VARCHAR(50),
LastName VARCHAR(50),
MiddleName VARCHAR(50),
JobTitle VARCHAR(50),
DepartmanetId INT,
Salary DECIMAL(15, 2)
)

CREATE TRIGGER tr_DeleteEmployees
            ON Employees
AFTER DELETE
AS
BEGIN 

	DECLARE @employeeId INT = (
	SELECT EmployeeId FROM deleted
	)

	DECLARE @firstName VARCHAR(50) = (
	SELECT FirstName FROM deleted
	)

	DECLARE @lastName VARCHAR(50) = (
	SELECT LasTName FROM deleted
	)

	DECLARE @middleName VARCHAR(50) = (
	SELECT MiddleName FROM deleted
	)

	DECLARE @jobTitle VARCHAR(50) = (
	SELECT JobTitle FROM deleted
	)

	DECLARE @departmentId INT = (
	SELECT DepartmentId FROM deleted
	)

	DECLARE @salary DECIMAL(15, 2) = (
	SELECT Salary FROM deleted
	)

	INSERT INTO Deleted_Employees
	VALUES
	(@employeeId, @firstName, @lastName, @middleName, @jobTitle, @departmentId, @salary)

END


DELETE FROM EmployeesProjects
     WHERE EmployeeID IN
     (
         SELECT EmployeeID
         FROM Employees
         WHERE DepartmentID = 1
     );
     UPDATE Employees
       SET
           ManagerID = NULL
     WHERE ManagerID IN
     (
         SELECT EmployeeId
         FROM Employees
         WHERE DepartmentID = 1
     );
	ALTER TABLE Departments 
ALTER COLUMN ManagerID INT
     UPDATE Departments
       SET
           ManagerID = NULL
     WHERE ManagerID IN
     (
         SELECT EmployeeId
         FROM Employees
         WHERE DepartmentID = 1
     );
     DELETE FROM Employees
     WHERE DepartmentID = 1;
     DELETE FROM dbo.Departments
     WHERE  DepartmentID = 1;

Select EmployeeID from deleted_employees;