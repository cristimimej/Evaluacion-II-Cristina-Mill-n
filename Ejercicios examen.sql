USE sakila;

#Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

#Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title, rating
FROM film
WHERE rating = 'PG-13';

#Encuentra el título y la descripción de todas las películas que contengan la cadena de caracteres "amazing" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

#Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length
FROM film
WHERE length >120
ORDER BY length ASC;

#Recupera los nombres y apellidos de todos los actores.
SELECT first_name, last_name
FROM actor;

#Encuentra el nombre y apellidos de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

#Encuentra los nombres y apellidos de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id BETWEEN 10
AND 20;

#Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating
FROM film
WHERE rating <> 'R'
AND rating <> 'PG-13';

#Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT rating, COUNT(*) AS total_películas
FROM film
GROUP BY rating;

#Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas
SELECT
c.customer_id,
c.first_name,
c.last_name,
COUNT(r.rental_id) AS total_peliculas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_peliculas DESC;

#Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT
c.name AS categoria,
COUNT(r.rental_id) AS total_peliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

#Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT
f.rating AS clasificacion,
AVG(length) AS Duracion_media
FROM film f
GROUP BY f.rating
ORDER BY Duracion_media ASC;

#Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
SELECT
a.first_name, 
a.last_name,
f.title
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title LIKE 'INDIAN LOVE%';

#Muestra el título de todas las películas que contengan la cadena de caracteres "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%dog%' OR '%cat%';

#Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
SELECT
a.first_name,
a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

#Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

#Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title, c.name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

#Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name, a.last_name,
COUNT(fa.film_id) AS peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >10
ORDER BY peliculas ASC;

#Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title, length, rating
FROM film
WHERE rating = 'R' AND length > 120
ORDER BY title ASC;

#Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c.name AS categoria,
AVG(f.length) AS duracion_media
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY categoria
HAVING AVG(f.length) >120;

#Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT a.first_name, a.last_name,
COUNT(fa.film_id) AS peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING peliculas >= 5
ORDER BY peliculas ASC;

#Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
SELECT film_id, title, rental_duration
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film
    WHERE rental_duration >5);
    
#Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
    );
    
#Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
SELECT title, length
FROM film
WHERE length >180
	AND film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Comedy'
    );