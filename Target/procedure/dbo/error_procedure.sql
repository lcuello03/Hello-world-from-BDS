CREATE OR REPLACE PROCEDURE PUBLIC.ERROR_PROCEDURE ()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
	// REGION SnowConvert Helpers Code
	var _RS, ROW_COUNT, _ROWS, MESSAGE_TEXT, SQLCODE = 0, SQLSTATE = '00000', OBJECT_SCHEMA_NAME  = 'UNKNOWN', ERROR_HANDLERS, NUM_ROWS_AFFECTED, PROC_NAME = arguments.callee.name, DOLLAR_DOLLAR = '$' + '$';
	function* sqlsplit(sql) {
		var part = '';
		var ismark = () => sql[i] == '$' && sql[i + 1] == '$';
		for(var i = 0;i < sql.length;i++) {
			if (sql[i] == ';') {
				yield part + sql[i];
				part = '';
			} else if (ismark()) {
				part += sql[i++] + sql[i++];
				while ( i < sql.length && !ismark() ) {
					part += sql[i++];
				}
				part += sql[i] + sql[i++];
			} else part += sql[i];
		}
		if (part.trim().length) yield part;
	};
	var formatDate = (arg) => (new Date(arg - (arg.getTimezoneOffset() * 60000))).toISOString().slice(0,-1);
	var fixBind = function (arg) {
		arg = arg == undefined ? null : arg instanceof Date ? formatDate(arg) : arg;
		return arg;
	};
	var EXEC = (stmt,binds = [],severity = "16",noCatch = false) => {
		binds = binds ? binds.map(fixBind) : binds;
		for(var stmt of sqlsplit(stmt)) {
			try {
				_RS = snowflake.createStatement({
						sqlText : stmt,
						binds : binds
					});
				_ROWS = _RS.execute();
				ROW_COUNT = _RS.getRowCount();
				NUM_ROWS_AFFECTED = _RS.getNumRowsAffected();
				return {
					THEN : (action) => !SQLCODE && action(fetch(_ROWS))
				};
			} catch(error) {
				let rStack = new RegExp('At .*, line (\\d+) position (\\d+)');
				let stackLine = error.stackTraceTxt.match(rStack) || [0,-1];
				MESSAGE_TEXT = error.message.toString();
				SQLCODE = error.code.toString();
				SQLSTATE = error.state.toString();
				snowflake.execute({
					sqlText : `SELECT UPDATE_ERROR_VARS_UDF(?,?,?,?,?,?)`,
					binds : [stackLine[1],SQLCODE,SQLSTATE,MESSAGE_TEXT,PROC_NAME,severity]
				});
				throw error;
			}
		}
	};
	// END REGION

	try {
		let _VAR = 0;
		EXEC(`		SELECT 1/ ?`,[_VAR]);
	} catch(error) {
		EXEC(`CREATE TABLE PUBLIC.ERROR_TABLE AS
   SELECT
      *
      FROM
      		(SELECT
               /*** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'ERROR_NUMBER_UDF' INSERTED. ***/
               ERROR_NUMBER_UDF() AS ERROR_NUMBER,
               /*** MSC-WARNING - MSCEWI4025 - CUSTOM UDF 'ERROR_SEVERITY_UDF' INSERTED FOR ERROR_SEVERITY FUNCTION. ***/
               ERROR_SEVERITY_UDF() AS ERROR_SEVERITY,
               /*** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'ERROR_STATE_UDF' INSERTED. ***/
               ERROR_STATE_UDF() AS ERROR_STATE,
               /*** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'ERROR_PROCEDURE_UDF' INSERTED. ***/
               ERROR_PROCEDURE_UDF() AS ERROR_PROCEDURE,
               /*** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'ERROR_LINE_UDF' INSERTED. ***/
               ERROR_LINE_UDF() AS ERROR_LINE,
               /*** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'ERROR_MESSAGE_UDF' INSERTED. ***/
               ERROR_MESSAGE_UDF() AS ERROR_MESSAGE
      		) error_query`);
	}
$$;