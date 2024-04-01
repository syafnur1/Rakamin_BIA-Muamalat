-- 1. Define the PRIMARY KEY of each table --

-- Products table
-- check the PK is unique
SELECT 
  ProdNumber, 
  COUNT(*)
FROM Sales_BIA.products
GROUP BY 1
ORDER BY 2 DESC
-- product table > PK = ProdNumber
ALTER TABLE Sales_BIA.products
ADD PRIMARY KEY(ProdNumber) NOT ENFORCED;

-- Productcategory table
-- check the PK is unique
SELECT 
  CategoryID, 
  COUNT(*)
FROM Sales_BIA.productcategory
GROUP BY 1
ORDER BY 2 DESC
-- productcategory table > PK = CategoryID
ALTER TABLE Sales_BIA.productcategory
ADD PRIMARY KEY(CategoryID) NOT ENFORCED;

-- Orders table
-- check the PK is unique
SELECT 
  OrderID, 
  COUNT(*)
FROM Sales_BIA.orders
GROUP BY 1
ORDER BY 2 DESC, 1 
-- orders table > PK = OrderID
ALTER TABLE Sales_BIA.orders
ADD PRIMARY KEY(OrderID) NOT ENFORCED;

-- Customers table
-- check the PK is unique
SELECT 
  CustomerID, 
  COUNT(*)
FROM Sales_BIA.customers
GROUP BY 1
ORDER BY 2 DESC, 1 
-- Customers table > PK = OrderID
ALTER TABLE Sales_BIA.customers
ADD PRIMARY KEY(CustomerID) NOT ENFORCED;


-- 2. Define the relationship between tables (FOREIGN KEY) --

--- orders(CustomerID) --> customers(CustomerID)
ALTER TABLE Sales_BIA.orders
ADD CONSTRAINT CustomerID FOREIGN KEY (CustomerID)
REFERENCES Sales_BIA.customers(CustomerID) NOT ENFORCED;

--- orderss(ProdNumber) --> products(ProdNumber)
ALTER TABLE Sales_BIA.orders
ADD CONSTRAINT ProdNumber FOREIGN KEY (ProdNumber)
REFERENCES Sales_BIA.products(ProdNumber) NOT ENFORCED;

--- products(Category) --> productcategory(CategoryID)
ALTER TABLE Sales_BIA.products
ADD CONSTRAINT Category FOREIGN KEY (Category)
REFERENCES Sales_BIA.productcategory(CategoryID) NOT ENFORCED;


-- 3. Create new table as Master table --

CREATE TABLE IF NOT EXISTS Sales_BIA.master AS (
SELECT 
  REGEXP_EXTRACT(c.CustomerEmail, r'([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})') AS Email,
  c.CustomerCity AS City,
  o.Date AS OrderDate,
  o.Quantity AS OrderQuantity,
  p.ProdName AS ProductName,
  p.Price AS ProductPrice,
  pc.CategoryName AS ProductCategoryName,
  o.Quantity*p.Price AS TotalSales
FROM
  Sales_BIA.orders AS o
LEFT JOIN Sales_BIA.customers AS c
  ON o.CustomerID = c.CustomerID
LEFT JOIN Sales_BIA.products AS p
  ON o.ProdNumber = p.ProdNumber
LEFT JOIN Sales_BIA.productcategory AS pc
  ON p.Category = pc.CategoryID
);

