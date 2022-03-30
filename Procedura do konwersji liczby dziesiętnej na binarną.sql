--Tytu³: Procedura konwertuje liczbê dziesiêtn¹ do systemu dwójkowego (binarnego)
--Autor: Adam Bernaœ
--Update: 28-03-2022
--Wersja: 1.1

/*Skrót do obs³ugi procedury

exec ConverterDecimalToBinary
@number = "WprowadŸ liczbê ca³kowit¹"
*/

--SprawdŸ czy procedura istnieje, je¿eli tak usuñ j¹
IF OBJECT_ID('ConverterDecimalToBinary') IS NOT NULL DROP PROC ConverterDecimalToBinary
GO

CREATE PROC ConverterDecimalToBinary

@number DECIMAL(38,0) = 999999

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
			PRINT 'Podaj dodatni¹ liczbê'
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

PRINT 'Wprowadzona liczba w systemie dziesiêtnym:' + char(10) + char(10 ) + CAST(@number as varchar(max)) + char(10) + char(10) + 
	  'Konwersja na sytem binarny (dwójkowy): ' + char(10) + char(10) + @priv_txt + char(10)

PRINT 'Liczba znaków ci¹gu binarnego: ' + CAST(LEN(@priv_txt) as varchar(200))