DROP TABLE IF EXISTS BOOKS;

CREATE TABLE BOOKS (
	BOOK_ID SERIAL PRIMARY KEY,
	TITLE VARCHAR(100),
	AUTHOR VARCHAR(100),
	GENRE VARCHAR(100),
	PUBLISHED_YEAR INT,
	PRICE NUMERIC(10, 2),
	STOCK INT
);

DROP TABLE IF EXISTS customers;

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID SERIAL PRIMARY KEY,
	NAME VARCHAR(100),
	EMAIL VARCHAR(100),
	PHONE VARCHAR(100),
	CITY VARCHAR(100),
	COUNTRY VARCHAR(100)
);

DROP TABLE IF EXISTS orders;

CREATE TABLE ORDERS (
	ORDER_ID SERIAL PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID INT REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);


SELECT * FROM BOOKS;

SELECT * FROM CUSTOMERS;

SELECT * FROM ORDERS;

-- ============================================================
--						Basic Queries
-- ============================================================

-- ============================================================
--Q1. Retrieve all books in the "Fiction" genre
-- ============================================================ 

SELECT * FROM BOOKS 
WHERE genre = 'Fiction';

-- ============================================================
--Q2. Find books published after the year 1950
-- ============================================================

SELECT * FROM BOOKS  
WHERE published_year > 1950;

-- ============================================================
--Q3. List all customers from the Canada
-- ============================================================

SELECT  * FROM CUSTOMERS
WHERE country = 'Canada'; 

-- ============================================================
--Q4.Show orders placed in November 2023
-- ============================================================

SELECT * FROM ORDERS 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- ============================================================
--Q5.Retrieve the total stock of books available
-- ============================================================

SELECT  SUM (stock) AS total_stock
FROM BOOKS;

-- ============================================================
--Q6. Find the details of the most expensive book
-- ============================================================

SELECT * FROM BOOKS
ORDER BY price DESC 
LIMIT 1;

-- ============================================================
--Q7. Show all customers who ordered more than 1 quantity of a 
--	  book
-- ============================================================	

SELECT DISTINCT customer_id FROM ORDERS
WHERE quantity  > 1;

-- ============================================================
--Q8. Retrieve all orders where the total amount exceeds $20
-- ============================================================

SELECT * FROM ORDERS
WHERE total_amount > 20;

-- ============================================================
--Q9. List all genres available in the Books table
-- ============================================================

SELECT DISTINCT genre  
FROM BOOKS;

-- ============================================================
--Q10. Find the book with the lowest stock
-- ============================================================

SELECT * FROM BOOKS
ORDER BY stock   
LIMIT 1;

-- ============================================================
--Q11. Calculate the total revenue generated from all orders
-- ============================================================

SELECT SUM (total_amount) AS total_revenue
FROM ORDERS;

-- ============================================================
--						Advance Queries
-- ============================================================

-- ============================================================
--Q1. Retrieve the total number of books sold for each genre
-- ============================================================

 SELECT b.genre, SUM(o.quantity) AS total_books_sold
 FROM BOOKS b
 JOIN ORDERS o
 ON b.book_id = o.book_id
 GROUP BY genre;

-- ============================================================
--Q2. Find the average price of books in the "Fantasy" genre
-- ============================================================

 SELECT AVG(price) AS Average_price
 FROM BOOKS
 WHERE genre = 'Fantasy';
 
-- ============================================================
--Q3.List customers who have placed at least 2 orders
-- ============================================================

SELECT customer_id 
FROM ORDERS
GROUP  BY customer_id
HAVING COUNT(order_id) >= 2;

-- ============================================================
--Q4.Find the most frequently ordered book
-- ============================================================

SELECT book_id, SUM(quantity) AS total_sold
FROM ORDERS
GROUP BY book_id
ORDER BY total_sold DESC
LIMIT 1;

-- ============================================================
--Q5.Show the top 3 most expensive books of 'Fantasy' Genre
-- ============================================================

SELECT * FROM BOOKS
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- ============================================================
--Q6.Retrieve the total quantity of books sold by each author
-- ============================================================

SELECT author, SUM(o.quantity)
FROM BOOKS b
JOIN ORDERS o
ON b.book_id = o.book_id
GROUP BY author;

-- ============================================================
--Q7.List the cities where customers who spent over $30 are located
-- ============================================================

SELECT DISTINCT c.city 
FROM CUSTOMERS c
JOIN ORDERS o
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

-- ============================================================
--Q8.Find the customer who spent the most on orders
-- ============================================================

SELECT customer_id, SUM(total_amount) AS total_spent
FROM ORDERS 
GROUP BY customer_id
ORDER BY  total_spent DESC 
LIMIT 1;


-- ============================================================
--Q9.Calculate the stock remaining after fulfilling all orders
-- ============================================================

SELECT   b.book_id,   b.title,   b.stock,  
    COALESCE(SUM(o.quantity), 0) AS order_quantity, 
    b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_quantity 
FROM Books b 
LEFT JOIN ORDERS o ON b.book_id = o.book_id 
GROUP BY b.book_id, b.title, b.stock;


