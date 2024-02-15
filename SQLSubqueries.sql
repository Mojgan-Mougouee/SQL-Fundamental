---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 04 - Subqueries
-- Mougouee Mojgan
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Self-Contained Subqueries
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Scalar Subqueries 
---------------------------------------------------------------------

-- Order with the maximum order ID--
USE TSQLV4;



--1-DECLARE
DECLARE @maxid AS INT = (SELECT MAX(orderid)
                         FROM Sales.Orders); 
DECLARE @maxid AS INT = 10  


--2:DECLARE&set
DECLARE @maxid AS INT;
SET @maxid = 10;



--3- select
select @Maxid=max(Orderid)
From Sales.Orders






GO

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderid = (SELECT MAX(orderid) 
                 FROM Sales.Orders AS O);

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
ORDER BY orderid DESC, orderdate, empid, custid;





--chjuri ye subquery benevisim
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderid = (SELECT max(o.orderid)
                 FROM Sales.Orders AS O);



SELECT orderid
FROM Sales.Orders
WHERE empid = 
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'D%');

-Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <= , >, >= or when
 the subquery is used as an expression.


-- Scalar subquery expected to return one value
SELECT orderid
FROM Sales.Orders
WHERE empid = 
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'C%');
GO

SELECT orderid
FROM Sales. Orders as o
Inner join Hr. Employees as E
on e.empid=o.empid and e.lastname LIKE N'C%'






SELECT orderid
FROM Sales.Orders
WHERE empid = 
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'A%');

---------------------------------------------------------------------
-- Multi-Valued Subqueries
---------------------------------------------------------------------

SELECT orderid
FROM Sales.Orders
WHERE empid IN 
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'D%');

SELECT O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid
WHERE E.lastname LIKE N'D%';

-- Orders placed by US customers
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN
  (SELECT C.custid
   FROM Sales.Customers AS C
   WHERE C.country = N'USA');

-- Customers who placed no orders


SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN
  (SELECT O.custid
   FROM Sales.Orders AS O);


SELECT s.custid, companyname
FROM Sales.Customers as s
Left join 
Sales.Orders AS O
on s.custid = o.custid
where o.orderid is null

SELECT custid, companyname
FROM Sales.Customers as c
WHERE NOT exists
  (SELECT 1 
   FROM Sales.Orders AS O
   WHERE O.custid = C.custid);

-- While the NOT IN operator is useful for filtering data, it can lead to performance issues, especially with large datasets. This is because the database engine needs to perform a scan of the entire subquery result for each row in the outer query.

--To address performance concerns, one alternative approach is to use NOT EXISTS, which often performs better, particularly when the subquery result set is large. Another option is to use a LEFT JOIN combined with a NULL check.


-- Missing order IDs
USE TSQLV4;
DROP TABLE IF EXISTS dbo.Orders;
CREATE TABLE dbo.Orders(orderid INT NOT NULL CONSTRAINT PK_Orders PRIMARY KEY);

INSERT INTO dbo.Orders(orderid)
  SELECT orderid
  FROM Sales.Orders
  WHERE orderid % 2 = 0;

SELECT n
FROM dbo.Nums
WHERE n BETWEEN (SELECT MIN(O.orderid) FROM dbo.Orders AS O)
            AND (SELECT MAX(O.orderid) FROM dbo.Orders AS O)
  AND n NOT IN (SELECT O.orderid FROM dbo.Orders AS O);

-- CLeanup
DROP TABLE IF EXISTS dbo.Orders;

---------------------------------------------------------------------
-- Correlated Subqueries
---------------------------------------------------------------------

