USE master;

--=============================Crear la Base de Datos=========================
--EXEC CreateDatabase @Name='LendingClub';
--GO

--Eliminamos si es necesario
IF OBJECT_ID(LendingClub) EXISTS
	

CREATE DATABASE LendingClub;
GO
USE LendingClub;
GO

EXEC sp_tables @table_type='LendingClub';

--=============================Crear las Tablas=========================
--==========Client==========
IF ('Client') IS NOT NULL
    DROP TABLE Client;
GO

CREATE TABLE Client(
    Id_Client INT IDENTITY(1,1),
    Name VARCHAR(100),
    Lastname VARCHAR(100),
    Sex CHAR(1),

    PRIMARY KEY (Id_Client)
);
GO

--==========EconomicSituation==========
IF ('EconomicSituation') IS NOT NULL
    DROP TABLE EconomicSituation;
GO

CREATE TABLE EconomicSituation(
    Id_Client INT, --(FK)
    Log_annual_inc FLOAT,
    Dti FLOAT,
    Pub_rec SMALLINT,
    FICO SMALLINT,

    PRIMARY KEY (Id_Client)
);
GO
--==========Loan==========
IF ('Loan') IS NOT NULL
    DROP TABLE Loan;
GO

CREATE TABLE Loan(
    Id_Loan INT IDENTITY(1,1),
    Id_Purpose INT, --(FK)
    Id_Client INT, --(FK)
    Credit_policy CHAR(1), --(Change name)
    Int_rate FLOAT, --(Change)
    Fee FLOAT,
    Date_loan DATE, --(Change)

    PRIMARY KEY(Id_Loan)
);
GO

--==========Purpose==========
IF ('Purpose') IS NOT NULL
    DROP TABLE Purpose;
GO

CREATE TABLE Purpose(
    Id_Purpose INT IDENTITY(1,1),
    Name VARCHAR(200),

    PRIMARY KEY(Id_Purpose)
);
GO

--==========CreditHistory==========
IF ('CreditHistory') IS NOT NULL
    DROP TABLE CreditHistory;
GO

CREATE TABLE CreditHistory(
    Id_Loan INT, --(FK)
    Days_with_cr_line INT,
    Revol_bal INT,
    Revol_util FLOAT,
    Inq_last_6mths SMALLINT,
    Delinq_2yrs SMALLINT,
    Fully_paid CHAR(1),

    PRIMARY KEY (Id_Loan)
);
GO

--=============================Llaves FORÁNEAS=========================
--==========EconomicSituation==========
ALTER TABLE EconomicSituation
ADD CONSTRAINT FK_EconomicSituation_Id_Client
FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client);
GO

--==========Loan==========
ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_Id_Purpose
FOREIGN KEY (Id_Purpose) REFERENCES Purpose(Id_Purpose);
GO

ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_Id_Client
FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client);
GO

--==========CreditHistory==========
ALTER TABLE CreditHistory
ADD CONSTRAINT FK_CreditHistory_Id_Loan
FOREIGN KEY (Id_Loan) REFERENCES Loan(Id_Loan);
GO

--===================Ver columnas en tabla========
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Client';

--=============================Procedimientos Almacenados=========================
-- CREATE OR ALTER PROCEDURE CreateDatabase
--     @Nombre VARCHAR(50),
--     @Drop CHAR(1) = False

-- AS
-- BEGIN
--     IF (@Nombre) IS NULL
--         BEGIN
--             THROW 50000, 'El Nombre de la base de datos no fue ingresado.', 1;
--         END
--     IF (@Nombre) IS NOT NULL
--         IF @Drop == False
--             BEGIN
--                 THROW 50000, 'La Base de Datos ya existe', 1;
--             END
--         ELSE
--             BEGIN
--                 DROP DATABASE @Nombre;
--             END
        
--     CREATE DATABASE @Nombre;
-- 	USE @Nombre;
-- END;

-- GO