
-------------------------Lab-3----------------------------------------

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    ManagerID INT NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- Create Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DoB DATETIME NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    HireDate DATETIME NOT NULL,
    DepartmentID INT NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


-- Insert Dummy Data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location)
VALUES 
    (1, 'IT', 101, 'New York'),
    (2, 'HR', 102, 'San Francisco'),
    (3, 'Finance', 103, 'Los Angeles'),
    (4, 'Admin', 104, 'Chicago'),
    (5, 'Marketing', 105, 'Miami');

-- Insert Dummy Data into Employee
INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID, Salary)
VALUES 
    (101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00),
    (102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00),
    (103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00),
    (104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00),
    (105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);

-- Insert Dummy Data into Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES 
    (201, 'Project Alpha', '2022-01-01', '2022-12-31', 1),
    (202, 'Project Beta', '2023-03-15', '2024-03-14', 2),
    (203, 'Project Gamma', '2021-06-01', '2022-05-31', 3),
    (204, 'Project Delta', '2020-10-10', '2021-10-09', 4),
    (205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);

select * from Departments
select * from Projects
select * from Employee

------------------part-A--------------------------

--1.Create Stored Procedure for Employee table As User enters either First Name or Last Name and based on this you must give EmployeeID, DOB, Gender & Hiredate. 
CREATE PROCEDURE PR_Employee_GetByName
    @FirstName VARCHAR(100) = NULL,
    @LastName VARCHAR(100) = NULL
AS
BEGIN
    SELECT EmployeeID, DoB, Gender, HireDate
    FROM Employee
    WHERE (@FirstName IS NOT NULL AND FirstName = @FirstName)
        OR 
        (@LastName IS NOT NULL AND LastName = @LastName);
END;

exec PR_Employee_GetByName @LastName='Doe'
--2.Create a Procedure that will accept Department Name and based on that gives employees list who belongs to that department. 
CREATE PROCEDURE PR_Employee_GetByDepartmentName
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.DoB, e.Gender, e.HireDate, e.Salary
    FROM Employee e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = @DepartmentName;
END;

PR_Employee_GetByDepartmentName 'HR'

--3.Create a Procedure that accepts Project Name & Department Name and based on that you must give all the project related details. 
CREATE PROCEDURE PR_Project_GetByProjectAndDepartment
    @ProjectName VARCHAR(100),
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT p.ProjectID, p.ProjectName, p.StartDate, p.EndDate, d.DepartmentName
    FROM Projects p
    JOIN Departments d ON p.DepartmentID = d.DepartmentID
    WHERE p.ProjectName = @ProjectName AND d.DepartmentName = @DepartmentName;
END;

PR_Project_GetByProjectAndDepartment 'Project Gamma','Finance'

--4.Create a procedure that will accepts any integer and if salary is between provided integer, then those employee list comes in output. 
CREATE PROCEDURE PR_Employee_GetBySalaryRange
    @MinSalaryRange INT,
	@MaxSalaryRange INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE Salary BETWEEN @MinSalaryRange AND @MaxSalaryRange; -- Adjust range as needed
END;

PR_Employee_GetBySalaryRange 70000,80000

--5.Create a Procedure that will accepts a date and gives all the employees who all are hired on that date. 
CREATE PROCEDURE PR_Employee_GetByHireDate
    @HireDate DATETIME
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE HireDate = @HireDate;
END;

PR_Employee_GetByHireDate '2012-07-18'


------------------------------------------PART-B----------------------------

--6.	Create a Procedure that accepts Gender’s first letter only and based on that employee details will be served. 
CREATE PROCEDURE PR_Employee_GetByGenderLetter
    @GenderLetter CHAR(1)
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE LEFT(Gender, 1) = @GenderLetter;
END;

PR_Employee_GetByGenderLetter 'm'

--7.	Create a Procedure that accepts First Name or Department Name as input and based on that employee data will come. 
CREATE PROCEDURE PR_Employee_GetByFirstNameOrDepartment
    @FirstName VARCHAR(100) = NULL,
    @DepartmentName VARCHAR(100) = NULL
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.DoB, e.Gender, e.HireDate, e.Salary, d.DepartmentName
    FROM Employee e
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE 
	   (@FirstName IS NOT NULL AND e.FirstName = @FirstName)
        OR 
       (@DepartmentName IS NOT NULL AND d.DepartmentName = @DepartmentName);
END;

PR_Employee_GetByFirstNameOrDepartment @DepartmentName='Finance'

--8.	Create a procedure that will accepts location, if user enters a location any characters, then he/she will get all the departments with all data.
CREATE PROCEDURE PR_Department_GetByLocation
    @Location VARCHAR(100)
AS
BEGIN
    SELECT DepartmentID, DepartmentName, ManagerID, Location
    FROM Departments
    WHERE Location LIKE '%' + @Location + '%';
END;

PR_Department_GetByLocation 'a'

--------------------------------------------Part – C---------------------------
--9.	Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve Project related data. 
CREATE PROCEDURE PR_Project_GetByDateRange
    @FromDate DATETIME,
    @ToDate DATETIME
AS
BEGIN
    SELECT ProjectID, ProjectName, StartDate, EndDate, DepartmentID
    FROM Projects
    WHERE StartDate BETWEEN @FromDate AND @ToDate;
END;

PR_Project_GetByDateRange '2022-01-01','2023-03-15'

--10.	Create a procedure in which user will enter project name & location and based on that you have to provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates. 
CREATE PROCEDURE PR_Project_GetByProjectAndLocation
    @ProjectName VARCHAR(100),
    @Location VARCHAR(100)
AS
BEGIN
    SELECT p.ProjectName, d.DepartmentName, m.FirstName AS ManagerFirstName, m.LastName AS ManagerLastName,
           p.StartDate, p.EndDate
    FROM Projects p
    JOIN Departments d ON p.DepartmentID = d.DepartmentID
    JOIN Employee m ON d.ManagerID = m.EmployeeID
    WHERE p.ProjectName = @ProjectName AND d.Location = @Location;
END;

PR_Project_GetByProjectAndLocation 'Project Epsilon','Miami'