/*The company is a mock company using real-world data using W3 Schools Database

https://coursera.w3schools.com/sql/trysql.asp?filename=trysql_select_all

The company wanted to compensate the 5 top sales team performers

I used SQL to:

Identify how the information was organized
sort and filter the data
determine the credibility of the data

The audience is the CFO of the company

I will create queries and extract tables to show the top five performers based on two different criteria*/

-- Key Takeaways

-- TOP 5 SALES *(Possible same employees)
-- This query lists the top five sales ever made.  Some of these sales may have been made by the same employee

SELECT LastName, FirstName, Orders.OrderID, Products.ProductID, Quantity, Price, SUM(Quantity * Price) AS SalesAmount
FROM Employees
	INNER JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
	INNER JOIN OrderDetails
		ON OrderDetails.OrderID  = Orders.OrderID
	INNER JOIN Products
		ON Product.ProductID = OrderDetails.ProductID
GROUP BY Orders.OrderID
ORDER BY  SalesAmount DESC
LIMIT 5

-- TOP 5 SALES EMPLOYEES
-- This query lists the top five sales employees

SELECT LastName, FirstName, Orders.OrderID, Products.ProductID, Quantity, Price, SUM(Quantity * Price) AS SalesAmount
FROM Employees
	INNER JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
	INNER JOIN OrderDetails
		ON OrderDetails.OrderID  = Orders.OrderID
	INNER JOIN Products
		ON Product.ProductID = OrderDetails.ProductID
GROUP BY Orders.OrderID
HAVING Orders.OrderID IN (10372, 10424, 10417, 10324, 10351)
ORDER BY  SalesAmount DESC




