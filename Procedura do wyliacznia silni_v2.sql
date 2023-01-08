--Tytuł: Procedura do wylicznia silni liczby całkowitej
--Autor: Adam Bernaś
--Update: 08-01-2022
--Wersja: 2.0
--Opis: Nowa wersja procedury do wyliczenia silni, ciało bardziej zoptymalizowane i uproszczone, wykorzystuje jedną pętle zamiast kursora z wersji poprzedniej

/*Skrót do obsługi procedury

exec CalculatingFactorial
@Number = " tu wprowadź liczbe całkowitą"
*/

--Sprawdź czy procedura istnieje, jeżeli tak usuń ją
IF OBJECT_ID('CalculatingFactorial_v2') IS NOT NULL DROP PROC CalculatingFactorial_v2
GO

--Tworzenie procedury 
CREATE PROCEDURE CalculatingFactorial_v2 

--Liczba całkowita z której będzie wyliczana silnia
	@Number INT = NULL
	AS
--Otwarcie bloku do obsługi błędów
BEGIN TRY
--Warunkich dla których przerwać wykonywanie procedury
IF	@Number IS NULL 
	OR @Number = 0
	OR @Number < 0
BEGIN
	PRINT 'Podaj dodatnią liczbę do wyliczenia silni większą od zera (@silnia = "liczba")'
	RETURN
END
SET NOCOUNT ON
BEGIN
	DECLARE @Number2 INT = @Number
    DECLARE @Factorial FLOAT = 1

    WHILE (@Number2 > 0)
    BEGIN
        SET @Factorial = @Factorial * @Number2
        SET @Number2 = @Number2 - 1
    END

    PRINT 'Silnia liczby  ' + CAST(@Number as nvarchar(20)) + '  wynosi: ' + CAST(@Factorial as nvarchar(50))
END
END TRY

BEGIN CATCH
	PRINT 'Wynik przekracza zakres liczy float (1.79E + 308)'
END CATCH