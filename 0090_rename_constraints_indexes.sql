alter session set current_schema=&&v_table_owner;
whenever sqlerror continue

alter index "PARTITION1_IDX_INT" rename to "PARTITION1_IDX";

alter session set current_schema=sys;
whenever sqlerror exit 1

