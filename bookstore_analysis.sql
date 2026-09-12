-- ============================================================
-- Bookstore SQL Analysis
-- Database: PostgreSQL
-- Description: Bookstore sales, customer and inventory analysis
-- ============================================================

CREATE TABLE Books(
        Book_ID	INT	PRIMARY KEY,
		Title VARCHAR(100),
		Author VARCHAR(100),
		Genre VARCHAR(25),
		Published_Year INT,
		Price NUMERIC(5,2),
		Stock INT
);
DROP TABLE Customers;
CREATE TABLE Customers(
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'data/Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'data/Customers.csv' 
CSV HEADER;

--Import Data into Orders table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_date, Quantity, Total_Amount)
FROM 'data/Orders.csv'
CSV HEADER;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) as total_stock_of_books FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books ORDER BY price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT c.customer_id,c.name,o.order_id,o.quantity
FROM Customers c
JOIN
Orders o
ON 
c.customer_id=o.customer_id
WHERE o.quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT(genre) FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books ORDER BY stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) as Total_Revenue_generated FROM Orders;

--ADVANCED QUERIES

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre,SUM(quantity) as total_books_sold
FROM Books b 
JOIN
Orders o
ON 
b.book_ID=o.book_ID
GROUP BY b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT genre, AVG(price) AS average_price 
FROM Books
WHERE genre='Fantasy'
GROUP BY genre;


-- 3) List customers who have placed at least 2 orders:
SELECT c.name,COUNT(o.order_ID) AS Totl_number_of_orders
FROM Customers c
JOIN
Orders o
ON 
c.customer_ID=o.customer_ID
GROUP BY c.name
HAVING COUNT(o.order_ID)>=2;


-- 4) Find the most frequently ordered book:
SELECT b.title,b.book_ID,COUNT(o.order_ID) AS total_orders
FROM Books b
JOIN
Orders o
ON 
b.book_ID=o.book_ID 
GROUP BY b.title,b.book_ID
ORDER BY COUNT(o.order_ID) DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT  3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author,SUM(o.quantity) AS Total_books_sold
FROM Books b
JOIN
Orders o
ON 
b.book_ID=o.book_ID
GROUP BY b.author
ORDER BY Total_books_sold DESC;

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT(c.city), o.total_amount
FROM Customers c
JOIN
Orders o
ON 
c.customer_id=o.customer_id
WHERE total_amount>30;

-- 8) Find the customer who spent the most on orders:
SELECT c.name,SUM(total_amount) AS total_spent
FROM Customers c
JOIN
Orders o
ON 
c.customer_id=o.customer_id
GROUP BY c.name
ORDER BY total_spent desc
LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.title, b.stock, COALESCE(SUM(o.quantity),0) AS ordered_stock,
b.stock- COALESCE(SUM(o.quantity),0) AS stock_left
FROM Books b
LEFT JOIN
Orders o
ON
b.book_id=o.book_id
GROUP BY b.title,b.stock;









