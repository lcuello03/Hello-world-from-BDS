﻿CREATE OR REPLACE SEQUENCE PUBLIC.NumericTable_COL7
	START WITH -1
	INCREMENT BY 1
COMMENT = 'FOR TABLE-COLUMN PUBLIC.NumericTable.COL7';

CREATE OR REPLACE TABLE PUBLIC.NumericTable (
	COL1 BOOLEAN NULL,
	COL2 NUMERIC(38, 18),
	COL3 NUMERIC(4, 2),
	COL4 DECIMAL,
	COL5 DECIMAL(8, 3),
	COL6 BIGINT,
	COL7 INT DEFAULT PUBLIC.NumericTable_COL7.NEXTVAL /*** MSC-WARNING - MSCEWI1048 - SEQUENCE -  GENERATED BY DEFAULT  START -1 INCREMENT 1 ***/ ,
	COL8 SMALLINT,
	COL9 TINYINT,
	COL10 DOUBLE PRECISION,
	COL11 DOUBLE PRECISION,
	COL12 FLOAT,
	COL13 FLOAT,
	COL14 REAL
);