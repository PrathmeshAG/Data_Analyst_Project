CREATE database IF NOT EXISTS PIZZAS;
USE PIZZAS;


SELECT * FROM PIZZA_TYPES;
SELECT * FROM PIZZAS;
SELECT * FROM ORDER_DETAILS;
SELECT * FROM ORDERS;

-- Basic:
-- 1. Retrieve the total number of orders placed.
SELECT distinct COUNT(ORDER_ID) AS TOTAL_ORDERS FROM ORDERS;

-- 2. Calculate the total revenue generated from pizza sales.
SELECT concat("$  ",round(sum(OD.QUANTITY * P.PRICE),2)) AS TOTAL_REVENUE 
FROM ORDER_DETAILS OD
JOIN PIZZAS P ON OD.PIZZA_ID = P.PIZZA_ID;

-- 3. Identify the highest-priced pizza.
select p.price, pt.name from pizzas p
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
order by p.price desc
limit 1;

-- 4. Identify the most common pizza size ordered.
select p.size, sum(od.quantity) as total_orders from ORDER_DETAILS od
join pizzas p on p.pizza_id = od.pizza_id
group by p.size
order by total_orders desc;


-- 5. List the top 5 most ordered pizza types along with their quantities.
select  p.pizza_type_id , sum(o.quantity) as total_quantities from order_details o
join pizzas p on p.pizza_id = o.pizza_id
group by p.pizza_type_id
order by total_quantities desc
limit 5;


 -- Intermediate:
-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
select sum(od.quantity) as total_qunatities, pt.category from ORDER_DETAILS od
 join pizzas p on p.pizza_id = od.pizza_id
 join PIZZA_TYPES pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category ;

-- 7. Determine the distribution of orders by hour of the day.
select hour(time) as hours, count(order_id) as total_orders  from ORDERS
group by hours 
order by total_orders desc;


-- 8. Join relevant tables to find the category-wise distribution of pizzas.
select  pt.category, count(p.pizza_id) as no_pizzas  from PIZZA_TYPES pt
join pizzas p on p.pizza_type_id = pt.pizza_type_id
group by pt.category;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
with avg_pizzas_orderd as (
Select o.date, sum(od.quantity)as sum_pizzas from ORDER_DETAILS od
join orders o on od.order_id = o.order_id 
group by o.date)
select avg(sum_pizzas) as avg_per_day from avg_pizzas_orderd ;

-- 10. Determine the top 3 most ordered pizza types based on revenue.
select pt.name, sum(p.price * od.quantity ) as most_revenu   from pizzas p
join ORDER_DETAILS od on od.pizza_id = p.pizza_id
join PIZZA_TYPES pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by most_revenu desc
limit 3;

-- quntity * price = sum(value)


-- Advanced:
-- 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.name,
    SUM(p.price * od.quantity) *100 / SUM(SUM(p.price * od.quantity)) over()  AS revenue_percentage  -- mysql not support nested agreggate fun then help over() 
																									-- postgreSql supported nested agreggate fun 
FROM
    pizzas p
        JOIN
    ORDER_DETAILS od ON od.pizza_id = p.pizza_id
        JOIN
    PIZZA_TYPES pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;


-- 12. Analyze the cumulative revenue generated over time.
Select ord.date, sum(p.price *od.quantity) as daily_revenue ,
SUM(SUM(p.price *od.quantity)) OVER (ORDER BY ord.date) AS cumulative_revenue
from pizzas p
join order_details od on p.pizza_id = od.pizza_id 
join orders ord on od.order_id =ord.order_id 
group by ord.date
order by ord.date ;

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, category , most_revenu from(
select pt.name, pt.category, sum(p.price * od.quantity ) as most_revenu , rank() over(
partition by pt.category
order by sum(p.price * od.quantity )  desc
) as rnk from pizzas p
join ORDER_DETAILS od on od.pizza_id = p.pizza_id
join PIZZA_TYPES pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name, category
order by category
) t
where  rnk <= 3 ;



SELECT name, category, revenue
FROM (
    SELECT 
        pt.name,
        pt.category,
        SUM(p.price * od.quantity) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(p.price * od.quantity) DESC
        ) AS rn
    FROM pizzas p
    JOIN order_details od 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt 
        ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.name, pt.category
) t
WHERE rn <= 3
ORDER BY category, revenue DESC;

-- 14 Determine the top 5 days with the highest revenue
select o.date, round(sum(p.price * od.quantity),2) as revenue from orders o
join ORDER_DETAILS od on od.order_id = o.order_id
join PIZZAS p on od.pizza_id = p.pizza_id
group by date
order by revenue desc
limit 5 ;


-- 15 Find the busiest day of the week based on number of orders
select 
dayname(date) as days,
count(order_id) as totals_orders
from orders
group by days
order by totals_orders desc;

-- 16 Rank pizzas based on total quantity sold 
select  pt.name ,sum(od.quantity) quantity_sold ,  rank() over(
order by sum(od.quantity) desc
) as rnk from pizzas p
join ORDER_DETAILS od on od.pizza_id = p.pizza_id
join PIZZA_TYPES pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name;


-- 17 Calculate revenue growth compared to previous day
select o.date, (round(sum(p.price * od.quantity),2)) as revenue , lag((round(sum(p.price * od.quantity),2))) over(
order by o.date asc
) as previous_day from ORDERS o 
join ORDER_DETAILS od on od.order_id = o.order_id
join PIZZAS p on od.pizza_id = p.pizza_id
group by o.date;


