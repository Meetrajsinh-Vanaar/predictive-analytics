drop table if exists pizzahut;

 CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_time TIME
);

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(100),
    ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size VARCHAR(10),
    price NUMERIC(10,2),
    FOREIGN KEY (pizza_type_id)
    REFERENCES pizza_types(pizza_type_id)
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT,
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id)
    REFERENCES pizzas(pizza_id)
);

--Q1. Retrieve the total number of orders placed.:-

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

--Q2. Calculate the total revenue genrated from pizza sales.:-

 SELECT SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;

--Q3.Identify the highest-priced pizza.:-

SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

--Q4.Identify the most common pizza size ordered.:-

 SELECT pizzas.size, COUNT(order_details.order_details_id) AS order_count
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

--Q5.List the top 5 most ordered pizza types along with their quantites.

 SELECT pizza_types.name, SUM(order_details.quantity) AS total_quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;

--Q6. Join the necessary tables to find the total quantity of each pizza ordered.:-

SELECT pizza_types.name, SUM(order_details.quantity) AS total_quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name;

--Q7. Determine the  distribution of orders by hour of the day.:-

SELECT EXTRACT(HOUR FROM order_time) AS order_hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

--Q8. Join relvant tables to find the category wise distribution of pizzas.:-

SELECT category, COUNT(name) AS total_pizzas
FROM pizza_types
GROUP BY category;

--Q9. Group the orders by data and calculate the average number of pizzas ordered per day.:-

SELECT AVG(daily_quantity) AS average_pizzas_per_day
FROM (
    SELECT orders.order_date, SUM(order_details.quantity) AS daily_quantity
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS order_counts;

--Q10. Determine the top 3 most ordered pizza types based on revanue.

SELECT pizza_types.name, SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3;