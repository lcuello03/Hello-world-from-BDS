CREATE OR ALTER PROCEDURE NumericProcedure1 @VALUE INT = 10 AS
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