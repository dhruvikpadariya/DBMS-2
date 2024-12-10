----------------------------------Lab-5---------------------

-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
    PersonID INT PRIMARY KEY,
    PersonName VARCHAR(100) NOT NULL,
    Salary DECIMAL(8,2) NOT NULL,
    JoiningDate DATETIME NULL,
    City VARCHAR(100) NOT NULL,
    Age INT NULL,
    BirthDate DATETIME NOT NULL
);

-- Creating PersonLog Table
CREATE TABLE PersonLog (
    PLogID INT PRIMARY KEY IDENTITY(1,1),
    PersonID INT NOT NULL,
    PersonName VARCHAR(250) NOT NULL,
    Operation VARCHAR(50) NOT NULL,
    UpdateDate DATETIME NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES PersonInfo(PersonID) ON DELETE CASCADE
);

----------------------------------Part – A----------------------

--1.	Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display a message “Record is Aff[ected.” 
CREATE TRIGGER tr_PersonInfo_RecordAffected
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'Record is Affected.'
END;

--2.	Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.
----a inseret
create trigger Tr_Person_After_Insert
on PersonInfo
after Insert
as
begin
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);

	select @PersonID=PersonID from inserted
	select @PersonName=PersonName from inserted;

	INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    VALUES (@PersonID, @PersonName, 'INSERT', GETDATE());
end

-------B trigger Update Operation
Create TRIGGER tr_Person_after_Update
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
	SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE());
END;

------- c. Trigger for Delete Operation

Create TRIGGER tr_Person_after_Delete
ON PersonInfo
AFTER DELETE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
    SELECT @PersonID = PersonID, @PersonName = PersonName FROM deleted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'DELETE', GETDATE());
END;

--3	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.

-- a. Trigger for Insert Operation
Create TRIGGER tr_Person_InsteadOf_Insert
ON PersonInfo
Instead of INSERT
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);
    
    SELECT @PersonID = PersonID From inserted 
	Select @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    VALUES (@PersonID, @PersonName, 'INSERT', GETDATE());
END;


-- b. Trigger for Update Operation

Create TRIGGER tr_Person_InsteadOf_Update
ON PersonInfo
Instead Of UPDATE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
	SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE());
END;

-- c. Trigger for Delete Operation

Create TRIGGER tr_Person_InsteadOf_Delete
ON PersonInfo
Instead Of DELETE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
    SELECT @PersonID = PersonID, @PersonName = PersonName FROM deleted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'DELETE', GETDATE());
END;

--4.Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into uppercase whenever the record is inserted.
CREATE TRIGGER tr_Person_NameUpper_Inset
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @Uname VARCHAR(50)
	DECLARE @PersonID int

	select @Uname=PersonName from inserted
	select @PersonID=PersonID from inserted

	UPDATE PersonInfo
	SET PersonName=Upper(@Uname)
	WHERE PersonID=@PersonID
END

--5.Create trigger that prevent duplicate entries of person name on PersonInfo table.
Create TRIGGER tr_PersonInfo_PreventDuplicateName
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
    SELECT 
        PersonID, 
        PersonName, 
        Salary, 
        JoiningDate, 
        City, 
        Age, 
        BirthDate
    FROM inserted
    WHERE PersonName NOT IN (SELECT PersonName FROM PersonInfo);
END;

--6.Create trigger that prevent Age below 18 years.
CREATE TRIGGER tr_PersonInfo_PreventUnderage
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN

    INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
    SELECT 
        PersonID, 
        PersonName, 
        Salary, 
        JoiningDate, 
        City, 
        Age, 
        BirthDate
    FROM inserted
    WHERE Age >= 18;
END;


-------------------------------Part – B---------------------
--7.Create a trigger that fires on INSERT operation on person table, which calculates the age and update that age in Person table.
CREATE TRIGGER tr_Person_CalculateAge
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET Age = DATEDIFF(YEAR, i.BirthDate, GETDATE())
    FROM PersonInfo p
    JOIN inserted i ON p.PersonID = i.PersonID
END;

--8.Create a Trigger to Limit Salary Decrease by a 10%.
CREATE TRIGGER tr_Person_LimitSalaryDecrease
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    DECLARE @OldSalary DECIMAL(8,2), @NewSalary DECIMAL(8,2);
    
	SELECT @OldSalary = d.Salary, @NewSalary = i.Salary
    FROM deleted d
    JOIN inserted i ON d.PersonID = i.PersonID;

    IF @NewSalary < @OldSalary * 0.9
    BEGIN
        UPDATE PersonInfo
        SET Salary = @OldSalary
        WHERE PersonID IN (SELECT PersonID FROM inserted);
    END
END;

-------------------------Part – C-----------------------------------

--9.Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL during an INSERT.
CREATE TRIGGER tr_Person_UpdateJoiningDate
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET JoiningDate = GETDATE()
    FROM PersonInfo p
    JOIN inserted i ON p.PersonID = i.PersonID
    WHERE i.JoiningDate IS NULL;
END;

--10.Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints ‘Record deleted successfully from PersonLog’.
CREATE TRIGGER tr_PersonLog_Delete
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog';
END;