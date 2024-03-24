SELECT 
    TABLE_NAME tablename,
	COLUMN_NAME NAME,
	COLUMN_KEY ISKEY,
	DATA_TYPE DATATYPE,
	CHARACTER_MAXIMUM_LENGTH LENGTH,
	IS_NULLABLE NULLABLE,
    ( UPPER( extra ) like UPPER( '%auto_increment%' ) ) isAutoIncrement
FROM 
	INFORMATION_SCHEMA.COLUMNS 
WHERE 
	UPPER( TABLE_SCHEMA ) = UPPER( 'arms' );
	AND 
	UPPER( TABLE_NAME ) = UPPER( 'countries' );

SELECT t.table_schema, t.table_name, k.column_name
FROM information_schema.table_constraints t
JOIN information_schema.key_column_usage k
USING(constraint_name,table_schema,table_name)
WHERE t.constraint_type='PRIMARY KEY'
  AND t.table_schema='ARMS';
  AND t.table_name='COUNTRIES';

select * from INFORMATION_SCHEMA.COLUMNS ;
select * from information_schema.table_constraints;

CREATE TABLE Sales(
   ID INT PRIMARY KEY AUTO_INCREMENT,
   ProductName VARCHAR (20) NOT NULL,
   CustomerName VARCHAR (20) NOT NULL,
   DispatchDate date,
   DeliveryTime timestamp,
   Price INT,
   Location varchar(20)
);

insert into SALES (
   ID,
   ProductName,
   CustomerName
)
values (
    101,
    'EV',
    'Louis Liu'
);
rename table Sales to SALES;
Select * from SALES;

delete from SALES where id = 102;