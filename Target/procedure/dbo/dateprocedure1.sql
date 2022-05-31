CREATE OR REPLACE PROCEDURE PUBLIC.DateProcedure1 ()
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

	let VAL = 1 + 1;
	while ( VAL > 0 ) {
		if (VAL == 2) {
			EXEC(`				INSERT INTO PUBLIC.DateTable VALUES ('9999-12-31', '2021-12-31 10:00:00', '2021-12-31 10:00:00', '2021-12-31 10:00:00')`);
		} else if (VAL == 1) {
			EXEC(`				INSERT INTO PUBLIC.DateTable VALUES ('0001-01-01', '2023-01-01 02:02:02', '2023-01-01 02:02:02', '2023-01-01 02:02:02')`);
		}
		VAL -= 1;
	}
$$;