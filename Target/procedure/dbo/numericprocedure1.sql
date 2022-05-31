CREATE OR REPLACE PROCEDURE PUBLIC.NumericProcedure1 (/*** MSC-WARNING - MSCEWI4009 - The default value 10 is not supported by Snowflake. ***/ VALUE FLOAT)
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

	let COL1_0 = 1;
	let COL1_1 = 0;
	let COL1_2;
	COL1_2 = null;
	try {
		if ([1,10].includes(VALUE)) {
			{
				EXEC(`			INSERT INTO PUBLIC.NumericTable (COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (?, 123, .1234, 123.123, 12345.678, -12345, 100, 255, 45643, 909, 12345.67, 123456.78, 3443)`,[COL1_0]);
				EXEC(`			INSERT INTO PUBLIC.NumericTable (COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (?, 2*2, 00.01, -0.0, 0000.00, 11233*3, 1024, 255, 9085, 909, 123.5678, 123.5678, -001)`,[COL1_1]);
				EXEC(`			INSERT INTO PUBLIC.NumericTable (COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (?, +1, +99.99, +123.123, +99999.999, +9223372036854775807, +32767, +255, +9223372036, +214748, +1111111, +123456.78, +1)`,[COL1_2]);
				EXEC(`			INSERT INTO PUBLIC.NumericTable (COL1, COL2, COL3, COL4, COL5, COL6, COL8, COL9, COL10, COL11, COL12, COL13, COL14) VALUES (?, -1, -00.00, -123.123, -99999.999, -9223372036854775808, -32768, -0, -9223372036, -214748, -00000000, -123456.78, -1)`,[COL1_2]);
			}
		} else {
			{
				;
				throw {
					code : 50005,
					message : "'NumericTable does not exists'",
					state : 1
				};
			}
		}
	} catch(error) {
		return -1;
	}
$$;