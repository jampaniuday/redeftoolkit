exec dbms_redefinition.finish_redef_table -
( -
UNAME      => '&&v_table_owner', -
ORIG_TABLE => '&&v_table_name', -
INT_TABLE  => '&&v_table_int_name' -
);

