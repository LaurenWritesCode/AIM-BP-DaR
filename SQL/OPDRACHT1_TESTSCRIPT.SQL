
/*-- TEST SCRIPT --*/

/*************************************************************************

	Onderstaand script bevat:
		Casus Opdracht 1E:	Test inserts bij de constraints 
							uit opdracht 1B en 1C.
		Ook geven wij hier toelichting bij de constraints die 
		wij bij opdracht 1C hebben bedacht. 

**************************************************************************/

USE Fletnix_Database

-- CONSTRAINT ck_person_gender_FN CHECK (gender IN ('M','F')) -- B.i.
INSERT INTO person_FN
VALUES	-- Goede voorbeelden -- 
		(1111, 'John', 'Doe', 'M'),
		(1112, 'Jane', 'Doe', 'F'),
		-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
		-- Foutmelding: The INSERT statement conflicted with the CHECK constraint "ck_person_gender_FN". --	
		(2222, 'Josh', 'Draper', 'B'),
		(2223, 'Jannis', 'Draper', 'V');

-- CONSTRAINT ck_movie_publication_year_FN CHECK (publication_year BETWEEN 1890  AND DATEPART(YEAR,GETDATE())) -- B.ii.
INSERT INTO movie_FN
VALUES	-- Goede voorbeelden -- 
		(19, 'Test film 1', NULL, NULL, 1999, NULL, NULL, 2.50, 'https'),
		(20, 'Test film 2', NULL, NULL, 1999, NULL, NULL, 2.50, 'https'),
		-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
		-- Foutmelding: The INSERT statement conflicted with the CHECK constraint "ck_movie_publication_year_FN". --		
		(21, 'Test film 3', NULL, NULL, 1889, NULL, NULL, 2.50, 'https'),
		(22, 'Test film 4', NULL, NULL, 2020, NULL, NULL, 2.50, 'https'); 

