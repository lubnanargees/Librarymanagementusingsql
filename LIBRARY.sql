-- Create the database
CREATE DATABASE library;

-- Use the database
USE library;

-- Create Branch table
CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(255),
    Contact_no VARCHAR(15)
);

-- Create Employee table
CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(255),
    Position VARCHAR(255),
    Salary DECIMAL(10, 2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);

-- Create Books table
CREATE TABLE Books (
    ISBN INT PRIMARY KEY,
    Book_title VARCHAR(255),
    Category VARCHAR(255),
    Rental_Price DECIMAL(10, 2),
    Status VARCHAR(3), -- 'Yes' or 'No'
    Author VARCHAR(255),
    Publisher VARCHAR(255)
);

-- Create Customer table
CREATE TABLE Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_name VARCHAR(255),
    Customer_address VARCHAR(255),
    Reg_date DATE
);

-- Create IssueStatus table
CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust INT,
    Issued_book_name VARCHAR(255),
    Issue_date DATE,
    Isbn_book INT,
    FOREIGN KEY (Issued_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);

-- Create ReturnStatus table
CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(255),
    Return_date DATE,
    Isbn_book2 INT,
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);


-- Insert into Branch
INSERT INTO Branch (Branch_no, Manager_Id, Branch_address, Contact_no)
VALUES
(1, 101, '123 Library Lane, City A', '1234567890'),
(2, 102, '456 Knowledge Road, City B', '0987654321'),
(3, 103, '789 Wisdom Street, City C', '1122334455');

-- Insert into Employee
INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no)
VALUES
(101, 'John Doe', 'Manager', 75000, 1),
(102, 'Jane Smith', 'Manager', 80000, 2),
(103, 'Emily Davis', 'Manager', 72000, 3),
(104, 'Michael Brown', 'Staff', 50000, 1),
(105, 'Sarah Wilson', 'Staff', 48000, 2),
(106, 'David Johnson', 'Staff', 51000, 3),
(107, 'Laura Martinez', 'Staff', 47000, 1);

-- Insert into Books
INSERT INTO Books (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher)
VALUES
(1001, 'History of Ancient Civilizations', 'History', 30.00, 'Yes', 'John Historian', 'Publisher A'),
(1002, 'Modern Physics', 'Science', 40.00, 'Yes', 'Albert Einstein', 'Publisher B'),
(1003, 'Introduction to Programming', 'Technology', 25.00, 'No', 'Ada Lovelace', 'Publisher C'),
(1004, 'World War II Chronicles', 'History', 35.00, 'Yes', 'Winston Churchill', 'Publisher D'),
(1005, 'The Biology Handbook', 'Science', 20.00, 'No', 'Charles Darwin', 'Publisher E');

-- Insert into Customer
INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date)
VALUES
(201, 'Alice Green', '1 Booklover Ave, City A', '2021-12-15'),
(202, 'Bob White', '2 Knowledge Blvd, City B', '2022-05-10'),
(203, 'Catherine Blue', '3 Study St, City C', '2021-11-20'),
(204, 'Daniel Black', '4 Research Rd, City A', '2023-03-12');

-- Insert into IssueStatus
INSERT INTO IssueStatus (Issue_Id, Issued_cust, Issued_book_name, Issue_date, Isbn_book)
VALUES
(301, 201, 'History of Ancient Civilizations', '2023-06-10', 1001),
(302, 202, 'Modern Physics', '2023-06-15', 1002),
(303, 203, 'World War II Chronicles', '2023-06-20', 1004);

-- Insert into ReturnStatus
INSERT INTO ReturnStatus (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2)
VALUES
(401, 201, 'History of Ancient Civilizations', '2023-06-30', 1001),
(402, 202, 'Modern Physics', '2023-07-05', 1002);


SELECT * FROM Branch;
SELECT * FROM Employee;
SELECT * FROM Books;
SELECT * FROM Customer;
SELECT * FROM IssueStatus;
SELECT * FROM ReturnStatus;

-- Retrieve book title, category, and rental price of all available books
SELECT Book_title, Category, Rental_Price
FROM Books
WHERE Status = 'Yes';

-- List employee names and salaries in descending order of salary
SELECT Emp_name, Salary
FROM Employee
ORDER BY Salary DESC;

-- Retrieve book titles and corresponding customers who issued them
SELECT b.Book_title, c.Customer_name
FROM IssueStatus i
JOIN Books b ON i.Isbn_book = b.ISBN
JOIN Customer c ON i.Issued_cust = c.Customer_Id;

-- Display total count of books in each category.
SELECT Category, COUNT(*) AS Total_Books
FROM Books
GROUP BY Category;

-- Retrieve employee names and positions with salaries above Rs. 50,000
SELECT Emp_name, Position
FROM Employee
WHERE Salary > 50000;

INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date)
VALUES (205, 'Eleanor Brown', '5 Library St, City A', '2021-10-15');


-- List customer names who registered before 2022-01-01 and have not issued books
SELECT c.Customer_name
FROM Customer c
LEFT JOIN IssueStatus i ON c.Customer_Id = i.Issued_cust
WHERE c.Reg_date < '2022-01-01' AND i.Issue_Id IS NULL;

-- Display branch numbers and the total count of employees in each branch
SELECT Branch_no, COUNT(*) AS Employee_Count
FROM Employee
GROUP BY Branch_no;

-- Display names of customers who issued books in June 2023
SELECT c.Customer_name
FROM IssueStatus i
JOIN Customer c ON i.Issued_cust = c.Customer_Id
WHERE i.Issue_date BETWEEN '2023-06-01' AND '2023-06-30';

-- Retrieve book titles containing "history"
SELECT Book_title
FROM Books
WHERE Book_title LIKE '%history%';

INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no)
VALUES
(108, 'Kevin Turner', 'Staff', 48000, 1),
(109, 'Sophia Lee', 'Staff', 47000, 1),
(110, 'James King', 'Staff', 45000, 1);

-- Retrieve branch numbers with more than 5 employees
SELECT Branch_no, COUNT(*) AS Employee_Count
FROM Employee
GROUP BY Branch_no
HAVING COUNT(*) > 5;

-- Retrieve employee names managing branches and their branch addresses
SELECT e.Emp_name, b.Branch_address
FROM Employee e
JOIN Branch b ON e.Emp_Id = b.Manager_Id;

-- Display customer names who issued books with rental price > Rs. 25
SELECT DISTINCT c.Customer_name
FROM IssueStatus i
JOIN Books b ON i.Isbn_book = b.ISBN
JOIN Customer c ON i.Issued_cust = c.Customer_Id
WHERE b.Rental_Price > 25;
