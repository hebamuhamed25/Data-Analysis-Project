
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(200)
);
-------------
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50),

    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
---------------------
CREATE TABLE MenuItems (
    MenuItemID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10,2) NOT NULL,
    CuisineType NVARCHAR(50)  
);
----------------------
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (MenuItemID)
        REFERENCES MenuItems(MenuItemID)
);
-------------------
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL, -- ?????: Cash, Credit Card, PayPal

    CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID));
---------------------
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-----------------------
------Customers Table Inserting
INSERT INTO Customers (FullName, Phone,Address)
SELECT TOP (3000)
    
    CONCAT(
        CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*10+1 AS INT),
            'Ahmed','Mohamed','Mostafa','Khaled','Omar',
            'Sara','Mona','Heba','Nour','Aya'
        ),
        ' ',
        CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*10+1 AS INT),
            'Ali','Mahmoud','Hassan','Youssef','Tamer',
            'Fathy','Kamal','Hussein','Gamal','Adel'
        )
    ) AS FullName,

   
    CONCAT('01',
        CAST((RAND(CHECKSUM(NEWID()))*899999999 + 100000000) AS BIGINT)
    ) AS Phone,

    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*10+1 AS INT),
        'Nasr City','Heliopolis','Maadi','Dokki','Mohandessin',
        'Zamalek','Shubra','Imbaba','Smouha','Agami'
    ) AS Address
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;

------------
SELECT TOP 100 *
FROM Customers;

-------------
DELETE FROM Customers
WHERE FullName IS NULL OR Address IS NULL OR FullName = '' OR Address = '';

------ Orders Table Inserting
INSERT INTO Orders (CustomerID, OrderDate, Status)
SELECT TOP (3500)
    
    CAST(RAND(CHECKSUM(NEWID())) * (SELECT MAX(CustomerID) FROM Customers) + 1 AS INT) AS CustomerID,

  
    DATEADD(DAY, -CAST(RAND(CHECKSUM(NEWID())) * 365 AS INT), GETDATE()) AS OrderDate,


    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*4+1 AS INT),
        'Pending','Shipped','Delivered','Cancelled'
    ) AS Status
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;

------------Order Details Table Inserting

INSERT INTO OrderDetails (OrderID, MenuItemID, Quantity, Price, Driver_name)
SELECT TOP (3500)
  
    CAST(RAND(CHECKSUM(NEWID())) * (SELECT MAX(OrderID) FROM Orders) + 1 AS INT) AS OrderID,

   
    CAST(RAND(CHECKSUM(NEWID())) * (SELECT MAX(MenuItemID) FROM MenuItems) + 1 AS INT) AS MenuItemID,

 
    CAST(RAND(CHECKSUM(NEWID())) * 5 + 1 AS INT) AS Quantity,

    CAST(RAND(CHECKSUM(NEWID())) * 180 + 20 AS DECIMAL(10,2)) AS Price,

    
    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*8+1 AS INT),
        'Ahmed Ali','Mohamed Hassan','Mostafa Tamer','Khaled Omar',
        'Sara Hany','Mona Adel','Heba Gamal','Nour Fathy','Aya Kamal'
    ) AS Driver_name
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;

-----------MenuItems Table Inserting

INSERT INTO MenuItems (Name, Description, Price, CuisineType)
SELECT TOP (100)
    
    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*10+1 AS INT),
        'Pizza','Burger','Pasta','Shawarma','Sushi',
        'Fried Chicken','Koshari','Falafel','Steak','Salad'
    ) AS Name,

    
    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*10+1 AS INT),
        'Delicious and fresh','Spicy and hot','Family favorite',
        'Healthy choice','Chef special','Crispy and tasty',
        'Authentic recipe','Best seller','Light and fresh','Rich flavor'
    ) AS Description,

    
    CAST(RAND(CHECKSUM(NEWID())) * 170 + 30 AS DECIMAL(10,2)) AS Price,


    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*6+1 AS INT),
        'Italian','American','Egyptian','Asian','Mexican','Indian','French'
    ) AS CuisineType
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;

---------- Payments Table Inserting

INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod)
SELECT TOP (3000)
    
    CAST(RAND(CHECKSUM(NEWID())) * (SELECT MAX(OrderID) FROM Orders) + 1 AS INT) AS OrderID,

    DATEADD(DAY, -CAST(RAND(CHECKSUM(NEWID())) * 365 AS INT), GETDATE()) AS PaymentDate,

   
    CAST(RAND(CHECKSUM(NEWID())) * 450 + 50 AS DECIMAL(10,2)) AS Amount,

    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*4+1 AS INT),
        'Cash','Credit Card','Fawry','Vodaphone Cash'
    ) AS PaymentMethod
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;

---------- Reviews Table Inserting
INSERT INTO Reviews (OrderID, CustomerID, Rating, Comment, ReviewDate)
SELECT TOP (1500)
    
    CAST(RAND(CHECKSUM(NEWID())) * (SELECT MAX(OrderID) FROM Orders) + 1 AS INT) AS OrderID,

   
    CAST(RAND(CHECKSUM(NEWID())) * (SELECT MAX(CustomerID) FROM Customers) + 1 AS INT) AS CustomerID,

   
    CAST(RAND(CHECKSUM(NEWID())) * 5 + 1 AS INT) AS Rating,

  
    CHOOSE(CAST(RAND(CHECKSUM(NEWID()))*8+1 AS INT),
        'Excellent service!',
        'Very satisfied with the order.',
        'Food was tasty and hot.',
        'Delivery was a bit late.',
        'Not satisfied with the quality.',
        'Average experience.',
        'Highly recommend!',
        'Would order again.',
        'Driver was very friendly.'
    ) AS Comment,

   
    DATEADD(DAY, -CAST(RAND(CHECKSUM(NEWID())) * 365 AS INT), GETDATE()) AS ReviewDate
FROM sys.all_objects a
CROSS JOIN sys.all_objects b;







