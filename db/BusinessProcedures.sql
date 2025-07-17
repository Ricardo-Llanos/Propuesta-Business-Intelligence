USE LendingClub_DW;


--=============================Procedimiento  FECHA - DATELOAN================
--Probar Procedimiento
EXEC InsertDateLoan @Date_Loan = '2025-07-16';
GO

--Generar Procedimiento
CREATE OR ALTER PROCEDURE InsertDateLoan
    @Id_Date INT,
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
			@Day_description)
        
        WHERE Id_Date = @Id_Date;
			
END


/*Documentación

https://learn.microsoft.com/es-es/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver17 
*/


/*Al utilizar en VISUAL STUDIO y con Integration Service, este procedimiento no servirá, por ello estás son las claves:

--Year
YEAR((DT_DBDATE) [DateLoan])

--Month
MONTH((DT_DBDATE) [DateLoan])

--Quarter
DATEPART("QUARTER", (DT_DBDATE) [DateLoan])

--Day
DAY((DT_DBDATE) [DateLoan])


-- Días (La primera línea de DT_STR es importante porque así los resultados volverán a convertirse a STRINGs, 
la forma de trabajo de Integration Service es un lío, al intentar generar los nombres de los días, Integration Service los convierte a NVARCHAR, por lo que 
es inadmisible que puedan ser insertados en columnas de tipo VARCHAR)

(DT_STR, 20, 1252)(
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 1 ? "Domingo":
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 2 ? "Lunes" :
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 3 ? "Martes" :
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 4 ? "Miércoles" :
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 5 ? "Jueves" :
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 6 ? "Viernes" :
DATEPART("WEEKDAY", (DT_DBDATE)Date_loan) == 7 ? "Sábado" :
"Desconocido"
)

-- Meses
(DT_STR, 20, 1252)(
MONTH((DT_DBDATE)Date_loan) == 1 ? "Enero" :
MONTH((DT_DBDATE)Date_loan) == 2 ? "Febrero" :
MONTH((DT_DBDATE)Date_loan) == 3 ? "Marzo" :
MONTH((DT_DBDATE)Date_loan) == 4 ? "Abril" :
MONTH((DT_DBDATE)Date_loan) == 5 ? "Mayo" :
MONTH((DT_DBDATE)Date_loan) == 6 ? "Junio" :
MONTH((DT_DBDATE)Date_loan) == 7 ? "Julio" :
MONTH((DT_DBDATE)Date_loan) == 8 ? "Agosto" :
MONTH((DT_DBDATE)Date_loan) == 9 ? "Septiembre" :
MONTH((DT_DBDATE)Date_loan) == 10 ? "Octubre" :
MONTH((DT_DBDATE)Date_loan) == 11 ? "Noviembre" :
MONTH((DT_DBDATE)Date_loan) == 12 ? "Diciembre" :
"Desconocido"
)
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