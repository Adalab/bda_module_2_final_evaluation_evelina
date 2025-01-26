USE sakila; 

-- 1. Display all film titles without duplicates.

SELECT DISTINCT title 
FROM film; 

-- The operator DISTINCT allows us to avoid repetition in the result.

-- 2. Display all film titles with "PG-13" rating.

SELECT title, rating
FROM film
WHERE rating = 'PG-13'; 

-- The operator WHERE allows us to specify the rating using '='

-- 3. Find the title and description of all the films that contain the word 'amazing' in their description. 

SELECT title, description 
FROM film
WHERE description LIKE '%amazing%' 

-- The command LIKE allows us to showcase the needed results.
-- % are used before and after the word 'amazing' to tell the program that any other content may appear before and after the word, but 'amazing' HAS TO be included.

-- 4.Find the title of all the films whose duration length is superior to 120 minutes.

SELECT title, length 
FROM film
WHERE length > 120; 

-- The symbol '>' allows us to express the desired length of the film. 

-- 5. Find the names of all the actors. Then, display them in a single column named actor_name, containing actor's first name and last name.

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor; 

-- The command CONCAT allows us to concatenate the values of two columns into one.
-- The ' ' symbol is needed in order to indicate the program to leave a space between the two values.

-- 6. Find the first and last names of actors who have "Gibson" in their last name.

-- There are four ways to do this exercise, which all return the same result. 

-- Option A

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE last_name LIKE '%Gibson%'; 

-- The wildcards % allow for any characters before or after "Gibson."

-- Option B

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE last_name IN ('Gibson');

-- This option checks if the last_name is an exact match. 
-- Since there is only "Gibson," it's effectively the same as option C.

-- Option C

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE last_name = 'Gibson';

-- This is the most direct option. It checks for an exact match to "Gibson."
-- This will only find actors with the last name "Gibson," and nothing else.

-- Option D

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE last_name REGEXP 'Gibson';

-- The final option uses regular expressions (REGEXP), which are powerful for pattern matching. 

-- 7. Find the names of actors with an actor_id between 10 and 20. 

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20; 

-- The command BETWEEN allows us to showcase a range between the two desired values.

-- 8. Find the names of the films in table 'film,' which are not rated "R" or "PG-13."

SELECT title, rating 
FROM film
WHERE rating NOT IN('R', 'PG-13'); 

-- The NOT IN operator negates the IN operator. So,it checks if a value DOES NOT match any value in the list. 

-- 9. Find the total number of films in each rating in table 'film', and display the rating along with the count.

-- Option A
SELECT rating, COUNT(*) 
FROM film
GROUP BY rating 

-- COUNT(*) counts all the rows in each group, regardless of the possible NULL values.

-- Option B

SELECT rating, COUNT(film_id) 
FROM film
GROUP BY rating; 

-- This counts only the rows where the film_id column is not NULL. 

-- 10.  Find the total number of films rented by each customer and display the customers ID, first and last name along with the number of the films rented.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rented
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- This INNER JOIN connects the 'customer' and 'rental' tables based on a shared piece of information: the customer_id. 

-- 11. Find the total number of films rented by category, and then display the category name along with the rental count.

SELECT c.name, COUNT(r.rental_id) AS total_rented
FROM rental r
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film_category fc 
ON i.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
GROUP BY c.name;

-- There are three INNER JOINS: 

-- rental and inventory tables:
-- Purpose: To connect rentals with the specific inventory items involved.
-- Key: rental_id in both tables.

-- inventory and film_category tables:
-- Purpose: To connect inventory items with their corresponding film categories.
-- Key: film_id in both tables.

-- film_category and category tables:
-- Purpose: To connect film categories with their names.
-- Key: category_id in both tables.
 
-- 12. Find the average movie length for each rating in the film table, and then display the rating along with the average length.

 SELECT rating, AVG (length) AS average_length 
 FROM film
 GROUP BY rating; 

 -- AVG() is an aggregate function:  It operates on a set of values (in this case, the length of films) and returns a single value that represents the average.
 
-- 13. Find the first and last name of the actors appearing in the films titled “Indian Love”.

SELECT a.first_name, a.last_name, f.title 
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film f 
ON fa.film_id = f.film_id
WHERE f.title = 'INDIAN LOVE';

 -- INNER JOIN film_actor fa ON a.actor_id = fa.actor_id: This joins the actor table with the film_actor table (aliased as fa). 
 -- The join condition a.actor_id = fa.actor_id ensures that only actors associated with films (through the film_actor table) are included.

