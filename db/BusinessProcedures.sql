USE LendingClub_DW;

--=============================Procedimiento  FECHA - DATELOAN================
--Probar Procedimiento
EXEC InsertDateLoan @Date_Loan = '2025-07-16';
GO

--Generar Procedimiento
CREATE OR ALTER PROCEDURE InsertDateLoan
    @Date_Loan DATE
    --Format: 2024-10-30 (yyyy, mm, dd)
AS
BEGIN
    DECLARE @Year SMALLINT;
    DECLARE @Quarter TINYINT;
    DECLARE @Month TINYINT;
    DECLARE @Day TINYINT;
    DECLARE @Month_description VARCHAR(20);
    DECLARE @Day_description VARCHAR(20);

    SET LANGUAGE 'Spanish';
    SET DATEFORMAT ymd;

    --IF ISDATE(@Date_Loan) = 1            
        SET @Year = YEAR(@Date_Loan);
        SET @Month = MONTH(@Date_Loan);
        SET @Day = DAY(@Date_Loan);
        SET @Quarter = DATEPART(QUARTER, @Date_Loan);

        SET @Month_description = DATENAME(MONTH, @Date_Loan);
        SET @Day_description = DATENAME(WEEKDAY, @Date_Loan);
    
    --SELECT @Year AS Year, @Quarter AS Quarter, @Month AS Month, @Month_description AS 'Nombre Descripción', @Day AS Day, @Day_description AS 'Nombre Día';
	INSERT INTO DateLoan 
		VALUES
			(@Year, 
			@Quarter, 
			@Month, 
			@Month_description, 
			@Day, 
			@Day_description);
			
END

/*Documentación
https://learn.microsoft.com/es-es/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver17 
*/
GO


--=============================Procedimiento  TIME CREDIT LINE================
-- Probar Procedimiento
EXEC InsertTimeCreditLine @Days_Total= 5437;
GO

--Generar Procedimiento
CREATE OR ALTER PROCEDURE InsertTimeCreditLine
    @Days_Total INT

AS
BEGIN
    DECLARE @Years_with SMALLINT;
    DECLARE @Month_with SMALLINT;
    
    IF @Days_Total >= 0
	--CEILIGN => Redondeo hacia arriba
	--FLOOR   => Redondeo hacia abajo
        SET @Years_with = FLOOR(@Days_Total/365);
        SET @Month_with = FLOOR(@Days_Total/30);

	--SELECT @Years_with AS 'Años', @Month_with AS 'Meses', @Days_Total AS 'Días';
	INSERT INTO TimeCreditLine
		VALUES
		   (@Years_with, 
			@Month_with,
			@Days_Total);
END