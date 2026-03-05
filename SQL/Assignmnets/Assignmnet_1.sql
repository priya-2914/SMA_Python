use sakila;
-- 1.Get all customers whose first name starts with 'J' and who are active.
select * from customer
where first_name like "j%" and active = 1;

-- 2.Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.
select * from film
where title like "%ACTION" or description like "%WAR%";

-- 3.List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.
select * from customer 
where lower(last_name) != "smith" and first_name like "%a";

-- 4.Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.
select * from film
where rental_rate >3 and replacement_cost is not null;

-- 5.Count how many customers exist in each store who have active status = 1.
select count(*) from customer 
where active=1;

-- 6.Show distinct film ratings available in the film table.
select distinct rating from film;

-- 7.Find the number of films for each rental duration where the average length is more than 100 minutes.
select rental_duration , count(*) from film
group by rental_duration
having avg(length) >100;

-- 8. List payment dates and total amount paid per date, but only include days where more than 100 payments were made.
select payment_date, sum(amount) from payment
group by payment_date
having count(payment_date)>100;

-- 9.Find customers whose email address is null or ends with '.org'.
select * from customer
where email is null or email like "%.org"

-- 10. List all films with rating 'PG' or 'G', and order them by rental rate in descending order.
select * from film
where rating = 'PG' or rating = 'G'
order by rental_rate desc;

-- 11. Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.
select count(*) from film
where title like 't%'
group by length 
having count(*) >5;

-- 12. List all actors who have appeared in more than 10 films.
select * from actor
where actor_id in 
(select actor_id ,count(film_id) from film_actor
group by actor_id
having count(film_id)>10);

-- 13. Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.
select title, rental_rate, length from film 
order by rental_rate desc, length desc
limit 5;

-- 14. Show all customers along with the total number of rentals they have made, ordered from most to least rentals.
select first_name,last_name, count(rental_id) as no_of_rentals
from customer c left join rental r on
c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
order by no_of_rentals desc;

-- 15. List the film titles that have never been rented.
SELECT f.title
FROM film f
LEFT JOIN inventory i
  ON f.film_id = i.film_id
LEFT JOIN rental r
  ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;


