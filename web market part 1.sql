-- Part 1
-- Define table alias if necessary (optional)
-- campaign_identifier  as 	e
-- event_identifier 	as 	d
-- events 				as 	c
-- page_hierarchy 		as 	d
-- users				as 	a

--------------------------------
use webmarketk3;
#1 How many users are there?
select 
	count(distinct(user_id)) as total_user
from users;

#2 How many cookies does each user have on average?
select 
	user_id, 
    count(cookie_id) as cookie_count
from users
group by user_id;
select 
	avg(cookie_count) as avg_cookie
from (select user_id, count(cookie_id) as cookie_count
from users
group by user_id) as cookie_count_table;

#3 at is the unique number of visits by all users per month?
select 
	date_format(start_date, '%Y-%m') Month_name,
	count(distinct(user_id)) as total_user_visit
from users 
group by month_name
order by month_name;

#4 What is the number of events for each event type?
SELECT 
	event_type , 
    COUNT(*) AS event_count
FROM events
GROUP BY event_type
ORDER BY event_count DESC;

#5 What is the percentage of visits which have a purchase event?
select 
	ei.event_name, 
	round(count(e.visit_id)/(select count(visit_id) 
	from events) * 100, 2) as visit_percentage
from events e
join event_identifier ei
on e.event_type = ei.event_type
where ei.event_name = 'Purchase';

#6 What is the number of views and cart adds for each product category?
with views as(
	select 
		b.product_category, 
        count(c.event_type) as views_count
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Page View' and b.product_category is not null
	group by b.product_category),
cart_adds as(
	select 
		b.product_category, 
        count(c.event_type) as cart_adds_count
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart' and b.product_category is not null
	group by b.product_category)	

select 
	v.product_category, 
    v.views_count, 
    ca.cart_adds_count
from views v
join cart_adds ca
on v.product_category = ca.product_category;