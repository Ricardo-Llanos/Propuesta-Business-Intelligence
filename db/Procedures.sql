USE LendingClub;
GO
USE master;
SELECT * FROM CreditHistory;

--=======================================Probar INNER JOIN=======================
SELECT cl.Id_Client AS ID_CLIENTE, 
	cl.Name, 
	cl.Lastname, 
	cl.Sex,
	eco.Log_annual_inc,
	eco.Dti,
	eco.Pub_rec,
	eco.FICO

FROM Client AS cl 
INNER JOIN EconomicSituation AS eco
ON cl.Id_Client = eco.Id_Client;




--EXEC sp_columns @table_name='Client';
CREATE OR ALTER PROCEDURE InsertClient
		@Name VARCHAR(100),
		@Lastname VARCHAR(100),
		@Sex CHAR(1),
		@New_Id_Client INT OUTPUT -- Variable de tipo OUTPUT (Será devuelta al ejecutar el procedimiento)
	AS
	BEGIN
		SET NOCOUNT ON;
		IF (@Name IS NULL OR @Lastname IS NULL OR @Sex IS NULL)
			BEGIN
				DECLARE @message_error NVARCHAR(MAX);
				SET @message_error = 'InsertClient::No se ingresó alguno de los valores: '+
										 ' @Name = '+ ISNULL(CAST(@Name AS VARCHAR(MAX)), 'NULL')+
										 ' @Lastname= '+ISNULL(CAST(@Lastname AS VARCHAR(MAX)), 'NULL')+
										 ' @Sex= '+ISNULL(CAST(@Sex AS VARCHAR(MAX)), 'NULL');

				THROW 50000, @message_error, 1;
			END
		ELSE
			BEGIN
			INSERT INTO Client (Name, Lastname, Sex)
				VALUES 
				(@Name, @Lastname, @Sex);

			SET @New_Id_Client = SCOPE_IDENTITY(); --De esta manera tendremos los IDs
			END

			--SELECT TOP 1 * FROM Client;
	END;
GO

CREATE OR ALTER PROCEDURE InsertEconomicSituation
    @Id_Client INT, --(FK)
    @Log_annual_inc FLOAT,
    @Dti FLOAT,
    @Pub_rec SMALLINT,
    @FICO SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @message_error VARCHAR(MAX);
    IF (@Id_Client IS NULL OR @Log_annual_inc IS NULL OR @Dti IS NULL OR @Pub_rec IS NULL OR @FICO IS NULL)
		BEGIN
		SET @message_error = 'InsertEconomicSituation::No se ingresó alguno de los valores'+
								' @Id_Client: '+ ISNULL(CAST(@Id_Client AS VARCHAR(MAX)), 'NULL')+
								' @Log_annual_inc: '+ ISNULL(CAST(@Log_annual_inc AS VARCHAR(MAX)), 'NULL')+
								' @Dti: '+ ISNULL(CAST(@Dti AS VARCHAR(MAX)), 'NULL')+
								' @Pub_rec: '+ ISNULL(CAST(@Pub_rec AS VARCHAR(MAX)), 'NULL')+
								' @FICO: '+ ISNULL(CAST(@FICO AS VARCHAR(MAX)), 'NULL');
		--SELECT Code_Error=1, Status_Error='No se pudo', Id_Client=@Id_Client; 
			THROW 50000, @message_error, 1;
		END
    ELSE
		BEGIN
			SET @Log_annual_inc = ROUND(@Log_annual_inc, 4);

			INSERT INTO EconomicSituation (Id_Client, Log_annual_inc, Dti, Pub_rec, FICO)
				VALUES 
				(@Id_Client, @Log_annual_inc, @Dti, @Pub_rec, @FICO);
		END

END;
GO

