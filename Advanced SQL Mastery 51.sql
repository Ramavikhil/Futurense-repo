use classicmodels;

-- Part-1
-- Task 1.1
SELECT productName, productLine
FROM products
WHERE
    productLine LIKE 'Classic%Cars';

-- Task 1.2
SELECT customerName, addressLine1
FROM customers
WHERE
    addressLine1 LIKE "%Street%"
    OR addressLine1 LIKE "%Avenue%";

-- Part-2
-- Task 2.1
SELECT orderDetails.orderNumber, SUM(priceEach * quantityOrdered) AS totalAmount
FROM orderDetails, orders
WHERE
    orderDetails.orderNumber = orders.orderNumber
GROUP BY
    orderDetails.orderNumber
HAVING
    totalAmount BETWEEN 1000 AND 10000;

-- Task 2.2
SELECT *
FROM payments
WHERE
    paymentDate BETWEEN '2004-01-01' AND '2004-03-31';

-- Part-3
-- Task 3.1
SELECT orderNumber, SUM(quantityOrdered * priceEach) AS orderTotal
FROM orderdetails
GROUP BY
    orderNumber
HAVING
    SUM(quantityOrdered * priceEach) > ANY (
        SELECT AVG(orderTotal)
        FROM (
                SELECT orderNumber, SUM(quantityOrdered * priceEach) AS orderTotal
                FROM orderdetails
                GROUP BY
                    orderNumber
            ) AS average_sales
    );

--  Task 3.2
SELECT *
FROM products
WHERE
    quantityInStock = ALL (
        SELECT MAX(quantityInStock)
        FROM products
    );

-- Task 4.1
-- SELECT customerName, country, (
--     SELECT SUM(amount)
--     FROM payments p
--     WHERE c.customerNumber = p.customerNumber
--     GROUP BY p.customerNumber
--     HAVING SUM(amount) > ANY (
--         SELECT 0.9 * MAX(amount)
--         FROM payments
--     )
-- ) AS paymentAmount
-- FROM customers c
-- WHERE country LIKE 'USA%' OR country LIKE 'Canada%'
--   AND paymentAmount IS NOT NULL;

WITH
    CustomerPayments AS (
        SELECT
            customerName, country, (
                SELECT SUM(amount)
                FROM payments p
                WHERE
                    c.customerNumber = p.customerNumber
                GROUP BY
                    p.customerNumber
                HAVING
                    SUM(amount) > ANY (
                        SELECT 0.9 * MAX(amount)
                        FROM payments
                    )
            ) AS paymentAmount
        FROM customers c
        WHERE
            country LIKE 'USA%'
            OR country LIKE 'Canada%'
    )
SELECT
    customerName,
    country,
    paymentAmount
FROM CustomerPayments
WHERE
    paymentAmount IS NOT NULL;

-- Task 4.2
SELECT
    p.productCode,
    p.productName,
    AVG(od.quantityOrdered) AS annualAverage,
    AVG(CASE
        WHEN o.orderDate BETWEEN 'start_date_of_season' AND 'end_date_of_season' THEN od.quantityOrdered
        ELSE NULL
    END) AS seasonalAverage
FROM
    products p
JOIN
    orderdetails od ON p.productCode = od.productCode
JOIN
    orders o ON od.orderNumber = o.orderNumber
GROUP BY
    p.productCode, p.productName;