-- CONSTRAINT ck_customer_subscription_start_FN CHECK (subscription_start < subscription_end) -- B.iii.
INSERT INTO customer_FN
VALUES		-- Goede voorbeelden -- 
		(	'test.persoon.1@gmail.com', 'Test', 'Persoon1', 'Mastercard', '0000001', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon1', 'Persoon1', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.2@gmail.com', 'Test', 'Persoon2', 'Mastercard', '0000002', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon2', 'Persoon2', 'The Netherlands', 'M', '1970-07-07'	), 
			-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
			-- Foutmelding: The INSERT statement conflicted with the CHECK constraint "ck_customer_subscription_start_FN". --
		(	'test.persoon.3@gmail.com', 'Test', 'Persoon3', 'Mastercard', '0000003', 'Basic', '2012-12-12', 
			'2011-11-11', 'TestPersoon3', 'Persoon3', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.4@gmail.com', 'Test', 'Persoon4', 'Mastercard', '0000004', 'Basic', '2012-12-12', 
			'2011-11-11', 'TestPersoon4', 'Persoon4', 'The Netherlands', 'M', '1970-07-07'	);

-- CONSTRAINT ck_customer_user_name_FN UNIQUE(user_name) -- B.iv.
INSERT INTO customer_FN
VALUES		-- Goede voorbeelden -- 
		(	'test.persoon.5@gmail.com', 'Test', 'Persoon5', 'Mastercard', '03000005', 'Basic', '2010-10-10', 
			'2010-11-11', 'TestPersoon5', 'Persoon5', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.6@gmail.com', 'Test', 'Persoon6', 'Mastercard', '03000006', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon6', 'Persoon6', 'The Netherlands', 'M', '1970-07-07'	),
			-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
			-- Foutmelding: Violation of UNIQUE KEY constraint 'ck_customer_user_name_FN'. --
		(	'test.persoon.7@gmail.com', 'Test', 'Persoon7', 'Mastercard', '00300007', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon', 'Persoon7', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.8@gmail.com', 'Test', 'Persoon8', 'Mastercard', '00300008', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon', 'Persoon8', 'The Netherlands', 'M', '1970-07-07'	); 

-- CONSTRAINT ck_watchdate_FN CHECK (dbo.CheckDatum(watch_date, customer_mail_address) = 1) -- B.v.
INSERT INTO watchhistory_FN
VALUES		-- Goede voorbeelden -- 
		(	11, 'test.persoon.5@gmail.com', '2010-11-10', 3, 1	),
		(	12, 'test.persoon.5@gmail.com', '2010-12-10', 3, 1	),
			-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
			-- Foutmelding: The INSERT statement conflicted with the CHECK constraint "ck_watchdate_FN". --
		(	13, 'test.persoon.5@gmail.com', '2011-12-10', 3, 1	),
		(	14, 'test.persoon.5@gmail.com', '2011-11-12', 3, 1	);

/******************************************************************/

-- CONSTRAINT ck_movie_price_FN CHECK (price > 0)
-- prijs moet groter zijn dan 0 euro / Eigen constraint 
INSERT INTO movie_FN
VALUES	-- Goede voorbeelden -- 
		(23, 'Test film 5', NULL, NULL, 1999, NULL, NULL, 2.50, 'https'),
		(24, 'Test film 6', NULL, NULL, 1999, NULL, NULL, 2.50, 'https'),
		-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
		-- Foutmelding: The INSERT statement conflicted with the CHECK constraint "ck_movie_price_FN". --		
		(25, 'Test film 7', NULL, NULL, 1999, NULL, NULL, -3.50, 'https'),
		(26, 'Test film 8', NULL, NULL, 1999, NULL, NULL, 0.00, 'https'); 

-- CONSTRAINT ck_customer_birth_date_FN CHECK (birth_date < subscription_start), --  
-- Klant moet geboren zijn voor het abbonoment in gaat / Eigen constraint
INSERT INTO customer_FN
VALUES		-- Goede voorbeelden -- 
		(	'test.persoon.9@gmail.com', 'Test', 'Persoon9', 'Mastercard', '00030090', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon9', 'Persoon9', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.10@gmail.com', 'Test', 'Persoon10', 'Mastercard', '00090100', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon10', 'Persoon10', 'The Netherlands', 'M', '1970-07-07'	),
			-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
			-- Foutmelding: The INSERT statement conflicted with the CHECK constraint "ck_customer_birth_date_FN". --
		(	'test.persoon.11@gmail.com', 'Test', 'Persoon11', 'Mastercard', '00000110', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon11', 'Persoon11', 'The Netherlands', 'M', '2011-07-07'	),
		(	'test.persoon.12@gmail.com', 'Test', 'Persoon12', 'Mastercard', '00000120', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon12', 'Persoon12', 'The Netherlands', 'M', '2010-08-07'	); 

-- CONSTRAINT ck_customer_gender_FN CHECK (gender IN ('M','F')), 
-- geslacht moet M of F zijn / eigen constraint  
INSERT INTO customer_FN
VALUES		-- Goede voorbeelden -- 
		(	'test.persoon.13@gmail.com', 'Test', 'Persoon13', 'Mastercard', '00001300', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon13', 'Persoon13', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.14@gmail.com', 'Test', 'Persoon14', 'Mastercard', '00001400', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon14', 'Persoon14', 'The Netherlands', 'M', '1970-07-07'	),
			-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
			-- Foutmelding: String or binary data would be truncated.. --
		(	'test.persoon.15@gmail.com', 'Test', 'Persoon15', 'Mastercard', '00000005', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon15', 'Persoon11', 'The Netherlands', 'Man', '1999-07-07'	),
		(	'test.persoon.16@gmail.com', 'Test', 'Persoon16', 'Mastercard', '00000006', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon16', 'Persoon16', 'The Netherlands', 'Man', '1999-08-07'	); 

-- CONSTRAINT ck_customer_mail_address_FN CHECK (customer_mail_address LIKE '%@%'), 
-- er moet een @ in het email adres staan / eigen constraint
INSERT INTO customer_FN
VALUES		-- Goede voorbeelden -- 
		(	'test.persoon.13@gmail.com', 'Test', 'Persoon13', 'Mastercard', '00001300', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon13', 'Persoon13', 'The Netherlands', 'M', '1970-07-07'	),
		(	'test.persoon.14@gmail.com', 'Test', 'Persoon14', 'Mastercard', '00001400', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon14', 'Persoon14', 'The Netherlands', 'M', '1970-07-07'	),
			-- Tegen voorbeelden - Deze kunnen niet worden uitgevoerd dus de test is geslaagd --
			-- The INSERT statement conflicted with the CHECK constraint "ck_customer_mail_address_FN". --
		(	'test.persoon.15gmail.com', 'Test', 'Persoon15', 'Mastercard', '00000005', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon15', 'Persoon11', 'The Netherlands', 'M', '1999-07-07'	),
		(	'test.persoon.16gmail.com', 'Test', 'Persoon16', 'Mastercard', '00000006', 'Basic', '2010-10-10', 
			'2011-11-11', 'TestPersoon16', 'Persoon16', 'The Netherlands', 'M', '1999-08-07'	); 


