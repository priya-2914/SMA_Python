-- 1.Find all actors whose first name starts with 'M'.
use sakila;
select first_name from actor
where first_name regexp '^[mM]';
-- 2.Find actors whose last name ends with 'son'.
select last_name from actor
where last_name regexp '[sS][oO][nN]$';
-- 3.Find actors whose first name contains exactly 6 letters.
select first_name from actor
where first_name regexp '^.{6}$';
-- 4.Find actors whose first name contains 'a' or 'e'.
select first_name from actor
where first_name regexp '[aAeE]';

-- 5.Find films whose title contains 'LOVE' or 'HATE' (case-insensitive).
select title from film
where title regexp 'LOVE|HATE';
-- 6.Find films where the title starts with a number.
select title from film
where title regexp '^[0-9]';
-- 7.Find films with exactly 3 words in the title.
select title from film
where title regexp '^[a-zA-Z]+ [a-zA-Z]+ [a-zA-Z]+$';
-- 8.Find films whose title ends with 'man'.
select title from film
where title regexp 'man$';
-- 9.Find films whose title contains exactly 2 vowels. (Hint: REGEXP can help here)
select title from film
where title regexp '[aeiouAEIOU]{2}';   -- wrong bcz it matches 2 consecutive vowels

SELECT title
FROM film
WHERE title REGEXP '^[^aeiouAEIOU]*[aeiouAEIOU][^aeiouAEIOU]*[aeiouAEIOU][^aeiouAEIOU]*$';

-- 10.Find films whose title contains the word 'THE' anywhere.
select title from film
where title regexp 'THE'; -- works but also matches theatre, breathe 

select title from film
WHERE title REGEXP '(^| )THE( |$)' -- matches for 'the lion', 'season of the month'

