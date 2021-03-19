/* --WATCH HISTORY PROCEDURE-- */

/*****************************************************************************************************************

	Onderstaand script bevat:
		Een procedure die per klant een willekeurig aantal (tussen 100 en 400)
		willekeurige movie_ids kiest. Er wordt willekeurig bepaald of de film al betaald is,
		de price wordt uit de movie tabel overgenomen. Dit wordt vervolgens met een random watch_date
		in de watch_history tabel gestopt.  

*****************************************************************************************************************/

USE Fletnix_Database
GO

SET ansi_nulls ON 
GO

SET quoted_identifier ON 

GO

CREATE PROCEDURE Create_random_watchhistory_data
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      DECLARE @Random INT; 
      DECLARE @Upper INT; 
      DECLARE @Lower INT 
      DECLARE @customer_mail_address VARCHAR(255); 
      DECLARE @subscription_start DATE; 
      DECLARE @subscription_end DATE; 
      DECLARE @counter INT = 0; 
      DECLARE @invoiced INT; 
      DECLARE @moviecount INT; 
      DECLARE @movie INT; 
      DECLARE @price INT; 
      DECLARE cur_customers CURSOR fast_forward FOR 
        SELECT customer_mail_address, 
               subscription_start, 
               subscription_end 
        FROM   customer_fn; 

      OPEN cur_customers 

      FETCH next FROM cur_customers INTO @customer_mail_address, 
      @subscription_start, @subscription_end; 

      WHILE @@FETCH_STATUS = 0 
        BEGIN 
            SET @counter=0; 
            SET @Lower = 100 
            SET @Upper = 400 

            SELECT @moviecount = Round(( ( @Upper - @Lower - 1 ) * Rand() + @Lower ), 0) 

            --SELECT @moviecount 
            WHILE @counter < @moviecount 
              BEGIN 
                  SET @counter += 1; 
                  SET @Lower = 0 
                  SET @Upper = 412320 

                  SELECT @movie = Round(( ( @Upper - @Lower - 1 ) * Rand() + @Lower ), 0) 

                  --SELECT @movie 
                  SET @Lower = 0 
                  SET @Upper = 2 

                  SELECT @invoiced = Round(( ( @Upper - @Lower - 1 ) * Rand() + @Lower ), 0) 

                  --SELECT @invoiced 
                  SET @price = 0 

                  SELECT @price = price 
                  FROM   movie_fn 
                  WHERE  movie_id = @movie; 

                  IF @price != 0 -- movie exists 
                    BEGIN try 
                        INSERT INTO dbo.watchhistory_fn 
                        VALUES      (@movie, 
                                     @customer_mail_address, 
                                     dbo.F_random_date(@subscription_start, @subscription_end), 
                                     @price, 
                                     @invoiced) 
                    END try 

                  BEGIN catch 
                      WAITFOR delay '00:00:00'; -- dummy statement
                  END catch; 
              END 

            FETCH next FROM cur_customers INTO @customer_mail_address, 
            @subscription_start, @subscription_end; 
        END 

      CLOSE cur_customers 

      DEALLOCATE cur_customers 

  END 

go  