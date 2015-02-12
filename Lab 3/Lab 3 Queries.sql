----------------------------------------------------------------------------------------
-- Lab 3 Queries
-- Database Management
-- @author Robert Coords
-- 2/12/2015
----------------------------------------------------------------------------------------

-- Query 1
select ordno, dollars from orders;

-- Query 2
select name, city from agents
where name = 'Smith';

-- Query 3
select pid, name, priceUSD from products
where quantity > 200000;

-- Query 4
select name, city from customers
where city = 'Dallas';

-- Query 5
select name from agents
where city != 'New York' and city != 'Tokyo';

-- Query 6
select * from products
where (city != 'Dallas' or city != 'Duluth') and priceusd > 1.00;

-- Query 7
select * from orders
where mon = 'jan' or mon = 'may';

-- Query 8
select * from orders
where mon = 'feb' and dollars > 500.00;

-- Query 9
select * from orders
where cid = 'c005';