create database nnl;

use nnl;

alter database nnl set single_user with rollback immediate;

alter database nnl modify name = nnl_evm;

alter database nnl_evm set multi_user;

use nnl_evm;

create schema l2h;

create table [l2h].[staging] (
    id bigint identity(1, 1),
    tid varchar(128),
    path varchar(256) not null,
    filename varchar(128) not null,
    created datetime2 default( SYSUTCDATETIME() ) not null,
    updated datetime2 generated always as row start not null,
    payload varchar(max),
    status varchar(12) check( status in( 'NEW', 'READY', 'PROCESSING', 'DONE', 'ERROR', 'FAILED', 'ARCHIVED' ) ) not null,
    errormessage varchar(4096),
    validuntil datetime2 generated always as row end hidden not null,
    period for system_time ( updated, validuntil ),
    constraint pk_nnl_evm_staging primary key ( id )
);

drop table [l2h].[staging];

insert into l2h.staging  ( filename, payload, status ) values ( 'test.txt', 'test is a test', 'NEW' );

select * from l2h.staging;

update staging set payload= ' This is a test!' where id = 1;

select count(*) from l2h.staging;

delete from l2h.staging;

commit;