-- INNER JOIN film f ON fa.film_id = f.film_id: This joins the film_actor table with the film table (aliased as f). 
-- The join condition fa.film_id = f.film_id connects the film actors with the specific films they acted in.

-- WHERE f.title = 'INDIAN LOVE': This filters the results to include only those rows where the film title (f.title) is 'INDIAN LOVE'.

-- 14. Display the title of all the films containing the word “dog” or “cat” in their description.

SELECT title, description 
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- WHERE description LIKE '%dog%' OR description LIKE '%cat%': This is the filtering condition. 
-- It uses the LIKE operator with the % wildcard to search for descriptions that contain the word "dog" or "cat".
-- % means "any sequence of zero or more characters". So %dog% matches any description with "dog" anywhere within it. The same applies to %cat%.
-- OR combines the two conditions, so films matching either condition are included in the result.

-- 15. Are there any actors or actresses who do not appear in any film in the film_actor table?

-- Option A 

SELECT a.first_name, a.last_name 
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

-- Option B

SELECT a.first_name, a.last_name 
FROM actor a
WHERE a.actor_id NOT IN 
	(SELECT fa.actor_id 
     FROM film_actor fa);

-- IS NULL: This option attempts to find actors who are not linked to any films in the film_actor table. 
-- NOT IN: The main query then uses NOT IN to select actors from the actor table whose actor_id is not present in the list generated by the subquery. 

-- 16. Find the titles of all the films that were released between 2005 and 2010.

SELECT title, release_year 
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- This is the filtering condition. It uses the BETWEEN operator to select only the films where the release_year falls within the range of 2005 to 2010 (inclusive). 
-- This means films released in 2005, 2006, 2007, 2008, 2009, and 2010 (if any) will be included in the result.

-- 17. Find the title of all the films that are in the same category as “Family”.

SELECT f.title, c.name 
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- Using the two INNER JOINs, we first join the 'film' table with the 'film_category' table. Then, we join the 'film_category' table with the 'category' table.
-- WHERE c.name = 'Family': This filters the results to include only those rows where the category name (c.name) is 'Family'.

-- 18. Display the first and last names of the actors appearing in more than 10 films.

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS number_of_films
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10;

-- Using the INNER JOIN we join the 'actor' table with the 'film_actor' table. 
-- GROUP BY a.actor_id: This groups the results by the actor_id, so the COUNT() function counts films per actor.
-- HAVING COUNT(fa.film_id) > 10: This filters the grouped results, keeping only those actors who have appeared in more than 10 films. 
-- !!! HAVING is used for filtering after grouping, whereas WHERE filters before grouping.!!!

-- 19. In the 'film' table, find the title of all the films that are “R” rated, and have a duration longer than 2 hours.

SELECT title, rating, length 
FROM film
WHERE rating = 'R' AND length > 120;

-- rating = 'R': The movie has an 'R' rating.
-- length > 120: The movie's duration is greater than 120 minutes (2 hours).
-- The AND operator ensures that both conditions must be true for a movie to be included in the results.

-- 20. Find categories of films that have an average running time longer than 120 minutes.
-- Then, display the category name alongside the average running time.

SELECT c.name AS category, AVG(f.length) AS average_running_time
FROM category c
INNER JOIN film_category fc 
ON c.category_id = fc.category_id
INNER JOIN film f 
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- Using the two INNER JOINs we first join the 'category' table with the 'film_category' table. Then we join the 'film_category' table with the 'film' table.
-- Filtering: The HAVING AVG(f.length) > 120. The clause filters out any categories that don't have an average film length exceeding 120 minutes.

-- 21. Find actors who have acted in at least 5 films. Display the actor's name alongside the number of films they have acted in.

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS number_of_films
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >= 5;

-- Using the INNER JOIN we join the 'actor' table with the 'film_actor' table. 
-- GROUP BY a.actor_id: This groups the results by the actor_id, so the COUNT() function counts films per actor.
-- Filtering: HAVING COUNT(fa.film_id) >= 5 keeps only the groups (actors) where the film count is exactly 5 or more.

-- 22. Find the title of all the films that were rented for more than 5 days. Use a subquery to find the rental_ids with a duration longer than 5 days, and then select the corresponding films. 
-- Hint: We use DATEDIFF to calculate the difference between one date and another, e.g. DATEDIFF(start_date, end_date).

-- Option A with subquery:

