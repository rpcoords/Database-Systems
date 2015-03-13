----------------------------------------------------------------------------------------
-- Lab 5 Queries
-- Database Management
-- @author Robert Coords
-- 3/3/2015
----------------------------------------------------------------------------------------

-- Query 1
select a.city
from agents a, orders o
where o.cid = 'c006' 
  and a.aid = o.aid
  
-- Query 2
select o1.pid
from (orders o inner join customers c
	on (c.city = 'Kyoto' and c.cid = o.cid))
	inner join orders o1
	on o1.aid = o.aid
group by o1.pid
order by o1.pid desc 

-- Query 3
select name
from customers
where cid not in (select cid 
	from orders)

-- Query 4
select c.name
from customers c left outer join orders o 
	on c.cid = o.cid
where o.cid is NULL

-- Query 5
select c.name, a.name
from orders o inner join 
	(customers c inner join agents a
		on c.city = a.city)
	on  o.cid = c.cid
	and o.aid = a.aid
group by c.name, a.name

-- Query 6
select c.name, a.name, a.city
from customers c inner join agents a
	on c.city = a.city

-- Query 7
-- (Work in Progress)
select *
from products p left outer join customers c
	on c.city = p.city

group by p.pid, c.cid
order by p.city desc



select  count(city) as cnt
from products
group by city
having count(city) = min(cnt)


-- Returns number of products made in city that makes fewest number of products
select min(cnt)
from (select count(city) as cnt
	from products
	group by city) as foo