﻿CREATE OR ALTER PROCEDURE NumericProcedure1 @VALUE INT = 10 AS
DECLARE @COL1_0 [BIT] = 1;
DECLARE @COL1_1 [BIT] = 0;
DECLARE @COL1_2 [BIT];

SET @COL1_2 = NULL;

BEGIN TRY
	IF (@VALUE in (1, 10))
		BEGIN
			INSERT INTO NumericTable(COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (@COL1_0, 123, .1234, 123.123, 12345.678, -12345, 100, 255, 45643, 909, 12345.67, 123456.78, 3443);
			INSERT INTO NumericTable(COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (@COL1_1, 2*2, 00.01, -0.0, 0000.00, 11233*3, 1024, 255, 9085, 909, 123.5678, 123.5678, -001);
			INSERT INTO NumericTable(COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (@COL1_2, +1, +99.99, +123.123, +99999.999, +9223372036854775807, +32767, +255, +9223372036, +214748, +1111111, +123456.78, +1);
			INSERT INTO NumericTable(COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (@COL1_2, -1, -00.00, -123.123, -99999.999, -9223372036854775808, -32768, -0, -9223372036, -214748, -00000000, -123456.78, -1);

		END
	ELSE
		BEGIN
			;THROW 50005, 'NumericTable does not exists', 1;
		END
END TRY

BEGIN CATCH
	RETURN -1;
END CATCH

GO

-- query1
EXEC NumericProcedure1;

GO

CREATE OR ALTER PROCEDURE DateProcedure1 AS
	DECLARE @VAL [INT] = 1 + 1;
	WHILE @VAL > 0
		BEGIN
			IF @VAL = 2
				INSERT INTO DateTable VALUES ('9999-12-31', '2021-12-31 10:00:00', '2021-12-31 10:00:00', '2021-12-31 10:00:00');

			ELSE IF @VAL = 1
				INSERT INTO DateTable VALUES ('0001-01-01', '2023-01-01 02:02:02', '2023-01-01 02:02:02', '2023-01-01 02:02:02');
				
		SET @VAL -= 1;
		END
GO

-- query2
EXEC DateProcedure1;

GO

CREATE OR ALTER PROCEDURE StringProcedure1 AS
	DECLARE @i INT = 0;

	CREATE TABLE #TemporaryStringTable
	(
		COL1 [CHAR] DEFAULT 'HELLO',
		COL2 [CHAR](5),
		COL3 [VARCHAR] COLLATE Modern_Spanish_CI_AI DEFAULT 'HOLA' NOT NULL,
		COL4 [VARCHAR](max) COLLATE Latin1_General_CI_AI DEFAULT 'HOLA' NOT NULL,
	-- Unicode character strings
		COL5 [NVARCHAR],
		COL6 [NVARCHAR](15)
	);

	INSERT INTO #TemporaryStringTable VALUES ('0', '.....', '!', 'Helaos', '>', '123456789123456');
	INSERT INTO #TemporaryStringTable VALUES ('1', '.....', '#', 'Hello', '_', 'aAaAaAaAaAaAaAa');
	INSERT INTO #TemporaryStringTable VALUES ('2', '.....', '$', 'Something', '[', '~ABC~');
	INSERT INTO #TemporaryStringTable VALUES ('3', '.....', '%', '.>,.,/:', '{', '[COL1]');

	INSERT INTO StringTable SELECT * FROM #TemporaryStringTable;

	DELETE #TemporaryStringTable WHERE COL2 = '.....';
	DROP TABLE IF EXISTS #TemporaryStringTable;

	WHILE @i < 4
		BEGIN
			WITH TemporaryStringTableSelect AS (SELECT * FROM StringTable)
			SELECT * FROM TemporaryStringTableSelect WHERE COL1 = @i;

			SET @i += 1;
		END;
GO

-- query3
EXEC StringProcedure1;

GO

CREATE OR ALTER PROCEDURE NumericProcedure2 @Clean BIT AS
BEGIN
	DECLARE @VALUE1 AS VARCHAR = 'A';

	Declares:
	DECLARE @VALUE2 INT;
	SET @VALUE2 = 1;

	BeginTry:

	BEGIN TRY
		CREATE TABLE NumericProcedure2Table
		(
			COL1 VARCHAR,
			COL2 SMALLINT
		);

		DECLARE CUSTOM_CURSOR CURSOR FOR SELECT COL8 FROM NumericTable;
		DECLARE @VALUE3 AS SMALLINT = 1;
		OPEN CUSTOM_CURSOR;
		
		FETCH NEXT FROM CUSTOM_CURSOR INTO @VALUE3;
		INSERT INTO NumericProcedure2Table SELECT CHAR(ASCII(@VALUE1) + @VALUE2), @VALUE3;
		SET @VALUE2 += 1;

		FETCH NEXT FROM CUSTOM_CURSOR INTO @VALUE3;
		INSERT INTO NumericProcedure2Table SELECT CHAR(ASCII(@VALUE1) + @VALUE2), @VALUE3;
		SET @VALUE2 += 1;

		FETCH NEXT FROM CUSTOM_CURSOR INTO @VALUE3;
		INSERT INTO NumericProcedure2Table SELECT CHAR(ASCII(@VALUE1) + @VALUE2), @VALUE3;
		SET @VALUE2 += 1;

		FETCH NEXT FROM CUSTOM_CURSOR INTO @VALUE3;
		INSERT INTO NumericProcedure2Table SELECT CHAR(ASCII(@VALUE1) + @VALUE2), @VALUE3;
		SET @VALUE2 += 1;

		IF @Clean = 1
			GOTO Cleanup

		GOTO NotCleanup
	END TRY
	
	BEGIN CATCH
		GOTO Cleanup
	END CATCH

	NotCleanup:
	GOTO Finished

	Finished:
	Return 1

	Cleanup:
	CLOSE CUSTOM_CURSOR;
	DEALLOCATE CUSTOM_CURSOR;
	GOTO Finished
END;

GO

-- query4
EXEC NumericProcedure2 @Clean = 1;