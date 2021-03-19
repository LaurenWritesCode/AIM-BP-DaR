/* --WATCH HISTORY SCRIPT-- */

/*************************************************************************

	Onderstaand script bevat:
		1 view en 2 functies waarmee wij wilekeurige datums kunnen genereren.
		Deze datums gebruiken wij bij het vullen van de watch history tabel.
		Dit gebeurd in PROCEDURE p_create_random_watchhistory_data 
		deze staat in OPDRACHT2_CREATE_RANDOM_WATCH_HISTORY_DATA_PROC.

		 -  v_rand (hulp view om willekeurige getallen te genereren)
		 -  f_correct_date kijkt of subscription end Null is of niet
			indien is null = true wordt subscription_end de huidige datum.
		 -  Kies een datum die valt tussen de sub_start en end van de gegeven
			customer. Maak hierbij gebruik van f_correct_date en v_rand.

**************************************************************************/

USE Fletnix_Database
GO

DROP FUNCTION IF EXISTS f_correct_date
go
DROP FUNCTION IF EXISTS f_random_date
go
DROP VIEW IF EXISTS v_Rand
go

CREATE VIEW v_rand
AS
	SELECT Rand() [rand]
GO


CREATE FUNCTION f_correct_date (@date DATE)
	RETURNS DATE AS 
	BEGIN
	DECLARE @result DATE

	IF  (@date IS NULL)
		BEGIN
		SELECT @result = GETDATE()
		END
	ELSE
		BEGIN
		SELECT @result = @date
		END

	RETURN @result 
END
GO

CREATE FUNCTION f_random_date
(@DateStart DATE, @dateEnd DATE)
RETURNS DATE
AS BEGIN
SELECT @DateEnd = dbo.f_correct_date(@dateEnd)
	
	DECLARE @Result DATE
	SELECT	DISTINCT @Result = DateAdd(DAY, [Rand] * DateDiff(HOUR, @DateStart, @DateEnd), @DateStart)
	FROM	dbo.v_Rand

	RETURN	@Result	
END
GO