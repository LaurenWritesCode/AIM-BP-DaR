-- 
USE Fletnix_Database

use Fletnix_Database

/**********************************************************************************************************
	5A). Maak een ontwerp van het rapport dat de use case, zoals beschreven in bijlage A,
		 ondersteunt. Je mag je ontwerp deels baseren op de tabel in opdracht 4 maar zorg dat de use
		 case ondersteund wordt.
***********************************************************************************************************/
DROP VIEW IF EXISTS overview_n_and_w_per_award
GO
CREATE VIEW overview_n_and_w_per_award AS
SELECT M.movie_id, M.title, M.publication_year, AY.award, A.country, AY.year, AY.category, P.person_id, P.lastname, P.firstname, AY.code
FROM movie_FN M INNER JOIN awards_per_year_FN AY ON M.movie_id = AY.movie_id
				INNER JOIN award_show_FN A ON AY.award = A.award
				INNER JOIN person_FN P ON AY.person_id = P.person_id
GO

--SELECT * FROM overview_n_and_w_per_award WHERE title = 'Sleepy Hollow'

DROP VIEW IF EXISTS count_nominations
GO

CREATE VIEW count_nominations AS
SELECT  title, 
		count(*) AS nominations
FROM	overview_n_and_w_per_award
GROUP BY title
GO

select * from count_nominations

DROP VIEW IF EXISTS count_wins
GO
CREATE VIEW count_wins AS
SELECT  title, 
		count(*) AS wins
FROM	overview_n_and_w_per_award
WHERE	code ='W'
GROUP BY title
GO

select * from count_wins

DROP VIEW IF EXISTS overview_n_and_w_per_movie
GO
CREATE VIEW overview_n_and_w_per_movie AS
SELECT  distinct OPA.title,
		CN.nominations,
		CW.wins
FROM	overview_n_and_w_per_award OPA  LEFT JOIN count_nominations CN ON OPA.title = CN.title
										LEFT Join count_wins CW ON OPA.title = CW.title
GO

SELECT * FROM overview_n_and_w_per_movie ORDER BY title

/**********************************************************************************************************
	5A. De omzet die over een bepaalde periode (jaar – maand) gemaakt wordt (betaald versus nog
		niet betaald). Men wil die informatie graag per land zien maar ook per genre zodat duidelijk
		wordt of men meer budget aan reclame (in bepaalde landen) moet besteden en of men meer
		films van een bepaald genre moet inkopen.

		onderstaande statements zijn in jaren maar kunnen ook omgezet worden naar maanden.
***********************************************************************************************************/

-- gekeken films waar al wel voor betaald is per jaar --
DROP VIEW IF EXISTS payed_profit
GO 
CREATE VIEW payed_profit AS 
SELECT	  YEAR(W.watch_date) AS [year],
		  CU.country_name AS country,
		  SUM(W.price) AS payed_profit
FROM	  watchhistory_FN W LEFT JOIN customer_FN CU ON W.customer_mail_address = CU.customer_mail_address
							LEFT JOIN country_FN CO ON CU.country_name = CO.country_name
WHERE     invoiced = 1
GROUP BY  CU.country_name, YEAR(W.watch_date)
GO

-- gekeken films waar nog niet voor betaald is --

DROP VIEW IF EXISTS unpayed_profit
GO
CREATE VIEW unpayed_profit AS 
SELECT	  YEAR(W.watch_date) AS [year],
		  CU.country_name AS country,
		  SUM(W.price) AS unpayed_profit
FROM	  watchhistory_FN W LEFT JOIN customer_FN CU ON W.customer_mail_address = CU.customer_mail_address
							LEFT JOIN country_FN CO ON CU.country_name = CO.country_name
WHERE     invoiced = 0
GROUP BY  CU.country_name, YEAR(W.watch_date)
GO

-- totale omzet van films --
DROP VIEW IF EXISTS total_profit
GO
CREATE VIEW total_profit AS 
SELECT		P.country AS country,
			P.YEAR AS year,
			payed_profit,
			unpayed_profit,
			payed_profit - unpayed_profit AS total_profit
FROM		payed_profit P  LEFT OUTER JOIN unpayed_profit N ON P.country = N.country and P.[year] = N.[year]
GO

select * from total_profit

-- Spreiding genres --
DROP VIEW IF EXISTS genres_watched_per_country
GO 
CREATE VIEW genres_watched_per_country AS 
SELECT	  YEAR(W.watch_date) AS [year],
		  MG.genre_name AS genre,
		  count(*) as times_watched
FROM	  watchhistory_FN W LEFT JOIN movie_FN M ON W.movie_id = M.movie_id
							LEFT JOIN movie_genre_FN MG ON M.movie_id = MG.movie_id
WHERE	  MG.genre_name is not null
GROUP BY  MG.genre_name, YEAR(W.watch_date)
GO

select * from genres_watched_per_country


