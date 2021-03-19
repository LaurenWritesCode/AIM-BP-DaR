/* --CONVERSIE SCRIPT-- */

/*************************************************************************

	Onderstaand script bevat:
		 Casus Opdracht 2:
				A. Maak de delete statements die de gehele FLETIX database in de juiste volgorde leegmaakt.
				B. Schrijf het conversiescript voor de Parent-tabellen (domein-tabellen) van FLETNIX 
						o Person
						o Movie
						o Customer 
						o Genre
				C. Schrijf het conversiescript voor het vullen van de Child-tabellen.

**************************************************************************/

USE Fletnix_Database;

--A Tabelen leeg maken --
DELETE FROM watchhistory_FN;
DELETE FROM customer_FN;
DELETE FROM country_FN;
DELETE FROM contract_FN;
DELETE FROM payment_FN;
DELETE FROM movie_genre_FN;
DELETE FROM genre_FN;
DELETE FROM movie_director_FN;
DELETE FROM movie_cast_FN;
DELETE FROM movie_FN;
DELETE FROM person_FN;

--MOVIE--
INSERT INTO Fletnix_Database.dbo.movie_FN
	SELECT DISTINCT 
	CAST  ( Id AS INT) AS movie_id,
	LEFT  (Name,255) AS title,
	NULL  AS duration, 
	NULL  AS description,
	CAST  (year AS INT) AS publication_year,
	NULL  AS cover_image, 
	NULL  AS previous_part,
	price = 3.50, --universele film prijs--
	NULL  AS url
	FROM  MYIMDB.dbo.Imported_Movie;

--PERSON--
INSERT INTO Fletnix_Database.dbo.person_FN
	SELECT 
	CAST  ( Id AS int) AS person_id,
	LEFT  (Lname,50) AS lastname,
	LEFT  (Fname,50) AS firstname,
	LEFT  (Gender, 1) AS gender
	FROM   MYIMDB.dbo.Imported_Person; 

INSERT INTO Fletnix_Database.dbo.person_FN
	SELECT 
	CAST  ( Id + 1000000 AS int) AS person_id, -- Id ophogen met 1000000 om PK violation te voorkomen
	LEFT  (Lname,50) AS lastname ,
	LEFT  (Fname,50) AS firstname ,
	NULL   AS gender
	FROM   MYIMDB.dbo.Imported_Directors;

--MOVIE CAST--
INSERT INTO Fletnix_Database.dbo.movie_cast_FN
	SELECT DISTINCT
	CAST  (Mid AS int) AS movie_id,
	CAST  (Pid AS int) AS person_id,
	LEFT  (Role,255) AS role
	FROM   MYIMDB.dbo.Imported_Cast;

--MOVIE DIRECTOR--
INSERT INTO Fletnix_Database.dbo.movie_director_FN
	SELECT 
	CAST  (Mid as int) as movie_id,				
	CAST  (Did + 1000000 as int) as person_id -- Id ophogen met 1000000 om PK violation te voorkomen
	FROM  MYIMDB.dbo.Imported_Movie_Directors;

--GENRE--
INSERT INTO Fletnix_Database.dbo.genre_FN
	SELECT DISTINCT 
	LEFT  (Genre,255) AS genre_name,
	NULL  as description
	FROM  MYIMDB.dbo.Imported_Genre;

--MOVIE GENRE--
INSERT INTO Fletnix_Database.dbo.movie_genre_FN
	SELECT DISTINCT
	CAST  (Id AS int) AS movie_id,
	left  (Genre,255) AS genre_name
	FROM  MYIMDB.dbo.Imported_Genre;

--PAYMENT--
INSERT INTO Fletnix_Database.dbo.payment_FN
VALUES  ('Amex'),
		('Chase'),
		('Discover'),
		('Mastercard'),
		('Visa');

--CONTRACT--
INSERT INTO Fletnix_Database.dbo.contract_FN
VALUES  ('Basic', 6, 0),
		('Premium', 12, 12.5),
		('Pro', 18, 25);

