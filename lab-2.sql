create database CSE_6A

----------------Lab 2 --------------------------------

create table Person
(PersonID	Int,
FirstName	Varchar (100),
LastName	Varchar (100),
Salary	Decimal (8,2),
JoiningDate	Datetime,
DepartmentID	Int,
DesignationID	Int
);

create table Department(
DepartmentID	Int,
DepartmentName	Varchar (100)
);

create table Designation(
DesignationID	Int,
DesignationName	Varchar (100)
);

select * from Person

insert into Person values
(101,'Rahul','Anshu',56000,'01-01-1990',1,12),
(102,'Hardik','Hinsu',18000,'1990-09-25',2,11),
(103,'Bhavin','Kamani',25000,'05-14-1991',NULL,	11),
(104,'Bhoomi','Patel',39000,'02-20-2014',1,	13),
(105,'Rohit','Rajgor',17000,'07-23-1990',2,15),
(106,'Priya','Mehta',25000,'10-18-1990',2,NULL),
(107,'Neha','Trivedi',18000,'02-20-2014',3,15)


insert into Department values
(1,'Admin'),
(2,	'IT'),
(3,	'HR'),
(4,	'Account')

insert into Designation values
(11,'Jobber'),
(12,'Welder'),
(13,'Clerk'),
(14,'Manager'),
(15,'CEO')


-------------------------------------Stored Procedure----------------------------------

--------------------------Part-A

-- 1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures

-- Department INSERT Procedure
CREATE PROCEDURE PR_Department_Insert
    @DepartmentID INT,
    @DepartmentName VARCHAR(100)
AS
BEGIN
    INSERT INTO Department (DepartmentID, DepartmentName)
    VALUES (@DepartmentID, @DepartmentName);
END;

-- Department UPDATE Procedure
CREATE PROCEDURE PR_Department_Update
    @DepartmentID INT,
    @DepartmentName VARCHAR(100)
AS
BEGIN
    UPDATE Department
    SET DepartmentName = @DepartmentName
    WHERE DepartmentID = @DepartmentID;
END;

-- Department DELETE Procedure
CREATE PROCEDURE PR_Department_Delete
    @DepartmentID INT
AS
BEGIN
    DELETE FROM Department
    WHERE DepartmentID = @DepartmentID;
END;

-- Designation INSERT Procedure
CREATE PROCEDURE PR_Designation_Insert
    @DesignationID INT,
    @DesignationName VARCHAR(100)
AS
BEGIN
    INSERT INTO Designation (DesignationID, DesignationName)
    VALUES (@DesignationID, @DesignationName);
END;

-- Designation UPDATE Procedure
CREATE PROCEDURE PR_Designation_Update
    @DesignationID INT,
    @DesignationName VARCHAR(100)
AS
BEGIN
    UPDATE Designation
    SET DesignationName = @DesignationName
    WHERE DesignationID = @DesignationID;
END;

-- Designation DELETE Procedure
CREATE PROCEDURE PR_Designation_Delete
    @DesignationID INT
AS
BEGIN
    DELETE FROM Designation
    WHERE DesignationID = @DesignationID;
END;

-- Person INSERT Procedure
CREATE PROCEDURE PR_Person_Insert
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Salary DECIMAL(8, 2),
    @JoiningDate DATETIME,
    @DepartmentID INT = NULL,
    @DesignationID INT = NULL
AS
BEGIN
    INSERT INTO Person (FirstName, LastName, Salary, JoiningDate, DepartmentID, DesignationID)
    VALUES (@FirstName, @LastName, @Salary, @JoiningDate, @DepartmentID, @DesignationID);
END;

-- Person UPDATE Procedure
CREATE PROCEDURE PR_Person_Update
    @PersonID INT,
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Salary DECIMAL(8, 2),
    @JoiningDate DATETIME,
    @DepartmentID INT = NULL,
    @DesignationID INT = NULL
AS
BEGIN
    UPDATE Person
    SET FirstName = @FirstName, LastName = @LastName, Salary = @Salary, JoiningDate = @JoiningDate,
        DepartmentID = @DepartmentID, DesignationID = @DesignationID
    WHERE PersonID = @PersonID;
END;

-- Person DELETE Procedure
CREATE PROCEDURE PR_Person_Delete
    @PersonID INT
AS
BEGIN
    DELETE FROM Person
    WHERE PersonID = @PersonID;
END;

-- 2. SELECTBYPRIMARYKEY Procedures

-- Department SELECTBYPRIMARYKEY Procedure
CREATE PROCEDURE PR_Department_SelectByPrimaryKey
    @DepartmentID INT
AS
BEGIN
    SELECT * FROM Department
    WHERE DepartmentID = @DepartmentID;
END;

-- Designation SELECTBYPRIMARYKEY Procedure
CREATE PROCEDURE PR_Designation_SelectByPrimaryKey
    @DesignationID INT
AS
BEGIN
    SELECT * FROM Designation
    WHERE DesignationID = @DesignationID;
END;

-- Person SELECTBYPRIMARYKEY Procedure
CREATE PROCEDURE PR_Person_SelectByPrimaryKey
    @PersonID INT
