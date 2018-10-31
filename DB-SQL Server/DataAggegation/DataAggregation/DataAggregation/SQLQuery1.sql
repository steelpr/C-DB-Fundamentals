-- Problem 1. Records’ Count

SELECT COUNT(*)
  FROM WizzardDeposits

-- Problem 2. Longest Magic Wand

SELECT MAX(MagicWandSize)
  FROM WizzardDeposits

-- Problem 3. Longest Magic Wand per Deposit Groups

SELECT DepositGroup, MAX(MagicWandSize)
  FROM WizzardDeposits
GROUP BY (DepositGroup)

-- Smallest Deposit Group per Magic Wand Size

SELECT TOP (2) DepositGroup 
  FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- Problem 5. Deposits Sum

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
  FROM WizzardDeposits
GROUP BY DepositGroup

-- Problem 6. Deposits Sum for Ollivander Family

SELECT DepositGroup, SUM(DepositAmount)
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- Problem 7. Deposits Filter

SELECT DepositGroup, TotalSum
  FROM(
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
 GROUP BY DepositGroup
 ) AS e
 WHERE TotalSum < 150000
ORDER BY TotalSum DESC

-- Deposit Charge

SELECT DepositGroup, MagicWandCreator, MinDepositCharge
  FROM(
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
  FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
) AS e
ORDER BY MagicWandCreator, DepositGroup

-- Problem 9.	Age Group

SELECT e.Age, COUNT(e.Age) AS [WizardCount] FROM(
SELECT 
  CASE
      WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
      WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
      WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
      WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
      WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
      WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
      WHEN Age >= 61 THEN '[61+]'
  END AS Age
  FROM WizzardDeposits
  ) AS e
 GROUP BY E.Age

 -- First Letter

SELECT DISTINCT LEFT(FirstName, 1)
  FROM WizzardDeposits
 WHERE DepositGroup LIKE 'Troll Chest'

 --Problem 11.	Average Interest

 SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest)
   FROM WizzardDeposits
  WHERE DepositStartDate > '01/01/1985'
 GROUP BY DepositGroup, IsDepositExpired
 ORDER BY DepositGroup DESC, IsDepositExpired

 -- Rich Wizard, Poor Wizard

 SELECT SUM(e.S) AS SumDifference FROM(
 SELECT DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS S
   FROM WizzardDeposits
   ) AS e
 
 -- Problem 13.	Departments Total Salaries

  SELECT DepartmentID, SUM(Salary) AS ToatlSalary
    FROM Employees
  GROUP BY DepartmentID

-- Problem 14.	Employees Minimum Salaries

SELECT DepartmentID, MIN(Salary) AS MinimumSalary
  FROM Employees
  WHERE DepartmentID LIKE '[2, 5, 7]' AND HireDate > '01/01/2000'
  GROUP BY DepartmentID 

  -- Problem 15.	Employees Average Salaries

  SELECT * INTO EmployeesSalary 
    FROM Employees
   WHERE Salary > 30000

   DELETE FROM EmployeesSalary
         WHERE ManagerID = 42

  UPDATE EmployeesSalary
     SET Salary += 5000
    WHERE DepartmentID = 1

  SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM EmployeesSalary
  GROUP BY DepartmentID

  -- Problem 16.	Employees Maximum Salaries

  SELECT DepartmentID, MAX(Salary) 
    FROM Employees
  GROUP BY DepartmentID
  HAVING MAX(Salary) < 30000 OR MAX(Salary) > 70000

  -- Problem 17.	Employees Count Salaries

  SELECT COUNT(EmployeeID)
    FROM Employees
   WHERE ManagerID IS NULL

   --3rd Highest Salary

   SELECT DISTINCT DepartmentID, Salary FROM(
   SELECT DepartmentID, Salary, DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryR
     FROM Employees
   ) AS [Salary]
   WHERE SalaryR = 3
    
 -- Salary Challenge

 SELECT TOP(10) FirstName, LastName, DepartmentID
   FROM Employees AS emp
  WHERE Salary > (SELECT AVG(Salary) FROM Employees 
                   WHERE DepartmentID = emp.DepartmentID)
 ORDER BY DepartmentID