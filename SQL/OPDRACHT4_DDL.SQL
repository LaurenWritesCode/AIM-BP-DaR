/* -- CREATE SCRIPT - Opdracht 4 -- */

/*************************************************************************

	Onderstaande statements bevatten:
		- Casus Opdracht 4B Implementeer het model in SQL
		- Casus Opdracht 4C Populeer de nieuwe database 
							met de ontbrekende data conform 
							deze twee overzichten.

**************************************************************************/

/****
  4B
*****/

-- Tabellen droppen voor creatie -- 

DROP TABLE IF EXISTS awards_per_year_FN
GO

DROP TABLE IF EXISTS result_FN
GO

DROP TABLE IF EXISTS award_show_FN
GO

-- Create table statements --

CREATE TABLE award_show_FN (
	award		VARCHAR(50)	  NOT NULL,
	year		INT			  NOT NULL,
	country		VARCHAR(50)	  NOT NULL,
	
	CONSTRAINT  pk_award_show_FN PRIMARY KEY (award, year),
	CONSTRAINT  fk_award_show_country_FN FOREIGN KEY (country) REFERENCES country_FN(country_name)
				ON UPDATE CASCADE
				ON DELETE NO ACTION,
);

CREATE TABLE result_FN (
	code			CHAR(1)			NOT NULL,
	description		VARCHAR(20)		NOT NULL,

	CONSTRAINT  pk_result_FN PRIMARY KEY (code),
	CONSTRAINT  ak_result_code_description_FN UNIQUE (description)
);

CREATE TABLE awards_per_year_FN (
	award		VARCHAR(50)		NOT NULL,
	year		INT				NOT NULL,
	category	VARCHAR(50)		NOT NULL,
	movie_id	INT				NOT NULL,
	person_id	INT				NOT NULL,
	code		CHAR(1)			NOT NULL,

	CONSTRAINT  pk_awards_per_year_FN PRIMARY KEY (award, year, category, movie_id, person_id),
	CONSTRAINT  fk_awards_per_year_award_show_FN FOREIGN KEY (award, year) REFERENCES award_show_FN (award, year)
				ON UPDATE CASCADE
				ON DELETE NO ACTION,
	CONSTRAINT  fk_awards_per_year_movie_FN FOREIGN KEY (movie_id) REFERENCES movie_FN (movie_id)
				ON UPDATE CASCADE
				ON DELETE NO ACTION,
	CONSTRAINT  fk_awards_per_year_person_FN FOREIGN KEY (person_id) REFERENCES person_FN (person_id)
				ON UPDATE CASCADE
				ON DELETE NO ACTION,
	CONSTRAINT  fk_awards_per_year_code_FN FOREIGN KEY (code) REFERENCES result_FN (code)
				ON UPDATE CASCADE
				ON DELETE NO ACTION,
);

/****
  4C
*****/

-- Insert statements -- Alleen de personen die nog niet bestonden in person_FN (Id vanaf max(person_id) from person_FN)

INSERT INTO person_FN ( person_id, firstname, lastname )
VALUES  ( 1088802,	 'Paul',	'Rubell'	),
		( 1088803,	 'Richard', 'Hymns'		),
		( 1088804,	 'Dane',	'Davis'		),
		( 1088805,	 'John',	'Gaeta'		),
		( 1088806,	 'Steve',	'Courtley'	),
		( 1088807,	 'Jon',		'Thum'		),
		( 1088808,	 'David',	'Lee'		),
		( 1088809,   'John',	'Reitz'		),
		( 1088810,   'Gregg',	'Rudloff'	),
		( 1088811,   'David',	'Campbell'	),
		( 1088812,   'Tom',		'Bellfort'	),
		( 1088813,   'Bob',		'Beemer'	),
		( 1088814,   'Bill',	'Pope'		),
		( 1088815,   'Conrad',	'Hall'		),
		( 1088816,   'Tariq',	'Anwar'		),
		( 1088817,   'Zach',	'Steanberg'	);

INSERT INTO award_show_FN
VALUES  ( 'Academy Awards',	2000,	'Netherlands' ),
		( 'BAFTA',	2000,	'New Zealand' );

INSERT INTO result_FN
VALUES  ( 'W',	'Won'		),
		( 'N',	'Nominated' );

INSERT INTO awards_per_year_FN 
VALUES  ('Academy Awards',	2000,	'Best Film Editing',	207992,	  1088817,   'W'),
		('Academy Awards',	2000,	'Best Film Editing',	160492,	  176884,    'N'),
		('Academy Awards',	2000,	'Best Film Editing',	160492,	  1088802,    'N'),
		('Academy Awards',	2000,	'Best Film Editing',	160492,	  1068042,    'N'),
		('Academy Awards',	2000,	'Best Film Editing',	303564,	  1054796,    'N'),

		('Academy Awards',	2000,	'Best Sound Effects Editing',	112290,	 251397,  'N'),
		('Academy Awards',	2000,	'Best Sound Effects Editing',	112290,	 1088803,  'N'),
		('Academy Awards',	2000,	'Best Sound Effects Editing',	207992,	 1088804,  'W'),
		('Academy Awards',	2000,	'Best Sound Effects Editing',	313474,	 1010889,  'N'),

		('Academy Awards',	2000,	'Best Visual Effects',	313474,	 251981,   'N'),
		('Academy Awards',	2000,	'Best Visual Effects',	313474,	 91712,	   'N'),
		('Academy Awards',	2000,	'Best Visual Effects',	207992,	 1088805,  'W'),
		('Academy Awards',	2000,	'Best Visual Effects',	207992,	 440853,   'W'),
		('Academy Awards',	2000,	'Best Visual Effects',	207992,	 1088806,  'W'),
		('Academy Awards',	2000,	'Best Visual Effects',	207992,	 1088807,  'W'),

		('BAFTA', 2000,	'Best Sound',	207992,	 1088808,  'W'),
		('BAFTA', 2000,	'Best Sound',	207992,	 1088809,  'W'),
		('BAFTA', 2000,	'Best Sound',	207992,	 1088810,  'W'),
		('BAFTA', 2000,	'Best Sound',	207992,	 1088811,  'W'),
		('BAFTA', 2000,	'Best Sound',	207992,	 1088804,  'W'),
		('BAFTA', 2000,	'Best Sound',	313474,	 65453,    'N'),
		('BAFTA', 2000,	'Best Sound',	313474,	 1088812,  'N'),
		('BAFTA', 2000,	'Best Sound',	13789,	 1088813,  'N'),

		('BAFTA', 2000,	'Best Cinematography',	207992,	 1088804,  'N'),
		('BAFTA', 2000,	'Best Cinematography',	13789,	 1088815,  'W'),

		('BAFTA', 2000,	'Best Production Design',	207992,	 364716,   'N'),
		('BAFTA', 2000,	'Best Production Design',	304862,	 203143,   'W'),

		('BAFTA', 2000,	'Best Editing',	207992,	 1088817,  'N'),
		('BAFTA', 2000,	'Best Editing',	13789,	 1088816,  'W'),
		('BAFTA', 2000,	'Best Editing',	13789,	 183753,   'W');