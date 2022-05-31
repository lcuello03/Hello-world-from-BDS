CREATE OR REPLACE PROCEDURE PUBLIC.NumericProcedure2 (CLEAN FLOAT)
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
	// REGION SnowConvert Helpers Code
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
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
	var CURSOR = function (stmt,binds) {
		var statementObj, result_set, total_rows, isOpen = false, result_set_table = '', self = this;
		this.CURRENT = new Object;
		this.OPEN = function (usingParams) {
				try {
					if (usingParams) binds = usingParams;
					if (binds instanceof Function) binds = binds();
					var finalBinds = binds && binds.map(fixBind);
					var finalStmt = stmt instanceof Function ? stmt() : stmt;
					statementObj = snowflake.createStatement({
							sqlText : finalStmt,
							binds : finalBinds
						});
					result_set = statementObj.execute();
					total_rows = statementObj.getRowCount();
					isOpen = true;
					row_count = 0;
				} catch(error) {
					RAISE(error.code,"error",error.message);
				}
				return this;
			};
		this.CURSOR_ROWS = function () {
				return total_rows;
			};
		this.FETCH_STATUS = function () {
				return total_rows >= row_count;
			};
		this.FETCH_NEXT = function () {
				self.res = [];
				self.res = fetch(total_rows,result_set,statementObj);
				if (self.res) row_count++
				return self.res && self.res.length > 0;
			};
		this.INTO = function () {
				return self.res;
			};
		this.CLOSE = function () {
				isOpen = row_count = result_set_table = total_rows = result_set = statementObj = undefined;
			};
		this.DEALLOCATE = function () {
				this.CURRENT = self = undefined;
			};
	};
	// END REGION

	let VALUE3;
	let CUSTOM_CURSOR = new CURSOR(`SELECT
   COL8
FROM
   PUBLIC.NumericTable`,[],false);
	let VALUE2;
	let VALUE1 = `A`;
	DECLARES();
	BEGINTRY();
	NOTCLEANUP();
	FINISHED();
	CLEANUP();
	function DECLARES() {
		VALUE2 = 1;
	}
	function BEGINTRY() {
		try {
			EXEC(`CREATE OR REPLACE TABLE PUBLIC.NumericProcedure2Table
(
   COL1 VARCHAR,
   COL2 SMALLINT
)`);
			VALUE3 = 1;
			CUSTOM_CURSOR.OPEN();
			CUSTOM_CURSOR.FETCH_NEXT() && ([VALUE3] = CUSTOM_CURSOR.INTO());
			EXEC(`		INSERT INTO PUBLIC.NumericProcedure2Table
		SELECT
		   CHAR(ASCII(?) + ?),
		   ?`,[VALUE1,VALUE2,VALUE3]);
			VALUE2 += 1;
			CUSTOM_CURSOR.FETCH_NEXT() && ([VALUE3] = CUSTOM_CURSOR.INTO());
			EXEC(`		INSERT INTO PUBLIC.NumericProcedure2Table
		SELECT
		   CHAR(ASCII(?) + ?),
		   ?`,[VALUE1,VALUE2,VALUE3]);
			VALUE2 += 1;
			CUSTOM_CURSOR.FETCH_NEXT() && ([VALUE3] = CUSTOM_CURSOR.INTO());
			EXEC(`		INSERT INTO PUBLIC.NumericProcedure2Table
		SELECT
		   CHAR(ASCII(?) + ?),
		   ?`,[VALUE1,VALUE2,VALUE3]);
			VALUE2 += 1;
			CUSTOM_CURSOR.FETCH_NEXT() && ([VALUE3] = CUSTOM_CURSOR.INTO());
			EXEC(`		INSERT INTO PUBLIC.NumericProcedure2Table
		SELECT
		   CHAR(ASCII(?) + ?),
		   ?`,[VALUE1,VALUE2,VALUE3]);
			VALUE2 += 1;
			if (CLEAN == 1) {
				return CLEANUP();
			}
			return NOTCLEANUP();
		} catch(error) {
			return CLEANUP();
		}
	}
	function NOTCLEANUP() {
		return FINISHED();
	}
	function FINISHED() {
		return 1;
	}
	function CLEANUP() {
		CUSTOM_CURSOR.CLOSE();
		CUSTOM_CURSOR.DEALLOCATE();
		return FINISHED();
	}
$$;