CREATE OR ALTER PROCEDURE InsertLoan
    @Id_Purpose INT, --(FK)
    @Id_Client INT, --(FK)
    @Credit_policy CHAR(1),
    @Int_rate FLOAT,
    @Fee FLOAT,
    @Date_loan DATE,
	@New_Id_Loan INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @error_message VARCHAR(MAX);
    IF (@Id_Purpose IS NULL OR @Id_Client IS NULL OR @Credit_policy IS NULL OR
            @Int_Rate IS NULL OR @Fee IS NULL OR @Date_Loan IS NULL)
		BEGIN
			SET @error_message = 'InsertLoan::No se ingresó alguno de los valores'+
								' @Id_Purpose: '+ISNULL(CAST(@Id_Purpose AS VARCHAR(MAX)), 'NULL')+
								' @Id_Client: '+ISNULL(CAST(@Id_Client AS VARCHAR(MAX)), 'NULL')+
								' @Credit_Policy: '+ISNULL(CAST(@Credit_policy AS VARCHAR(MAX)), 'NULL')+
								' @Int_rate: '+ISNULL(CAST(@Int_rate AS VARCHAR(MAX)), 'NULL')+
								' @Fee: '+ISNULL(CAST(@Fee AS VARCHAR(MAX)), 'NULL')+
								' @Date_Loan: '+ISNULL(CAST(@Date_loan AS VARCHAR(MAX)), 'NULL');
			THROW 50000, @error_message, 1;
		END
    ELSE
		BEGIN
			INSERT INTO Loan (Id_Purpose, Id_Client, Credit_policy, Int_rate, Fee, Date_loan)
				VALUES 
				(@Id_Purpose, @Id_Client, @Credit_policy, @Int_rate, @Fee, @Date_loan);

				SET @New_Id_Loan = SCOPE_IDENTITY();
		END
END;
GO

CREATE OR ALTER PROCEDURE InsertPurpose
    @Name_Purpose VARCHAR(200),
	@New_Id_Purpose INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @error_message VARCHAR(MAX);
    IF (@Name_Purpose IS NULL)
		BEGIN
			SET @error_message = 'InsertPurpose::No se ingresó alguno de los valores'+
									' @Name_Purpose: '+ ISNULL(CAST(@Name_Purpose AS VARCHAR(MAX)), 'NULL');
			THROW 50000, @error_message, 1;
		END
    ELSE
		BEGIN
			INSERT INTO Purpose (Name)
				VALUES
				(@Name_Purpose);

			SET @New_Id_Purpose = SCOPE_IDENTITY();
		END
END;
GO

CREATE OR ALTER PROCEDURE InsertCreditHistory
    @Id_Loan INT, --(FK)
    @Days_with_cr_line INT,
    @Revol_bal INT,
    @Revol_util FLOAT,
    @Inq_last_6mths SMALLINT,
    @Delinq_2yrs SMALLINT,
    @Fully_paid CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @error_message VARCHAR(MAX);
    IF (@Id_Loan IS NULL OR @Days_with_cr_line IS NULL OR @Revol_bal IS NULL
            OR @Revol_util IS NULL OR @Inq_last_6mths IS NULL OR @Delinq_2yrs IS NULL OR @Fully_paid IS NULL)
        BEGIN
			SET @error_message = 'InsertCreditHistory::No se ingresó alguno de los valores'+
								' @Id_Loan: '+ISNULL(CAST(@Id_Loan AS VARCHAR(MAX)), 'NULL')+
								' @Days_with_cr_line: '+ISNULL(CAST(@Days_with_cr_line AS VARCHAR(MAX)), 'NULL')+
								' @Revol_bal: '+ISNULL(CAST(@Revol_bal AS VARCHAR(MAX)), 'NULL')+
								' @Revol_util: '+ISNULL(CAST(@Revol_util AS VARCHAR(MAX)), 'NULL')+
								' @Inq_last_6mths: '+ISNULL(CAST(@Inq_last_6mths AS VARCHAR(MAX)), 'NULL')+
								' @Delinq_2yrs: '+ISNULL(CAST(@Delinq_2yrs AS VARCHAR(MAX)), 'NULL')+
								' @Fully_paid: '+ISNULL(CAST(@Fully_paid AS VARCHAR(MAX)), 'NULL');
			THROW 50000, @error_message, 1;
		END
    ELSE
		BEGIN
			INSERT INTO CreditHistory (Id_Loan, Days_with_cr_line, Revol_bal, Revol_util, Inq_last_6mths, Delinq_2yrs, Fully_paid)
				VALUES 
				(@Id_Loan, @Days_with_cr_line, @Revol_bal, @Revol_util, @Inq_last_6mths, @Delinq_2yrs, @Fully_paid)
		END
