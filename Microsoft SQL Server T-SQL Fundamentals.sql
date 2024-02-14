---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 02 - Single-Table Queries



---------------------------------------------------------------------
-- Elements of the SELECT Statement
---------------------------------------------------------------------

-- Listing 2-1: Sample Query
USE TSQLV4;



/*
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;
*/
---------------------------------------------------------------------
-- The FROM Clause
---------------------------------------------------------------------
select *
from Hr.Employees;

select firstname,lastname,title
from Hr.Employees;


SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders;







---------------------------------------------------------------------
-- The WHERE Clause
---------------------------------------------------------------------
SELECT *
FROM Sales.Orders



SELECT custid,orderid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71 or empid in(9,1) ;




---------------------------------------------------------------------
-- The GROUP BY Clause
---------------------------------------------------------------------
/* retrieve the employee IDs  along with the respective years of orders 
  for orders made by the customer with ID 718*/


SELECT   empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid in(71,75)
GROUP BY empid, YEAR(orderdate);







/*Key Insights:

1-Freight Costs Analysis
2-Order Frequency Assessment by Employee
3-Employee Performance Evaluation
4-Yearly Trends Observation
5-Cost Analysis for Decision Making
6-Employee Contribution Assessment*/



SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(freight) AS totalfreight
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);








/*SELECT
  orderid,
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(freight) AS totalfreight,
  COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)*/


SELECT
  orderid,
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(freight) AS totalfreight,
  COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate),orderid;




select * 
from sales.orders
where empid=5 and year(orderdate)='2015' and  custid = 71

/*
SELECT empid, YEAR(orderdate) AS orderyear, freight
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);
*/




SELECT 
  empid, 
  YEAR(orderdate) AS orderyear, 
  COUNT(DISTINCT custid) AS numcusts,
  COUNT(custid) AS numcustsDuplicate,
  COUNT(DISTINCT orderdate) AS numorder,
  Count(*) as CountStar,
  Count(Shipregion) as ShipRegion
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);




select * 
from sales.orders
where empid=1 and year(orderdate)='2014' 


---------------------------------------------------------------------
-- The HAVING Clause
---------------------------------------------------------------------


SELECT empid, YEAR(orderdate) AS orderyear,COUNT(*) as cntro
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;


SELECT empid, YEAR(orderdate) AS orderyear,COUNT(*) as cntrow, SUM(FREIGHT)AS Sumfreight
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING sum(freight)>100 --AND COUNT(*) > 2;



SELECT empid, YEAR(orderdate) AS orderyear,COUNT(*) as cntrow
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 2;

---------------------------------------------------------------------
-- The SELECT Clause
---------------------------------------------------------------------
SELECT *
FROM Sales.Orders;


SELECT orderid,orderdate
FROM Sales.Orders;




SELECT
  O.empid,
  YEAR(O.orderdate) AS [OrderYear],
  COUNT(*) AS [cntrow]
FROM
  Sales.Orders AS O
WHERE
  O.custid = 71
GROUP BY
  O.empid, YEAR(O.orderdate)
HAVING
  COUNT(*) > 1;


/*
SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE orderyear > 2015;
*/

SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE YEAR(orderdate) > 2015;

/*
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING numorders > 1;
*/

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

-- Listing 2-2: Query Returning Duplicate Rows
SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;

-- Listing 2-3: Query With a DISTINCT Clause
SELECT distinct empid, YEAR(orderdate) AS orderyear,CustId
FROM Sales.Orders
WHERE custid = 71
ORDER BY empid,orderYear,CustId

SELECT *
FROM Sales.Shippers;

/*
SELECT orderid,		
		YEAR(orderdate) AS orderyear,  
		  orderyear + 1 AS nextyear
FROM Sales.Orders;
*/

SELECT orderid as [Order Number],
  YEAR(orderdate) AS orderyear,
  YEAR(orderdate) + 1 AS nextyear,
  empid as [Employee No]
FROM Sales.Orders;

