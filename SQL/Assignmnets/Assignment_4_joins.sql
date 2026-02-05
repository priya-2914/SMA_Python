-- SQL JOIN QUESTIONS 
use sakila;
-- 1. List all customers along with the films they have rented.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    f.title AS film_title
FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
LEFT JOIN inventory i 
    ON r.inventory_id = i.inventory_id
LEFT JOIN film f 
    ON i.film_id = f.film_id
ORDER BY c.customer_id;


-- 2. List all customers and show their rental count, including those who haven't rented any films.
select c.customer_id,c.first_name,c.last_name , count(r.rental_id) from customer c
left join rental r on c.customer_id = r.customer_id
group by customer_id,c.first_name,c.last_name 

-- 3. Show all films along with their category. Include films that don't have a category assigned.
select f.film_id,f.title,ca.name from film f
left join film_category fc on
f.film_id = fc.film_id
left join category ca on 
fc.category_id = ca.category_id;

-- 4. Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).

SELECT c.email AS customer_email, s.email AS staff_email
FROM customer c
LEFT JOIN staff s ON c.email = s.email

UNION

SELECT c.email AS customer_email, s.email AS staff_email
FROM customer c
RIGHT JOIN staff s ON c.email = s.email;

-- 5. Find all actors who acted in the film "ACADEMY DINOSAUR".
select a.actor_id,a.first_name,a.last_name from actor a
join film_actor fa on a.actor_id=fa.actor_id
join film f on fa.film_id=f.film_id
where f.title = 'ACADEMY DINOSAUR';

-- 6. List all stores and the total number of staff members working in each store, even if a store has no staff.
select store.store_id,count(staff.staff_id) from store
left join staff on store.store_id = staff.store_id
group by store.store_id;

/*COUNT(staff.staff_id) is better than COUNT(*)
If you use COUNT(*), the query counts the "empty" row and might incorrectly show 1 staff member.

If you use COUNT(st.staff_id), SQL specifically looks for a value in the staff column. 
Since it will be NULL for stores with no staff, it correctly returns 0.*/

-- 7. List the customers who have rented films more than 5 times. Include their name and total rental count.
select c.customer_id,c.first_name,c.last_name , count(r.rental_id) from customer c
left join rental r on c.customer_id = r.customer_id
group by customer_id,c.first_name,c.last_name 
having count(r.rental_id) >5
