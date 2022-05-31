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