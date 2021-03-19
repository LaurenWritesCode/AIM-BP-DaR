/* --SELECT SCRIPT-- */ 


/************************************************************************* 

Onderstaand script bevat: 
Casus Opdracht 3: Queries voor het genereren van overzichten. 

**************************************************************************/ 


USE fletnix_database
GO


-- A. Alle films gesorteerd naar genre --
SELECT   movie_fn.title, 
         movie_fn.publication_year, 
         movie_genre_fn.genre_name 
FROM     movie_fn, 
         movie_genre_fn 
WHERE    movie_fn.movie_id = movie_genre_fn.movie_id 
ORDER BY genre_name ASC; 

-- B. Alle movies die tussen 1990 en 2010 geproduceerd zijn. --
SELECT   * 
FROM     movie_fn 
WHERE    publication_year BETWEEN 1990 AND      2010 
ORDER BY publication_year ASC, 
         movie_id ASC; 

-- C. Alle klanten die op dit moment actief zijn --
SELECT   lastname, 
         firstname, 
         subscription_start 
FROM     customer_fn 
WHERE    subscription_end IS NULL 
OR       subscription_end > Getdate() 
ORDER BY subscription_end; 

-- D. De cast uit alle Terminator movies uit het jaar 1991 --
SELECT   movie_fn.movie_id, 
         movie_fn.title, 
         person_fn.firstname, 
         person_fn.lastname, 
         movie_cast_fn.role 
FROM     movie_fn, 
         person_fn, 
         movie_cast_fn 
WHERE    person_fn.person_id = movie_cast_fn.person_id 
AND		 title LIKE 'terminator%' 
AND      publication_year = 1991; 

-- E. Alle movies waarin de acteur “Arnold Schwarzenegger” een rol speelt --
SELECT   title, 
         publication_year 
FROM	 movie_fn 
WHERE    movie_id IN 
         (    SELECT movie_id 
              FROM   movie_cast_fn 
              WHERE  person_id IN 
                     (      SELECT person_id 
                            FROM   person_fn 
                            WHERE  firstname = 'Arnold' 
                            AND    lastname = 'Schwarzenegger')); 

-- F. Alle gebruikers met openstaande kosten --
DROP VIEW IF EXISTS outstanding_charges
GO

CREATE VIEW outstanding_charges (firstname, lastname, total) AS 
SELECT          c.firstname, 
                c.lastname, 
                Sum(w.price) AS total 
FROM            customer_fn c 
LEFT OUTER JOIN watchhistory_fn w 
ON              C.customer_mail_address = W.customer_mail_address 
WHERE           W.invoiced = 0 
GROUP BY        C.lastname, 
                C.firstname,
				C.customer_mail_address
GO

SELECT firstname, 
       lastname, 
       total 
FROM   outstanding_charges 
ORDER  BY 3 DESC; 

-- G. Toon 100 movies die tot nu toe het minst bekeken zijn, gesorteerd naar het aantal keren dat ze gekeken werden. --
DROP VIEW IF EXISTS views_per_movie
GO

CREATE VIEW views_per_movie (title, number_of_views) AS  
SELECT          TOP(100) m.title, 
	            COUNT(w.watch_date) AS number_of_views
FROM            movie_FN m LEFT OUTER JOIN watchhistory_FN w
ON              m.movie_id = w.movie_id
GROUP BY		m.movie_id, m.title
GO

SELECT title, 
	   number_of_views
FROM   views_per_movie
ORDER  BY number_of_views ASC; 

-- H. Alle movies die in de afgelopen twee maanden het meest bekeken zijn, gesorteerd naar het aantal keren dat ze gekeken werden. --DROP VIEWIF EXISTS views_in_last_two_monthsgoCREATE VIEW views_in_last_two_months 
DROP VIEW IF EXISTS views_in_last_two_months
GO

