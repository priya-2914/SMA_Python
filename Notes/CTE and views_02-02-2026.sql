use sakila;
/*Query-Level (CTE)
Exists: Only during the query
Scope: Single query
Lifetime: Ends immediately after query
Use: Simplify complex queries or intermediate results
WITH cte_name AS (
    -- your query
    SELECT ...
)
SELECT * FROM cte_name;*/
-- Top 5 actors by number of films:
WITH actor_film_count AS (
    SELECT a.actor_id, CONCAT(a.first_name,' ',a.last_name) AS actor_name,
           COUNT(fa.film_id) AS total_films
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id
)
SELECT * 
FROM actor_film_count
ORDER BY total_films DESC
LIMIT 5;

/*Multiple CTEs
Definition:
You can define more than one CTE in a single query.
Later CTEs can refer to earlier CTEs.
Helps break complex queries into smaller parts.
All exist only during that query (query-level).*/

-- Find top 5 customers by total payments, along with their total rentals:
WITH customer_rentals AS (
    -- CTE1: total rentals per customer
    SELECT customer_id, COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
),
customer_payments AS (
    -- CTE2: total payments per customer
    SELECT customer_id, SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
),
top_customers AS (
    -- CTE3: combine rentals and payments
    SELECT cr.customer_id, cr.total_rentals, cp.total_paid
    FROM customer_rentals cr
    JOIN customer_payments cp ON cr.customer_id = cp.customer_id
)
SELECT *
FROM top_customers
ORDER BY total_paid DESC
LIMIT 5;


/*Nested CTE
Definition:
A CTE defined inside another CTE or multiple CTEs referencing each other.
Helps break complex queries into layers.
Makes queries more readable and modular.
Key Points:
Can have multiple CTEs separated by commas.
Later CTEs can refer to earlier CTEs.
Still query-level, only exists during that query.*/
-- Find actors and their number of films, then only select actors with more than 50 films:
WITH actor_film_count AS (
    -- CTE1: count films per actor
    SELECT a.actor_id, CONCAT(a.first_name,' ',a.last_name) AS actor_name,
           COUNT(fa.film_id) AS total_films
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id
),
top_actors AS (
    -- CTE2: filter actors with more than 50 films
    SELECT *
    FROM actor_film_count
    WHERE total_films > 10
)
SELECT * FROM top_actors;


/*Recursive CTE
Definition:
A CTE that refers to itself to produce a result.
Used for hierarchies, sequences, or iterative calculations.
Consists of two parts:
Anchor member – starting point of recursion
Recursive member – refers to the CTE itself */
WITH RECURSIVE rental_seq AS (
    -- Anchor member: start with rental_id = 1
    SELECT 1 AS rental_id
    UNION ALL
    -- Recursive member: add 1 each time until 10
    SELECT rental_id + 1
    FROM rental_seq
    WHERE rental_id < 10
)
SELECT * FROM rental_seq;

/*Session-Level (Temporary Table)
Exists: For the entire session
Scope: Can use in multiple queries within the session
Lifetime: Automatically deleted when session ends
Use: Store intermediate results, avoid repeating queries 
CREATE TEMPORARY TABLE temp_name AS
SELECT ...*/
-- Customers with more than 5 rentals:
CREATE TEMPORARY TABLE temp_rentals AS
SELECT customer_id, COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY customer_id;
-- Can use in multiple queries in the same session
SELECT * FROM temp_rentals WHERE total_rentals > 5;
SELECT AVG(total_rentals) FROM temp_rentals;

/*DB-Level (View / Table)
Exists: Permanently in the database
Scope: Can be accessed by any session with permission
Lifetime: Stays until dropped
Use: Reuse frequently run queries, simplify reporting
CREATE VIEW view_name AS
SELECT ...*/
-- View for customer rental summary:
CREATE VIEW customer_rental_summary AS
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       COUNT(r.rental_id) AS total_rentals,
       SUM(p.amount) AS total_paid
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

-- Query the view
SELECT * FROM customer_rental_summary
WHERE total_rentals > 30;




