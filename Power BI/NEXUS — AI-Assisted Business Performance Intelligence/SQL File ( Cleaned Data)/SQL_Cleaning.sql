create Database nexus;

USE nexus;

select count(*) from customers_raw;
select count(*) from orders_raw;
select count(*) from targets_raw;
select count(*) from products_raw;

SELECT COUNT(*) AS total_rows
FROM orders_raw;

SHOW WARNINGS LIMIT 20;

-- Customers clean table
USE nexus;

DROP TABLE IF EXISTS customers_clean;

CREATE TABLE customers_clean AS
SELECT DISTINCT
    TRIM(CustomerID) AS CustomerID,
    TRIM(CustomerName) AS CustomerName,
    CASE
        WHEN Segment IS NULL OR TRIM(Segment) = '' THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(TRIM(Segment), 1)),
            LOWER(SUBSTRING(TRIM(Segment), 2))
        )
    END AS Segment,
    CASE
        WHEN Region IS NULL OR TRIM(Region) = '' THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(TRIM(Region), 1)),
            LOWER(SUBSTRING(TRIM(Region), 2))
        )
    END AS Region
FROM customers_raw
WHERE CustomerID IS NOT NULL
  AND TRIM(CustomerID) <> '';
  
  
SELECT COUNT(*) AS clean_customers
FROM customers_clean;

SELECT *
FROM customers_clean
LIMIT 10;

-- Products Cleaning
USE nexus;

DROP TABLE IF EXISTS products_clean;

CREATE TABLE products_clean AS
SELECT DISTINCT
    TRIM(ProductID) AS ProductID,
    TRIM(ProductName) AS ProductName,

    CASE
        WHEN Category IS NULL OR TRIM(Category) = ''
        THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(TRIM(Category), 1)),
            LOWER(SUBSTRING(TRIM(Category), 2))
        )
    END AS Category,

    ROUND(
        CASE
            WHEN UnitCost IS NULL OR UnitCost <= 0
            THEN 0
            ELSE UnitCost
        END, 2
    ) AS UnitCost,

    ROUND(
        CASE
            WHEN UnitPrice IS NULL OR UnitPrice <= 0
            THEN UnitCost * 1.5
            ELSE UnitPrice
        END, 2
    ) AS UnitPrice

FROM products_raw
WHERE ProductID IS NOT NULL
  AND TRIM(ProductID) <> '';
  
  SELECT COUNT(*) AS clean_products
FROM products_clean;

SELECT *
FROM products_clean
LIMIT 10; 


 -- Clean order
DESCRIBE orders_raw;


SELECT *
FROM orders_raw
LIMIT 5;

USE nexus;

DROP TABLE IF EXISTS orders_clean;

