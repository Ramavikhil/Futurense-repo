USE classicmodels;

-- Part 1
-- Task 1
SELECT
    p.productLine,
    COUNT(od.productCode) AS totalProductsSold,
    SUM(od.quantityOrdered * od.priceEach) AS totalSalesAmount
FROM
    products p, orderdetails od
WHERE
    p.productCode = od.productCode
GROUP BY
    p.productLine;

-- Task 2
SELECT
    o.city AS officeCity,
    COUNT(DISTINCT ord.orderNumber) AS numberOfOrdersProcessed,
    SUM(odr.quantityOrdered * odr.priceEach) AS totalSalesAmount
FROM
    offices o
JOIN
    employees e ON o.officeCode = e.officeCode
JOIN
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN
    orders ord ON c.customerNumber = ord.customerNumber
JOIN
    orderdetails odr ON ord.orderNumber = odr.orderNumber
GROUP BY
    o.city;

-- Part 2
-- Task 1
SELECT
    o.city AS officeCity,
    AVG(odr.quantityOrdered * odr.priceEach) AS averageOrderValue,
    COUNT(DISTINCT ord.orderNumber) AS totalOrders
FROM
    offices o
JOIN
    employees e ON o.officeCode = e.officeCode
JOIN
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN
    orders ord ON c.customerNumber = ord.customerNumber
JOIN
    orderdetails odr ON ord.orderNumber = odr.orderNumber
GROUP BY
    o.city
HAVING
    averageOrderValue > 100;
    
-- Task 2
SELECT
    p.productLine,
    AVG(p.buyPrice) AS averageProductSalePrice
FROM
    products p
GROUP BY
    p.productLine
HAVING
    averageProductSalePrice > 40; 

-- Part 3
-- Task 1
use world;

SELECT
    Continent,
    AVG(Population) AS AveragePopulation,
    SUM(GNP) AS TotalGDP
FROM
    country
GROUP BY
    Continent
HAVING
    AveragePopulation >= 5000000;

-- Task 2
SELECT
    c.Name AS CountryName,
    COUNT(cl.Language) AS NumberOfLanguages,
    SUM(c.Population) AS TotalPopulation
FROM
    country c
JOIN
    countrylanguage cl ON c.Code = cl.CountryCode
GROUP BY
    c.Code, c.Name
HAVING
    NumberOfLanguages > 4;
    
-- Part-4
-- Task 1
use classicmodels;
 
WITH MonthlySales AS (
    SELECT
        DATE_FORMAT(o.orderDate, '%Y-%m') AS month,
        p.productLine,
        SUM(od.quantityOrdered * od.priceEach) AS monthlySales
    FROM
        orders o
    JOIN
        orderdetails od ON o.orderNumber = od.orderNumber
    JOIN
        products p ON od.productCode = p.productCode
    GROUP BY
        month, p.productLine
)
SELECT
    month,
    productLine,
    monthlySales,
    (monthlySales / LAG(monthlySales) OVER (PARTITION BY productLine ORDER BY month) - 1) * 100 AS salesGrowth
FROM
    MonthlySales;

-- Task 2
WITH QuarterlySales AS (
    SELECT
        e.officeCode,
        CONCAT(YEAR(o.orderDate), 'Q', QUARTER(o.orderDate)) AS quarter,
        SUM(od.quantityOrdered * od.priceEach) AS quarterlySales
    FROM
        orders o
    JOIN
        orderdetails od ON o.orderNumber = od.orderNumber
    JOIN
        customers c ON o.customerNumber = c.customerNumber
    JOIN
        employees e ON c.salesRepEmployeeNumber = e.employeeNumber
    GROUP BY
        e.officeCode, quarter
)
SELECT
    qs.officeCode,
    qs.quarter,
    qs.quarterlySales,
    (qs.quarterlySales / AVG(qs.quarterlySales) OVER (PARTITION BY qs.officeCode)) * 100 AS salesPercentage
FROM
    QuarterlySales qs;