/**********************************************************************************************************
	5B. De geografische spreiding van klanten en inzicht in de abonnementsvormen per land. Men wil
		die informatie hebben zodat inzichtelijk wordt welke regio’s de afgelopen jaren sterk in
		opkomst zijn. Je mag ervan uitgaan dat de abonnementsvormen niet veranderen (we houden
		immers geen historie bij.
***********************************************************************************************************/

-- view to find all customers per country -- 
DROP VIEW IF EXISTS geo_spread_customers
GO
CREATE VIEW geo_spread_customers AS 
SELECT		CO.country_name AS country,
			count(CU.customer_mail_address) as customers
FROM		customer_FN CU LEFT OUTER JOIN country_FN CO on CO.country_name = CU.country_name
GROUP BY	CO.country_name
GO

-- select * from geo_spread_customers;

-- view to find the divide between contract types per country -- 
DROP VIEW IF EXISTS geo_spread_customers_per_subscription_kind
GO
CREATE VIEW geo_spread_customers_per_subscription_kind AS 
SELECT		CO.country_name AS country,
			count(CU.customer_mail_address) as customers_per_type,
			CU.contract_type
FROM		customer_FN CU LEFT OUTER JOIN country_FN CO on CO.country_name = CU.country_name
						   LEFT OUTER JOIN contract_FN CON on CU.contract_type = CON.contract_type
GROUP BY	CO.country_name, CU.contract_type
GO

--select * from geo_spread_customers_per_subscription_kind order by country;

/**********************************************************************************************************
	5C. Het aantal customers per abonnementsvorm dat in een periode (jaar) lid is geworden versus
		het aantal dat het abonnement heeft opgezegd. Men wil gevoel krijgen of FLETNIX nog
		steeds groeiende is, constant blijft of dat het aantal gebruikers juist afneemt. Men hoopt op
		een jaarlijkse groei van 6%. Het zou mooi zijn als het inzichtelijk gemaakt kan worden of die
		groei bereikt is/wordt..
***********************************************************************************************************/
DROP VIEW IF EXISTS customer_growth_per_contract_type_per_year
GO
CREATE VIEW customer_growth_per_contract_type_per_year AS	
SELECT		YEAR(CU.subscription_start) AS year,
			COUNT(CU.customer_mail_address) AS customers_per_type,
			CU.contract_type,
			COUNT(CU.subscription_start)	AS registrations, 
			COUNT(CU.subscription_end)		AS cancellations,
			COUNT(CU.subscription_start) - COUNT(subscription_end) AS total_growth
FROM		customer_FN CU LEFT OUTER JOIN contract_FN CON on CU.contract_type = CON.contract_type
GROUP BY	YEAR(subscription_start), CU.contract_type
GO

SELECT * FROM customer_growth_per_contract_type_per_year;

-- Deze 2 counts bij elkaar zijn 470 dus de query klopt.
-- select sum(registrations) - sum(cancellations) from customer_growth_per_contract_type_per_year;
-- select count(customer_mail_address) from customer_FN where subscription_end < getdate();


/**********************************************************************************************************
	5D.	Men heeft het gevoel dat de groei van abonnees in de leeftijdscategorie 50 - 75 jarigen achter
		blijft ten opzichte van de leefstijdscategorie 25 - 50. Men wil dit gevoel kunnen toetsen door
		één of meerdere overzichten te krijgen.
***********************************************************************************************************/

DROP FUNCTION IF EXISTS calculate_age
GO

CREATE FUNCTION calculate_age (@birth_date DATE, @time_passed DATE) 
returns int
with SCHEMABINDING
as
begin

declare @iMonthDayDob int
declare @iMonthDayPassedDate int


select @iMonthDayDob = CAST(datepart (mm,@birth_date) * 100 + datepart  (dd,@birth_date) AS int) 
select @iMonthDayPassedDate = CAST(datepart (mm,@time_passed) * 100 + datepart  (dd,@time_passed) AS int) 

return DateDiff(yy,@birth_date, @time_passed) 
- CASE WHEN @iMonthDayDob <= @iMonthDayPassedDate
  THEN 0 
  ELSE 1
  END

End
go

-- select customer_mail_address, dbo.calculate_age(birth_date, getdate()) as age from customer_FN;

DROP VIEW IF EXISTS c_age_25_to_50
GO
CREATE VIEW c_age_25_to_50 AS
SELECT	customer_mail_address, 
		dbo.calculate_age(birth_date, getdate()) as age,
		'25 to 50' as age_group
FROM	customer_FN
WHERE	dbo.calculate_age(birth_date, getdate()) BETWEEN 25 AND 51
GO
SELECT count(*) FROM c_age_25_to_50;

DROP VIEW IF EXISTS c_age_50_to_75
GO
CREATE VIEW c_age_50_to_75 AS
SELECT	customer_mail_address, 
		dbo.calculate_age(birth_date, getdate()) as age,
		'50 to 75' as age_group
FROM	customer_FN
WHERE	dbo.calculate_age(birth_date, getdate()) BETWEEN 50 AND 76
GO