CREATE TABLE orders_clean AS
SELECT
    TRIM(o.OrderID) AS OrderID,

    STR_TO_DATE(TRIM(o.OrderDate), '%Y-%m-%d') AS OrderDate,

    TRIM(o.CustomerID) AS CustomerID,
    TRIM(o.ProductID) AS ProductID,

    -- Negative / zero quantity ko positive minimum 1
    CASE
        WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
        ELSE o.Quantity
    END AS Quantity,

    -- Missing discount = 0, maximum discount = 20%
    LEAST(
        GREATEST(COALESCE(o.DiscountPct, 0), 0),
        0.20
    ) AS DiscountPct,

    -- Missing UnitPrice ko product master se fill
    ROUND(
        COALESCE(o.UnitPrice, p.UnitPrice),
        2
    ) AS UnitPrice,

    -- Region standardization
    CASE
        WHEN o.Region IS NULL OR TRIM(o.Region) = ''
            THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(TRIM(o.Region), 1)),
            LOWER(SUBSTRING(TRIM(o.Region), 2))
        )
    END AS Region,

    -- Gross Sales
    ROUND(
        (
            CASE
                WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
                ELSE o.Quantity
            END
        ) *
        COALESCE(o.UnitPrice, p.UnitPrice),
        2
    ) AS GrossSales,

    -- Discount Amount
    ROUND(
        (
            CASE
                WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
                ELSE o.Quantity
            END
        ) *
        COALESCE(o.UnitPrice, p.UnitPrice) *
        LEAST(
            GREATEST(COALESCE(o.DiscountPct, 0), 0),
            0.20
        ),
        2
    ) AS DiscountAmount,

    -- Final Sales / Revenue
    ROUND(
        (
            CASE
                WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
                ELSE o.Quantity
            END
        ) *
        COALESCE(o.UnitPrice, p.UnitPrice) *
        (
            1 -
            LEAST(
                GREATEST(COALESCE(o.DiscountPct, 0), 0),
                0.20
            )
        ),
        2
    ) AS Sales,

    -- Cost
    ROUND(
        (
            CASE
                WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
                ELSE o.Quantity
            END
        ) * p.UnitCost,
        2
    ) AS Cost,

    -- Profit
    ROUND(
        (
            (
                CASE
                    WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
                    ELSE o.Quantity
                END
            ) *
            COALESCE(o.UnitPrice, p.UnitPrice) *
            (
                1 -
                LEAST(
                    GREATEST(COALESCE(o.DiscountPct, 0), 0),
                    0.20
                )
            )
        )
        -
        (
            CASE
                WHEN o.Quantity IS NULL OR o.Quantity <= 0 THEN 1
                ELSE o.Quantity
            END
        ) * p.UnitCost,
        2
    ) AS Profit

FROM orders_raw o
LEFT JOIN products_clean p
    ON TRIM(o.ProductID) = p.ProductID; 
    
SELECT COUNT(*) AS clean_orders
FROM orders_clean;

SELECT *
FROM orders_clean
LIMIT 10;
 -- KPI Check 
SELECT
    ROUND(SUM(Sales), 2) AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS MarginPct,
    COUNT(DISTINCT OrderID) AS Orders
FROM orders_clean;

-- Targets cleaning
USE nexus;

DROP TABLE IF EXISTS targets_clean;

CREATE TABLE targets_clean AS
SELECT
    STR_TO_DATE(TRIM(TargetDate), '%Y-%m-%d') AS TargetDate,

    CASE
        WHEN Region IS NULL OR TRIM(Region) = ''
            THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(TRIM(Region), 1)),
            LOWER(SUBSTRING(TRIM(Region), 2))
        )
    END AS Region,

    ROUND(
        COALESCE(SalesTarget, 0),
        2
    ) AS SalesTarget

FROM targets_raw
WHERE TargetDate IS NOT NULL;

SELECT *
FROM targets_clean
LIMIT 10;

SELECT USER(), CURRENT_USER();

USE nexus;

SELECT ProductID, ProductName, Category
FROM products_clean
LIMIT 20;


USE nexus;

SET SQL_SAFE_UPDATES = 0;