SELECT f.title 
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM rental r
    INNER JOIN inventory i 
    ON r.inventory_id = i.inventory_id
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5
);

 -- Subquery:
 
 -- SELECT i.film_id FROM rental r INNER JOIN inventory i ON r.inventory_id = i.inventory_id WHERE DATEDIFF(r.return_date, r.rental_date) > 5: 
 -- This part joins the rental and inventory tables to connect rentals with their corresponding films. 
 -- It then filters for rentals where the difference between return_date and rental_date (calculated using DATEDIFF) is greater than 5 days. 
 -- The result of this subquery is a list of film_ids.
 
 -- Main query: 
 
 -- SELECT f.title FROM film f WHERE f.film_id IN (...): 
 -- This part selects the title from the film table where the film_id is present in the list generated by the subquery.
 
-- Option B with two INNER JOINs:

SELECT f.title, DATEDIFF(r.return_date, r.rental_date) AS days_rented, r.return_date, r.rental_date 
FROM film f
INNER JOIN inventory i
ON i.film_id = f.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;

-- We use two INNER JOINs to connect films with their rental information. First we connect 'film' with 'inventory,' and then 'inventory' with 'rental, using the columns in common.
-- WHERE DATEDIFF(r.return_date, r.rental_date) > 5: This filters the joined results to include only those rows where the rental duration is greater than 5 days.

-- 23. Find the first and last name of actors who have not acted in any film in the “Horror” category. 
-- HINT: Use a subquery to find actors who have acted in films in the “Horror” category, and then exclude them from the list of actors.

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc 
    ON fa.film_id = fc.film_id
    INNER JOIN category c  
    ON fc.category_id = c.category_id
    WHERE c.name = 'Horror' 
);
 
 -- Subquery: The subquery uses INNER JOINs to connect the film_actor table with the film_category table and then the category table. 
 -- This allows it to filter for actor_ids associated with films in the "Horror" category (where c.name = 'Horror').
 
 -- Main query: The main query selects the first_name and last_name of actors from the actor table (aliased as a). 
 -- The WHERE clause uses NOT IN to exclude any actors whose actor_id appears in the list returned by the subquery.

-- BONUS:
    
-- 24. In the 'film' table, find the title of the films that are comedies, and whose duration is longer than 180 minutes. Use a subquery.

SELECT f.title, f.length
FROM film f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c 
    ON fc.category_id = c.category_id
    WHERE c.name = 'Comedy'
    AND f.length > 180
);

-- Subquery: The subquery retrieves film_ids for movies that are in the "Comedy" category (c.name = 'Comedy')
-- It also picks out films that have a duration greater than 180 minutes (f.length > 180).

-- Main query: The main query selects the title and length of films whose film_id is in the list returned by the subquery.

-- Table Joins: The subquery uses INNER JOINs to connect the film_category table with the category table and the film table. 

-- 25. BONUS: Find all actors who have acted together in at least one film. 
-- The query must show the first and the last name of the actors, and the number of films in which they have acted together. 
-- Hint: We can do a SELF/AUTO JOIN of the table 'film_actor' with itself, using a different alias.

SELECT
    CONCAT(a1.first_name, " ", a1.last_name) AS "Actor 1",
    CONCAT(a2.first_name, " ", a2.last_name) AS "Actor 2",
    COUNT(fa1.film_id) AS "Total movies"
FROM film_actor fa1
JOIN film_actor fa2 
ON fa1.film_id = fa2.film_id 
INNER JOIN actor a1 
ON fa1.actor_id = a1.actor_id
INNER JOIN actor a2 
ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id < a2.actor_id
GROUP BY a1.actor_id, a2.actor_id
HAVING COUNT(fa1.film_id);

 -- FROM film_actor fa1 JOIN film_actor fa2 ON fa1.film_id = fa2.film_id: This is a self-join on the film_actor table. 
 -- It creates two instances of the table (fa1 and fa2) and joins them where the film_id is the same. 
 -- This effectively finds all pairs of actors who have worked in the same film.
 
 -- INNER JOIN actor a1 ON fa1.actor_id = a1.actor_id INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id: 
 -- These joins connect the film_actor instances to the actor table to retrieve the first and last names of the actors.
 
 -- After these INNER JOINs are complete, we use WHERE a1.actor_id < a2.actor_id:
 -- This condition prevents duplicate pairs. Without it, you'd get both "Actor A, Actor B" and "Actor B, Actor A" for each pair. 
 -- This ensures each pair is listed only once, with the actor with the lower actor_id listed first.

-- GROUP BY a1.actor_id, a2.actor_id: This groups the results by unique pairs of actors. In this way, you can count how many films each pair has worked on together.

-- HAVING COUNT(fa1.film_id): This is similar to a WHERE clause but applies after grouping. 
-- In this case, it filters out any pairs of actors who haven't worked on any films together. 
-- Since COUNT(fa1.film_id) will be 0 for those pairs, they are effectively removed from the results.
    