-- Orders with maximum order ID for each customer
-- Listing 4-1: Correlated Subquery
USE TSQLV4;

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders AS O1
WHERE orderid = 
  (SELECT MAX(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.custid = o1.custid);



--recomended
select max(orderId) AS MAXorderid ,CustId
From Sales.Orders
Group by custid





-- Percentage of customer total
SELECT orderid, custid, val,
  CAST(100. * val / (SELECT SUM(O2.val)
                     FROM Sales.OrderValues AS O2
                     WHERE O2.custid = O1.custid)
       AS NUMERIC(5,2)) AS pct
FROM Sales.OrderValues AS O1
ORDER BY custid, orderid;



SELECT orderid, o1.custid, val,
  CAST(100. * val / o2.SumTotal
       AS NUMERIC(5,2)) AS pct
FROM Sales.OrderValues AS O1
Join
	(SELECT SUM(val) as SumTotal,CustId
                     FROM Sales.OrderValues
		Group by custid) as O2
On o2.custid = o1.custid
ORDER BY o2.custid, o1.orderid;


---------------------------------------------------------------------
-- EXISTS
---------------------------------------------------------------------

-- Customers from Spain who placed orders: customerhaee ke 
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
  AND EXISTS
    (SELECT * FROM Sales.Orders AS O
     WHERE o.custid=c.custid);

SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
  AND c.CustId in
    (SELECT custid FROM Sales.Orders AS o);


-- Customers from Spain who didn't place Orders
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
  AND NOT EXISTS
    (SELECT 1 FROM Sales.Orders AS O
     WHERE O.custid = C.custid);



SELECT c.custid, companyname
FROM Sales.Customers AS C
Left Join
Sales.Orders AS O
on O.custid = C.custid
WHERE country = N'Spain'  and o.orderid is null



---------------------------------------------------------------------
-- Beyond the Fundamentals of Subqueries
-- (Optional, Advanced)
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Returning "Previous" or "Next" Value
---------------------------------------------------------------------
SELECT orderid, orderdate, empid, custid,
  (SELECT MAX(O2.orderid)
  FROM Sales.Orders AS O2
  WHERE O2.orderid < O1.orderid and o2.custid=o1.custid) AS prevorderid
FROM Sales.Orders AS O1
order by custid,orderid


SELECT orderid, orderdate, empid, custid,
  (SELECT MIN(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.orderid > O1.orderid and o1.custid=o2.custid) AS nextorderid
FROM Sales.Orders AS O1
order by o1.custid,o1.orderid

--------------------------------------------------------------------
-- Running Aggregates
---------------------------------------------------------------------

SELECT orderyear, qty
FROM Sales.OrderTotalsByYear;

SELECT orderyear, qty,
  (SELECT SUM(O2.qty)
   FROM Sales.OrderTotalsByYear AS O2
   WHERE O2.orderyear <= O1.orderyear) AS runqty
FROM Sales.OrderTotalsByYear AS O1
ORDER BY orderyear;

---------------------------------------------------------------------
-- Misbehaving Subqueries
---------------------------------------------------------------------

---------------------------------------------------------------------
-- NULL Trouble 
---------------------------------------------------------------------

-- Customers who didn't place orders

-- Using NOT IN
SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN(SELECT O.custid
                    FROM Sales.Orders AS O);





-- Add a row to the Orders table with a NULL custid
INSERT INTO Sales.Orders
  (custid, empid, orderdate, requireddate, shippeddate, shipperid,
   freight, shipname, shipaddress, shipcity, shipregion,
   shippostalcode, shipcountry)
  VALUES(NULL, 1, '20160212', '20160212',
         '20160212', 1, 123.00, N'abc', N'abc', N'abc',
         N'abc', N'abc', N'abc');

-- Following returns an empty set
SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN(SELECT O.custid
                    FROM Sales.Orders AS O);


-- Exclude NULLs explicitly
SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN(SELECT O.custid 
                    FROM Sales.Orders AS O
                    WHERE O.custid IS NOT NULL);

-- Using NOT EXISTS
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT * 
   FROM Sales.Orders AS O
   WHERE O.custid = C.custid);

-- Cleanup
DELETE FROM Sales.Orders WHERE custid IS NULL;
GO

---------------------------------------------------------------------
-- Substitution Error in a Subquery Column Name
---------------------------------------------------------------------

DROP TABLE IF EXISTS Sales.MyShippers;

CREATE TABLE Sales.MyShippers
(
  shipper_id  INT          NOT NULL,
  companyname NVARCHAR(40) NOT NULL,
  phone       NVARCHAR(24) NOT NULL,
  CONSTRAINT PK_MyShippers PRIMARY KEY(shipper_id)
);

INSERT INTO Sales.MyShippers(shipper_id, companyname, phone)
  VALUES(1, N'Shipper GVSUA', N'(503) 555-0137'),
	      (2, N'Shipper ETYNR', N'(425) 555-0136'),
				(3, N'Shipper ZHISN', N'(415) 555-0138');
GO


select * from sales.MyShippers
-- Shippers who shipped orders to customer 43

-- Bug   mige boro az  Sales.MyShippers mige oonhaee ro baraye man biar ke shipper_id shoon dar sales. order bashe va cust idish 43 bashe
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT shipper_id
   FROM Sales.Orders
   WHERE custid = 43);
GO

-- The safe way using aliases, bug identified
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT O.shipper_id
   FROM Sales.Orders AS O
   WHERE O.custid = 43);
GO

-- Bug corrected
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT O.shipperid
   FROM Sales.Orders AS O
   WHERE O.custid = 43);

-- Cleanup
DROP TABLE IF EXISTS Sales.MyShippers;
