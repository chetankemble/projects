-- USE lco_films;

-- SHOW TABLES;

USE lco_films;

-- Q1) Which categories of movies released in 2018? Fetch with the number of movies. 

SELECT category.name, category.category_id,film.release_year, film.film_id, COUNT(category.category_id) AS number_of_films FROM category 
LEFT JOIN film_category ON film_category.category_id = category.category_id 
RIGHT JOIN film ON film.film_id = film_category.film_id 
WHERE film.release_year = "2018" 
GROUP BY category.category_id;

-- Q2) Update the address of actor id 36 to “677 Jazz Street”.

UPDATE `address` INNER JOIN actor ON actor.address_id=address.address_id 
SET `address`="677 Jazz Street" 
WHERE actor.actor_id=36

--  question no. 3) Add the new actors (id : 105 , 95) in film  ARSENIC INDEPENDENCE (id:41).
INSERT INTO `film_actor`(`actor_id`, `film_id`) 
VALUES (105,41) , (95,41) 
ON DUPLICATE KEY UPDATE
film_id = VALUES(film_id) , actor_id = VALUES(actor_id);

-- question no. 4 ) Get the name of films of the actors who belong to India.
SELECT DISTINCT film.title 
from film 
INNER JOIN film_actor on film.film_id= film_actor.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id  
INNER JOIN address ON address.address_id = actor.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'india' ;

-- question no. 5) How many actors are from the United States?
SELECT  count(*)
FROM actor
INNER JOIN address ON address.address_id = actor.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'United States' ;
 
-- question no. 6) Get all languages in which films are released in the year between 2001 and 2010.
SELECT language.name, film.release_year,count(language.language_id) AS 'movies(2001-2010movies)'
from film 
INNER JOIN language ON language.language_id = film.language_id
WHERE film.release_year between 2001 and 2010
group by language.name;


SELECT language.name,film.release_year, COUNT(language.language_id) AS number_of_films 
FROM language 
LEFT JOIN film ON film.language_id = language.language_id 
WHERE film.release_year BETWEEN 2001 AND 2010 
GROUP BY language.language_id;

-- question no. 7) The film ALONE TRIP (id:17) was actually released in Mandarin, update the info.
Update `language` INNER JOIN film on language.language_id = film.language_id 
SET language.name = 'Mandarin' where film.film_id= 17;
-- question no. 8) Fetch cast details of films released during 2005 and 2015 with PG rating.
select concat(actor.first_name, " ",actor.last_name) AS ACTOR_NAME,
film.title,film.release_year,
film.rating AS PG_RATING
from ((film  
INNER JOIN film_actor on film.film_id = film_actor.film_id)
INNER JOIN actor on actor.actor_id = film_actor.actor_id)
where film.release_year between 2005 and 2015 and film.rating= 'PG';
-- question no. 9) In which year most films were released?

select title,release_year,count(release_year) AS movies from film 
group by release_year
order by  count(release_year) desc limit 1 ;

select  release_year,count( film_id) AS movies from film 
group by 1
order by  2 desc limit 1 ;

SELECT film.title,film.release_year, COUNT(film.release_year) AS no_of_films 
FROM `film` 
GROUP BY (film.release_year) 
ORDER BY COUNT(film.release_year) DESC LIMIT 1;



-- question no. 10) In which year most films were released?

select title,release_year,count(release_year) AS movies from film 
group by release_year
order by  count(release_year) asc limit 1 ;



-- question no. 11) Get the details of the film with maximum length released in 2014 .

select *, language.name AS LANGUAGE 
FROM (film
INNER JOIN language on film.language_id=language.language_id )
where release_year = '2014' 
order by `length` desc limit 1;

-- question no. 12) Get all Sci- Fi movies with NC-17 ratings and language they are screened in.

select film.film_id,film.title,film.rating,film.description,film.release_year,
film.length, category.name as genre,
language.name AS language
FROM (((film 
LEFT JOIN language on language.language_id = film.language_id)
LEFT JOIN film_category ON film_category.film_id = film.film_id)
LEFT JOIN Category on category.category_id = film_category.category_id )
WHERE category.name = 'Sci-Fi' and film.rating = 'NC-17';


-- question no. Q13) The actor FRED COSTNER (id:16) shifted to a new address

 INSERT INTO city(`city`,`country_id`)values ('Florence',(SELECT Country_id from country where country= 'Italy')) ;


desc city;

UPDATE
address INNER JOIN actor on address.address_id = actor.address_id 
SET  
address.address = "055,  Piazzale Michelangelo ",
address.district = 'Rifredi',
address.city_id = (SELECT city_id FROM city WHERE city.city = "Florence") , 
address.postal_code = "50125" WHERE actor.actor_id = 16;


-- question no. Q14) A new film “No Time to Die” is releasing in 2020 whose details are : 

