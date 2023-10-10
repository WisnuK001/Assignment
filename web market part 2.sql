-- Part 2
-- Define table alias if necessary (optional)
-- campaign_identifier  as 	e
-- event_identifier 	as 	d
-- events 				as 	c
-- page_hierarchy 		as 	d
-- users				as 	a

--------------------------------
use webmarketk3;
-- table for product viewed
select 
	b.page_name as product_name, 
	count(b.page_name) as views_count
from page_hierarchy b
join events c
on b.page_id = c.page_id
join event_identifier as d
on c.event_type = d.event_type
where d.event_name='Page View' and b.product_category is not null
group by b.page_name
order by views_count desc;

-- table for product added to cart?
select 
	b.page_name as product_name, 
	count(b.page_name) as cart_adds_count
from page_hierarchy b
join events c
on b.page_id = c.page_id
join event_identifier as d
on c.event_type = d.event_type
where d.event_name='Add to Cart' and b.product_category is not null
group by b.page_name
order by cart_adds_count desc;

-- table for abandoned product?
with cart_adds as (
	select 
		c.visit_id,
        b.page_name as product_name
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'),
purchases as (
	select c.visit_id
	from events c
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Purchase')
select 
	ca.product_name,
    count(ca.product_name) as total_abandoned
from cart_adds ca
left join purchases p
on ca.visit_id = p.visit_id
where p.visit_id is null
group by ca.product_name
order by total_abandoned desc;

-- table for each product purchased?
with cart_adds as (
	select 
		c.visit_id,
        c.event_time,
        b.product_id, 
        b.page_name as product_name
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'),
purchases as (
	select 
		c.visit_id
	from events c
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Purchase')
select 
	ca.product_name,
    count(ca.product_name) as total_purchased
from cart_adds ca
join purchases p
on ca.visit_id = p.visit_id
group by ca.product_name
order by total_purchased desc;
    
-- ----------------------

-- 1. Which product had the most views, cart adds and purchases?
with views as(
	select b.page_name as product_name, 
		   count(b.page_name) as total_views
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Page View' 
    and b.product_category is not null
    group by product_name),
cart_adds as (
	select  
		c.visit_id,
		b.page_name as product_name,
		count(b.page_name) over (partition by b.page_name) as total_cart_adds
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'),
purchases as (
	select c.visit_id
	from events c
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Purchase')
select 
	v.product_name, 
	v.total_views, 
    dense_rank() over (order by v.total_views desc) as view_rank,
    ca.total_cart_adds,
    dense_rank() over (order by ca.total_cart_adds desc) as cart_adds_rank,
	count(ca.product_name) as total_purchases,
    dense_rank() over (order by count(ca.product_name) desc) as purchase_rank
from views v
join cart_adds ca
on v.product_name = ca.product_name
join purchases p
on ca.visit_id = p.visit_id
group by ca.product_name
order by product_name;

-- 2. Which product was most likely to be abandoned?
with cart_adds as (
	select 
		c.visit_id,
        b.page_name as product_name
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'),
purchases as (
	select 
		c.visit_id
	from events c
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Purchase')
select 
	ca.product_name, 
	count(ca.product_name) as total_abandoned,
    dense_rank () over (order by count(ca.product_name) desc) as ranking
from cart_adds ca
left join purchases p
on ca.visit_id = p.visit_id
where p.visit_id is null
group by ca.product_name;

-- 3. Which product had the highest view to purchase percentage?
with views as(
	select 
		b.page_name as product_name, 
		count(b.page_name) as total_views
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Page View' 
    and b.product_category is not null
    group by product_name),
cart_adds as (
	select  
		c.visit_id,
        b.page_name as product_name,
		count(b.page_name) over (partition by b.page_name) as total_cart_adds
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'),
purchases as (
	select 
		c.visit_id
	from events c
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Purchase')
select 
	ca.product_name, 
	v.total_views, 
	count(ca.product_name) as total_purchases,
    round(count(ca.product_name)/v.total_views * 100, 2) as convertion_rate,
    dense_rank() over (order by count(ca.product_name)/v.total_views desc) as convertion_rank
from views v
join cart_adds ca
on v.product_name = ca.product_name
join purchases p
on ca.visit_id = p.visit_id
group by ca.product_name;

-- 4. What is the average conversion rate from view to cart add?
with views as(
	select 
		b.page_name as product_name, 
		count(b.page_name) as total_views
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Page View' and b.product_category is not null
    group by product_name),
cart_adds as (
	select
        b.page_name as product_name,
		count(b.page_name) as total_cart_adds
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'
	group by product_name)
select 
	v.product_name, 
    v.total_views,
    ca.total_cart_adds,
    round(ca.total_cart_adds/v.total_views * 100, 2) as convertion_rate,
    dense_rank() over (order by ca.total_cart_adds/v.total_views desc) as convertion_rank,
    round(avg(ca.total_cart_adds/v.total_views * 100) over(), 2) as avg_convertion_rate
from views v
join cart_adds ca
on v.product_name = ca.product_name;

-- 5. What is the average conversion rate from cart add to purchase?
with cart_adds as (
	select  c.visit_id,
        b.page_name as product_name,
		count(b.page_name) over (partition by b.page_name) as total_cart_adds
	from page_hierarchy b
	join events c
	on b.page_id = c.page_id
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Add to Cart'),
purchases as (
	select c.visit_id
	from events c
	join event_identifier as d
	on c.event_type = d.event_type
	where d.event_name='Purchase'),

cart_purchases as(
	select ca.product_name,
		ca.total_cart_adds,
		count(ca.product_name) as total_purchases,
        round(count(ca.product_name)/ca.total_cart_adds*100, 2) as convertion_rate,
        dense_rank() over (order by count(ca.product_name)/ca.total_cart_adds desc) as convertion_rank
	from cart_adds ca
	join purchases p
	on ca.visit_id = p.visit_id
	group by ca.product_name)
select
	product_name,
    total_cart_adds,
    total_purchases,
    convertion_rate,
    convertion_rank,
    round(avg(convertion_rate) over(), 2) as avg_convertion_rate
from cart_purchases;