END;
GO


--===============================PROCEDIMIENTO GENERAL=====================
/*En sí :V, este procedimiento es más lento, un Bulk Insert o un BCP sería más rápido y demás... pero... :v ehhh xd, 
hay que generar tablas temporales y luego hacer transformación de datos, ahí nomás ;v (Son solo 10k datos)*/
CREATE OR ALTER PROCEDURE InsertLoanComplete
    @Name VARCHAR(100),
    @Lastname VARCHAR(100),
    @Sex CHAR(1),

    -- @Id_Client INT, --(FK)
    @Log_annual_inc FLOAT,
    @Dti FLOAT,
    @Pub_rec SMALLINT,
    @FICO SMALLINT,

    @Name_Purpose VARCHAR(200),

    -- @Id_Purpose INT, --(FK)
    -- @Id_Client INT, --(FK)
    @Credit_policy CHAR(1),
    @Int_rate FLOAT,
    @Fee FLOAT,
    @Date_loan DATE,

    -- @Id_Loan INT, --(FK)
    @Days_with_cr_line INT,
    @Revol_bal INT,
    @Revol_util FLOAT,
    @Inq_last_6mths SMALLINT,
    @Delinq_2yrs SMALLINT,
    @Fully_paid CHAR(1)
AS

BEGIN

    DECLARE @Last_Id_Client INT;
    DECLARE @Last_Id_Purpose INT;
    DECLARE @Last_Id_Loan INT;

    BEGIN TRY
        BEGIN TRANSACTION
            --=============Client
            EXEC InsertClient @Name= @Name, @Lastname= @Lastname, @Sex= @Sex, @New_Id_Client=@Last_Id_Client OUTPUT; --Ante un variable de tipo OUTPUT, debemos especificar que será OUTPUT

            --=============EconomicSituation
            EXEC InsertEconomicSituation @Id_Client = @Last_Id_Client, @Log_annual_inc = @Log_annual_inc,
                @Dti = @Dti, @Pub_rec = @Pub_rec, @FICO = @FICO;
            
            --=============Purpose
            --En caso exista el Purpose evitaremos crearlo nuevamente
            SELECT @Last_Id_Purpose=Id_Purpose FROM Purpose WHERE Name=@Name_Purpose;
            
            IF @Last_Id_Purpose IS NULL
                BEGIN
                    EXEC InsertPurpose @Name_Purpose = @Name_Purpose, @New_Id_Purpose= @Last_Id_Purpose OUTPUT;
                END

            --=============Loan
            EXEC InsertLoan @Id_Purpose= @Last_Id_Purpose, @Id_Client= @Last_Id_Client, @Credit_policy= @Credit_policy,
                @Int_rate = @Int_rate, @Fee= @Fee, @Date_loan= @Date_loan, @New_Id_Loan= @Last_Id_Loan OUTPUT;

            --=============CreditHistory
            EXEC InsertCreditHistory @Id_Loan= @Last_Id_Loan, @Days_with_cr_line= @Days_with_cr_line,
                @Revol_bal= @Revol_bal, @Revol_util= @Revol_util, @Inq_last_6mths= @Inq_last_6mths, 
                @Delinq_2yrs= @Delinq_2yrs, @Fully_paid=@Fully_paid;

			SELECT @Name AS Nombre, @Last_Id_Client AS ValorIDCliente, @Last_Id_Purpose AS ValorIDPurpose, @Name_Purpose AS Proposito, 
				@Last_Id_Loan AS ValorIDLoan, @Date_Loan AS Date;

        COMMIT TRANSACTION; --Confirmamos la transacción.
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;--Generamos el error (Ahora no será usado por el catch, sino que llegará a la aplicación desde donde se ejecutó el procedmiento)
    END CATCH;
END;
GO