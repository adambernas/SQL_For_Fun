--Tytuł: Procedura konwertuje liczbę dziesiętną do systemu dwójkowego (binarnego)
--Autor: Adam Bernaś
--Update: 28-03-2022
--Wersja: 1.1

/*Skrót do obsługi procedury

exec ConverterDecimalToBinary
@number = "Wprowadź liczbę całkowitą"
*/

--Sprawdź czy procedura istnieje, jeżeli tak usuń ją
IF OBJECT_ID('ConverterDecimalToBinary') IS NOT NULL DROP PROC ConverterDecimalToBinary
GO

CREATE PROC ConverterDecimalToBinary

@number DECIMAL(38,0) = NULL

AS

DECLARE @mod DECIMAL(38,0);
	SET @mod = @number % 2;
DECLARE @i DECIMAL(38,0);
	SET @i = @number;
DECLARE @Tab TABLE(id BIGINT IDENTITY, n DECIMAL(38,0))

IF	@number IS NULL 
	OR @number = 0
	OR @number < 0
		BEGIN
			PRINT 'Podaj dodatnią liczbę'
			RETURN
		END
SET NOCOUNT ON

WHILE @i <= @number
	BEGIN
		INSERT INTO @Tab(n) VALUES (@mod)
		IF @i= 1 AND @mod = 1 BREAK;
		SET @i = @i / 2
		SET @mod = @i % 2
	END

BEGIN
		
	DECLARE @txt varchar(max);
	DECLARE @priv_txt varchar(max);
	DECLARE @start INT = 0;
	DECLARE Kursor CURSOR FOR

	SELECT CAST(n as varchar(max)) FROM @Tab
	ORDER BY id DESC
	OPEN Kursor
	FETCH NEXT FROM Kursor INTO @txt
		SET @priv_txt = @txt

	WHILE @@FETCH_STATUS = 0	
		BEGIN
			IF @start = 1
				SET @priv_txt = @priv_txt + @txt
			ELSE
				SET @start = 1
			FETCH NEXT FROM Kursor INTO @txt
		END
	
	CLOSE Kursor
	DEALLOCATE Kursor;
END

PRINT 'Wprowadzona liczba w systemie dziesiętnym:' + char(10) + char(10 ) + CAST(@number as varchar(max)) + char(10) + char(10) + 
	  'Konwersja na sytem binarny (dwójkowy): ' + char(10) + char(10) + @priv_txt + char(10)

PRINT 'Liczba znaków ciągu binarnego: ' + CAST(LEN(@priv_txt) as varchar(200))