CREATE OR REPLACE PROCEDURE PUBLIC.OBJECT_ID_PROCEDURE ()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
	// REGION SnowConvert Helpers Code
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
	var SELECT = (sql,binds = [],...args) => {
		var reducers = args.filter((i) => i instanceof Function);
		reducers = reducers.length ? reducers : [(value) => value]
		args = args.splice(0,args.length - reducers.length)
		EXEC("SELECT " + sql,binds)
		if (ROW_COUNT < 1) return;
		var colCount = _ROWS.getColumnCount();
		if (colCount != reducers.length) throw new Error("Missing arguments results has ${colCount} columns");
		var cols = Array.from(Array(colCount),() => []);
		while ( _ROWS.next() ) {
			for(var i = 0;i < colCount;i++) {
				cols[i].push(_ROWS.getColumnValue(i + 1))
			}
		}
		if (colCount == 1) {
			cols[0].forEach((value) => reducers[0](value))
			return (cols[0])[0];
		}
		for(var i = 0;i < colCount;i++) {
			cols[i].forEach((value) => reducers[i](value))
		}
	};
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

	EXEC(`	SELECT
	   --** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'FUNCTION_OBJECT_ID_UDF' INSERTED. **
	   FUNCTION_OBJECT_ID_UDF('PUBLIC.FUNCTION1')`);
	if (SELECT(`   --** MSC-WARNING - MSCEWI1020 - CUSTOM UDF 'PROCEDURE_OBJECT_ID_UDF' INSERTED. **
   PROCEDURE_OBJECT_ID_UDF('PUBLIC.CONVERT_PROCEDURE')`)) {
		{
			EXEC(`CREATE TABLE PUBLIC.OBJECT_ID_TABLE AS
   SELECT
      *
      FROM (SELECT 1 AS COL1
      ) object_id_query`);
		}
	} else {
		{
			EXEC(`CREATE TABLE PUBLIC.OBJECT_ID_TABLE AS
   SELECT
      *
      FROM (SELECT 0 AS COL1
      ) object_id_query`);
		}
	}
$$;