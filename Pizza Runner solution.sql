-- 1. How many pizzas were ordered?
select
	count(pizza_id) as pizzas_ordered
from
	pizza_runner.customer_orders;
    
-- 2. How many unique customer orders were made?

select
	customer_id,
	count(distinct order_id) as pizzas_ordered
from
	pizza_runner.customer_orders
group by
	1;

-- 3. How many successful orders were delivered by each runner?

select
	runner_id,
	count(order_id) as delivered_order
from
	pizza_runner.runner_orders
where
	pickup_time != 'null'
	and distance != 'null'
    and duration != 'null'
group by
	1
order by
	1;
    
-- 4. How many of each type of pizza was delivered?

select
	pn.pizza_name,
    count(pn.pizza_name) as number_of_pizzas_delivered
from
	pizza_runner.customer_orders as c
    join
    pizza_runner.pizza_names as pn on c.pizza_id=pn.pizza_id
    join
    pizza_runner.runner_orders as ro on c.order_id=ro.order_id
where
	pickup_time != 'null'
	and distance != 'null'
    and duration != 'null'
group by
	1
order by
	1;
    
-- 5. How many vegetarian and meatlovers were ordered by each customer?

select
	customer_id,
    pizza_name,
    count(pizza_name) as count_of_orders
from
	pizza_runner.customer_orders as c
    join
    pizza_runner.pizza_names as n on c.pizza_id=n.pizza_id
group by
	1,2
order by
	1;

-- 6. What was the maximum number of pizzas delivered in a single order?

with max_pizza as (
select
	c.order_id,
    c.customer_id,
    count(c.order_id) as item_ordered,
    rank() over(order by count(c.order_id) desc) as ranks
from
	pizza_runner.customer_orders as c
    join
    pizza_runner.runner_orders as r on c.order_id=r.order_id
where
	pickup_time != 'null'
	and distance != 'null'
    and duration != 'null'
group by
	1,2)

select order_id,customer_id,item_ordered from max_pizza where ranks=1;

-- 7. What was the total volume of pizzas ordered for each hour of the day?


	select
		extract(hour from order_time) as hours,
        count(extract(hour from order_time)) as pizza_volume
	from
		pizza_runner.customer_orders
	group by
		1
	order by
		1;

-- 8. How many runners signed up for each week ?

select
	concat('Week', ' ', week(registration_date)) as week_number,
    count(runner_id) as signups_per_week
from
	pizza_runner.runners
group by
	1;
    
-- 9. What was the average time in minutes it took for each runner to arrive at the pizza runner hq to pickup the order?

select
	r.runner_id,
    round(avg(timestampdiff(minute, str_to_date(c.order_time, '%Y-%m-%d %H:%i:%s'),str_to_date(r.pickup_time, '%Y-%m-%d %H:%i:%s')))) as avg_pickup_time
from
	pizza_runner.runner_orders as r
    join
    pizza_runner.customer_orders as c on c.order_id=r.order_id
where
	pickup_time != 'null'
	and distance != 'null'
    and duration != 'null'
group by
	1
order by
	1;

-- 10. What was the average distance travelled for each customer?

-- 11. What was the difference between the longest and shortest delivery time for all orders?

-- 12. What was the average speed for each runner for each delvery and do you notice any trend for these values?

