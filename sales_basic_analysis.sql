-- Display the first 10 customers with their full name, email, and phone number.

SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS Customer_name,
    email,
    state
FROM
    customers
LIMIT 10;

-- List all products that have a list price greater than 500.

select *from products;

SELECT 
    product_id, product_name, ROUND(list_price, 0) list_price
FROM
    products
WHERE
    list_price > 500;
    
-- Retrieve the names of all brands in alphabetical order.

select * from brands;

SELECT 
    brand_name AS available_brand
FROM
    brands
ORDER BY brand_name;


--  Find the top 5 most expensive products based on their list_price.

select * from products;

SELECT 
    product_name AS expensive_product
FROM
    products
ORDER BY list_price DESC
LIMIT 5;

-- Show all the products that belong to the 'Mountain Bikes' category.

SELECT * FROM bikesales.categories;
SELECT 
    a.product_name
FROM
    (SELECT DISTINCT
        pro.product_name, c.category_name
    FROM
        products AS pro
    JOIN categories AS c ON pro.category_id = c.category_id) AS a
WHERE
    category_name = 'Mountain Bikes';
    
--  Get all orders placed in 2018 with order_id, customer_id, and order_date.

SELECT * FROM bikesales.orders;

SELECT 
    order_id, customer_id, order_date
FROM
    orders
WHERE
    order_date BETWEEN '2018-01-01' AND '2018-12-31';
    
-- Count how many products each brand has.

select * from products;
SELECT 
    brand_id, COUNT(product_name)
FROM
    products
GROUP BY brand_id
ORDER BY brand_id;

-- Display the unique cities where customers are located

SELECT DISTINCT
    city
FROM
    customers
ORDER BY city;

-- Show the details of customers whose first name starts with 'A'.

SELECT 
    *
FROM
    customers
WHERE
    first_name LIKE 'A%' OR 'a%';
    
--  Find the total number of orders recorded in the dataset

SELECT 
    COUNT(order_id) AS total_no_orders
FROM
    orders;


