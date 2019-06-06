exec dbms_stats.gather_table_stats -
( -
ownname=>'&&v_table_owner', -
tabname=>'&&v_table_int_name', -
cascade=>false, -
granularity=>'ALL', -
estimate_percent=>3, -
degree => &&v_job_dop, -
method_opt=>'FOR ALL INDEXED COLUMNS SIZE 1' -
);

