/* --INSERT SCRIPT-- */

/*************************************************************************

	Onderstaand script bevat:
		 Casus Opdracht 1F: Insert statements voorbeeld populatie.

**************************************************************************/

USE Fletnix_Database

-- Tabelen leeg maken --
DELETE FROM watchhistory_FN;
DELETE FROM customer_FN;
DELETE FROM country_FN;
DELETE FROM contract_FN
DELETE FROM payment_FN;
DELETE FROM movie_genre_FN;
DELETE FROM genre_FN;
DELETE FROM movie_director_FN;
DELETE FROM movie_cast_FN;
DELETE FROM movie_FN;
DELETE FROM person_FN;

-- Inserts / tabellen vullen -- 
INSERT INTO person_FN
VALUES	(83616, 'Wachowski', 'Andy', 'M'),
		(83617, 'Wachowski', 'Larry', 'M'),
		(393411, 'Reeves', 'Keanu', 'M'),
		(729933, 'Moss', 'Carrie-Anne', 'F'),
		(151786, 'Fishburne', 'Laurence', 'M'),
		(1312, 'Mottola', 'Greg', 'M'),
		(1313, 'Cera', 'Michael', 'M'),
		(1314, 'Hill', 'Jonah', 'M'),
		(1900, 'Nolan', 'Christopher', 'M'),
		(1901, 'DiCaprio', 'Leonardo', 'M'),
		(1902, 'Page', 'Ellen', 'F');

INSERT INTO movie_FN
VALUES	(11, 'Matrix, The', 122, 'A computer hacker learns from mysterious rebels
		about the true nature of his reality and his role in the war against its controllers.',
		1999, NULL, NULL, 2.50, 'https://www.youtube.com/watch?v=m8e-FF8MsqU'),
		(12, 'Matrix Reloaded, The', 106, 'Neo and his allies race against time before the machines 
		discover the city of Zion and destroy it. While seeking the truth about the Matrix, 
		Neo must save Trinity from a dark fate within his dreams.', 
		2003, NULL, 11, 2.50, 'https://www.youtube.com/watch?v=kYzz0FSgpSU'),
		(13, 'Matrix Revolutions, The', 103, 'The human city of Zion defends itself against the massive
		invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.', 
		2003, NULL, 12, 2.50, 'https://www.youtube.com/watch?v=hMbexEPAOQI'),
		
		-- Onderstaande films hebben wij zelf toegevoegd --
		(14, 'Emoji Movie, The', 86, 'Gene, a multi-expressional emoji, sets out on a journey to become a normal emoji.', 
		2017, NULL, NULL, 4.00, 'https://www.youtube.com/watch?v=r8pJt4dK_s4'),
		(15, 'Superbad', 113, 'Two co-dependent high school seniors are forced to deal with separation anxiety
		after their plan to stage a booze-soaked party goes awry.', 
		2007, NULL, NULL, 2.25, 'https://www.youtube.com/watch?v=4eaZ_48ZYog'),
		(16, 'Shaun of the Dead', 99, 'A man''s uneventful life is disrupted by the zombie apocalypse.',  --- Hoe gebruik je ' in tekst?
		2004, NULL, NULL, 3.00, 'https://www.youtube.com/watch?v=LIfcaZ4pC-4'),
		(17, 'Fight Club', 139, 'An insomniac office worker and a devil-may-care soapmaker 
		form an underground fight club that evolves into something much, much more.', 
		1999, NULL, NULL, 3.99, 'https://www.youtube.com/watch?v=qtRKdVHc-cE'),
		(18, 'Inception', 148, 'A thief who steals corporate secrets through the use of 
		dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.', 
		2010, NULL, NULL, 3.50, 'https://www.youtube.com/watch?v=YoHD9XEInc0');

INSERT INTO movie_cast_FN
VALUES	(11, 393411, 'Neo'), -- matrix -- 
		(11, 729933, 'Trinity'), -- matrix --
		(11, 151786, 'Morpheus'), -- matrix--
		(15, 1313, 'Evan'), -- superbad --
		(15, 1314, 'Seth'), -- superbad -- 
		(18, 1901, 'Cobb'), -- inception -- 
		(18, 1902, 'Adriadne'); -- inception --

INSERT INTO movie_director_FN
VALUES	(11, 83616), -- matrix -- 
		(11, 83617), -- matrix -- 
		(12, 83616), -- matrix reloaded -- 
		(12, 83617), -- matrix reloaded --
		(15, 1312), -- superbad --
		(18, 1900); -- inception -- 

