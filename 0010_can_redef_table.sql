REM 001_can_redef_table
REM Determine if the table is able to participate in DBMS_REDEFINITION
REM In reality, should have been before now

EXEC DBMS_REDEFINITION.CAN_REDEF_TABLE -
( -
'&&v_table_owner' , -
'&&v_table_name' , -
options_flag => dbms_redefinition.CONS_USE_ROWID -
);
