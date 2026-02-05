/* ADDDATE() and DATE_ADD() - Adds a time/date interval to a date and then returns the date. Both are same
DATE_ADD(date, INTERVAL value addunit)
date	Required. The date to be modified
value	Required. The value of the time/date interval to add. Both positive and negative values are allowed
addunit	Required. The type of interval to add. Can be one of the following values:
MICROSECOND
SECOND
MINUTE
HOUR
DAY
WEEK
MONTH
QUARTER
YEAR
SECOND_MICROSECOND
MINUTE_MICROSECOND
MINUTE_SECOND
HOUR_MICROSECOND
HOUR_SECOND
HOUR_MINUTE
DAY_MICROSECOND
DAY_SECOND
DAY_MINUTE
DAY_HOUR
YEAR_MONTH*/
use sakila;
select payment_date,date_add(payment_date, interval 2 year_month) from payment;

SELECT 
  rental_date,
  DATE_ADD(rental_date, INTERVAL 1503 YEAR) AS future_date
FROM rental;

-- The DATE_SUB() function subtracts a time/date interval from a date and then returns the date.

SELECT DATE_SUB("2017-06-15", INTERVAL 10 DAY);

/* ADDTIME() is used to add a time/duration to a time or datetime value.
ADDTIME(time_or_datetime, time_interval)
The interval must be in TIME format: HH:MM:SS*/
SELECT 
  rental_date,
  ADDTIME(rental_date, '02:00:00') AS adjusted_time
FROM rental;

/* The CURDATE() function returns the current date.

Note: The date is returned as "YYYY-MM-DD" (string) or as YYYYMMDD (numeric).

Note: This function equals the CURRENT_DATE() function.

*/
SELECT CURDATE(); 
select current_date();
select current_time();  select curtime(); -- both returns current time
SELECT CURRENT_TIMESTAMP();

select time(payment_date) from payment; -- similar day(), date(), year()

-- datediff() - Returns the number of days between two date values
select datediff(now(), payment_date) from payment; -- output in days

/*The DATE_FORMAT() function formats a date as specified
DATE_FORMAT(date, format)
Parameter	Description
date	Required. The date to be formatted
format	Required. The format to use. Can be one or a combination of the following values:
Format	Description
%a	Abbreviated weekday name (Sun to Sat)
%b	Abbreviated month name (Jan to Dec)
%c	Numeric month name (0 to 12)
%D	Day of the month as a numeric value, followed by suffix (1st, 2nd, 3rd, ...)
%d	Day of the month as a numeric value (01 to 31)
%e	Day of the month as a numeric value (0 to 31)
%f	Microseconds (000000 to 999999)
%H	Hour (00 to 23)
%h	Hour (00 to 12)
%I	Hour (00 to 12)
%i	Minutes (00 to 59)
%j	Day of the year (001 to 366)
%k	Hour (0 to 23)
%l	Hour (1 to 12)
%M	Month name in full (January to December)
%m	Month name as a numeric value (00 to 12)
%p	AM or PM
%r	Time in 12 hour AM or PM format (hh:mm:ss AM/PM)
%S	Seconds (00 to 59)
%s	Seconds (00 to 59)
%T	Time in 24 hour format (hh:mm:ss)
%U	Week where Sunday is the first day of the week (00 to 53)
%u	Week where Monday is the first day of the week (00 to 53)
%V	Week where Sunday is the first day of the week (01 to 53). Used with %X
%v	Week where Monday is the first day of the week (01 to 53). Used with %x
%W	Weekday name in full (Sunday to Saturday)
%w	Day of the week where Sunday=0 and Saturday=6
%X	Year for the week where Sunday is the first day of the week. Used with %V
%x	Year for the week where Monday is the first day of the week. Used with %v
%Y	Year as a numeric, 4-digit value
%y	Year as a numeric, 2-digit value*/
SELECT payment_date,DATE_FORMAT(payment_date, "%W %M %e %Y") from payment;

-- The DAYOFYEAR() function returns the day of the year for a given date (a number from 1 to 366).
-- DAYOFMONTH() function returns the day of the month for a given date (a number from 1 to 31).
-- The DAYOFWEEK() function returns the weekday index for a given date (a number from 1 to 7).
-- Note: 1=Sunday, 2=Monday, 3=Tuesday, 4=Wednesday, 5=Thursday, 6=Friday, 7=Saturday.

-- The EXTRACT() function extracts a part from a given date.
select payment_date, extract(year_month from payment_date) from payment;

/* special Functions*/
/* The IFNULL() function returns a specified value if the expression is NULL.
If the expression is NOT NULL, this function returns the expression.*/
SELECT IFNULL(NULL, "W3Schools.com");

/* The NULLIF() function compares two expressions and returns NULL if they are equal. Otherwise, the first expression is returned.*/
SELECT NULLIF(25, 25);
SELECT NULLIF("Hello", "world");

/* COALESCE() returns the first NON-NULL value from a list of expressions.*/
SELECT 
  first_name,
  last_name,
  COALESCE(email, 'No Email') AS email_status
FROM customer;