--COUNTRY--
INSERT INTO Fletnix_Database.dbo.country_FN
VALUES  ('Afghanistan'),
		('Aland Islands'),
		('Albania'),
		('Algeria'),
		('American Samoa'),
		('Andorra'),
		('Angola'),
		('Anguilla'),
		('Antarctica'),
		('Antigua and Barbuda'),
		('Argentina'),
		('Armenia'),
		('Aruba'),
		('Australia'),
		('Austria'),
		('Azerbaijan'),
		('Bahamas'),
		('Bahrain'),
		('Bangladesh'),
		('Barbados'),
		('Belarus'),
		('Belgium'),
		('Belize'),
		('Benin'),
		('Bermuda'),
		('Bhutan'),
		('Bolivia'),
		('Bonaire, Sint Eustatius and Saba'),
		('Bosnia and Herzegovina'),
		('Botswana'),
		('Bouvet Island'),
		('Brazil'),
		('British Indian Ocean Territory'),
		('Brunei'),
		('Bulgaria'),
		('Burkina Faso'),
		('Burundi'),
		('Cambodia'),
		('Cameroon'),
		('Canada'),
		('Cape Verde'),
		('Cayman Islands'),
		('Central African Republic'),
		('Chad'),
		('Chile'),
		('China'),
		('Christmas Island'),
		('Cocos (Keeling) Islands'),
		('Colombia'),
		('Comoros'),
		('Congo'),
		('Cook Islands'),
		('Costa Rica'),
		('Ivory Coast'),
		('Croatia'),
		('Cuba'),
		('Curacao'),
		('Cyprus'),
		('Czech Republic'),
		('Democratic Republic of the Congo'),
		('Denmark'),
		('Djibouti'),
		('Dominica'),
		('Dominican Republic'),
		('Ecuador'),
		('Egypt'),
		('El Salvador'),
		('Equatorial Guinea'),
		('Eritrea'),
		('Estonia'),
		('Ethiopia'),
		('Falkland Islands (Malvinas)'),
		('Faroe Islands'),
		('Fiji'),
		('Finland'),
		('France'),
		('French Guiana'),
		('French Polynesia'),
		('French Southern Territories'),
		('Gabon'),
		('Gambia'),
		('Georgia'),
		('Germany'),
		('Ghana'),
		('Gibraltar'),
		('Greece'),
		('Greenland'),
		('Grenada'),
		('Guadaloupe'),
		('Guam'),
		('Guatemala'),
		('Guernsey'),
		('Guinea'),
		('Guinea-Bissau'),
		('Guyana'),
		('Haiti'),
		('Heard Island and McDonald Islands'),
		('Honduras'),
		('Hong Kong'),
		('Hungary'),
		('Iceland'),
		('India'),
		('Indonesia'),
		('Iran'),
		('Iraq'),
		('Ireland'),
		('Isle of Man'),
		('Israel'),
		('Italy'),
		('Jamaica'),
		('Japan'),
		('Jersey'),
		('Jordan'),
		('Kazakhstan'),
		('Kenya'),
		('Kiribati'),
		('Kosovo'),
		('Kuwait'),
		('Kyrgyzstan'),
		('Laos'),
		('Latvia'),
		('Lebanon'),
		('Lesotho'),
		('Liberia'),
		('Libya'),
		('Liechtenstein'),
		('Lithuania'),
		('Luxembourg'),
		('Macao'),
		('Macedonia'),
		('Madagascar'),
		('Malawi'),
		('Malaysia'),
		('Maldives'),
		('Mali'),
		('Malta'),
		('Marshall Islands'),
		('Martinique'),
		('Mauritania'),
		('Mauritius'),
		('Mayotte'),
		('Mexico'),
		('Micronesia'),
		('Moldova'),
		('Monaco'),
		('Mongolia'),
		('Montenegro'),
		('Montserrat'),
		('Morocco'),
		('Mozambique'),
		('Myanmar (Burma)'),
		('Namibia'),
		('Nauru'),
		('Nepal'),
		('Netherlands'),
		('New Caledonia'),
		('New Zealand'),
		('Nicaragua'),
		('Niger'),
		('Nigeria'),
		('Niue'),
		('Norfolk Island'),
		('North Korea'),
		('Northern Mariana Islands'),
		('Norway'),
		('Oman'),
		('Pakistan'),
		('Palau'),
		('Palestine'),
		('Panama'),
		('Papua New Guinea'),
		('Paraguay'),
		('Peru'),
		('Phillipines'),
		('Pitcairn'),
		('Poland'),
		('Portugal'),
		('Puerto Rico'),
		('Qatar'),
		('Reunion'),
		('Romania'),
		('Russia'),
		('Rwanda'),
		('Saint Barthelemy'),
		('Saint Helena'),
		('Saint Kitts and Nevis'),
		('Saint Lucia'),
		('Saint Martin'),
		('Saint Pierre and Miquelon'),
		('Saint Vincent and the Grenadines'),
		('Samoa'),
		('San Marino'),
		('Sao Tome and Principe'),
		('Saudi Arabia'),
		('Senegal'),
		('Serbia'),
		('Seychelles'),
		('Sierra Leone'),
		('Singapore'),
		('Sint Maarten'),
		('Slovakia'),
		('Slovenia'),
		('Solomon Islands'),
		('Somalia'),
		('South Africa'),
		('South Georgia and the South Sandwich Islands'),
		('South Korea'),
		('South Sudan'),
		('Spain'),
		('Sri Lanka'),
		('Sudan'),
		('Suriname'),
		('Svalbard and Jan Mayen'),
		('Swaziland'),
		('Sweden'),
		('Switzerland'),
		('Syria'),
		('Taiwan'),
		('Tajikistan'),
		('Tanzania'),
		('Thailand'),
		('Timor-Leste (East Timor)'),
		('Togo'),
		('Tokelau'),
		('Tonga'),
		('Trinidad and Tobago'),
		('Tunisia'),
		('Turkey'),
		('Turkmenistan'),
		('Turks and Caicos Islands'),
		('Tuvalu'),
		('Uganda'),
		('Ukraine'),
		('United Arab Emirates'),
		('United Kingdom'),
		('United States'),
		('United States Minor Outlying Islands'),
		('Uruguay'),
		('Uzbekistan'),
		('Vanuatu'),
		('Vatican City'),
		('Venezuela'),
		('Vietnam'),
		('Virgin Islands, British'),
		('Virgin Islands'),
		('Wallis and Futuna'),
		('Western Sahara'),
		('Yemen'),
		('Zambia'),
		('Zimbabwe');

--CUSTOMER-- 
INSERT INTO Fletnix_Database.dbo.customer_FN
	SELECT 
	customer_mail_address	AS customer_mail_address,
	lastname				AS lastname,
	firstname				AS firstname,
	payment_method			AS payment_method,
	payment_card_number		AS payment_card_number,
	contract_type			AS contract_type,
	subscription_start		AS subscription_start,
	subscription_end		AS subscription_end,
	user_name				AS user_name,
	password				AS password,
	country_name			AS country_name,
	gender					AS gender,
	birth_date				AS birth_date
	FROM	FLETNIX_DOCENT.dbo.Customer
	WHERE	country_name in (select country_name from Fletnix_Database.dbo.country_FN);

--WATCH HISTORY--
/* OPDRACHT2_WATCH_HISTORY_SCRIPT EN OPDRACHT2_CREATE_RANDOM_WATCH_HISTORY_DATA_PROC */

/****************************************************/


