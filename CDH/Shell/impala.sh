#!/bin/bash

# Copyright (c) 2012 Cloudera, Inc. All rights reserved.

set -e
set -x

# Time marker for both stderr and stdout
date; date 1>&2

cloudera_config=`dirname $0`
cloudera_config=`cd "$cloudera_config/../common"; pwd`
. ${cloudera_config}/cloudera-config.sh

# Load the parcel environment
source_parcel_environment

export IMPALA_HOME=${IMPALA_HOME:-$CDH_IMPALA_HOME}

# set impala configuration directory
export IMPALA_CONF_DIR=${CONF_DIR}/impala-conf
export HADOOP_CONF_DIR=${CONF_DIR}/hadoop-conf
export HIVE_CONF_DIR=${CONF_DIR}/hive-conf
export HBASE_CONF_DIR=${CONF_DIR}/hbase-conf
export JAVA_TOOL_OPTIONS=$(replace_pid $JAVA_TOOL_OPTIONS)

if [[ -d $HBASE_CONF_DIR ]]; then
  perl -pi -e "s#{{HBASE_CONF_DIR}}#$HBASE_CONF_DIR#g" $HBASE_CONF_DIR/hbase-env.sh
fi


# Add JDBC jars to the path. Oracle and Mysql installed by end user, can't ship due to licensing.
JDBC_JARS="$CLOUDERA_MYSQL_CONNECTOR_JAR:$CLOUDERA_POSTGRESQL_JDBC_JAR:$CLOUDERA_ORACLE_CONNECTOR_JAR"
if [[ -z "$AUX_CLASSPATH" ]]; then
  export AUX_CLASSPATH="$JDBC_JARS"
else
  export AUX_CLASSPATH="$AUX_CLASSPATH:$JDBC_JARS"
fi
# Due to IMP-898 Impala isn't correctly picking up AUX_CLASSPATH in Impala 1.0, but it does pick up CLASSPATH.
# Just emit both.
if [[ -z "$CLASSPATH" ]]; then
  export CLASSPATH="$JDBC_JARS"
else
  export CLASSPATH="$CLASSPATH:$JDBC_JARS"
fi

# The DSSD_SCR parcel sets JAVA_LIBRARY_PATH, but impalad.sh doesn't
# add it to java.library.path. Setting LIBHDFS_OPTS is a workaround.
if [[ -n "$JAVA_LIBRARY_PATH" ]]; then
  export LIBHDFS_OPTS="$LIBHDFS_OPTS -Djava.library.path=$IMPALA_HOME/lib:$JAVA_LIBRARY_PATH"
fi

FLAG_FILE=$IMPALA_CONF_DIR/$2
USE_DEBUG_BUILD=$3

# Search-replace {{CMF_CONF_DIR}} in files
  set -e
  PYTHON_CMD=$CMF_PACKAGE_DIR/../agent/build/env/bin/python
  COLLECT_BREAKPAD_DUMPS="$IMPALA_HOME/../../bin/impala-collect-minidumps"
  PROCESS_DIR_NAME=$(pwd)
  BREAKPAD_DUMP_FILE=$PROCESS_DIR_NAME/$3.tar.gz

  #Mapping the rolenames sent by CM to the ones needed by Impala
  if [ "$3" == "IMPALAD" ]; then
    ROLE_NAME="impalad"
  elif [ "$3" == "STATESTORE" ]; then
    ROLE_NAME="statestored"
  elif [ "$3" == "CATALOGSERVER" ]; then
    ROLE_NAME="catalogd"
  else
    echo "Breakpad minidumps collection is not supported for role type: $3"
  fi

  COLLECT_BREAKPAD_DUMP_ARGS="--end_time $2 --role_name $ROLE_NAME --max_output_size $4 --output_file_path $BREAKPAD_DUMP_FILE --conf_dir $IMPALA_CONF_DIR"
  if [[ ! -z $5 ]]; then
    COLLECT_BREAKPAD_DUMP_ARGS="$COLLECT_BREAKPAD_DUMP_ARGS --start_time $5"
  fi
  PYTHON_VERSION_CHECK="import sys; print (sys.hexversion >= 0x02060000)"
  CORRECT_PYTHON_VERSION="$($PYTHON_CMD -c "$PYTHON_VERSION_CHECK")"
  if [ $CORRECT_PYTHON_VERSION != "True" ]; then
    echo "Python Version greater than 2.6 is needed to collect breakpad dumps. Skipping.."
  else
    $COLLECT_BREAKPAD_DUMPS $COLLECT_BREAKPAD_DUMP_ARGS
  fi
  if [[ ! -f $BREAKPAD_DUMP_FILE ]]; then
    echo "No Impala Dumps found."
  else
    ln -s $BREAKPAD_DUMP_FILE output.gz
  fi
fi
cd 