UPDATE products_clean
SET ProductName =
CASE Category

    WHEN 'Electronics' THEN
        CASE MOD(CAST(SUBSTRING(ProductID, 5) AS UNSIGNED), 10)
            WHEN 0 THEN CONCAT('Laptop Pro ', SUBSTRING(ProductID, 5))
            WHEN 1 THEN CONCAT('Smartphone ', SUBSTRING(ProductID, 5))
            WHEN 2 THEN CONCAT('LED Monitor ', SUBSTRING(ProductID, 5))
            WHEN 3 THEN CONCAT('Bluetooth Speaker ', SUBSTRING(ProductID, 5))
            WHEN 4 THEN CONCAT('Wireless Keyboard ', SUBSTRING(ProductID, 5))
            WHEN 5 THEN CONCAT('Wireless Mouse ', SUBSTRING(ProductID, 5))
            WHEN 6 THEN CONCAT('Headphones ', SUBSTRING(ProductID, 5))
            WHEN 7 THEN CONCAT('Webcam ', SUBSTRING(ProductID, 5))
            WHEN 8 THEN CONCAT('Tablet ', SUBSTRING(ProductID, 5))
            ELSE CONCAT('Gaming Monitor ', SUBSTRING(ProductID, 5))
        END

    WHEN 'Furniture' THEN
        CASE MOD(CAST(SUBSTRING(ProductID, 5) AS UNSIGNED), 8)
            WHEN 0 THEN CONCAT('Office Chair ', SUBSTRING(ProductID, 5))
            WHEN 1 THEN CONCAT('Executive Desk ', SUBSTRING(ProductID, 5))
            WHEN 2 THEN CONCAT('Office Cabinet ', SUBSTRING(ProductID, 5))
            WHEN 3 THEN CONCAT('Bookshelf ', SUBSTRING(ProductID, 5))
            WHEN 4 THEN CONCAT('Conference Table ', SUBSTRING(ProductID, 5))
            WHEN 5 THEN CONCAT('Computer Desk ', SUBSTRING(ProductID, 5))
            WHEN 6 THEN CONCAT('Storage Cabinet ', SUBSTRING(ProductID, 5))
            ELSE CONCAT('Reception Desk ', SUBSTRING(ProductID, 5))
        END

    WHEN 'Accessories' THEN
        CASE MOD(CAST(SUBSTRING(ProductID, 5) AS UNSIGNED), 8)
            WHEN 0 THEN CONCAT('Laptop Bag ', SUBSTRING(ProductID, 5))
            WHEN 1 THEN CONCAT('USB Hub ', SUBSTRING(ProductID, 5))
            WHEN 2 THEN CONCAT('Mouse Pad ', SUBSTRING(ProductID, 5))
            WHEN 3 THEN CONCAT('Laptop Stand ', SUBSTRING(ProductID, 5))
            WHEN 4 THEN CONCAT('Phone Case ', SUBSTRING(ProductID, 5))
            WHEN 5 THEN CONCAT('Power Bank ', SUBSTRING(ProductID, 5))
            WHEN 6 THEN CONCAT('HDMI Cable ', SUBSTRING(ProductID, 5))
            ELSE CONCAT('USB Cable ', SUBSTRING(ProductID, 5))
        END

    WHEN 'Office supplies' THEN
        CASE MOD(CAST(SUBSTRING(ProductID, 5) AS UNSIGNED), 8)
            WHEN 0 THEN CONCAT('Notebook Pack ', SUBSTRING(ProductID, 5))
            WHEN 1 THEN CONCAT('Printer Paper ', SUBSTRING(ProductID, 5))
            WHEN 2 THEN CONCAT('Premium Pen Set ', SUBSTRING(ProductID, 5))
            WHEN 3 THEN CONCAT('Stapler Kit ', SUBSTRING(ProductID, 5))
            WHEN 4 THEN CONCAT('File Folder Set ', SUBSTRING(ProductID, 5))
            WHEN 5 THEN CONCAT('Desk Organizer ', SUBSTRING(ProductID, 5))
            WHEN 6 THEN CONCAT('Marker Set ', SUBSTRING(ProductID, 5))
            ELSE CONCAT('Sticky Notes Pack ', SUBSTRING(ProductID, 5))
        END

    WHEN 'Software' THEN
        CASE MOD(CAST(SUBSTRING(ProductID, 5) AS UNSIGNED), 6)
            WHEN 0 THEN CONCAT('Business Suite ', SUBSTRING(ProductID, 5))
            WHEN 1 THEN CONCAT('Cloud Storage Plan ', SUBSTRING(ProductID, 5))
            WHEN 2 THEN CONCAT('Security License ', SUBSTRING(ProductID, 5))
            WHEN 3 THEN CONCAT('Analytics Pro License ', SUBSTRING(ProductID, 5))
            WHEN 4 THEN CONCAT('Project Management Suite ', SUBSTRING(ProductID, 5))
            ELSE CONCAT('Productivity Suite ', SUBSTRING(ProductID, 5))
        END

    ELSE CONCAT('Business Product ', SUBSTRING(ProductID, 5))

END;



