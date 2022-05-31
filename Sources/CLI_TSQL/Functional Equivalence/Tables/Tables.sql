﻿CREATE TABLE NumericTable 
(
	-- Exact numerics
	COL1 [BIT] NULL,
	COL2 [NUMERIC],
	COL3 [NUMERIC](4, 2),
	COL4 [DECIMAL],
	COL5 [DECIMAL](8, 3),
	COL6 [BIGINT],
	COL7 [INT] IDENTITY(-1, 1),
	COL8 [SMALLINT],
	COL9 [TINYINT],
	COL10 [MONEY],
	COL11 [SMALLMONEY],
-- Approx numerics
	COL12 [FLOAT](8),
	COL13 [FLOAT],
	COL14 [REAL]
);

CREATE TABLE DateTable
(
	-- Date and time
	COL1 [DATE],
	COL2 [DATETIME2],
	COL3 [DATETIME2](2),
	COL4 [DATETIME]
);

CREATE TABLE StringTable
(
	COL1 [CHAR] DEFAULT 'HELLO',
	COL2 [CHAR](5),
	COL3 [VARCHAR] COLLATE Modern_Spanish_CI_AI DEFAULT 'HOLA' NOT NULL,
	COL4 [VARCHAR](max) COLLATE Latin1_General_CI_AI DEFAULT 'HOLA' NOT NULL,
-- Unicode character strings
	COL5 [NVARCHAR],
	COL6 [NVARCHAR](15)
);