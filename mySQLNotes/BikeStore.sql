select a.name as table_name, b.name as column_name from sys.columns as a LEFT JOIN sys.objects as b on a.object_id = b.object_id where a.is_identity > 0;

select object_id( 'PRODUCTION.BRANDS' ) as Result;

SELECT 
  name,
  object_id,
  OBJECT_ID( 'PRODUCTION.BRANDS' ) AS [OBJECT_ID(name)]
FROM sys.objects
WHERE name = 'BRANDS';

CREATE TABLE [sales].[Employee] (
    Emp_ID VARCHAR(20) NOT NULL,
    Name VARCHAR(50) NOT NULL, 
    Age INT,
    Phone_No VARCHAR(10),
    Address VARCHAR(100),
    PRIMARY KEY (Emp_ID)
);
 
drop table [sales].[employee];

insert into sales.employee (
    Emp_ID,
    Name, 
    Age,
    Phone_No,
    Address
)
values (
    '001',
    'Louis Liu',
    56,
    '5852818075',
    '10 Terrain Dr.'
);

select * from sales.employee;


CREATE TABLE [sales].[Employee] (
    Emp_ID VARCHAR(20) NOT NULL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL, 
    Age INT,
    Phone_No VARCHAR(10),
    Address VARCHAR(100)
);


SELECT 
    pkinfo.SCHEMANAME SCHEMANAME,
	c.name NAME,
	is_identity ISKEY,
	TYPE_NAME( c.system_type_id ) DATATYPE,
	max_length LENGTH,
	is_nullable NULLABLE,
    pkinfo.pkcolumn PRIMARYCOLUMN
FROM 
	sys.columns AS c 
	LEFT JOIN sys.tables AS t ON t.object_id = c.object_id 
	LEFT JOIN sys.schemas AS s ON s.schema_id = t.schema_id
    LEFT JOIN (
        SELECT 
            KU.table_schema as SCHEMANAME,
            KU.table_name as tbname,
            KU.column_name as pkcolumn
        FROM
            INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC 
        LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
            ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' 
            AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
    ) pkinfo
    on ( pkinfo.pkcolumn = c.name and UPPER( pkinfo.tbname ) = UPPER( t.name ) )
WHERE 
	UPPER( s.name ) = UPPER( 'production' ) 
	AND 
	UPPER( t.name ) = UPPER( 'stocks' );

SELECT 
     KU.table_name as TABLENAME
    ,KU.column_name as PRIMARYKEYCOLUMN
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC 
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
    ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' 
    AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
ORDER BY 
     KU.TABLE_NAME
    ,KU.ORDINAL_POSITION
; 

select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS as TC where TC.CONSTRAINT_TYPE = 'PRIMARY KEY';
select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE as KU;
select * from sys.columns;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1
AND TABLE_NAME = 'employee' AND TABLE_SCHEMA = 'sales';

SELECT PRODUCT_NAME, LIST_PRICE, MODEL_YEAR, PRODUCT_ID FROM PRODUCTION.PRODUCTS  WHERE  (BRAND_ID = convert( int, convert( float, 6 ) ) ) ORDER BY PRODUCT_ID OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;