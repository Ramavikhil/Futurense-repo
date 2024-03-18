use bookstoredb;

-- Book Table
CREATE TABLE Books (BookID INT PRIMARY KEY, Title VARCHAR(255), AuthorID INT, Price DECIMAL(10,2), PublicationDate DATE, CONSTRAINT FK_AuthorID FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID));

-- Authors Table
CREATE TABLE Authors (AuthorID INT PRIMARY KEY, Name VARCHAR(255), Bio TEXT);

-- Sales Table
CREATE TABLE Sales (SaleID INT PRIMARY KEY, BookID INT, QuantitySold INT, SaleDate DATE, CONSTRAINT FK_BookID FOREIGN KEY (BookID) REFERENCES Books(BookID));

-- Adding Genre column to Books Table
ALTER TABLE Books ADD COLUMN Genre VARCHAR(100);

-- Prepare for end-of-year data reset
TRUNCATE TABLE Sales;

DROP TABLE Authors;

ALTER TABLE Books
RENAME TO atheneum;



