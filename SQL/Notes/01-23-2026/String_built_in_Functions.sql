use Sakila;
-- char_length(col) or character_length(col) - Returns the length of a string (in characters)
select first_name, char_length(first_name) from customer;

-- length(string) - Returns the length of a string (in bytes)
select first_name, length(first_name) from customer;

SELECT CHAR_LENGTH('😊');   -- 1
SELECT LENGTH('😊');        -- 4   (bytes)
/* ------------------------------------------------------*/

-- concat(exp1,exp2,...) - Adds two or more expressions together
-- concat_ws(seperator,exp1,exp2..) - Adds two or more expressions together with a separator
select concat(first_name,last_name), concat_ws('-',first_name,last_name) from customer;
/* CONCAT() joins strings but returns NULL if any value is NULL, 
whereas CONCAT_WS() joins strings using a separator and safely ignores NULL values.*/
SELECT CONCAT('Hello', NULL, 'World'); -- output- null
SELECT CONCAT_WS(' ', 'Hello', NULL, 'World'); -- output- Hello World
/* --------------------------------------------------------------------------*/

-- FIELD - Returns the index position of a value in a list of values
-- if not found returns 0
select field('smith','smith vani','smith') -- 2
-- common use case - custom sorting

SELECT title, rating
FROM sakila.film
ORDER BY FIELD(rating, 'G', 'PG', 'PG-13', 'R', 'NC-17');

/*What MySQL does for each row
Imagine one row has:
rating = 'PG-13'

MySQL evaluates:
FIELD('PG-13', 'G', 'PG', 'PG-13', 'R', 'NC-17')
Internally:
'G' → position 1 ❌
'PG' → position 2 ❌
'PG-13' → position 3 ✅
So MySQL returns 3 for that row.

Now imagine another row:
rating = 'R'
FIELD('R', 'G', 'PG', 'PG-13', 'R', 'NC-17') = 4
🧠 Then ORDER BY happens
MySQL now has a hidden numeric column like this:

title	rating	FIELD value
Film A	G	    1
Film B	PG-13	3
Film C	R	    4
It simply sorts by that number.
➡️ FIELD() is just converting text into a number for sorting. */

-- FIND_IN_SET() -Finds the position of a value in a comma-separated string.
SELECT FIND_IN_SET('B', 'A,B,C');
-- If not found: returns 0
/* ------------------------------------------------------------------------------ */

/* FORMAT() - The FORMAT() function formats a number to a format like "#,###,###.##", 
rounded to a specified number of decimal places, then it returns the result as a string. */
SELECT 
  title,rental_rate,
  FORMAT(rental_rate, 2) AS rental_rate_display
FROM sakila.film;
/* ----------------------------------------------------------------------------------- */

-- insert - replaces part of a string with another string.
SELECT INSERT('Hello World', 7, 5, 'MySQl'); -- Hello MySQL
-- If len = 0 (pure insert)
SELECT INSERT('abcdef', 4, 0, '123'); -- abc123def
-- Position beyond string length
SELECT INSERT('abc', 10, 1, 'X'); -- abc
-- NULL behavior
SELECT INSERT('abc', 2, 1, NULL); -- NULL
 select email, insert(email,3,5,'*****') from sakila.customer;
 /*---------------------------------------------------------------------------------*/
 
 /* INSTR(string,substring) - returns the position of the first occurrence of a substring inside a string.
Positions start from 1
If not found → returns 0 */
SELECT 
  email,
  INSERT(email, 2, INSTR(email, '@') - 2, '*****') AS masked_email
FROM sakila.customer;

select instr('mohini in','in'); -- 4

-- Locate(substring, string, start pos (optional)) - hey both return the position of the first occurrence of a substring.
SELECT 
  email,
  Locate('@', email)
FROM sakila.customer;

-- main diff is locate allows to choose the start position.

-- The MID() and SUBSTR() functions equals the SUBSTRING() function
-- SUBSTR(string, start, length)
SELECT SUBSTR("SQL Tutorial", 5, 3) AS ExtractString;

-- REPEAT() - Repeat the string as many times as specified
  -- select repeat(first_name,2) from customer;
  
-- Replace () - Replaces all occurrences of a substring within a string, with a new substring
-- REPLACE(string, from_string, new_string)
select Replace('mohini','i', 'priya' );

-- The REVERSE() function reverses a string and returns the result.
-- The SPACE() function returns a string of the specified number of space characters.
-- SPACE(number)
/* --------------------------------------------------------------------------- */
-- LEFT() extracts characters from the beginning of a string, while RIGHT() extracts characters from the end.
-- First 3 letters of film titles
SELECT title, LEFT(title, 3)
FROM film;

-- Domain of customer emails
SELECT email, RIGHT(email, 3)
FROM customer; 
/* --------------------------------------------------------------- */

-- LPAD() - The LPAD() function left-pads a string with another string, to a certain length.
-- RPAD()- to right
select lpad(first_name,20,'*') from customer;
select rpad(first_name,20,'*') from customer;
select lpad('mohini', 10, '*');
select rpad('mohini', 10, '*');

-- The LTRIM() , RTRIM() function removes leading and trailing spaces from a string respectively.
/* ----------------------------------------------------------------------------------------------------- */
/*
The STRCMP() function compares two strings.
STRCMP(string1, string2)
If string1 = string2, this function returns 0
If string1 < string2, this function returns -1 ( based on alphabetical order)
If string1 > string2, this function returns 1 ( based on alphabetical order) */
SELECT STRCMP("SQL Tutorial", "HTML Tutorial");

-- The SUBSTRING_INDEX() function returns a substring of a string before a specified number of delimiter occurs.
-- SUBSTRING_INDEX(string, delimiter, number)
SELECT SUBSTRING_INDEX("www.w3schools.com", ".", 1); -- www
SELECT SUBSTRING_INDEX("www.w3schools.com", ".", -1); -- com 

-- trim - Removes leading and trailing spaces from a string



