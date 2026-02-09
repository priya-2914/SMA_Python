use sakila;
-- 1. display all customer details who have made more than 5 payments.
select *
from customer
where customer_id in (
select customer_id from payment
group by customer_id
having count(*) >5
)
-- 2. Find the names of actors who have acted in more than 10 films.
select first_name,last_name from actor
where actor_id in (
select actor_id from film_actor
group by actor_id 
having count(*) >10
)
-- 3. Find the names of customers who never made a payment.
select first_name,last_name from customer c
where customer_id not in(
select customer_id from payment p)
-- If the subquery returns even one NULL value, then
-- NOT IN returns NO rows at all (SQL logic thing, very common trap).

SELECT first_name, last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM payment p
    WHERE p.customer_id = c.customer_id
);

-- 4. List all films whose rental rate is higher than the average rental rate of all films.
select * from film
where rental_rate > (select avg(rental_rate) from film)

-- 5. List the titles of films that were never rented.
SELECT title
FROM film f
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory i
    WHERE i.film_id = f.film_id
      AND EXISTS (
          SELECT 1
          FROM rental r
          WHERE r.inventory_id = i.inventory_id
      )
);

-- 6. Display the customers who rented films in the same month as customer with ID 5.
select * from sakila.customer
where customer_id in (
select customer_id from sakila.rental
where month(rental_date) in (
SELECT DISTINCT MONTH(rental_date)
FROM sakila.rental
WHERE customer_id = 5))

-- 7. Find all staff members who handled a payment greater than the average payment amount.
select * from staff
where staff_id in (select staff_id from payment
where amount> (select avg(amount) from payment))

-- 8. Show the title and rental duration of films whose rental duration is greater than the average.
select title,rental_duration from film
where rental_duration > (select avg(rental_duration) from film)
-- 9. Find all customers who have the same address as customer with ID 1.
select * from customer
where address_id in (select address_id from customer 
where customer_id =1)
-- 10. List all payments that are greater than the average of all payments.
select * from payment
where amount > (select avg(amount) from payment)
