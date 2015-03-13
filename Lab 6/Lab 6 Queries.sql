----------------------------------------------------------------------------------------
-- Lab 6 Queries
-- Database Management
-- @author Robert Coords
-- 3/5/2015
----------------------------------------------------------------------------------------

-- Query 1
select c.name, c.city
from customers c inner join (select foo3.city as maxCity
	from (select max(cnt) as m
		from (select city as c, count(city) as cnt
			from products
			group by c) as foo) as foo2 inner join (select city, count(city) as ct
				from products
				group by city) as foo3
			on foo3.ct = foo2.m) as foo4 
	on c.city = foo4.maxCity

-- Query 2
select name
from products
where priceUSD < (select avg(priceUSD)
				  from products)
order by name asc

-- Query 3
select c.name, o.pid, o.dollars
from customers c inner join orders o
	on c.cid = o.cid
order by o.dollars desc;

-- Query 4
select c.name, coalesce(foo.total_ordered, 0)
from customers c left outer join (select cid, sum(qty) as total_ordered
	from orders
	group by cid) as foo 
	on c.cid = foo.cid
order by c.name desc 

-- Query 5
select c.name, p.name, a.name
from orders o, customers c, agents a, products p
where o.cid = c.cid 
  and o.aid = a.aid 
  and o.pid = p.pid 
  and a.city = 'Tokyo'

-- Query 6
select o.*
from orders o, customers c, products p
where o.cid = c.cid 
  and o.pid = p.pid 
  and o.dollars != ((o.qty * p.priceUSD) * ((100.0 - c.discount) / 100))
  
----------------------------------------------------------------------------------------
-- Question 7:
-- A left outer join takes the cross product of two entities, filters out any rows that do not fulfill the "on" clause's condition, and then adds any rows from the left entity that did not 
-- satisfy the "on" clause's condition. The fields from the right entity for the rows from the left entity that did not satisfy the "on" clause's condition are filled with NULL.
-- An example of a query using a left outer join is shown below:
--   select *
--   from customers c left outer join orders o
--   on c.cid = o.cid;
-- The query above shows all the data from the entities customers and orders, where the cid in customers equals the cid in orders. It also shows the data from customers for cid='c005', even 
-- though this row did not meet the condition given in the "on" clause. The fields from orders for cid='c005' in customers are filled with NULLs.
-- 
-- A right outer join is similar to a left outer join, but it adds the rows from the right entity that did not satisfy the condition in the "on" clause, instead of the rows from the left 
-- entity.
-- An example of a query using a right outer join is shown below:
--   select *
--   from orders o right outer join products p
--   on o.pid = p.pid and o.aid = 'a06';
-- The query above shows all the data from the entities orders and products, where the pid in orders matches the pid in products and the aid in orders is 'a06'. It also shows the data for 
-- products where the order was not overseen by agent 'a06', due to the use of the right outer join. The fields from orders for the rows in products that did not meet the "on" clause's 
-- condition are filled with NULLs.