--Tytu�: Procedura do wylicznia silni liczby ca�kowitej
--Autor: Adam Berna�
--Update: 21-10-2021
--Wersja: 1.1

/*Skr�t do obs�ugi procedury

exec CalculatingFactorial
@Number = " tu wprowad� liczbe ca�kowit�"
*/

--Sprawd� czy procedura istnieje, je�eli tak usu� j�
IF OBJECT_ID('CalculatingFactorial') IS NOT NULL DROP PROC CalculatingFactorial
GO

--Tworzenie procedury 
CREATE PROCEDURE CalculatingFactorial 

--Liczba ca�kowita z kt�rej b�dzie wyliczana silnia
	@Number FLOAT = NULL
	AS
--Otwarcie bloku do obs�ugi b��d�w
BEGIN TRY

--Deklarowanie liczby pocz�tkowej (wyliczanie silni zaczyna si� od 1)
	DECLARE @n as FLOAT = 1
--Deklarowanie zmiennej tablicowej
	DECLARE @Tab TABLE(n FLOAT)

--Warunkich dla kt�rych przerwa� wykonywanie procedury
IF	@Number IS NULL 
	OR @Number = 0
	OR @Number < 0
BEGIN
	PRINT 'Podaj dodatni� liczb� do wyliczenia silni wi�ksz� od zera (@silnia = "liczba")'
	RETURN
END
SET NOCOUNT ON

--P�tla kt�ra inkrementuje o 1 liczbe ze zmiennej @number i wstawia te liczby do zmiennej tablicowej @Tab
WHILE @n <= @Number
	BEGIN
		INSERT INTO @Tab(n) VALUES (@n)
		SET @n= @n + 1
	END

BEGIN
--Tworzenie kursora do wyliczania silni

	DECLARE @i FLOAT			--Kolejna liczba n pobierana ze zmiennej tabelarycznej @Tab
	DECLARE @Relation FLOAT		--Iloczyn poprzedniej i obecnej warto�ci @i
	DECLARE Kursor CURSOR FOR
		SELECT n FROM @Tab
		OPEN Kursor
		FETCH NEXT FROM Kursor INTO @i
		SET @Relation = @i
		WHILE @@FETCH_STATUS = 0

	BEGIN
		SET @Relation = @i * @Relation
		FETCH NEXT FROM Kursor into @i
	END

	CLOSE Kursor
	DEALLOCATE Kursor;
END

	PRINT 'Silnia liczby  ' + CAST(@Number as nvarchar(20)) + '  wynosi:  ' + CAST(@Relation as nvarchar(50))

END TRY

BEGIN CATCH
	PRINT 'Wynik przekracza zakres liczy float (1.79E + 308)'
END CATCH
