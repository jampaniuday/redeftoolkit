EXEC DBMS_REDEFINITION.SYNC_INTERIM_TABLE -
( -
UNAME => '&&v_table_owner', -
ORIG_TABLE => '&&v_table_name', -
INT_TABLE  => '&&v_table_int_name' -
);

