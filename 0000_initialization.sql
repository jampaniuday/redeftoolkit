connect / as sysdba

select 'Oracle SID for this partitioning exercise is ' || sid from v$mystat where rownum=1;

define v_job_dop = '4';
define v_table_owner = 'HR';
define v_table_name = 'PARTITION1';
define v_table_int_name = 'PARTITION1_INT';
define v_tablespace_name = 'PARTITION1';

set echo on;
set feedback on;
set lines 175;
set long 65536;
set pages 50;
set serveroutput on size 1000000;
set time on;
set timing on;
set verify on;

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION FORCE PARALLEL DML PARALLEL &&v_job_dop;
ALTER SESSION FORCE PARALLEL QUERY PARALLEL &&v_job_dop;

alter session enable resumable timeout 43000 name 'reorg &&v_table_name';

alter session set nls_date_format='mm/dd/yyyy hh24:mi:ss';

exec DBMS_APPLICATION_INFO.set_module(module_name => 'Partition table &&v_table_name', action_name => '');
exec DBMS_APPLICATION_INFO.set_action(action_name => '0000_initialization');

whenever sqlerror exit 1

