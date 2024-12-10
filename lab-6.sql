--------------------------------------------Lab-6------------------------------
--  Create the Products table
CREATE TABLE Products (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

--  Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);

------------------Part-A----------------------------


-- 1. Create a cursor Product_Cursor to fetch all the rows from the Products table.
Declare
	@ProductID int,
	@ProductName varchar(250),
	@Price decimal(10,2);

declare Product_Cursor cursor
for select 
	Product_id ,
    Product_Name,
    Price
from Products

open Product_Cursor;

fetch next from Product_Cursor into
	@ProductID,
	@ProductName,
	@Price;

while @@FETCH_STATUS=0
begin
	select @ProductID as ProductID,@ProductName as ProductName,@Price as Price;
	fetch next from Product_Cursor into
	@ProductID,
	@ProductName,
	@Price;
end;

close Product_Cursor;
deallocate Product_Cursor

--2.	Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName.(Example: 1_Smartphone)

declare Product_Cursor_Fetch cursor
for select 
	CAST(Product_id as varchar)+'_'+Product_Name as ProductInfo 
from Products;

open Product_Cursor_Fetch;

declare @ProductInfo varchar(200);

fetch next from Product_Cursor_Fetch into @ProductInfo

while @@FETCH_STATUS=0
begin
	Print @ProductInfo;
	fetch next from Product_Cursor_Fetch into @ProductInfo;
end;

close Product_Cursor_Fetch;
deallocate Product_Cursor_Fetch;

--3.Create a cursor Product_CursorDelete that deletes all the data from the Products table.
declare @ProductID int
declare Product_CursorDelete cursor

for select 
	Product_id
from Products;

open Product_CursorDelete;

fetch next from Product_CursorDelete into @ProductID;

while @@FETCH_STATUS=0
begin
	delete from Products where Product_id=@ProductID;
	fetch next from Product_CursorDelete into @ProductID;
end;

close Product_CursorDelete;
deallocate Product_CursorDelete;

--4.Create a Cursor to Find and Display Products Above Price 30,000
Declare
	@ProductID int,
	@ProductName varchar(250),
	@Price decimal(10,2);

declare Product_Cursor_Above_30000 cursor
for select 
	Product_id ,
    Product_Name,
    Price
from Products
where Price>30000

open Product_Cursor_Above_30000;

fetch next from Product_Cursor_Above_30000 into
	@ProductID,
	@ProductName,
	@Price;

while @@FETCH_STATUS=0
begin
	select @ProductID as ProductID,@ProductName as ProductName,@Price as Price;
	fetch next from Product_Cursor_Above_30000 into
	@ProductID,
	@ProductName,
	@Price;
end;

close Product_Cursor_Above_30000;
deallocate Product_Cursor_Above_30000;

--------------------Part-B-----------------------------

--5.Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%.
Declare
	@ProductID int,
	@ProductName varchar(250),
	@Price decimal(10,2);

declare Product_CursorUpdate cursor
for select 
	Product_id ,
    Price
from Products

open Product_CursorUpdate;

fetch next from Product_CursorUpdate into
	@ProductID,
	@Price;

while @@FETCH_STATUS=0
begin
	update Products set
	Price=Price*1.10
	where Product_id=@ProductID

	fetch next from Product_CursorUpdate into
	@ProductID,
	@Price;
end;

close Product_CursorUpdate;
deallocate Product_CursorUpdate;

select * from Products

--6.	Create a Cursor to Rounds the price of each product to the nearest whole number.
Declare
	@ProductID int,
	@ProductName varchar(250),
	@Price decimal(10,2);

declare Product_Cursor_Round cursor
for select 
	Product_id ,
    Price
from Products

open Product_Cursor_Round;

fetch next from Product_Cursor_Round into
	@ProductID,
	@Price;

while @@FETCH_STATUS=0
begin
	update Products set
	Price=round(Price,0)
	where Product_id=@ProductID

	fetch next from Product_Cursor_Round into
	@ProductID,
	@Price;
end;

close Product_Cursor_Round;
deallocate Product_Cursor_Round;


-----------------------------------------------------psrt-c----------------------

--7.	Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” (Note: Create NewProducts table first with same fields as Products table)

CREATE TABLE NewProducts (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);
-- Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop”.
DECLARE Product_Cursor_Insert_Laptop CURSOR
FOR SELECT 
    Product_id, 
    Product_Name, 
    Price 
FROM 
    Products 
WHERE 
    Product_Name = 'Laptop';

OPEN Product_Cursor_Insert_Laptop;

FETCH NEXT FROM Product_Cursor_Insert_Laptop INTO @ProductID, @ProductName, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NewProducts (Product_id, Product_Name, Price) 
    VALUES (@ProductID, @ProductName, @Price);
    
    FETCH NEXT FROM Product_Cursor_Insert_Laptop INTO @ProductID, @ProductName, @Price;
END;

CLOSE Product_Cursor_Insert_Laptop;
DEALLOCATE Product_Cursor_Insert_Laptop;

Select *From NewProducts

--8.Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products with a price above 50000 to an archive table, removing them from the original Products table
CREATE TABLE ArchivedProducts (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);

-- Create a Cursor to Archive High-Price Products in a New Table
DECLARE Product_Cursor_Archive CURSOR
FOR SELECT 
    Product_id, 
    Product_Name, 
    Price 
FROM 
    Products 
WHERE 
    Price > 50000;

OPEN Product_Cursor_Archive;

FETCH NEXT FROM Product_Cursor_Archive INTO @ProductID, @ProductName, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO ArchivedProducts (Product_id, Product_Name, Price) 
    VALUES (@ProductID, @ProductName, @Price);

    DELETE FROM Products WHERE Product_id = @ProductID;

    FETCH NEXT FROM Product_Cursor_Archive INTO @ProductID, @ProductName, @Price;
END;

CLOSE Product_Cursor_Archive;
DEALLOCATE Product_Cursor_Archive;

Select *From ArchivedProducts	
select * from Products