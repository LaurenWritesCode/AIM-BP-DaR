
/* -- CREATE SCRIPT -- */
	
USE master
DROP DATABASE IF EXISTS Fletnix_Database -- Als Fletnix_Database bestaat: verwijder Fletnix_Database
GO

CREATE DATABASE Fletnix_Database -- Maak Fletnix_Database 
GO

/*************************************************************************

	Onderstaande statements bevatten:
		- Casus Opdracht 1A Implementatie van het logisch rationeel schema
		- Casus Opdracht 1B Definitie van business rules
		- Casus Opdracht 1C Zelf bedachte constraints
		- Casus Opdracht 1D Implementatie update en delete regels 

**************************************************************************/

USE Fletnix_Database -- onderstaande staments hebben effect op Fletnix_Database

CREATE TABLE movie_FN (
	movie_id		  INT				NOT NULL, 
	title			  VARCHAR(255)		NOT NULL,
	duration		  INT				NULL,
	description		  VARCHAR(255)		NULL,
	publication_year  INT				NULL,
	cover_image		  VARCHAR(255)		NULL,
	previous_part	  INT				NULL,
	price			  NUMERIC(5,2)		NOT NULL, 
	url				  VARCHAR(255)		NULL,

	CONSTRAINT	pk_movie_FN PRIMARY KEY (movie_id),
	CONSTRAINT	ck_movie_publication_year_FN CHECK (publication_year BETWEEN 1890  AND DATEPART(YEAR,GETDATE())), 
	CONSTRAINT  ck_movie_price_FN CHECK (price > 0), -- prijs moet groter zijn dan 0 euro/ eigen constraint 
	CONSTRAINT  fk_movie_previous_part_FN FOREIGN KEY (previous_part) REFERENCES movie_FN(movie_id)
				ON UPDATE no action 
				ON DELETE no action
);

CREATE TABLE person_FN (
	person_id	INT			 NOT NULL,
	lastname	VARCHAR(50)  NOT NULL,
	firstname	VARCHAR(50)  NOT NULL,
	gender		CHAR(1)		 NULL,

	CONSTRAINT  pk_person_id_FN PRIMARY KEY (person_id),
	CONSTRAINT  ck_person_gender_FN CHECK (gender IN ('M','F'))
);

CREATE TABLE movie_cast_FN (
	movie_id	INT				NOT NULL,
	person_id	INT				NOT NULL,
	role		VARCHAR(255)	NOT NULL,

	CONSTRAINT	pk_movie_cast_FN PRIMARY KEY (movie_id, person_id, role),
	CONSTRAINT	fk_movie_cast_movie_id_FN FOREIGN KEY (movie_id) REFERENCES movie_FN(movie_id)
				ON UPDATE cascade
				ON DELETE cascade,
	CONSTRAINT  fk_movie_cast_person_id_FN FOREIGN KEY (person_id) REFERENCES person_FN(person_id)
				ON UPDATE cascade
				ON DELETE cascade,
);

CREATE TABLE movie_director_FN (
	movie_id	INT		NOT NULL,
	person_id	INT		NOT NULL,

	CONSTRAINT  pk_movie_director_FN PRIMARY KEY (movie_id, person_id),
	CONSTRAINT  fk_movie_director_movie_id_FN FOREIGN KEY (movie_id) REFERENCES movie_FN(movie_id)
				ON UPDATE cascade
				ON DELETE cascade,
	CONSTRAINT  fk_movie_director_person_id_FN FOREIGN KEY (person_id) REFERENCES person_FN(person_id)
				ON UPDATE cascade
				ON DELETE cascade,
);

CREATE TABLE genre_FN (
	genre_name	 VARCHAR(255)	NOT NULL,
	description  VARCHAR(255)	NULL, 
	
	CONSTRAINT  pk_genre_FN PRIMARY KEY (genre_name),
);

CREATE TABLE movie_genre_FN (
	movie_id	INT			  NOT NULL,
	genre_name	VARCHAR(255)  NOT NULL,
	
	CONSTRAINT  pk_movie_genre_FN PRIMARY KEY (movie_id, genre_name),
	CONSTRAINT  fk_movie_genre_movie_id_FN FOREIGN KEY (movie_id) REFERENCES movie_FN (movie_id)
				ON UPDATE cascade
				ON DELETE cascade,
	CONSTRAINT  fk_movie_genre_genre_name_FN FOREIGN KEY (genre_name) REFERENCES genre_FN (genre_name)
				ON UPDATE cascade
				ON DELETE cascade,
);