INSERT INTO `film` 
(title,`description`,release_year,Language_id,original_language_id,
rental_duration,rental_rate,length,replacement_cost,rating,special_features)
VALUES
('No Time to Die',
"Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, who's armed with a dangerous new technology",
'2020',
(SELECT language_id FROM language WHERE name = 'English'),
(SELECT language_id FROM language WHERE name = 'English'),
6,
3.99,
100,
20.99,
'PG-13',
'Trailers,Deleted Scenes');


-- question no. Q15) Assign the category Action, Classics, Drama  to the movie “No Time to Die” .



INSERT INTO `film_category`(film_id,category_id)
VALUES
((select film_id from film where title = 'No Time to Die'),(select category_id from category WHERE name = 'Action') ),
((select film_id from film where title = 'No Time to Die'),(select category_id from category WHERE name = 'Classics')),
((select film_id from film where title = 'No Time to Die'),(select category_id from category WHERE name = 'Drama'));

select category.category_id,film.film_id ,category.name,film.title
from ((film 
left join film_category on film_category.film_id = film.film_id)
left join category on film_category.category_id = category.category_id)
where title = 'No Time to Die' ;

-- question no. Q16) Assign the cast: PENELOPE GUINESS, NICK WAHLBERG, JOE SWANK to the movie “No Time to Die” .

INSERT INTO film_actor(film_id,actor_id)
VALUES 
((select film_id from film where title = 'No Time to Die'),(select actor_id from actor where first_name = "PENELOPE" AND last_name = "GUINESS")),
((select film_id from film where title = 'No Time to Die'),(select actor_id from actor where  first_name = "NICK" AND last_name = "WAHLBERG")),
((select film_id from film where title = 'No Time to Die'),(select actor_id from actor where first_name = "JOE" AND last_name = "SWANK"));

SELECT  film.title, film.film_id,actor.first_name,actor.last_name
from ((film 
inner join film_actor on film.film_id= film_actor.film_id)
inner join actor on actor.actor_id = film_actor.actor_id)
where film.title = 'No Time to Die' ; 


-- question no. Q17) Assign a new category Thriller  to the movie ANGELS LIFE.

INSERT INTO Category(name) values ('Thriller');

INSERT INTO `film_category`(film_id,category_id)
VALUES
((select film_id from film where film.title = 'ANGELS LIFE'),(select category_id from category WHERE category.name = 'Thriller')) ;

select category.category_id,film.film_id ,category.name,film.title
from ((film 
left join film_category on film_category.film_id = film.film_id)
left join category on film_category.category_id = category.category_id)
where title = 'ANGELS LIFE' ;

-- question no. Q18) Which actor acted in most movies?

SELECT film_actor.actor_id,actor.first_name,actor.last_name,count(film.film_id)AS numb_of_movies	
from ((film 
INNER JOIN film_actor on film.film_id = film_actor.film_id)
inner join actor on actor.actor_id = film_actor.actor_id)
group by film_actor.actor_id
order by 4 desc limit 1

SELECT actor_id, COUNT(actor_id) FROM `film_actor`
GROUP BY actor_id 
 ORDER BY COUNT(actor_id) DESC LIMIT 1;

-- question no.Q19) The actor JOHNNY LOLLOBRIGIDA was removed from the movie GRAIL FRANKENSTEIN. How would you update that record?
DELETE from film_actor where film_id =(SELECT film_id from film where title="GRAIL FRANKENSTEIN") 
AND
actor_id =(SELECT Actor_id from actor where actor.first_name ="JOHNNY" AND actor.last_name = "LOLLOBRIGIDA");

-- question no. Q20) The HARPER DYING movie is an animated movie with Drama and Comedy. Assign these categories to the movie.
INSERT INTO `film_category`(film_id,category_id)
VALUES
((select film_id from film where title = 'HARPER DYING'),(select category_id from category WHERE name = 'Drama') ),
((select film_id from film where title = 'HARPER DYING'),(select category_id from category WHERE name = 'Comedy'));

select category.category_id,film.film_id ,category.name,film.title
from ((film 
left join film_category on film_category.film_id = film.film_id)
left join category on film_category.category_id = category.category_id)
where title = 'HARPER DYING' ;

-- question no. Q21) The entire cast of the movie WEST LION has changed. 
--                   The new actors are DAN TORN, MAE HOFFMAN, SCARLETT DAMON. How would you update the record in the safest way?
DELETE FROM `film_actor` WHERE film_id = (SELECT film_id FROM film WHERE film.title = "WEST LION");

INSERT INTO film_actor(film_id,actor_id)
VALUES 
((select film_id from film where title = 'WEST LION'),(select actor_id from actor where first_name = "DAN" AND last_name = "TORN")),
((select film_id from film where title = 'WEST LION'),(select actor_id from actor where  first_name = "MAE" AND last_name = "HOFFMAN")),
((select film_id from film where title = 'WEST LION'),(select actor_id from actor where first_name = "SCARLETT" AND last_name = "DAMON"));

