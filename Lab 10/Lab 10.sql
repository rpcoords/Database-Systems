----------------------------------------------------------------------------------------
-- Lab 10
-- Database Management
-- @author Robert Coords
-- 4/21/2015
----------------------------------------------------------------------------------------

-- Question 1
-- Stored Procedure PreReqsFor(courseNum) returns the immediate prerequisites for the passed-in course number.
create or replace function PreReqsFor(integer, refcursor) returns refcursor as 
$$
declare
	cn integer := $1;
	resultset refcursor := $2;
begin
	open resultset for
		select prereqnum
		from prerequisites
		where coursenum = cn;
	return resultset;
end;
$$
language plpgsql;

-- SQL command to execute PreReqsFor
select * from prereqsfor(308, 'results');
fetch all from "results";

-- Question 2
-- Stored Procedure IsPreReqFor(courseNum) returns the courses for which the passed-in course number is a prerequisite.
create or replace function IsPreReqFor(integer, refcursor) returns refcursor as
$$
declare
	pn integer := $1;
	resultset refcursor := $2;
begin
	open resultset for
		select courseNum
		from prerequisites
		where prereqnum = pn;
	return resultset;
end;
$$
language plpgsql;

-- SQL command to execute IsPreReqFor
select * from IsPreReqFor(120, 'results');
fetch all from "results";