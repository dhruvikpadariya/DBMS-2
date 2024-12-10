-----------------lab-4--------------------------

---------------part A

--1.	Write a function to print "hello world".
create function fn_helloqworld()
returns varchar(25)
as
begin 
	return 'hello wolrd'
end

select dbo.fn_helloqworld()

--2.	Write a function which returns addition of two numbers.
create function fn_addTonuber(@num1 int,@num2 int)
returns int
as 
begin
	return @num1+@num2
end

select dbo.fn_addTonuber(4,5)

--3.	Write a function to check whether the given number is ODD or EVEN.
alter function fn_numOddOrEven(@number int)
returns varchar(25)
as 
begin
	return case
				when @number %2 = 0 then 'number is even'
				else 'number is odd'
			end
end

select dbo.fn_numOddOrEven(3)

--4.	Write a function which returns a table with details of a person whose first name starts with B.
CREATE FUNCTION fn_GetPersonsStartingWithB()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person
    WHERE FirstName LIKE 'B%'
);

select * from dbo.fn_GetPersonsStartingWithB()

--5.	Write a function which returns a table with unique first names from the person table.
CREATE FUNCTION fn_GetUNIQUEFIRSTNAME()
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT FIRSTNAME FROM Person
    
);

SELECT FirstName FROM fn_GetUNIQUEFIRSTNAME()

--6.	Write a function to print number from 1 to N. (Using while loop)
ALTER function fn_PRINTNUM(@N int)
returns VARCHAR(MAX)
as 
begin
	
    DECLARE @Result VARCHAR(MAX) = '';
    DECLARE @i INT = 1;

    WHILE @i <= @N
    BEGIN
        SET @Result = @Result + CAST(@i AS VARCHAR) + ' ';
        SET @i = @i + 1;
    END
		
    RETURN @Result;
end
SELECT DBO.fn_PRINTNUM(12)

--7.	Write a function to find the factorial of a given integer.
CREATE FUNCTION fn_Factorial(@Number INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT = 1;
    DECLARE @i INT = 1;

    WHILE @i <= @Number
    BEGIN
        SET @Result = @Result * @i;
        SET @i = @i + 1;
    END

    RETURN @Result;
END;

Select dbo.fn_Factorial(5)

----------------------------------PART B-----------------------

--1.Write a function to compare two integers and return the comparison result. (Using Case statement)
alter FUNCTION fn_CompareIntegers(@Num1 INT, @Num2 INT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE 
               WHEN @Num1 > @Num2 THEN 'First is greater' 
               WHEN @Num1 < @Num2 THEN 'Second is greater' 
               ELSE 'Both are equal' 
           END;
END;

Select dbo.fn_CompareIntegers(2,4)

--2.	Write a function to print the sum of even numbers between 1 to 20.
CREATE FUNCTION fn_SumOfEvens()
RETURNS INT
AS
BEGIN
    DECLARE @Sum INT = 0;
    DECLARE @i INT = 2;

    WHILE @i <= 20
    BEGIN
        SET @Sum = @Sum + @i;
        SET @i = @i + 2;
    END

    RETURN @Sum;
END;
SELECT dbo.fn_SumOfEvens(); 
--3.	Write a function that checks if a given string is a palindrome
CREATE FUNCTION fn_IsPalindrome(@Text VARCHAR(100))
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @ReversedText VARCHAR(100) = REVERSE(@Text);

    RETURN CASE 
               WHEN @Text = @ReversedText THEN 'Palindrome' 
               ELSE 'Not a Palindrome' 
           END;
END;
SELECT dbo.fn_IsPalindrome('sir'); 

----------------------------------------Part – C--------------------
--9.	Write a function to check whether a given number is prime or not.
CREATE FUNCTION fn_IsPrime(@Number INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @i INT = 2;

    IF @Number <= 1
        RETURN 'Not Prime';

    WHILE @i <= @Number/2
    BEGIN
        IF @Number % @i = 0
            RETURN 'Not Prime';

        SET @i = @i + 1;
    END

    RETURN 'Prime';
END;
SELECT dbo.fn_IsPrime(10);

--10.	Write a function which accepts two parameters start date & end date, and returns a difference in days.
CREATE FUNCTION fn_DateDifference(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @StartDate, @EndDate);
END;
SELECT dbo.fn_DateDifference('2023-01-01', '2023-01-31'); 

--11.	Write a function which accepts two parameters year & month in integer and returns total days in a given month & year.
CREATE FUNCTION fn_TotalDaysInMonth(@Year INT, @Month INT)
RETURNS INT
AS
BEGIN
    RETURN DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)));
END;
SELECT dbo.fn_TotalDaysInMonth(2024, 3);

--12.	Write a function which accepts departmentID as a parameter & returns a detail of the persons.
CREATE FUNCTION fn_GetPersonsByDepartment(@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person
    WHERE DepartmentID = @DepartmentID
);
SELECT * FROM fn_GetPersonsByDepartment(2); 

--13.	Write a function that returns a table with details of all persons who joined after 1-1-1991.
CREATE FUNCTION fn_GetPersonsJoinedAfter1991()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person
    WHERE JoiningDate > '1991-01-01'
);
SELECT * FROM fn_GetPersonsJoinedAfter1991();