CREATE VIEW views_in_last_two_months (title, publication_year, number_of_views) AS	
SELECT          m.title, m.publication_year, COUNT(w.watch_date) AS number_of_views
FROM            movie_FN m INNER JOIN watchhistory_FN w
				ON m.movie_id = w.movie_id
WHERE			watch_date >= DATEADD(MM,-2,GETDATE())
GROUP BY		m.movie_id, m.title, m.publication_year
HAVING			COUNT(W.watch_date) >= 1
GO

SELECT title, 
	   publication_year, 
	   number_of_views
FROM   views_in_last_two_months
ORDER  BY 3 DESC; 

-- I. Alle movies die meer dan 8 genres hebben --
SELECT m.title, 
       m.publication_year 
FROM   movie_fn m 
       INNER JOIN movie_genre_fn g 
               ON m.movie_id = g.movie_id 
GROUP  BY m.movie_id,
		  m.title, 
          m.publication_year 
HAVING Count(g.genre_name) > 8; 

-- J. Alle vrouwen die in Horror movies en Family movies gespeeld hebben -- // BEDOELEN ZE HIER VROUWEN DIE IN ALLEBIJ HEBBEN GESPEELD?????????
SELECT firstname, 
       lastname 
FROM   person_fn 
WHERE  person_id IN 
       (      SELECT person_id 
              FROM   movie_cast_fn 
              WHERE  movie_id IN 
                     (      SELECT movie_id 
                            FROM   movie_genre_fn 
                            WHERE  genre_name = 'Horror' 
                            OR     genre_name = 'Family')) 
AND    gender = 'F';
--!!!!!!!---

-- K. De director die tot nu toe de meeste films geproduceerd heeft --
SELECT     firstname, 
           lastname, 
           Count(*) AS number_of_films 
FROM       person_fn p 
INNER JOIN movie_director_fn d 
ON         p.person_id = d.person_id 
GROUP BY   p.person_id,
		   firstname, 
           lastname 
HAVING     Count(*) >= ALL 
           (	    SELECT   Count(*) 
                    FROM     movie_director_fn 
                    GROUP BY person_id); 

-- L. Alle Genres en het percentage dat de films uit het bepaalde genre uitmaken t.o.v. het totale aantal films [genre, percentage],
-- gesorteerd op meest populaire genre --
DROP VIEW IF EXISTS film_percentage_per_genre
GO

CREATE VIEW film_percentage_per_genre AS 
SELECT        genre_name, 
              (		Count(*) * 100.0 / 
              (		SELECT Count(*) 
					FROM   movie_genre_fn)) AS percentage 
FROM		  movie_genre_fn 
GROUP BY      genre_name
GO

SELECT	 genre_name, 
         percentage 
FROM     film_percentage_per_genre 
ORDER BY percentage DESC;

-- M. Gebruikers [mail_adress] en het gemiddelde aantal films die elke gebruiker per dag kijkt.
DROP VIEW IF EXISTS films_per_day
GO
CREATE VIEW films_per_day
AS	SELECT customer_mail_address, watch_date, COUNT(*) AS films_per_day 
	FROM watchhistory_FN 
	GROUP BY customer_mail_address, watch_date 
GO

DROP VIEW IF EXISTS date_count
GO
CREATE VIEW date_count
AS	SELECT customer_mail_address, COUNT(*) AS date_count
	FROM films_per_day
	GROUP BY customer_mail_address
GO

DROP VIEW IF EXISTS films_per_customer
GO
CREATE VIEW films_per_customer
AS	SELECT customer_mail_address, SUM(films_per_day) AS films_per_customer
	FROM films_per_day
	GROUP BY customer_mail_address
GO

DROP VIEW IF EXISTS film_average_per_customer
GO
CREATE VIEW film_average_per_customer
AS	SELECT films_per_customer.customer_mail_address, films_per_customer / date_count AS average
	FROM films_per_customer, date_count
	WHERE films_per_customer.customer_mail_address = date_count.customer_mail_address
GO

SELECT * FROM film_average_per_customer WHERE average >= 2