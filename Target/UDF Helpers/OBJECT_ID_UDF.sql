-- <copyright file="OBJECT_ID_UDF.cs" company="Mobilize.Net">
--        Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
-- 
--        This file is part of the Mobilize Frameworks, which is
--        proprietary and confidential.
-- 
--        NOTICE:  All information contained herein is, and remains
--        the property of Mobilize.Net Corporation.
--        The intellectual and technical concepts contained herein are
--        proprietary to Mobilize.Net Corporation and may be covered
--        by U.S. Patents, and are protected by trade secret or copyright law.
--        Dissemination of this information or reproduction of this material
--        is strictly forbidden unless prior written permission is obtained
--        from Mobilize.Net Corporation.
-- </copyright>

-- =========================================================================================================
-- Description: The OBJECT_ID_TABLE_UDF() function checks if a Table with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION TABLE_OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
IMMUTABLE
AS 
$$
	EXISTS (SELECT TABLE_SCHEMA || '.' || TABLE_NAME AS object_id FROM INFORMATION_SCHEMA.TABLES WHERE object_id = NAME)
$$;

-- =========================================================================================================
-- Description: The OBJECT_ID_VIEW_UDF() function checks if a View with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION VIEW_OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
AS 
$$
	EXISTS (SELECT TABLE_SCHEMA || '.' || TABLE_NAME AS object_id FROM INFORMATION_SCHEMA.VIEWS WHERE object_id = NAME)
$$;

-- =========================================================================================================
-- Description: The OBJECT_ID_FUNCTION_UDF() function checks if a Function with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION FUNCTION_OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
AS 
$$
	EXISTS (SELECT FUNCTION_SCHEMA || '.' || FUNCTION_NAME AS object_id FROM INFORMATION_SCHEMA.FUNCTIONS WHERE object_id = NAME)
$$;

-- =========================================================================================================
-- Description: The OBJECT_ID_PROCEDURE_UDF() function checks if a Procedure with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PROCEDURE_OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
AS 
$$
	EXISTS (SELECT PROCEDURE_SCHEMA || '.' || PROCEDURE_NAME AS object_id FROM INFORMATION_SCHEMA.PROCEDURES WHERE object_id = NAME)
$$;

-- =========================================================================================================
-- Description: The OBJECT_ID_CONSTRAINT_UDF() function checks if a Constraint with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION CONSTRAINT_OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
AS 
$$
	EXISTS (SELECT CONSTRAINT_SCHEMA || '.' || CONSTRAINT_NAME AS object_id FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE object_id = NAME)
$$;

-- =========================================================================================================
-- Description: The OBJECT_ID_SEQUENCE_UDF() function checks if a Sequence with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION SEQUENCE_OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
AS 
$$
	EXISTS (SELECT SEQUENCE_SCHEMA || '.' || SEQUENCE_NAME AS object_id FROM INFORMATION_SCHEMA.SEQUENCES WHERE object_id = NAME)
$$;

-- =========================================================================================================
-- Description: The OBJECT_ID_OBJECT_UDF() function checks if an Object with an specific name has been create before. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION OBJECT_ID_UDF(NAME VARCHAR) 
RETURNS BOOLEAN 
LANGUAGE SQL 
AS 
$$
	EXISTS (SELECT OBJECT_SCHEMA || '.' || OBJECT_NAME AS object_id FROM INFORMATION_SCHEMA.OBJECT_PRIVILEGES WHERE object_id = NAME)
$$;