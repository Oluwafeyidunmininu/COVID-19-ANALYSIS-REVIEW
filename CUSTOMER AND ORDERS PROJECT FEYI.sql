--List All Customers with Their Orders
SELECT c.CustomerName, o.OrderID, o.OrderTotal
		From Customers$ c
		join 
		Orders$ o
		on
		c.CustomerID = o.CustomerID; 
--Total Revenue Per Customer
SELECT p.CookieID,sum(P.RevenuePerCookie*op.Quantity)
AS Totalrevenuepercustomer
FROM Product$ P
join
Order_Product$ op
on p.CookieID= op.CookieID
GROUP BY p.CookieID;

--Find the most popular product
SELECT TOP 1 Order_Product$.CookieID, Product$.CookieName,
SUM (Quantity) AS Totalquantityordered
FROM Order_Product$

Join
Product$
On Product$.CookieID=Order_Product$.CookieID
GROUP BY  Order_Product$.CookieID, Product$.CookieName
ORDER BY Totalquantityordered DESC;

--Calculate Profit per order
SELECT o.OrderID, op.CookieID, sum(p.RevenuePerCookie  -p.CostPerCookie) AS ProfitPerOrder
FROM Product$ p
join
Order_Product$ op
on p.CookieID= op.CookieID
join
Orders$ o
on o.OrderID=op.OrderID
group by o.OrderID, op.CookieID
order by o.OrderID


--List customers with no orders
SELECT c.CustomerID,c.CustomerName
FROM Customers$ c
LEFT JOIN Orders$ o
ON c.CustomerID=c.CustomerID
WHERE o.OrderID IS NULL;
 
 --Customers who placed orders above $500
 SELECT c.CustomerID,c.CustomerName,
 SUM(o.OrderTotal) AS TotalOrder
 FROM Customers$ c
 left JOIN Orders$ o
 ON c.CustomerID=o.CustomerID
 GROUP BY c.CustomerID,c.CustomerName
 HAVING SUM(o.OrderTotal) > 500;
 
 SELECT c.CustomerID,c.CustomerName
 FROM Customers$ c
 WHERE
 NOT EXISTS(
 SELECT 1 
 FROM Orders$ o
 WHERE o.CustomerID=c.CustomerID);

 --Total Order per city 
 Select City, AVG(OrderTotal) as Total_order_Per_City 
 From Customers$ c
	join 
		Orders$ o
	on c.CustomerID = o.CustomerID
	Group by City

	--Most profitable customer
SELECT TOP 1 c.CustomerID,c.CustomerName,p.RevenuePerCookie,p.CostPerCookie
FROM Customers$ c,Product$ p

SELECT TOP 1 op.CookieID,  c.CustomerName,o.OrderID, SUM(p.RevenuePerCookie-p.CostPerCookie) AS Mostprofit
FROM Product$ p
JOIN Order_Product$ op
ON p.CookieID=op.CookieID
JOIN Orders$ o
ON op.OrderID=o.OrderID
JOIN Customers$ c
ON o.CustomerID=c.CustomerID
GROUP BY c.CustomerName,op.CookieID, o.OrderID