SELECT  film.title, film.film_id,actor.first_name,actor.last_name
from ((film 
inner join film_actor on film.film_id= film_actor.film_id)
inner join actor on actor.actor_id = film_actor.actor_id)
where film.title = 'WEST LION' ; 

-- question no. Q22) The entire category of the movie WEST LION was wrongly inserted. 
               -- The correct categories are Classics, Family, Children. How would you update the record ensuring no wrong data is left?

DELETE FROM Film_category where film_id = (SELECT film_id FROM film WHERE film.title = "WEST LION");

INSERT INTO `film_category`(film_id,category_id)
VALUES
((select film_id from film where title = 'WEST LION'),(select category_id from category WHERE name = 'Family') ),
((select film_id from film where title = 'WEST LION'),(select category_id from category WHERE name = 'Classics')),
((select film_id from film where title = 'WEST LION'),(select category_id from category WHERE name = 'Children'));

select category.category_id,film.film_id ,category.name,film.title
from ((film 
left join film_category on film_category.film_id = film.film_id)
left join category on film_category.category_id = category.category_id)
where title = 'WEST LION' ;

-- question no. Q23) How many actors acted in films released in 2017?

SELECT  film.release_year, count(film_actor.actor_id)AS NUMBER_OF_ACTORS
FROM film
INNER JOIN film_actor on film.film_id = film_actor.film_id
where film.release_year = '2017'
group by film.release_year

SELECT COUNT(*) FROM `film_actor` 
INNER JOIN film ON film.film_id=film_actor.film_id 
WHERE film.release_year = 2017;

-- question no.Q24) How many Sci-Fi films released between the year 2007 to 2017?

SELECT  count(Film.film_id)AS num_of_movies
FROM Film
INNER join film_category on film.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id 
where film.release_year between 2007 and 2017 and category.name= "Sci-Fi"

SELECT COUNT(*) 
FROM `film_category` 
INNER JOIN film ON film.film_id=film_category.film_id 
INNER JOIN category ON category.category_id=film_category.category_id 
WHERE film.release_year BETWEEN 2007 AND 2017 AND category.name="Sci-Fi";

-- question no. Q25) Fetch the actors of the movie WESTWARD SEABISCUIT with the city they live in.

SELECT actor.actor_id,actor.first_name,actor.last_name,Film.title, city.city
from film 
inner join film_actor on film_actor.film_id= film.film_id
inner join actor on film_actor.actor_id = actor.actor_id
inner join address on address.address_id = actor.address_id
inner join city on address.city_id = city.city_id
where film.title = "WESTWARD SEABISCUIT"

SELECT actor.first_name ,actor.last_name , film.title , city.city 
FROM film_actor 
INNER JOIN actor ON actor.actor_id = film_actor.actor_id 
INNER JOIN address ON address.address_id = actor.address_id 
INNER JOIN city ON city.city_id = address.address_id 
INNER JOIN film ON film.film_id = film_actor.film_id 
WHERE film.title="WESTWARD SEABISCUIT"; 

-- question no. Q26) What is the total length of all movies played in 2008?
select sum(film.length) as total_length from film where film.release_year = '2008'

-- question no. 27 ) Which film has the shortest length? In which language and year was it released?

SELECT film.title, film.length,language.name,film.release_year
from film 
Inner join `language` on film.language_id = language.language_id
group by film.length
order by 2 ASC limit 1;

SELECT language.name, film.title, film.release_year, film.length
FROM `film` 
LEFT JOIN language ON language.language_id=film.language_id 
WHERE film.length = (SELECT MIN(film.length) FROM film);

-- Q28) How many movies were released each year?

SELECT distinct release_year , count(*)AS numb_of_movies
from film group by release_year;

SELECT film.release_year, COUNT(film.film_id) AS number_of_films FROM `film` GROUP BY film.release_year;

-- Q29)  How many languages of movies were released each year?.
SELECT  film.release_year,language.name, count(film.film_id) as num_of_films
FROM film 
INNER JOIN `language` on language.language_id  = film.language_id
group by language.name, film.release_year;

SELECT language.name, COUNT(film.language_id) AS number_of_films 
FROM `film` 
INNER JOIN language ON language.language_id = film.language_id 
GROUP BY film.language_id;


-- Q30) Which actor did least movies?

SELECT actor.first_name ,actor.last_name , count(film_actor.film_id)as num_of_film
from (film_actor 
INNER JOIN Actor on film_actor.actor_id = Actor.actor_id)
group by actor.actor_id
order by 3 ASC limit 1;

SELECT actor_id, COUNT(actor_id) 
FROM `film_actor` 
GROUP BY actor_id 
ORDER BY COUNT(actor_id) ASC LIMIT 1;


