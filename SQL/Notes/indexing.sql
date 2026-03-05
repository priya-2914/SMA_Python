/*What is Indexing?
Indexing is a technique used to speed up SELECT queries
An index is a data structure that allows MySQL to find rows quickly
Works like an index page of a book
Without index → full table scan
With index → fast lookup*/

/*Why Indexes are Needed (Sakila context)
Example query:
SELECT * 
FROM customer 
WHERE last_name = 'SMITH';

customer table has many rows
Without index → MySQL checks every row
With index → MySQL directly finds matching rows*/

/*Primary Index (Clustered Index)
Created automatically on PRIMARY KEY
Table rows are stored in primary key order
Only one clustered index per table*/

explain SELECT * 
FROM sakila.customer 
WHERE customer_id = 5;

-- Uses primary (clustered) index
-- Fastest lookup
-- Clustered = data rows are stored physically in index order

/* Secondary Index (Non-Clustered Index)
Index created on non-primary key columns
Stored separately from table data
Contains: indexed_column → primary_key*/
CREATE INDEX idx_last_name 
ON customer(last_name);

explain SELECT * 
FROM sakila.customer 
WHERE last_name = 'SMITH';

-- Search last_name index
-- Get customer_id
-- Fetch row using primary key

-- Natural Key & Surrogate Key
Natural key
A natural key is a real-world, meaningful value that already exists in the data and can uniquely identify a record.
Examples:
Email address → uniquely identifies a user
SSN / Aadhaar / Passport number → uniquely identifies a person
ISBN → uniquely identifies a book
Employee ID given by company

Example table:
STUDENT
--------------------------------
email            name     course
priya@gmail.com  Priya    DS

Here, email is a natural key because:
it already exists
it has business meaning
users understand it
⚠️ Problems with natural keys:
They can change (email, phone number)
They can be long / messy
Sometimes they are not guaranteed unique forever

Surrogate key
A surrogate key is an artificial key created by the database.
It has no business meaning, it’s just there to uniquely identify rows.

Examples:
auto-increment integer
UUID
Example table:
STUDENT
--------------------------------------
student_id   email            name
1            priya@gmail.com  Priya

student_id is a surrogate key because:
database generates it
it never changes
it has no real-world meaning


