REM 999_pre_post_audit
REM Display pre and post audit information
REM With modifications, execute the routine before then after
REM the redefinition to help validate successful redefinition

set lines 160;
set pages 48;

select 
   OWNER,
   TABLE_NAME,
   STATUS,
   PCT_FREE,
   PCT_USED,
   PCT_INCREASE,
   NUM_ROWS,
   BLOCKS,
   AVG_SPACE,
   CHAIN_CNT,
   AVG_ROW_LEN,
   DEGREE,
   LAST_ANALYZED,
   PARTITIONED,
   BUFFER_POOL,
   ROW_MOVEMENT,
   COMPRESSION
from 
   dba_tables
where 
   owner='&&v_table_owner' and 
   table_name='&&v_table_name'
/

select 
   TABLE_OWNER,
   TABLE_NAME,
   PARTITION_NAME,
   INSERTS,
   UPDATES,
   DELETES,
   TIMESTAMP
from 
   dba_tab_modifications
where 
   table_owner='&&v_table_owner' and 
   table_name='&&v_table_name'
/

select 
   TABLE_OWNER,
   TABLE_NAME,
   TABLE_TYPE,
   OWNER,
   INDEX_NAME,
   INDEX_TYPE,
   UNIQUENESS,
   COMPRESSION,
   TABLESPACE_NAME,
   PCT_INCREASE,
   PCT_FREE,
   LOGGING,
   BLEVEL,
   LEAF_BLOCKS,
   DISTINCT_KEYS,
   AVG_LEAF_BLOCKS_PER_KEY,
   AVG_DATA_BLOCKS_PER_KEY,
   CLUSTERING_FACTOR,
   STATUS,
   NUM_ROWS,
   LAST_ANALYZED,
   DEGREE,
   PARTITIONED,
   BUFFER_POOL,
   USER_STATS
from 
   dba_indexes
where 
   table_owner='&&v_table_owner' and 
   table_name='&&v_table_name'
order by
   UNIQUENESS desc,
   TABLE_OWNER,
   TABLE_NAME,
   OWNER,
   INDEX_NAME
/

select
   OWNER,
   SEGMENT_NAME,
   PARTITION_NAME,
   SEGMENT_TYPE,
   TABLESPACE_NAME,
   BUFFER_POOL,
   BYTES/1048576 BYTES_MB
from
   dba_segments
where
   owner='&&v_table_owner' and
  (segment_name='&&v_table_name' or
   segment_name in
     (select index_name
      from dba_indexes
      where table_owner='&&v_table_owner' and table_name='&&v_table_name')
  )
order by
   OWNER,
   SEGMENT_NAME,
   PARTITION_NAME
/

select
   OWNER,
   SEGMENT_NAME,
   CEIL(SUM(BYTES)/1048576) BYTES_MB
from
   dba_segments
where
   owner='&&v_table_owner' and
  (segment_name='&&v_table_name' or
   segment_name in
     (select index_name
      from dba_indexes
      where table_owner='&&v_table_owner' and table_name='&&v_table_name')
  )
group by rollup
  (OWNER,
   SEGMENT_NAME)
order by
   OWNER,
   SEGMENT_NAME
/

select
   OWNER,
   SEGMENT_NAME,
   CEIL(SUM(BYTES)/1048576) BYTES_MB
from
   dba_segments
where
   owner='&&v_table_owner' and
  (segment_name='&&v_table_name' or
   segment_name in
     (select segment_name
      from dba_lobs
      where owner='&&v_table_owner' and table_name='&&v_table_name')
  )
group by rollup
  (OWNER,
   SEGMENT_NAME)
order by
   OWNER,
   SEGMENT_NAME
/


