-- Task 1
-- Task 1.1.1
INSERT INTO Authors (AuthorID, Name, Bio) VALUES
(1, 'Jonny Bhaya', 'Bestselling author with numerous awards.'),
(2, 'Dani Didi', 'Renowned novelist and short story writer.'),
(3, 'Mia Novelist', 'Up-and-coming author exploring various genres.'),
(4, 'Sunny Bhabhi', 'Experienced writer with a passion for storytelling.'),
(5, 'Eva Storyteller', 'Passionate about creating engaging narratives.'),
(6, 'Elsa Imagination', 'Dedicated to exploring new realms of storytelling.');

Select * from Authors;

INSERT INTO atheneum (BookID, Title, AuthorID, Price, PublicationDate, Genre) VALUES
(101, 'The Dark Fantasy Book', 1, 20.99, '2023-01-15', 'Fiction'),
(102, 'Deep Novel', 2, 15.50, '2022-11-10', 'Mystery'),
(103, 'Adventure Chronicles', 3, 18.75, '2023-02-28', 'Adventure'),
(104, 'Enigma Unleashed', 4, 22.49, '2024-02-10', 'Thriller'),
(105, 'Whimsical Wonders', 5, 14.99, '2023-04-05', 'Fantasy'),
(106, 'The Silent Observer', 6, 19.95, '2024-02-20', 'Suspense');

Select * from atheneum;

-- Task 1.1.2
INSERT INTO Sales (SaleID, BookID, QuantitySold, SaleDate) VALUES
(1001, 101, 30, '2023-02-10'),
(1002, 102, 20, '2023-01-20'),
(1003, 103, 0, '2023-12-29'),
(1004, 104, 15, '2023-03-20'),
(1005, 105, 0, '2024-01-03'),
(1006, 106, 22, '2023-06-10');

Select * from Sales;

-- Task 1.2.1
CREATE TABLE NewReleases (BookID INT PRIMARY KEY, Title VARCHAR(255), AuthorID INT, Price DECIMAL(10,2), PublicationDate DATE, Genre VARCHAR(100));

INSERT INTO NewReleases (BookID, Title, AuthorID, Price, PublicationDate, Genre)
SELECT BookID, Title, AuthorID, Price, PublicationDate, Genre
FROM atheneum
WHERE BookID = 106 AND DATEDIFF(CURDATE(), PublicationDate) <= 30;

INSERT INTO NewReleases (BookID, Title, AuthorID, Price, PublicationDate, Genre)
SELECT BookID, Title, AuthorID, Price, PublicationDate, Genre
FROM atheneum
WHERE BookID = 104 AND DATEDIFF(CURDATE(), PublicationDate) <= 30;

Select * from NewReleases;

-- Task 2
-- Task 2.1.1
UPDATE atheneum
SET Price = Price * 1.1
WHERE BookID IN (
    SELECT BookID
    FROM (
        SELECT BookID
        FROM Sales
        WHERE QuantitySold > 50 AND DATEDIFF(CURDATE(), SaleDate) <= 30
    ) AS HighDemandBooks
) AND BookID IS NOT NULL; 

-- Task 2.1.2
UPDATE atheneum
SET Price = Price * 0.95
WHERE BookID IN (
    SELECT BookID
    FROM (
        SELECT a.BookID
        FROM atheneum a
        LEFT JOIN Sales s ON a.BookID = s.BookID
        WHERE s.BookID IS NULL OR DATEDIFF(CURDATE(), s.SaleDate) > 90
    ) AS LowDemandBooks
) AND BookID IS NOT NULL; 

SET SQL_SAFE_UPDATES = 0;

-- Task 3
-- 3.1.1
ALTER TABLE atheneum
ADD COLUMN StockQuantity INT DEFAULT 0;

UPDATE atheneum a
JOIN (
    SELECT BookID, SUM(QuantitySold) AS TotalSold
    FROM Sales
    GROUP BY BookID
) s ON a.BookID = s.BookID
SET a.StockQuantity = a.StockQuantity - s.TotalSold;

-- 3.2.1
DELETE FROM Sales
WHERE DATEDIFF(CURDATE(), SaleDate) > 365;

-- 3.2.2
TRUNCATE TABLE Sales;


