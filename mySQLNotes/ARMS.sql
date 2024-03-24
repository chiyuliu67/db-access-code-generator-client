insert into logs ( ID ) values ( 1 );
insert into logs ( ID, logger) values ( 1, 'INFO' );
select logger from LOGS;

drop table logs;

CREATE TABLE "ARMS"."LOGS" 
   (
    "ID" VARCHAR2(50 BYTE), 
	"eventDate" TIMESTAMP (6), 
	"literalColumn" VARCHAR2(500 BYTE), 
	"loglevel" VARCHAR2(500 BYTE), 
	"logger" VARCHAR2(500 BYTE), 
	"message" VARCHAR2(4000 BYTE), 
	"exceptionMessage" VARCHAR2(500 BYTE), 
	 PRIMARY KEY ("ID")
); 
select ADDRESS from LOCATIONS;

SELECT 
    t.owner schemaName,
    t.table_name,
	t.column_name NAME, 
    c.column_name primaryColumn,
	t.data_type DATATYPE, 
	t.data_length LENGTH, 
	t.nullable NULLABLE,
	t.DATA_PRECISION P,
	t.DATA_SCALE S,
	t.identity_column ISKEY, 
    t.DATA_DEFAULT
FROM 
	ALL_TAB_COLUMNS t
LEFT JOIN (
    select 
        acc.owner, 
        acc.table_name, 
        acc.column_name 
    from 
        all_cons_columns acc 
        join 
            all_constraints ac 
            on 
                acc.owner = 'ARMS'
                and
                acc.constraint_name = ac.constraint_name
                and
                ac.constraint_type = 'P'
    ) c on
    ( t.owner = c.owner and t.table_name = c.table_name and t.column_name = c.column_name )
WHERE 
	UPPER( t.owner ) = UPPER( 'ARMS' );
	AND
	UPPER( t.table_name ) = UPPER( 'COUNTRIES' );


SELECT * FROM all_cons_columns WHERE constraint_name = (
  SELECT constraint_name FROM all_constraints 
  WHERE UPPER(table_name) = UPPER('ORDER_ITEMS') AND CONSTRAINT_TYPE = 'P'
);


select 
    acc.owner, 
    acc.table_name, 
    acc.column_name 
from 
    all_cons_columns acc 
    join 
        all_constraints ac 
        on 
            acc.owner = 'ARMS'
            and
            acc.constraint_name = ac.constraint_name
            and
            ac.constraint_type = 'P';

select * from all_constraints where upper( owner ) = 'ARMS' and constraint_type = 'P';

select * from v$sql where SQL_TEXT like '%to_date%' ORDER BY FIRST_LOAD_TIME DESC;



SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, TO_CHAR( HIRE_DATE, 'yyyy-MM-dd"T"HH24:MI:SS"Z"' ) HIRE_DATE, MANAGER_ID, JOB_TITLE FROM EMPLOYEES WHERE  ((HIRE_DATE = to_date( '2016-06-07', 'yyyy-MM-dd' ))) ORDER BY JOB_TITLE ASC OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, TO_CHAR( HIRE_DATE, 'yyyy-MM-dd' ) HIRE_DATE, MANAGER_ID, JOB_TITLE FROM EMPLOYEES WHERE  ((HIRE_DATE = to_date( '2016-06-07', 'yyyy-MM-dd' ))) ORDER BY JOB_TITLE ASC OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, TO_CHAR( HIRE_DATE, 'yyyy-MM-dd"T"HH24:MI:SS"Z"' ) HIRE_DATE, MANAGER_ID, JOB_TITLE FROM EMPLOYEES WHERE  ((HIRE_DATE = to_date( '2016-06-07T00:00:00Z', 'yyyy-MM-dd"T"HH24:MI:SS"Z"' ))) ORDER BY JOB_TITLE ASC OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, TO_CHAR( HIRE_DATE, 'yyyy-MM-dd"T"HH24:MI:SS"Z"' ) HIRE_DATE, MANAGER_ID, JOB_TITLE FROM EMPLOYEES  WHERE  (HIRE_DATE = to_date( '2016-06-07T00:00:00Z', 'yyyy-MM-dd"T"HH24:MI:SS"Z"' )) ORDER BY JOB_TITLE ASC OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, TO_CHAR( HIRE_DATE, 'yyyy-MM-dd"T"HH24:MI:SS"Z"' ) HIRE_DATE, MANAGER_ID, JOB_TITLE FROM EMPLOYEES  WHERE  (HIRE_DATE = to_date( ':parameter1', 'yyyy-MM-dd\"T\"HH24:MI:SS\"Z\"' )) ORDER BY JOB_TITLE ASC OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;

