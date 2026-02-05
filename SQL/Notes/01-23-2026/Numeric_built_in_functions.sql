-- ABS(number)- Returns the absolute(positive) value of a number
-- The AVG() function returns the average value of an expression.
-- Note: NULL values are ignored. 
select AVG(amount) from sakila.payment; 

select coalesce(amount,0) from sakila.payment;

-- count() - Returns the number of records returned by a select query
-- Note: NULL values are not counted.
select count(*) from sakila.customer;

-- MOD() - The MOD() function returns the remainder of a number divided by another number.
-- The POW(x,y) function returns the value of a number raised to the power of another number. x raised to yth power
-- RAND() generates a random float between 0 and 1
select rand()*10;
 -- rand(seed) - seed is optional and used if want to generate same numbers 
 select rand(5)*10;
 
 -- The ROUND() function rounds a number to a specified number of decimal places.
select amount,round(amount,1) from payment;
-- The TRUNCATE() function truncates a number to the specified number of decimal places.
select amount,truncate(amount,1) from payment; 
-- The SUM() function calculates the sum of a set of values.
-- Note: NULL values are ignored.
-- SQRT() returns square root of number
select amount, sqrt(amount) from payment;

