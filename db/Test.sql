-- ==========================Eliminamos la información=======================
-- Truncate no funcionará debido a las FK
USE LendingClub;
GO
DELETE TOP (10000) FROM CreditHistory;
DELETE TOP (10000) FROM Loan;
DELETE TOP (10000) FROM Purpose;
DELETE TOP (10000) FROM EconomicSituation;
DELETE TOP (10000) FROM Client;
GO
DBCC CHECKIDENT('Loan',reseed, 0);
GO
DBCC CHECKIDENT('Client',reseed, 0);
GO
DBCC CHECKIDENT('Purpose',reseed, 0);

GO

USE LendingClub_DW;
GO
DELETE TOP (10000) FROM CreditHistory;
DELETE TOP (10000) FROM TimeCreditLine;
DELETE TOP (10000) FROM Loan;
DELETE TOP (10000) FROM Client;
DELETE TOP (10000) FROM DateLoan;

GO
-- ==========================Verificamos=======================
USE LendingClub;
SELECT * FROM Loan;

GO
USE LendingClub_DW;
SELECT * FROM Loan;

--============================Vemos la información de la base de datos OLTP=========================
USE LendingClub;
GO
SELECT * FROM CreditHistory;
GO
SELECT * FROM Loan;
GO
SELECT * FROM Purpose;
GO
SELECT * FROM EconomicSituation;
GO
SELECT * FROM Client;
GO

--============================Vemos la información del DataWareHouse=========================
USE LendingClub_DW;
SELECT * FROM Loan;
GO
SELECT * FROM Client;
GO
SELECT * FROM DateLoan;
GO
SELECT * FROM TimeCreditLine;
GO
SELECT * FROM CreditHistory;
GO




