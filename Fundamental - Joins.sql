---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 03 - Joins
-- Mougouee Mojgan
---------------------------------------------------------------------

---------------------------------------------------------------------
-- CROSS Joins
---------------------------------------------------------------------

USE TSQLV4;

-- SQL-92 akharin standarde sql bood
SELECT C.custid, E.empid
FROM Sales.Customers AS C
  CROSS JOIN HR.Employees AS E;



-- Self Cross-Join
SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1 
  CROSS JOIN HR.Employees AS E2;
GO

-- All numbers from 1 - 1000

-- Auxiliary table of digits
USE TSQLV4;

DROP TABLE IF EXISTS dbo.Digits;

CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SELECT digit FROM dbo.Digits;
GO

-- All numbers from 1 - 1000
SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n,
       d3.digit as D3digit, 
	     d2.digit as D2digit, 
		   d1.digit as D1digit

FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;

---------------------------------------------------------------------
-- INNER Joins
---------------------------------------------------------------------

USE TSQLV4;


SELECT E.empid, E.firstname, E.lastname,O.orderid,O.empid
FROM HR.Employees AS E  
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid



-- SQL-92 
SELECT E.empid, E.firstname, E.lastname,O.orderid,o.empid
FROM HR.Employees AS E 
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid
where e.empid=4


-- SQL-89 kare balaee ro anjam mide va khata dare chon age bala on ro nazanim dastur ejra nemishe va error mizane
--SELECT E.empid, E.firstname, E.lastname, O.orderid
--FROM HR.Employees AS E, Sales.Orders AS O
--WHERE E.empid = O.empid;
--GO

-- Inner Join Safety
/*
SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O;
GO
*/

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E, Sales.Orders AS O;
GO

---------------------------------------------------------------------
-- More Join Examples
---------------------------------------------------------------------
--------------------------------------------------------------------
-- Non-Equi Joins
---------------------------------------------------------------------

-- Unique pairs of employees
SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1
  INNER JOIN HR.Employees AS E2
    ON E1.empid < E2.empid;



---------------------------------------------------------------------
-- Multi-Join Queries
---------------------------------------------------------------------
SELECT c.custid, C.companyname, O.orderid,o.*
FROM Sales.Customers AS C   
	left OUTER JOIN Sales.Orders AS O					
    ON C.custid = O.custid 




SELECT
  C.custid, C.companyname, O.orderid,
  OD.productid, OD.qty
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid --and od.productid=11	
where  od.productid=11
	



---------------------------------------------------------------------
-- Fundamentals of Outer Joins 
---------------------------------------------------------------------

-- Customers and their orders, including customers with no orders
SELECT c.custid, C.companyname, O.orderid,o.*
FROM Sales.Customers AS C   
	left OUTER JOIN Sales.Orders AS O					
    ON C.custid = O.custid 




--****point :what differences between these two syntax
SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
  left JOIN Sales.Orders AS O
    ON C.custid = O.custid 
Where c.custid=55

SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
  left JOIN Sales.Orders AS O
    ON C.custid = O.custid and c.custid=55


-- Customers with no orders : 
SELECT C.custid, C.companyname , o.ORderId , o.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderid IS NULL;

---------------------------------------------------------------------
-- Beyond the Fundamentals of Outer Joins
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Including Missing Values:
---------------------------------------------------------------------
select DATEADD(day, 1095, CAST('20140101' AS DATE))
Select*from Nums






SELECT DATEADD(day, n-1, CAST('20140101' AS DATE)) AS orderdate,n
FROM dbo.Nums
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;


 --Showing  the days for which there are no order

SELECT DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) AS orderdate,
  O.orderid, O.custid, O.empid
FROM dbo.Nums
  left OUTER JOIN Sales.Orders AS O
    ON DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) = O.orderdate
WHERE Nums.n <= DATEDIFF(day, '20140101', '20161231') + 1	
ORDER BY orderdate;


select orderdate,orderid 
from sales.orders
where orderdate is null




---------------------------------------------------------------------
-- Filtering Attributes from Non-Preserved Side of Outer Join
---------------------------------------------------------------------

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderdate >= '20160101';

---------------------------------------------------------------------
-- Using Outer Joins in a Multi-Join Query
---------------------------------------------------------------------

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Option 1: use outer join all along 
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  LEFT OUTER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Option 2: change join order
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid
  RIGHT OUTER JOIN Sales.Customers AS C
     ON O.custid = C.custid;

-- Option 3: use parentheses
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN
      (Sales.Orders AS O
         INNER JOIN Sales.OrderDetails AS OD
           ON O.orderid = OD.orderid)
    ON C.custid = O.custid;

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN
      Sales.Orders AS O
         INNER JOIN Sales.OrderDetails AS OD
           ON O.orderid = OD.orderid
    ON C.custid = O.custid;

---------------------------------------------------------------------
-- Using the COUNT Aggregate with Outer Joins
---------------------------------------------------------------------

SELECT C.custid, COUNT(*) AS numorders
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
GROUP BY C.custid;

SELECT C.custid, COUNT(O.orderid) AS numorders
FROM Sales.Customers AS C
  left OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
GROUP BY C.custid;
