var schemaQuery = {

"oracle": "SELECT 
    t.owner SCHEMANAME,
    t.table_name TABLE_NAME,
	t.column_name NAME, 
    c.column_name PRIMARYCOLUMN,
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
                acc.owner = :schemaName
                and
                acc.constraint_name = ac.constraint_name
                and
                ac.constraint_type = 'P'
    ) c on
    ( t.owner = c.owner and t.table_name = c.table_name and t.column_name = c.column_name )
WHERE 
	UPPER( t.owner ) = UPPER( :schemaName )
	AND
	UPPER( t.table_name ) = UPPER( :tableName )",

"mssql": "SELECT 
	c.name NAME,
	is_identity ISKEY,
	TYPE_NAME( c.system_type_id ) DATATYPE,
	max_length LENGTH,
	is_nullable NULLABLE,
    pkinfo.pkcolumn PRIMARYCOLUMN
FROM 
	sys.columns AS c 
	INNER JOIN sys.tables AS t ON t.object_id = c.object_id 
	INNER JOIN sys.schemas AS s ON s.schema_id = t.schema_id
    LEFT JOIN (
        SELECT 
            KU.table_name as tbname,
            KU.column_name as pkcolumn
        FROM
            INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC 
        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
            ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' 
            AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
    ) pkinfo
    on ( pkinfo.pkcolumn = c.name and UPPER( pkinfo.tbname ) = UPPER( t.name ) )
WHERE 
	UPPER( s.name ) = UPPER( :schemaName ) 
	AND 
	UPPER( t.name ) = UPPER( :tableName )",
	
"mysql": "SELECT 
    TABLE_NAME,
	COLUMN_NAME NAME,
	COLUMN_KEY ISKEY,
	DATA_TYPE DATATYPE,
	CHARACTER_MAXIMUM_LENGTH LENGTH,
	IS_NULLABLE NULLABLE,
    ( UPPER( extra ) like UPPER( '%auto_increment%' ) ) AUTO_GEN
FROM 
	INFORMATION_SCHEMA.COLUMNS 
WHERE 
	UPPER( TABLE_SCHEMA ) = UPPER( :schemaName ) 
	AND 
	UPPER( TABLE_NAME ) = UPPER( :tableName )"
}

var fkQuery = {
"oracle": "SELECT 
	a.constraint_name constraint_name
	,a.table_name table_name 
	,a.column_name constraint_column_name
	,b.table_name referenced_object
	,b.column_name referenced_column_name
	,'true' entity_only
FROM all_cons_columns a
	JOIN all_constraints c ON 
		a.owner = c.owner
		AND 
		a.constraint_name = c.constraint_name
	JOIN all_cons_columns b ON 
		c.owner = b.owner 
		AND 
		c.r_constraint_name = b.constraint_name
WHERE 
	c.constraint_type = 'R'
	AND 
	upper( a.table_name ) = upper( :tableName )
",

"mssql": "SELECT   
   OBJECT_NAME(f.constraint_object_id) AS constraint_name
   ,OBJECT_NAME(f.parent_object_id) AS table_name  
   ,COL_NAME(f.parent_object_id, f.parent_column_id) AS constraint_column_name  
   ,OBJECT_NAME (f.referenced_object_id) AS referenced_object  
   ,COL_NAME(f.referenced_object_id, f.referenced_column_id) AS referenced_column_name
   ,c.is_identity entity_only
FROM sys.foreign_key_columns AS f
INNER JOIN sys.columns AS C ON (
	f.referenced_object_id = c.object_id 
	and 
	f.referenced_column_id = c.column_id
)
where upper( OBJECT_NAME(f.parent_object_id) ) = upper( :tableName )",

"mysql": "SELECT
    CONSTRAINT_NAME constraint_name,
    TABLE_NAME table_name,
    COLUMN_NAME constraint_column_name,
    REFERENCED_TABLE_NAME referenced_object,
    REFERENCED_COLUMN_NAME referenced_column_name,
    'true' entity_only
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
	REFERENCED_TABLE_NAME is not NULL
	AND 
	upper( table_name ) = upper( :tableName )
	AND
	upper( TABLE_SCHEMA ) = upper( :schemaName )
"
}