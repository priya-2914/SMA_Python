use sakila;
/*A subquery is a query inside another query.
 The inner query runs first
 Its result is used by the outer query
 SELECT *
FROM table
WHERE column = (SELECT column FROM table);*/

-- Types of Subqueries
-- 1. Single-Row Subquery - Returns only one value
-- Find films with rental rate higher than the average rental rate
select title,rental_rate from sakila.film
where rental_rate > (select avg(rental_rate) from sakila.film);

-- 2.Multi-Row Subquery - Returns multiple values ( Uses: IN, ANY, ALL)
-- Find customers who rented movies
select customer_id from sakila.customer
where customer_id in (select customer_id from sakila.rental);

-- 3. Subquery in SELECT Clause - Used to display calculated values
-- no.of films done by each actor
SELECT actor_id,
       first_name,
       last_name,
       (
           SELECT COUNT(*)
           FROM sakila.film_actor
           WHERE film_actor.actor_id = actor.actor_id
       ) AS film_count
FROM sakila.actor;
-- Runs once per row → slower for large data

-- 4. Subquery in FROM Clause (Derived Table) - Treats subquery as a temporary table
-- Find customers who rented more than 20 movies
select customer_id, total_rentals from 
(select customer_id, count(*) as total_rentals 
from sakila.rental
group by customer_id) t 
where total_rentals >20;

SELECT a.actor_id, a.first_name, a.last_name, fa.film_count
FROM sakila.actor a
JOIN (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
) fa ON a.actor_id = fa.actor_id;

SELECT *
FROM (
    SELECT last_name,
           CASE 
               WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
               WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
               ELSE 'Other'
           END AS group_label
    FROM sakila.customer
) AS grouped_customers 
WHERE group_label = 'Group N-Z';

-- 5.Correlated Subquery - Inner query depends on outer query
-- Executes once for each row
SELECT title,
  (SELECT COUNT(*)
   FROM sakila.film_actor fa
   WHERE fa.film_id = f.film_id) AS actor_count
FROM sakila.film f;

SELECT payment_id, customer_id, amount, payment_date
FROM sakila.payment p1
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment p2
    WHERE p2.customer_id = p1.customer_id
);

/*EXISTS Subquery

Checks whether rows exist

Example:

Find customers who have made at least one payment */

SELECT first_name, last_name
FROM customer c
WHERE EXISTS
      (SELECT 1
       FROM payment p
       WHERE p.customer_id = c.customer_id);

-- Faster than IN in large datasets
-- Stops checking once match is found

/* NOT EXISTS

Find missing relationships

Example:

Find customers who never rented any movie */

SELECT first_name, last_name
FROM customer c
WHERE NOT EXISTS
      (SELECT 1
       FROM rental r
       WHERE r.customer_id = c.customer_id);
       