AS
BEGIN
    SELECT P.*, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE P.PersonID = @PersonID;
END;

-- 3. Department, Designation & Person Table’s Select with Foreign Key Joins
-- Department SelectAllWithDetails Procedure
CREATE PROCEDURE PR_Department_SelectAllWithDetails
AS
BEGIN
    SELECT * FROM Department
END;

-- Designation SelectAllWithDetails Procedure
CREATE PROCEDURE PR_Designation_SelectAllWithDetails
AS
BEGIN
    SELECT * FROM Designation
END;

-- Person SelectAllWithDetails Procedure
CREATE PROCEDURE PR_Person_SelectAllWithDetails
AS
BEGIN
    SELECT P.PersonID, P.FirstName, P.LastName, P.Salary, P.JoiningDate, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID;
END;

exec PR_Person_SelectAllWithDetails

-- 4. Procedure that shows details of the first 3 persons
CREATE PROCEDURE PR_Person_ShowFirstThree
AS
BEGIN
    SELECT TOP 3 * FROM Person;
END;

exec PR_Person_ShowFirstThree

------###########################--------Part-B

-- 5. Procedure that takes department name as input and returns all workers in that department
CREATE PROCEDURE PR_Person_GetWorkersByDepartment
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT P.*
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentName = @DepartmentName;
END;

exec PR_Person_GetWorkersByDepartment 'Admin'

-- 6. Procedure that takes department name & designation name as input and returns worker details
CREATE PROCEDURE PR_Person_GetWorkersByDeptAndDesig
    @DepartmentName VARCHAR(100),
    @DesignationName VARCHAR(100)
AS
BEGIN
    SELECT P.FirstName, P.Salary, P.JoiningDate, D.DepartmentName
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE D.DepartmentName = @DepartmentName AND G.DesignationName = @DesignationName;
END;

exec PR_Person_GetWorkersByDeptAndDesig 'IT','Jobber'

-- 7. Procedure that takes first name as input and displays worker details with department & designation
CREATE PROCEDURE PR_Person_GetWorkerDetailsByFirstName
    @FirstName VARCHAR(100)
AS
BEGIN
    SELECT P.*, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE P.FirstName = @FirstName;
END;

-- 8. Procedure that displays department-wise max, min & total salaries
CREATE PROCEDURE PR_Department_GetSalaryStats
AS
BEGIN
    SELECT D.DepartmentName, MAX(P.Salary) AS MaxSalary, MIN(P.Salary) AS MinSalary, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    GROUP BY D.DepartmentName;
END;

-- 9. Procedure that displays designation-wise average & total salaries
CREATE PROCEDURE PR_Designation_GetSalaryStats
AS
BEGIN
    SELECT G.DesignationName, AVG(P.Salary) AS AvgSalary, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Designation G ON P.DesignationID = G.DesignationID
    GROUP BY G.DesignationName;
END;

-- Part-C

-- 10. Procedure that accepts Department Name and returns Person Count
CREATE PROCEDURE PR_Department_GetPersonCount
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) AS PersonCount
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentName = @DepartmentName;
END;

exec PR_Department_GetPersonCount 'IT'

-- 11. Procedure that takes a salary value as input and returns workers with salary > 25000
CREATE PROCEDURE PR_Person_GetWorkersWithSalaryAbove
    @Salary DECIMAL(8,2)
AS
BEGIN
    SELECT P.*, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE P.Salary > @Salary;
END;

-- 12. Procedure to find the department with the highest total salary
CREATE PROCEDURE PR_Department_GetHighestTotalSalary
AS
BEGIN
    SELECT TOP 1 D.DepartmentName, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    GROUP BY D.DepartmentName
    ORDER BY TotalSalary DESC;
END;

exec PR_Department_GetHighestTotalSalary

-- 13. Procedure that takes a designation name and returns workers under that designation who joined within the last 10 years
alter PROCEDURE PR_Designation_GetRecentWorkers
    @DesignationName VARCHAR(100)
AS
BEGIN
    SELECT P.*, D.DepartmentName
    FROM Person P
    JOIN Designation G ON P.DesignationID = G.DesignationID
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE G.DesignationName = @DesignationName AND datediff(YEAR,p.JoiningDate,GETDATE())>10
END;

exec PR_Designation_GetRecentWorkers 'Manager'


-- 14. Procedure to list the number of workers in each department without a designation
CREATE PROCEDURE PR_Department_GetWorkersWithoutDesignation
AS
BEGIN
    SELECT D.DepartmentName, COUNT(P.PersonID) AS WorkerCount
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE P.DesignationID IS NULL
    GROUP BY D.DepartmentName;
END;

-- 15. Procedure to retrieve details of workers in departments where average salary is above 12000
CREATE PROCEDURE PR_Department_GetHighAvgSalaryWorkers
AS
BEGIN
    SELECT P.*, D.DepartmentName
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentID IN (
        SELECT DepartmentID
        FROM Person
        GROUP BY DepartmentID
        HAVING AVG(Salary) > 12000
    );
END;