CREATE TABLE payment_FN (
	payment_method	VARCHAR(10)	 NOT NULL,
	
	CONSTRAINT  pk_payment_FN PRIMARY KEY (payment_method)
);

CREATE TABLE contract_FN (
	contract_type		 VARCHAR(10)	NOT NULL,
	price_per_month		 NUMERIC(5,2)	NOT NULL,
	discount_percentage  NUMERIC(2)		NOT NULL

	CONSTRAINT pk_contract_FN PRIMARY KEY (contract_type)
);

CREATE TABLE country_FN (
	country_name   VARCHAR(50)  NOT NULL
	
	CONSTRAINT pk_country_FN PRIMARY KEY (country_name)
);

CREATE TABLE customer_FN (
	customer_mail_address   VARCHAR(255)	NOT NULL,
	lastname				VARCHAR(50)		NOT NULL,
	firstname				VARCHAR(50)		NOT NULL,
	payment_method			VARCHAR(10)		NOT NULL,
	payment_card_number		VARCHAR(30)		NOT NULL,
	contract_type			VARCHAR(10)		NOT NULL,
	subscription_start		DATE			NOT NULL,
	subscription_end		DATE			NULL,
	user_name				VARCHAR(30)		NOT NULL,
	password				VARCHAR(50)		NOT NULL,
	country_name			VARCHAR(50)		NOT NULL,
	gender					CHAR(1)			NULL,
	birth_date				DATE			NULL,

	CONSTRAINT  pk_customer_FN PRIMARY KEY (customer_mail_address),
	CONSTRAINT  ck_customer_subscription_start_FN CHECK (subscription_start <= subscription_end),
	CONSTRAINT  ck_customer_user_name_FN UNIQUE (user_name),
	CONSTRAINT  ck_customer_birth_date_FN CHECK (birth_date < subscription_start), -- Klant moet geboren zijn voor het abbonoment in gaat. Eigen constraint
	CONSTRAINT  ck_customer_gender_FN CHECK (gender IN ('M','F')), -- geslacht moet M of F zijn / eigen constraint
	CONSTRAINT  ck_customer_mail_address_FN CHECK (customer_mail_address LIKE '%@%'), -- er moet een @ in het email adres staan / eigen constraint
	CONSTRAINT  fk_customer_payment_FN FOREIGN KEY (payment_method) REFERENCES payment_FN (payment_method)
				ON UPDATE cascade
				ON DELETE cascade,
	CONSTRAINT  fk_customer_contract_FN FOREIGN KEY (contract_type) REFERENCES contract_FN (contract_type)
				ON UPDATE cascade
				ON DELETE cascade,
	CONSTRAINT  fk_customer_country_FN FOREIGN KEY (country_name) REFERENCES country_FN (country_name)
				ON UPDATE cascade
				ON DELETE cascade,
);

GO
CREATE FUNCTION dbo.CheckDatum (@watchDate date, @customer_mail_address varchar(255))
	RETURNS INT
	AS BEGIN 
		DECLARE @result int;
		SELECT @result = count(*)
		FROM dbo.customer_FN
		WHERE customer_mail_address = @customer_mail_address
		AND @watchDate between subscription_start and isnull(subscription_end, getdate())
	RETURN @result;
END;
GO

CREATE TABLE watchhistory_FN (
	movie_id			    INT				NOT NULL,
	customer_mail_address	VARCHAR(255)	NOT NULL,
	watch_date				DATE			NOT NULL,
	price					NUMERIC(5,2)	NOT NULL,
	invoiced				BIT				NOT NULL
	
	CONSTRAINT  pk_watchhistory_FN PRIMARY KEY (movie_id, watch_date, customer_mail_address) WITH (IGNORE_DUP_KEY = ON), -- WITH toegevoegd 
	CONSTRAINT  ck_watchdate_FN CHECK (dbo.CheckDatum(watch_date, customer_mail_address) = 1),
	CONSTRAINT  fk_watchhistory_movie_id_FN FOREIGN KEY (movie_id) REFERENCES movie_FN (movie_id)
				ON UPDATE cascade
				ON DELETE no action,
	CONSTRAINT  fk_watchhistory_customer_mail_address_FN FOREIGN KEY (customer_mail_address) REFERENCES customer_FN (customer_mail_address)
				ON UPDATE cascade
				ON DELETE no action,
);




