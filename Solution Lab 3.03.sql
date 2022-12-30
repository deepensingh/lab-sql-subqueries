-- ![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

-- # Lab | SQL Subqueries 3.03


-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

Use sakila;
SELECT * FROM inventory;

SELECT title, COUNT(inventory_id) AS Film_Copies
FROM inventory
JOIN film
USING (film_id)
WHERE title = "HUNCHBACK IMPOSSIBLE"
GROUP BY title;


-- 2. List all films whose length is longer than the average of all the films.

SELECT AVG(length) FROM film;

SELECT film_id, title, length 
FROM film
WHERE length > (SELECT AVG(length) FROM film ORDER BY length ASC);


-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT * FROM film_actor;
SELECT * FROM film;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
					SELECT actor_id FROM film_actor
					WHERE film_id IN (
										SELECT film_id
										FROM film
										WHERE title = "Alone Trip") 
); 



-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title 
FROM sakila.film
WHERE film_id IN(
				  SELECT film_id FROM(
										SELECT film_id
										FROM sakila.category
JOIN sakila.film_category USING(category_id)
WHERE name = 'Family') sub1
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their 
--    primary keys and foreign keys,
--    that will help you get the relevant information.

SELECT First_Name, Last_Name, Email
FROM customer 
WHERE address_id IN( 
					SELECT address_id 
					FROM address 
					WHERE city_id IN ( 
									   SELECT city_id 
									    FROM city 
										WHERE country_id IN( 
															SELECT country_id 
															FROM country 
															WHERE country = 'Canada'))
); 

-- With joins
SELECT Last_Name, First_Name, Email
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON city.city_id = city.city_id
JOIN country ON country.country_id = country.country_id
WHERE country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
   -- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
   
SELECT title
FROM film
WHERE film_id IN(
				  SELECT film_id
                  FROM film_actor
                  WHERE actor_id = (SELECT actor_id
									FROM film_actor
									GROUP BY actor_id
									ORDER BY count(film_id) DESC
                                    LIMIT  1)
);


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT DISTINCT(title) AS Film_Name
FROM film
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
WHERE customer_id = (
					SELECT customer_id 
                    FROM payment
					GROUP BY customer_id
					ORDER BY SUM(amount) desc
                    limit 1);

-- 8. Customers who spent more than the average payments.











