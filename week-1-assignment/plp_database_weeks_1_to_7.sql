-- ============================================================================
-- PLP Academy - Database Systems (Weeks 1 to 7) Complete SQL Solutions
-- Author: Chan Miabek Jak
-- ============================================================================

-- ============================================================================
-- WEEK 1: Introduction to SQL
-- Assignment: Database Creation and Deletion
-- ============================================================================

-- Question 1: Create a new database called salesDB
CREATE DATABASE IF NOT EXISTS salesDB;

-- Question 2: Drop (delete) the database called demo
DROP DATABASE IF EXISTS demo;


-- ============================================================================
-- WEEK 2: Data Retrieval & Filtering with SQL
-- Assignment: SELECT, WHERE, ORDER BY, and LIMIT Queries
-- ============================================================================

-- Question 1: Retrieve checkNumber, paymentDate, and amount from payments
SELECT checkNumber, paymentDate, amount
FROM payments;

-- Question 2: Retrieve orderDate, requiredDate, and status for 'In Process' orders
-- Sorted in descending order of orderDate
SELECT orderDate, requiredDate, status
FROM orders
WHERE status = 'In Process'
ORDER BY orderDate DESC;

-- Question 3: Display firstName, lastName, and email of 'Sales Rep' employees
-- Ordered in descending order of employeeNumber
SELECT firstName, lastName, email
FROM employees
WHERE jobTitle = 'Sales Rep'
ORDER BY employeeNumber DESC;

-- Question 4: Retrieve all columns and records from the offices table
SELECT *
FROM offices;

-- Question 5: Fetch productName and quantityInStock from products
-- Sorted in ascending order of buyPrice, limited to 5 records
SELECT productName, quantityInStock
FROM products
ORDER BY buyPrice ASC
LIMIT 5;


-- ============================================================================
-- WEEK 3: Grouping and Summarizing Data (or Data Manipulation & Table Creation)
-- ============================================================================

-- Question 1: Create the student table
CREATE TABLE IF NOT EXISTS student (
    id INT PRIMARY KEY,
    fullName VARCHAR(100),
    age INT
);

-- Question 2: Insert at least 3 records into the student table
INSERT INTO student (id, fullName, age) VALUES
    (1, 'Alice Johnson', 19),
    (2, 'Brian Smith', 18),
    (3, 'Clara Davis', 21);

-- Question 3: Update the age of the student with ID 2 to 20
UPDATE student
SET age = 20
WHERE id = 2;


-- ============================================================================
-- WEEK 4: Data Manipulation / Grouping & Summarizing Data
-- ============================================================================

-- Question 1: Total payment amount for each payment date (top 5 latest dates)
SELECT
    paymentDate,
    SUM(amount) AS totalAmount
FROM payments
GROUP BY paymentDate
ORDER BY paymentDate DESC
LIMIT 5;

-- Question 2: Average credit limit of each customer grouped by customerName and country
SELECT
    customerName,
    country,
    AVG(creditLimit) AS averageCreditLimit
FROM customers
GROUP BY customerName, country;

-- Question 3: Total price of products ordered from orderdetails
SELECT
    productCode,
    quantityOrdered,
    SUM(quantityOrdered * priceEach) AS totalPrice
FROM orderdetails
GROUP BY productCode, quantityOrdered;

-- Question 4: Highest payment amount for each check number
SELECT
    checkNumber,
    MAX(amount) AS highestAmount
FROM payments
GROUP BY checkNumber;


-- ============================================================================
-- WEEK 5: Performance & Optimization in SQL
-- Assignment: Database Indexing and User Privilege Management
-- ============================================================================

-- Question 1: Drop the index named IdxPhone from the customers table
DROP INDEX IdxPhone ON customers;

-- Question 2: Create a user named bob with password 'S$cu3r3!', restricted to localhost
CREATE USER 'bob'@'localhost' IDENTIFIED BY 'S$cu3r3!';

-- Question 3: Grant the INSERT privilege to user bob on the salesDB database
GRANT INSERT ON salesDB.* TO 'bob'@'localhost';

-- Question 4: Change the password for user bob to 'P$55!23'
ALTER USER 'bob'@'localhost' IDENTIFIED BY 'P$55!23';


-- ============================================================================
-- WEEK 6: Joins
-- Assignment: SQL Joins and Relationships
-- ============================================================================

-- Question 1: INNER JOIN – Employees and Offices
-- Retrieve firstName, lastName, email, and officeCode for all employees
SELECT
    e.firstName,
    e.lastName,
    e.email,
    e.officeCode
FROM employees AS e
INNER JOIN offices AS o
    ON e.officeCode = o.officeCode;

-- Question 2: LEFT JOIN – Products and Product Lines
-- Retrieve productName, productVendor, and productLine for all products
SELECT
    p.productName,
    p.productVendor,
    p.productLine
FROM products AS p
LEFT JOIN productlines AS pl
    ON p.productLine = pl.productLine;

-- Question 3: RIGHT JOIN – Customers and Orders
-- Retrieve orderDate, shippedDate, status, and customerNumber for the first 10 orders
SELECT
    o.orderDate,
    o.shippedDate,
    o.status,
    o.customerNumber
FROM customers AS c
RIGHT JOIN orders AS o
    ON c.customerNumber = o.customerNumber
LIMIT 10;


-- ============================================================================
-- WEEK 7: Normalization in SQL
-- Assignment: Database Design and Normalization (1NF & 2NF)
-- ============================================================================

-- Question 1: Achieving First Normal Form (1NF)
-- Transform ProductDetail (where Products holds comma-separated values)
-- into atomic single-product rows per order.

CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');


-- Question 2: Achieving Second Normal Form (2NF)
-- Partial Dependency Identified:
-- In OrderDetails(OrderID, CustomerName, Product, Quantity) with composite key (OrderID, Product),
-- CustomerName depends only on OrderID (a proper subset of the composite key), violating 2NF.
-- Solution: Decompose into Orders(OrderID, CustomerName) and OrderItems(OrderID, Product, Quantity).

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Orders (OrderID, CustomerName) VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);
