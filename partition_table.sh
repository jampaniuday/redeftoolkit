#!/bin/ksh

################################################################################
# Set miscellaneous variables
################################################################################

scriptname=`basename $0`
scriptfile=`print ${scriptname} | cut -d'.' -f1`
scriptext=`print ${scriptname} | cut -d'.' -f2`

################################################################################
# Collect command line arguments
################################################################################

script_argument_count=$#

################################################################################
# Miscellaneous setup
################################################################################

USAGE="\n${scriptname} \n
"

echo "Script starting at `date`"

export table_name="PARTITION1"

export info_list="youremail@example.com"

export notify_list="youremail@example.com"

export EXT=$(date +%Y%m%d%H%M%S)

export LogDir="/home/oracle/TEST/${table_name}"

################################################################################
# Direct the script standard output and standard error to files
################################################################################

OUTFILE=${LogDir}/${scriptfile}_${EXT}.out
export OUTFILE

ERRFILE=${LogDir}/${scriptfile}_${EXT}.err
export ERRFILE

exec 1>${OUTFILE} 2>${ERRFILE}

################################################################################
# Establish the SQL*Plus environment
################################################################################

SQLPLUS_STDIN_FILE=${LogDir}/${scriptfile}_sql_${$}.stdin
SQLPLUS_STDOUT_FILE=${LogDir}/${scriptfile}_sql_${$}.stdout
SQLPLUS_STDERR_FILE=${LogDir}/${scriptfile}_sql_${$}.stderr

>${SQLPLUS_STDIN_FILE}
>${SQLPLUS_STDOUT_FILE}
>${SQLPLUS_STDERR_FILE}

chmod 0600 ${SQLPLUS_STDIN_FILE}

export SQLPLUS_STDIN_FILE
export SQLPLUS_STDOUT_FILE
export SQLPLUS_STDERR_FILE

################################################################################
# Main script code
################################################################################

${ORACLE_HOME}/bin/sqlplus /nolog \
>${SQLPLUS_STDOUT_FILE} \
2>${SQLPLUS_STDERR_FILE} \
<<EOF
@0000_initialization
@0100_abort_redef_table
@0010_can_redef_table
@9999_pre_post_audit
--@0020_create_interim_table
@0030_start_redef_table
@0050_create_constraints_indexes
@0040_sync_interim_table
@0060_gather_statistics
@0040_sync_interim_table
@0070_finish_redef_table
--@0080_drop_interim_table
@0085_drop_interim_table_indexes
@0090_rename_constraints_indexes
@9999_pre_post_audit
quit
EOF

export SQLPLUS_RC=$?

echo "Table redefinition return code is ${SQLPLUS_RC}"

if [[ ${SQLPLUS_RC} -ne 0 ]] 
 then
#  mailx -s "FAILURE partition table ${table_name} ${notify_list} < nohup.out
  exit 1
fi

################################################################################
# Copy the SQL*Plus files to the script log file
################################################################################

echo " "
echo "SQL*Plus standard input file follows."
cat ${SQLPLUS_STDIN_FILE}

echo " "
echo "SQL*Plus standard output file follows."
cat ${SQLPLUS_STDOUT_FILE}

echo " "
echo "SQL*Plus standard error file follows."
cat ${SQLPLUS_STDERR_FILE}

################################################################################
# Cleanup work files
################################################################################

rm -fr \
${SQLPLUS_STDIN_FILE} \
${SQLPLUS_STDOUT_FILE} \
${SQLPLUS_STDERR_FILE}

################################################################################
# Distribute end of process notification
################################################################################

echo "Complete at $(date)"

# echo "${OUTFILE}" | \
# mailx -s "End partition table ${table_name} at $(date)" ${notify_list} < nohup.out

echo "${OUTFILE}" | \
mailx -s "End partition table ${table_name} at $(date)" ${info_list}

################################################################################
# Exit script
################################################################################

exit 0