---------------------------------------------------------------------
-- The ORDER BY Clause
---------------------------------------------------------------------

-- Listing 2-4: Query Demonstrating the ORDER BY Clause
SELECT empid, YEAR(orderdate) AS orderyear,COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid desc, orderyear  ;

SELECT empid, YEAR(orderdate) AS orderyear,COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY  orderyear , empid desc ;

SELECT top (5) empid, YEAR(orderdate) AS orderyear,COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY orderyear,empid desc ;

SELECT top (5) percent empid, YEAR(orderdate) AS orderyear,COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY orderyear,empid desc ;


SELECT empid, firstname, lastname, country,hiredate
FROM HR.Employees
ORDER BY-- hiredate;
 
/*
SELECT DISTINCT country
FROM HR.Employees
ORDER BY empid;
*/


SELECT DISTINCT country,empid
FROM HR.Employees
ORDER BY empid;
---------------------------------------------------------------------
-- The TOP and OFFSET-FETCH Filters
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The TOP Filter
---------------------------------------------------------------------

-- Listing 2-5: Query Demonstrating the TOP Option
SELECT distinct TOP (5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT TOP (1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

-- Listing 2-6: Query Demonstrating TOP with Unique ORDER BY List
SELECT TOP (5) with ties orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC ,--orderid DESC;


SELECT TOP (5) with ties orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC ,orderid DESC;



---------------------------------------------------------------------
-- The OFFSET-FETCH Filter
---------------------------------------------------------------------

-- OFFSET-FETCH
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders  
ORDER BY orderdate, orderid
OFFSET 10 ROWS FETCH NEXT 25 ROWS ONLY; 

---------------------------------------------------------------------
-- A Quick Look at Window Functions
---------------------------------------------------------------------



SELECT orderid, custid, val,orderdate,requireddate,qty,empid,
  count(*) OVER(PARTITION BY custid
                    ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custId,val;

---------------------------------------------------------------------
-- Predicates and Operators
---------------------------------------------------------------------

-- Predicates: IN, BETWEEN, LIKE
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid IN ('10248', '10249', '10250');

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid BETWEEN 10300 AND 10310;


SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

-- Comparison operators: =, >, <, >=, <=, <>, !=, !>, !< 
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20160101';

-- Logical operators: AND, OR, NOT
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20160101'
  AND empid IN(1, 3, 5);

-- Arithmetic operators: +, -, *, /, %
SELECT orderid, productid, qty, unitprice, discount,
  qty * unitprice * (1 - discount) AS val
FROM Sales.OrderDetails;

-- Operator Precedence

-- AND precedes OR
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
        custid = 1
    AND empid IN(1, 3, 5)
    OR  custid = 85
    AND empid IN(2, 4, 6)

-- Equivalent to
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
      ( custid = 1
        AND empid IN(1, 3, 5) )
    OR
      ( custid = 85
        AND empid IN(2, 4, 6) );

-- *, / precedes +, -
SELECT 10 + 2 * 3   -- 16

SELECT (10 + 2) * 3 -- 36

---------------------------------------------------------------------
-- CASE Expression
---------------------------------------------------------------------

-- Simple
SELECT productid, productname, categoryid,
  CASE categoryid
    WHEN 1 THEN 'Beverages'
    WHEN 2 THEN 'Condiments'
    WHEN 3 THEN 'Confections'
    WHEN 4 THEN 'Dairy Products'
    WHEN 5 THEN 'Grains/Cereals'
    WHEN 6 THEN 'Meat/Poultry'
    WHEN 7 THEN 'Produce'
    WHEN 8 THEN 'Seafood'
    ELSE 'Unknown Category'
  END AS categoryname
FROM Production.Products;

-- Searched
SELECT orderid, custid, val,
  CASE 
    WHEN val < 1000.00                   THEN 'Less than 1000'
    WHEN val BETWEEN 1000.00 AND 3000.00 THEN 'Between 1000 and 3000'
    WHEN val > 3000.00                   THEN 'More than 3000'
    ELSE 'Unknown'
  END AS valuecategory
FROM Sales.OrderValues;

---------------------------------------------------------------------
-- NULLs
---------------------------------------------------------------------

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS not NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA'
   OR region IS NULL
order by region



---------------------------------------------------------------------
-- Working with Character Data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Collation
---------------------------------------------------------------------

SELECT name, description
FROM sys.fn_helpcollations();

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname = N'davis';

SELECT empid, firstname, lastname 
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_Ci_AS = N'Davis';
--WHERE lastname COLLATE Latin1_General_Cs_AS = N'davis'



---------------------------------------------------------------------
-- Operators and Functions
---------------------------------------------------------------------

-- Concatenation
SELECT empid, firstname + N' ' + lastname AS fullname
FROM HR.Employees;

-- Listing 2-7: Query Demonstrating String Concatenation
SELECT custid, country, region, city,
  country + N',' + region + N',' + city AS location
FROM Sales.Customers;

-- convert NULL to empty string
SELECT custid, country, region, city,
  country + COALESCE( N',' + region, N'') + N',' + city AS location
FROM Sales.Customers;

-- using the CONCAT function
SELECT custid, country, region, city,
  CONCAT(country, N',' + region, N',' + city) AS location
FROM Sales.Customers;

-- Functions
SELECT SUBSTRING('abcde', 1, 3); -- 'abc'

SELECT RIGHT('abcde', 3); -- 'cde'

SELECT LEN(N'abcde'); -- 5

SELECT DATALENGTH(N'abcde'); -- 10

SELECT CHARINDEX(' ','Itzik Ben-Gan'); -- 6

SELECT PATINDEX('%[0-9]%', 'abcd123efgh'); -- 5

SELECT REPLACE('1-a 2-b', '-', ':'); -- '1:a 2:b'

SELECT empid, lastname,
  LEN(lastname) - LEN(REPLACE(lastname, 'e', '')) AS numoccur
FROM HR.Employees;

SELECT REPLICATE('abc', 3); -- 'abcabcabc'


SELECT supplierid,
  RIGHT(REPLICATE('0', 9) + CAST(supplierid AS VARCHAR(10)),
        10) AS strsupplierid
FROM Production.Suppliers;

select cast('Hamidreza' as varchar(3))

SELECT STUFF('xyz', 2, 2, 'abc'); -- 'xabcz'

SELECT UPPER('Itzik Ben-Gan'); -- 'ITZIK BEN-GAN'

SELECT LOWER('Itzik Ben-Gan'); -- 'itzik ben-gan'

SELECT RTRIM(LTRIM('   abc   ')); -- 'abc'

SELECT FORMAT(1759, '0000000000'); -- '0000001759'

-- COMPRESS
SELECT COMPRESS(N'This is my cv. Imagine it was much longer.');

/*
INSERT INTO dbo.EmployeeCVs( empid, cv )
  VALUES( @empid, COMPRESS(@cv) );
*/

-- DECOMPRESS
SELECT DECOMPRESS(COMPRESS(N'This is my cv. Imagine it was much longer.'));

SELECT
  CAST(
    DECOMPRESS(COMPRESS(N'This is my cv. Imagine it was much longer.'))
      AS NVARCHAR(MAX));

/*
SELECT empid, CAST(DECOMPRESS(cv) AS NVARCHAR(MAX)) AS cv
FROM dbo.EmployeeCVs;
*/

-- STRING_SPLIT
SELECT Value--CAST(value AS INT) AS myvalue
FROM STRING_SPLIT('10248;10249;10250;Hamidreza;Sara;Arezzo;Mohammad', '') AS S

/*
myvalue
-----------
10248
10249
10250
*/

---------------------------------------------------------------------
-- LIKE Predicate
---------------------------------------------------------------------

-- Last name starts with D
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

-- Second character in last name is e
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'_e%';

-- First character in last name is A, B or C
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[ABCDE]%';

-- First character in last name is A through E
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'%[A-E]%';

-- First character in last name is not A through E
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[^A-E]%';