INSERT INTO genre_FN
VALUES	('Action', 'Creative works characterized by emphasis on exciting action sequences'),
		('Drama', 'Fictional division between comedy and tragedy'),
		('Family', 'Fictional division between comedy and tragedy'),
		('Sci-Fi', 'Fictional movies dealing with imaginative content such as futuristic settings, 
					futuristic science and technology, space travel, time travel, parallel universes, and extraterrestrial life'),
		('Adventure', 'Adventure films are a genre of film that typically use their action scenes to display and explore exotic locations in an energetic way'),
		('Comedy', 'A comedy film is a genre of film in which the main emphasis is on humor');

INSERT INTO movie_genre_FN
VALUES	(11, 'Action'), -- matrix -- 
		(11, 'Sci-Fi'), -- matrix -- 
		(12, 'Action'), -- matrix reloaded -- 
		(12, 'Sci-Fi'), -- matrix reloaded --
		(13, 'Action'), -- matrix revolutions -- 
		(13, 'Sci-Fi'), -- matrix revolutions --
		(14, 'Comedy'), -- emoji movie -- 
		(15, 'Comedy'), -- superbad --
		(16, 'Comedy'), -- shaun of the Dead --
		(17, 'Drama'), -- fightclub --
		(18, 'Adventure'); -- inception -- 

INSERT INTO payment_FN
VALUES	('Mastercard'),
		('Visa'),
		('Amex'),
		('Rabobank'),
		('ING'),
		('PayPal');

INSERT INTO contract_FN
VALUES	('Basic', 4, 0),
		('Premium', 5, 20),
		('Pro', 6, 40);

INSERT INTO country_FN
VALUES	('The Netherlands'),
		('Belgium'),
		('Germany'),
		('Poland'),
		('Turkey');

INSERT INTO customer_FN 
-- Aaname - Fletnix bestaat sinds 2010-01-01 --
VALUES	(	'peter@pan.de', 'Pan', 'Peter', 'Mastercard', '0123456789', 'Basic', '2014-10-01', 
			'2014-10-28', 'pp123', 'Peterpass', 'The Netherlands', 'M', '1971-07-26'	),
		(	'guy@monk.nl', 'Threepwood', 'Guy', 'Visa', '333-555-777', 'Premium', 
			'2014-01-01', NULL, 'gm4ever', 'guypass', 'Belgium', 'M', '1972-03-03'	),
		
		-- onderstaande klanten hebben wij zelf toegevoegd. -- 
		(	'evan.nokia@hotmail.com', 'Evans', 'Evan', 'Mastercard', '9876543210', 'Premium', '2019-11-21',
			NULL, 'Evan.Nokia', 'Batman11', 'The Netherlands', 'M', '2000-02-20'),
		(	'a.jacobs@outlook.com', 'Jacobs', 'Anne', 'Visa', '11223344', 'Basic', '2019-11-21',
			NULL, 'Anne.Jacobs', 'Verderinbeweging', 'Turkey', 'F', '1998-05-13'),
		(	'tatum.berg@gmail.com', 'Berg', 'Tatum', 'ING', '99999999', 'Basic', '2019-11-15',
			NULL, 'CallTatum', 'Handbal123!', 'Belgium', 'F', '2001-06-24'),
		(	'floris.welvaart@live.nl', 'Welvaart', 'Floris', 'Rabobank', '98976878', 'Pro', '2010-03-02',
			NULL, 'FlorisFilms', 'Welkom!', 'The Netherlands', 'M', '2000-03-02'),
		(	'pim.stevens@live.nl', 'Stevens', 'Pim', 'Rabobank', '90368900', 'Premium', '2012-01-10',
			NULL, 'pimStevens', 'Beek123!', 'The Netherlands', 'M', '1998-05-24'),
		(	'jansen.eva@gmail.com', 'Jansen', 'Eva', 'PayPal', '4455984556', 'Pro', '2018-11-01',
			NULL, 'evalovehorses', 'Horse69', 'Poland', 'F', '1999-04-24'),
		(	'a.p.smk@hetnet.nl', 'Paaltje', 'Aaltje', 'Amex', '3434390934', 'Basic', '2010-07-23',
			NULL, 'aaltjepaaltje', 'Conquer', 'Germany', 'F', '1945-12-12'),
		(	'ida.v.laar@live.nl', 'Laar Van', 'Ida', 'ING', '129889012', 'Pro', '2014-06-12',
			NULL, 'IdaVL', 'loemen11', 'Belgium', 'F', '1974-01-22'),
		(	'arnold.evers@gmail.com', 'Evers', 'Arnold', 'Mastercard', '11228877', 'Premium', '2017-11-11',
			NULL, 'EversArnold', 'handel777', 'Germany', 'M', '1969-06-12'),
		(	'sandra.k@gmail.com', 'Koopman', 'Sandra', 'Amex', '4444666445', 'Basic', '2013-01-01',
			NULL, 'KoopmansSandra', 'Gebakjes123!', 'Germany', 'F', '1970-01-20');

INSERT INTO watchhistory_FN
VALUES	
		-- onze 10 customers hebben the matrix gekeken -- 
		(11, 'evan.nokia@hotmail.com', '2019-11-15', 2.50, 0),
		(11, 'a.jacobs@outlook.com', '2019-11-15', 2.50, 1),
		(11, 'tatum.berg@gmail.com', '2019-11-18', 2.50, 1),
		(11, 'floris.welvaart@live.nl', '2019-11-16', 2.50, 0),
		(11, 'pim.stevens@live.nl', '2019-11-19', 2.50, 0),
		(11, 'jansen.eva@gmail.com', '2019-11-14', 2.50, 1),
		(11, 'a.p.smk@hetnet.nl', '2019-11-21', 2.50, 0),
		(11, 'ida.v.laar@live.nl', '2019-11-15', 2.50, 0),
		(11, 'arnold.evers@gmail.com', '2019-11-16', 2.50, 0),
		(11, 'sandra.k@gmail.com', '2019-11-21', 2.50, 1),
		
		-- overgenomen geschiedenis uit casus -- 
		(11, 'peter@pan.de', '2014-10-01', 2.50, 1),
		(11, 'peter@pan.de', '2014-10-02', 2.50, 1),
		(12, 'guy@monk.nl', '2014-10-10', 2.00, 0),

		-- overige geschiedenis --
		(12, 'evan.nokia@hotmail.com', '2019-10-28', 2.50, 0),
		(13, 'evan.nokia@hotmail.com', '2019-09-10', 2.50, 1),
		(15, 'evan.nokia@hotmail.com', '2019-08-19', 2.25, 1),

		(12, 'a.jacobs@outlook.com', '2019-11-15', 2.50, 0),
		(15, 'a.jacobs@outlook.com', '2019-10-25', 2.25, 1),
		(16, 'a.jacobs@outlook.com', '2019-08-14', 3.00, 1),

		(14, 'tatum.berg@gmail.com', '2019-10-03', 4.00, 1),
		(16, 'tatum.berg@gmail.com', '2019-09-15', 3.00, 1),
		(17, 'tatum.berg@gmail.com', '2019-09-10', 3.99, 1),

		(12, 'floris.welvaart@live.nl', '2019-11-13', 2.50, 1),
		(13, 'floris.welvaart@live.nl', '2019-10-25', 2.50, 1),
		(18, 'floris.welvaart@live.nl', '2019-09-16', 3.50, 1),

		(15, 'pim.stevens@live.nl', '2019-11-20', 2.25, 1),
		(14, 'pim.stevens@live.nl', '2019-11-14', 4.00, 1),
		(16, 'pim.stevens@live.nl', '2019-11-07', 3.00, 1),

		(18, 'jansen.eva@gmail.com', '2019-11-13', 3.50, 1),
		(14, 'jansen.eva@gmail.com', '2019-10-27', 4.00, 1),
		(17, 'jansen.eva@gmail.com', '2019-10-20', 3.99, 1),

		(14, 'a.p.smk@hetnet.nl', '2019-11-12', 4.00, 1),
		(13, 'a.p.smk@hetnet.nl', '2019-11-05', 2.50, 1),
		(12, 'a.p.smk@hetnet.nl', '2019-09-18', 2.50, 1),

		(18, 'ida.v.laar@live.nl', '2019-10-03', 3.50, 1),
		(15, 'ida.v.laar@live.nl', '2019-10-03', 2.25, 1),
		(16, 'ida.v.laar@live.nl', '2019-10-03', 3.00, 1),

		(17, 'arnold.evers@gmail.com', '2019-10-03', 3.99, 1),
		(15, 'arnold.evers@gmail.com', '2019-10-03', 2.25, 1),
		(18, 'arnold.evers@gmail.com', '2019-10-03', 3.50, 1),

		(14, 'sandra.k@gmail.com', '2019-10-03', 4.00, 1),
		(13, 'sandra.k@gmail.com', '2019-10-03', 2.50, 1),
		(12, 'sandra.k@gmail.com', '2019-10-03', 2.50, 1); 

