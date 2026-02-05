use sakila;
-- 1. Identify if there are duplicates in Customer table. Don't use customer id to check the duplicates
select first_name,last_name,email,count(*) as dup_rec from customer
group by first_name,last_name,email
having count(*) >1;

SELECT *
FROM customer
WHERE (first_name, last_name, email) IN (
    SELECT first_name, last_name, email
    FROM customer
    GROUP BY first_name, last_name, email
    HAVING COUNT(*) > 1
);

-- 2. Number of times letter 'a' is repeated in film descriptions
select length(description)-length(replace(lower(description),'a','')) from film;

-- 3. Number of times each vowel is repeated in film descriptions 
select sum(length(description)-length(replace(lower(description),'a',''))) as count_a,
	sum(length(description)-length(replace(lower(description),'e',''))) as count_e,
    sum(length(description)-length(replace(lower(description),'i',''))) as count_i ,
    sum(length(description)-length(replace(lower(description),'o','')) )as count_o,
    sum(length(description)-length(replace(lower(description),'u',''))) as count_u
    from film;
    
/*4. Display the payments made by each customer
        1. Month wise
        2. Year wise
        3. Week wise */
select customer_id ,year(payment_date),sum(amount) from payment
group by customer_id ,year(payment_date)
order by customer_id,year(payment_date);

select customer_id ,month(payment_date),sum(amount) from payment
group by customer_id ,month(payment_date)
order by customer_id,month(payment_date);

select customer_id ,week(payment_date),sum(amount) from payment
group by customer_id ,week(payment_date)
order by customer_id,week(payment_date);

select customer_id ,year(payment_date),month(payment_date),week(payment_date) from payment
group by customer_id,year(payment_date),month(payment_date),week(payment_date);

-- 5. Check if any given year is a leap year or not. You need not consider any table from sakila database. Write within the select query with hardcoded date

SELECT 
    YEAR('2024-01-01') AS year,
    CASE 
        WHEN (YEAR('2024-01-01') % 4 = 0 AND YEAR('2024-01-01') % 100 != 0)
             OR (YEAR('2024-01-01') % 400 = 0)
        THEN 'Leap Year'
        ELSE 'Not a Leap Year'
    END AS leap_year_check;

-- 6. Display number of days remaining in the current year from today.
SELECT 
    DATEDIFF(
        MAKEDATE(YEAR(CURDATE()) + 1, 1),  -- January 1 of next year
        CURDATE()                            -- today
    ) AS days_remaining;

-- 7. Display quarter number(Q1,Q2,Q3,Q4) for the payment dates from payment table. 
select payment_date,quarter(payment_date) from payment;

-- 8. Display the age in year, months, days based on your date of birth. 
   -- For example: 21 years, 4 months, 12 days
   SELECT 
    CONCAT(
        TIMESTAMPDIFF(YEAR, '2001-10-14', CURDATE()), ' years, ',
        TIMESTAMPDIFF(MONTH, '2001-10-14', CURDATE()) % 12, ' months, ',
        DATEDIFF(CURDATE(), DATE_ADD('2001-10-14', INTERVAL TIMESTAMPDIFF(MONTH, '2001-10-14', CURDATE()) MONTH)), ' days'
    ) AS age;
select datediff('2026-01-03','2025-01-03')



   