CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(30),
    status VARCHAR(20)
);
 
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount INT
);
 
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    customer_id INT,
    payment_date DATE,
    amount INT
);
 
 
INSERT INTO customers VALUES
(1, 'Amit', 'Delhi', 'Active'),
(2, 'Bala', 'Chennai', 'Active'),
(3, 'Charan', 'Mumbai', 'Inactive'),
(4, 'Deepa', 'Delhi', 'Active'),
(5, 'Esha', 'Mumbai', 'Active');
 
INSERT INTO orders VALUES
(101, 1, '2024-01-05', 5000),
(102, 1, '2024-02-10', 7000),
(103, 2, '2024-01-15', 3000),
(104, 2, '2024-03-20', 8000),
(105, 4, '2024-02-25', 6000);
 
INSERT INTO payments VALUES
(201, 1, '2024-01-07', 5000),
(202, 1, '2024-02-12', 4000),
(203, 2, '2024-01-17', 3000),
(204, 4, '2024-03-01', 6000);

-- 1
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) t
);

-- 2
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.order_amount) >
(
    SELECT AVG(total_amt)
    FROM (
        SELECT SUM(order_amount) AS total_amt
        FROM orders
        GROUP BY customer_id
    ) x
);

-- 3
SELECT customer_id, customer_name, city
FROM customers
WHERE city IN (
    SELECT city
    FROM customers
    WHERE status = 'Inactive'
);

-- 4
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN payments p ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

-- 5
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN payments p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING IFNULL(SUM(p.amount),0) < SUM(o.order_amount);

-- 6
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN payments p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(p.payment_id) > COUNT(o.order_id);

-- 7
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) = 1;

-- 8
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_amount >
(
    SELECT MIN(o2.order_amount)
    FROM customers c2
    JOIN orders o2 ON c2.customer_id = o2.customer_id
    WHERE c2.city = c.city
      AND c2.customer_id <> c.customer_id
);

-- 9
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON c.customer_id = p.customer_id
WHERE o.order_id IS NULL;
