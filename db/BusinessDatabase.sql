USE master;

/*
SQLServer trabaja con las nomenclaturas de escritura Pascal o CamelCase.

*/


/*
En resumen: 
CREATE OR ALTER es una forma más flexible de crear o modificar procedimientos, preservando la seguridad existente y evitando recompilaciones innecesarias.
CREATE OR REPLACE es una forma más directa de reemplazar un procedimiento, manteniendo la propiedad y permisos intactos. 
*/

--=============================Crear la Base de Datos=========================
--EXEC CreateDatabase@Name='LendingClub_BI';
--GO

CREATE DATABASE LendingClub_DW;
GO
USE LendingClub_DW;
GO

--=============================Crear las Tablas=========================

IF ('Client') IS NOT NULL
    DROP TABLE Client;

CREATE TABLE Client(
    Id_Client INT,
    Sex CHAR(1),
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

CREATE TABLE Loan(
    Id_Loan INT,
    Id_Client INT, --(FK)
    Id_Date INT, --(FK)
    Purpose VARCHAR(200),
    Credyt_policy CHAR(1),
    Int_Rate FLOAT,
    Fee FLOAT,

    PRIMARY KEY(Id_Loan)
);
GO

IF ('DateLoan') IS NOT NULL
	DROP TABLE DateLoan;

CREATE TABLE DateLoan(
    Id_Date INT IDENTITY(1,1),
    --Date_Loan DATE,
    Year SMALLINT,
    Quarter TINYINT,
    Month SMALLINT,
    Month_description VARCHAR(20),
    Day TINYINT,
    Day_description VARCHAR(20),
    
    PRIMARY KEY(Id_Date)
);
GO

--==========CreditHistory==========
IF ('CreditHistory') IS NOT NULL
    DROP TABLE CreditHistory;

CREATE TABLE CreditHistory(
    Id_Loan INT, --(FK)
    Id_Time_Credit INT, --(FK)
    Revol_bal INT,
    Revol_util FLOAT,
    Inq_last_6mths SMALLINT,
    Delinq_2yrs SMALLINT,
    Fully_paid CHAR(1),

    PRIMARY KEY (Id_Loan)
);
GO

IF ('TimeCreditLine') IS NOT NULL
	DROP TABLE TimeCreditLine;

CREATE TABLE TimeCreditLine(
    Id_Time_Credit INT IDENTITY(1,1),
    --Days_Total INT,
    Years_with_cr_line TINYINT,
    Months_with_cr_line SMALLINT,
    Days_with_cr_line INT,

    PRIMARY KEY(Id_Time_Credit)
);
GO

--=============================Llaves FORÁNEAS=========================
--==========Loan==========
ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_Id_Date
FOREIGN KEY (Id_Date) REFERENCES DateLoan(Id_Date);
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

ALTER TABLE CreditHistory
ADD CONSTRAINT FK_CreditHistory_Id_Time_Credit
FOREIGN KEY (Id_Time_Credit) REFERENCES TimeCreditLine(Id_Time_Credit);
GO

--===================Ver columnas en tabla========
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Client';