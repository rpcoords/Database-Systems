

-- Query 1
select city from agents
where aid in (select aid from orders
	      where cid = 'c006');

-- Query 2
select pid from orders
where aid in (select aid from orders
	     where cid in (select cid from customers
			  where city = 'Kyoto'))
order by pid desc;

-- Query 3
select cid, name from customers
where cid not in (select cid from orders
	          where aid = 'a03');

-- Query 4
select cid from orders
where pid = 'p07' and cid in (select cid from orders
			      where pid = 'p01');

-- Query 5
select pid from products
where pid not in (select pid from orders
		  where cid in (select cid from orders
				where aid = 'a05'));

-- Query 6
select name, discount, city from customers
where cid in (select cid from orders
	      where aid in (select aid from agents
			    where city = 'Dallas' or city = 'New York'));

-- Query 7
select * from customers
where discount in (select discount from customers
		   where cid in (select cid from orders
				 where aid in (select aid from agents
					       where city = 'Dallas' or city = 'London')));

