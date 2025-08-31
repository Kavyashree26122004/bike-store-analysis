-- Identify the customers who placed more than 5 orders and calculate their total spending.

SELECT 
    o.customer_id,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS total_spent
FROM
    orders o
        JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
HAVING COUNT(o.order_id) > 5;
 
 -- Determine the best-performing store based on total revenue generated.
SELECT 
    t.store_id, s.store_name, t.total_revenue
FROM
    (SELECT 
        o.store_id,
            ROUND(SUM(oi.quantity * oi.list_price), 2) AS total_revenue
    FROM
        orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    GROUP BY o.store_id
    ORDER BY total_revenue DESC
    LIMIT 1) AS t
        JOIN
    stores AS s ON t.store_id = s.store_id;
    
-- Find the best-performing sales staff in each store using total revenue.

    with tab as 
    (select t2.store_id,staff_name, total_revenue , rank() over( partition by t2.store_id order by total_revenue desc) as ranks 
    from
    (select o.staff_id,o.store_id,concat(s.first_name,' ',s.last_name) as staff_name, ROUND(SUM(oi.quantity * oi.list_price), 2) as total_revenue 
    from orders as o 
    join order_items as oi on o.order_id = oi.order_id 
    join staffs as s on o.staff_id = s.staff_id
    group by o.staff_id,o.store_id order by total_revenue desc  ) as t2)
 
SELECT 
    store_id, staff_name, total_revenue FROM tab WHERE ranks = '1';
    
-- Generate a report showing year-over-year sales growth for the last 3 years.

select distinct year(t.order_date) as year, round(sum(t.total_revenue) over( partition by year(t.order_date)),2) as year_over_year_sales from 
(select o.order_date, ROUND(SUM(oi.quantity * oi.list_price), 2) as total_revenue from orders as o join order_items as oi 
on oi.order_id=o.order_id group by o.order_date) as t;

-- Use a window function to rank products based on total revenue and display the top n products using stored procedures.

create procedure top_n_products(in n int)
select t.product_name,t.total_revenue, rank() over(order by t.total_revenue desc) as rank_no from
(select p.product_name, round(sum(oi.list_price*oi.quantity),2) as total_revenue from order_items as oi join products as p 
on p.product_id=oi.product_id group by oi.product_id) as t
limit n;

call top_n_products(10);
call top_n_products(5);

-- Identify the customers who haven’t purchased anything in the last 12 months.

SELECT DISTINCT
    c.customer_id, c.first_name, c.last_name
FROM
    customers c
        LEFT JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_id IS NULL
        OR o.order_date < DATE_SUB(CURDATE(), INTERVAL 8 YEAR);

-- Find the average order value (AOV) for each customer and rank them from highest to lowest.

select t.customer_id , t.average_order_value, dense_rank() over ( order by t.average_order_value desc) as ranks from
(select o.customer_id , round(avg(oi.list_price*oi.quantity),2) as average_order_value from orders as o
join order_items as oi on o.order_id=oi.order_id group by o.customer_id) as t;

-- Calculate the cumulative revenue month by month using a window function.

SELECT distinct DATE_FORMAT(order_date,'%Y-%m') AS month, SUM(oi.quantity *
 oi.list_price) OVER (ORDER BY DATE_FORMAT(order_date,'%Y-%m')) AS
 cumulative_revenue FROM orders o JOIN order_items oi ON
 o.order_id=oi.order_id;
 
-- Generate a customer lifetime value (CLV) report showing total orders, total quantity,total spend
-- and average order value using views

create view CustomerLifetimeValue as 
SELECT 
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_quantity,
    ROUND(SUM(oi.quantity * oi.list_price), 2) AS total_spend,
    ROUND(AVG(oi.quantity * oi.list_price), 2) AS avg_order_value
FROM
    orders o
        JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;


 
