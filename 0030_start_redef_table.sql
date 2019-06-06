REM 004_start_redef_table
REM Start the redefinition process
REM 

EXEC DBMS_REDEFINITION.START_REDEF_TABLE -
( -
UNAME => '&&v_table_owner', -
ORIG_TABLE => '&&v_table_name', -
INT_TABLE  => '&&v_table_int_name' , -
options_flag => dbms_redefinition.CONS_USE_ROWID -
);

