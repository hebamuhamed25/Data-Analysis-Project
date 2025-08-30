----اعلى 10 عملاء دفعوا 
SELECT TOP 10 c.FullName, SUM(p.Amount)AS TotalSpent
FROM Customers c 
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN Payments p ON o.OrderID =p.OrderID
GROUP BY c.FullName 
ORDER BY TotalSpent DESC;

--------عدد الطلبات لكل عميل
SELECT c.FullName, COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c 
JOIN Orders o ON c.CustomerID=o.CustomerID
GROUP BY c.FullName 
ORDER BY NumberOfOrders DESC;

---------------المنتجات الاكثر طلبا
SELECT TOP 5 od.MenuItemID,m.Name, 
COUNT(*) AS TimesOrdered
FROM OrderDetails od
JOIN MenuItems m ON od.MenuItemID = m.MenuItemID
GROUP BY od.MenuItemID, m.Name
ORDER BY TimesOrdered DESC;

----------------الدخل الكلى للشركه
SELECT SUM(Amount) AS TotalRevenue
FROM Payments;

--------متوسط قيمة الطلب

SELECT AVG(p.Amount) AS AveragePayment
FROM Payments p;

----------الطلبات التى لم تسدد الى الان
SELECT o.OrderID, c.FullName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;

---------السائقين وعدد الطلبات اللي وصلوها
SELECT od.Driver_name,
COUNT(od.OrderID) AS DeliverdOrders
FROM OrderDetails od GROUP BY od.Driver_name
ORDER BY DeliverdOrders DESC;

--------افضل 5 عملاء حسب المراجعات

SELECT TOP 5 c.FullName, COUNT(r.ReviewID) AS NumberOfReviews
FROM Customers c
JOIN Reviews r ON c.CustomerID = r.CustomerID
GROUP BY c.FullName
ORDER BY NumberOfReviews DESC;

------------اليوم الاكثر طلبات فى الاسبوع
SELECT DATENAME(WEEKDAY, o.OrderDate) AS DayOfWeek, COUNT(*) AS OrdersCount
FROM Orders o
GROUP BY DATENAME(WEEKDAY, o.OrderDate)
ORDER BY OrdersCount DESC;

---------ترتيب السائقين حسب متوسط التقييم
SELECT 
    od.Driver_name, 
    AVG(r.Rating) AS AverageRating
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Reviews r ON o.OrderID = r.OrderID
GROUP BY od.Driver_name
ORDER BY AverageRating DESC;

---------------------- اسماءال Customers + اجمالى مدفوعاتهم
SELECT
    c.CustomerID,
    c.FullName,
    SUM(p.Amount) AS TotalPaid
FROM Customers      AS c
JOIN Orders         AS o ON o.CustomerID = c.CustomerID
JOIN Payments       AS p ON p.OrderID    = o.OrderID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalPaid DESC;

------------اسم كل صنف + عدد مرات طلبه+ اجمالى كميته
SELECT
    m.MenuItemID,
    m.Name,
    COUNT(*)           AS TimesOrdered,     -- كم مرة ظهر الصنف في سطور الطلبات
    SUM(od.Quantity)   AS TotalQuantity     -- إجمالي القطع المباعة (اختياري)
FROM OrderDetails AS od
JOIN MenuItems    AS m ON m.MenuItemID = od.MenuItemID
GROUP BY m.MenuItemID, m.Name
ORDER BY TimesOrdered DESC;

------------- (متوسط مبلغ الدفع لكل طريقةدفع +(عدد المدفوعات / مجموعها
SELECT
    p.PaymentMethod,
    COUNT(*)                                  AS PaymentsCount,
    SUM(p.Amount)                             AS TotalAmount,
    AVG(CAST(p.Amount AS DECIMAL(10,2)))      AS AverageAmount
FROM Payments AS p
GROUP BY p.PaymentMethod
ORDER BY AverageAmount DESC;