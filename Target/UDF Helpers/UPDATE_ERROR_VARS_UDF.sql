-- <copyright file="UPDATE_ERROR_VARS_UDF.cs" company="Mobilize.Net">
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
-- Description: The UPDATE_ERROR_VARS_UDF() function updates the error variables in environment in order to know when the procedure throws an error. 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION UPDATE_ERROR_VARS_UDF(LINE STRING,CODE STRING, STATE STRING, MESSAGE STRING, PROC_NAME STRING, SEVERITY STRING) 
RETURNS STRING
LANGUAGE SQL
IMMUTABLE
AS
$$
	select
	SETVARIABLE('ERROR_LINE',LINE) ||
	SETVARIABLE('ERROR_NUMBER',CODE) ||
	SETVARIABLE('ERROR_STATE',STATE) ||
	SETVARIABLE('ERROR_MESSAGE',MESSAGE) ||
	SETVARIABLE('ERROR_PROCEDURE',PROC_NAME) ||
	SETVARIABLE('ERROR_SEVERITY',SEVERITY)
$$;

CREATE OR REPLACE FUNCTION UPDATE_ERROR_VARS_UDF(MESSAGE STRING, SEVERITY STRING, STATE STRING) 
RETURNS STRING
LANGUAGE SQL
AS
$$
	select
	SETVARIABLE('ERROR_STATE',STATE) ||
	SETVARIABLE('ERROR_MESSAGE',MESSAGE) ||
	SETVARIABLE('ERROR_SEVERITY',SEVERITY)
$$;