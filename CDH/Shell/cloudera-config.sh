vi cloudera-config.sh 

#!/bin/bash

# Copyright (c) 2012 Cloudera, Inc. All rights reserved.

# defines a set of helper functions that can be used by Cloudera
# manager service scripts and exports some common environment
# variables.
#

# Attempts to locate java home, prints an error and exits if no
# java can be found.
locate_java_home() {
  locate_java_home_no_verify
  verify_java_home
}

# Attempts to locate java home, but doesn't exit if none is found.
locate_java_home_no_verify() {
  local JAVA6_HOME_CANDIDATES=(
    '/usr/lib/j2sdk1.6-sun'
    '/usr/lib/jvm/java-6-sun'
    '/usr/lib/jvm/java-1.6.0-sun-1.6.0'
    '/usr/lib/jvm/j2sdk1.6-oracle'
    '/usr/lib/jvm/j2sdk1.6-oracle/jre'
    '/usr/java/jdk1.6'
    '/usr/java/jre1.6'
  )

  local OPENJAVA6_HOME_CANDIDATES=(
    '/usr/lib/jvm/java-1.6.0-openjdk'
    '/usr/lib/jvm/jre-1.6.0-openjdk'
  )

  local JAVA7_HOME_CANDIDATES=(
    '/usr/java/jdk1.7'
    '/usr/java/jre1.7'
    '/usr/lib/jvm/j2sdk1.7-oracle'
    '/usr/lib/jvm/j2sdk1.7-oracle/jre'
    '/usr/lib/jvm/java-7-oracle'
  )

  local OPENJAVA7_HOME_CANDIDATES=(
    '/usr/lib/jvm/java-1.7.0-openjdk'
    '/usr/lib/jvm/java-7-openjdk'
  )

  local JAVA8_HOME_CANDIDATES=(
    '/usr/java/jdk1.8'
    '/usr/java/jre1.8'
    '/usr/lib/jvm/j2sdk1.8-oracle'
    '/usr/lib/jvm/j2sdk1.8-oracle/jre'
    '/usr/lib/jvm/java-8-oracle'
  )

  local OPENJAVA8_HOME_CANDIDATES=(
    '/usr/lib/jvm/java-1.8.0-openjdk'
    '/usr/lib/jvm/java-8-openjdk'
  )

  local MISCJAVA_HOME_CANDIDATES=(
    '/Library/Java/Home'
    '/usr/java/default'
    '/usr/lib/jvm/default-java'
    '/usr/lib/jvm/java-openjdk'
    '/usr/lib/jvm/jre-openjdk'
  )

  case ${BIGTOP_JAVA_MAJOR} in
    6) JAVA_HOME_CANDIDATES=(${JAVA6_HOME_CANDIDATES[@]})
       ;;
    7) JAVA_HOME_CANDIDATES=(${JAVA7_HOME_CANDIDATES[@]} ${OPENJAVA7_HOME_CANDIDATES[@]})
       ;;
    8) JAVA_HOME_CANDIDATES=(${JAVA8_HOME_CANDIDATES[@]} ${OPENJAVA8_HOME_CANDIDATES[@]})
       ;;
    misc) JAVA_HOME_CANDIDATES=(${MISCJAVA_HOME_CANDIDATES[@]})
       ;;
    *) JAVA_HOME_CANDIDATES=(${JAVA7_HOME_CANDIDATES[@]}
                             ${JAVA8_HOME_CANDIDATES[@]}
                             ${JAVA6_HOME_CANDIDATES[@]}
                             ${MISCJAVA_HOME_CANDIDATES[@]}
                             ${OPENJAVA7_HOME_CANDIDATES[@]}
                             ${OPENJAVA8_HOME_CANDIDATES[@]}
                             ${OPENJAVA6_HOME_CANDIDATES[@]})
       ;;
  esac

  # attempt to find java
  if [ -z "${JAVA_HOME}" ]; then
    for candidate_regex in ${JAVA_HOME_CANDIDATES[@]}; do
      for candidate in `ls -rvd ${candidate_regex}* 2>/dev/null`; do
        if [ -e ${candidate}/bin/java ]; then
          export JAVA_HOME=${candidate}
          break 2
        fi
      done
    done
  fi
}

# Attempts to locate java home, using CDH's provided detection
# routine. This allows us to delegate decisions such as the
# appropriateness of using java 6 vs 7 to CDH - where the
# answer varies, depending on the version.
locate_cdh_java_home() {
  if [ -z "$JAVA_HOME" ]; then

    if [ -z "$JSVC_HOME" ]; then
      echo "JSVC_HOME is unset. Cannot find CDH's bigtop-detect-javahome and JAVA_HOME is not set."
      exit 1
    fi

    # CDH >= 4.3 puts bigtop-detect-javahome in JSVC_HOME. In older versions
    # of CDH, it's in the parent directory of JSVC_HOME. To further complicate
    # matters, JSVC_HOME is hard-coded to the pre 4.3 value when parcels are
    # not used, so we must explicitly search /usr/lib.
    local BIGTOP_DETECT_JAVAHOME=
    for candidate in \
      "${JSVC_HOME}" \
      "${JSVC_HOME}/.." \
      "/usr/lib/bigtop-utils" \
      "/usr/libexec"; do
      if [ -e "$candidate/bigtop-detect-javahome" ]; then
        BIGTOP_DETECT_JAVAHOME="$candidate/bigtop-detect-javahome"
        break
      fi
    done

    if [ -z "$BIGTOP_DETECT_JAVAHOME" ]; then
      echo "Cannot find CDH's bigtop-detect-javahome."
      exit 1
    fi

    . "$BIGTOP_DETECT_JAVAHOME"
  fi

  verify_java_home
}

# Verify that JAVA_HOME set - does not verify that it's set to a meaningful
# value.
verify_java_home() {
  if [ -z "$JAVA_HOME" ]; then
    cat 1>&2 <<EOF
+======================================================================+
|      Error: JAVA_HOME is not set and Java could not be found         |
+----------------------------------------------------------------------+
| Please download the latest Oracle JDK from the Oracle Java web site  |
|  > http://www.oracle.com/technetwork/java/javase/index.html <        |
|                                                                      |
| Cloudera Manager requires Java 1.6 or later.                         |
| NOTE: This script will find Oracle Java whether you install using    |
|       the binary or the RPM based installer.                         |
+======================================================================+
EOF
    exit 1
  fi

  echo "JAVA_HOME=$JAVA_HOME"
}

# Source the parcel environment scripts passed by the agent
source_parcel_environment() {
  if [ ! -z "$SCM_DEFINES_SCRIPTS" ]; then
    # Narrow IFS to newline only to allow embedded spaces
    OLD_IFS=$IFS
    IFS=$':'
    SCRIPT_ARRAY=($SCM_DEFINES_SCRIPTS)
    DIRNAME_ARRAY=($PARCEL_DIRNAMES)
    IFS=$OLD_IFS

    COUNT=${#SCRIPT_ARRAY[@]}
    for i in `seq 1 $COUNT`; do
      SCRIPT=${SCRIPT_ARRAY[$i - 1]}
      PARCEL_DIRNAME=${DIRNAME_ARRAY[$i - 1]}
      . "$SCRIPT"
    done
  fi
}

# Sets the path to the HBase script in HBASE_BIN.
locate_hbase_script() {
  if [ "$CDH_VERSION" -ge "5" ]; then
    # CDH-13250 use bigtop script to start hbase
    # Disable sourcing defaults dir, which CM will manage instead.
    export BIGTOP_DEFAULTS_DIR=""
    HBASE_BIN="$HBASE_HOME/../../bin/hbase"
  else
    HBASE_BIN="$HBASE_HOME/bin/hbase"
  fi
}

# sets the default HADOOP_CLASSPATH to include cloudera log4j appender.
# The function will append to an existing HADOOP_CLASSPATH variable if it
# is defined. MGMT_HOME must be defined, otherwise the function prints an
# error message and exits.
set_hadoop_classpath() {
  set_classpath_in_var HADOOP_CLASSPATH
}

# sets the default HBASE_CLASSPATH to include cloudera log4j appender.
# The function appends to an existing HADOOP_CLASSPATH variable if it
# is defined. MGMT_HOME must be defined, otherwise the function prints an
# error message and exits.
set_hbase_classpath() {
  set_classpath_in_var HBASE_CLASSPATH
}

# sets the default ZOOKEEPER_CLASSPATH to include cloudera log4j appender.
# The function appends to an existing ZOOKEEPER_CLASSPATH variable if it
# is defined. MGMT_HOME must be defined, otherwise the function prints an
# error message and exits.
set_zookeeper_classpath() {
  set_classpath_in_var ZOOKEEPER_CLASSPATH
}

# sets the default FLUME_CLASSPATH to include cloudera log4j appender.
# The function appends to an existing FLUME_CLASSPATH variable if it
# is defined. MGMT_HOME must be defined, otherwise the function prints an
# error message and exits.
set_flume_classpath() {
  set_classpath_in_var FLUME_CLASSPATH
}

# sets hive's AUX_CLASSPATH to include cloudera governor plugin jar.
# MGMT_HOME must be defined, otherwise the function prints an
# error message and exits.
set_hive_classpath() {
  set_classpath_in_var AUX_CLASSPATH
}

# sets the classpath variable passed as a parameter to include all of cloudera
# default classes.
#
# If no parameter is passed the function prints an error message and exits.
#
# This function adds all the plugin jars that are needed by CM. It includes
# the Cloudera log4j appender, the navigator plugins and the tasktracker
# instrumentation jar. The function checks for the CDH version and includes
# all jars from that particular cdh subdir.
#
# Note that MGMT_HOME must be defined, if it is not the function prints
# an error and exits.
#
# param $1 - The name of the classpath variable to assign to. The function
# appends all the extra jars to this varible.
set_classpath_in_var() {
  if [ -z $1 ]; then
    echo "Must call with the name of variable to assign."
    exit 1
  fi
  if [[ -n "$MGMT_HOME" ]]; then
    # Add all plugin jars to the classpath.
    ADD_TO_CP=`find "${MGMT_HOME}/lib/plugins" -maxdepth 1 -name '*.jar' | tr "\n" ":"`

    # Add jars from dirs to classpath.
    if [[ -n "$CM_ADD_TO_CP_DIRS" ]]; then
      for DIR in $CM_ADD_TO_CP_DIRS
      do
        PLUGIN=`find "${MGMT_HOME}/lib/plugins/${DIR}" -maxdepth 1 -name '*.jar' | tr "\n" ":"`
        ADD_TO_CP="$ADD_TO_CP$PLUGIN"
      done
    fi

    eval OLD_VALUE=\$$1
    NEW_VALUE="$ADD_TO_CP$OLD_VALUE"
    export $1=${NEW_VALUE/%:/}  # Remove trailing ':' if present.
  else
    echo "MGMT_HOME must be set."
    exit 1
  fi
}

get_java_major_version() {
  if [ -z $JAVA_HOME/bin/java ]; then
    echo "JAVA_HOME must be set"
    exit 1
  fi
  local VERSION_STRING=`$JAVA_HOME/bin/java -version 2>&1`
  local RE_JAVA='[java|openjdk][[:space:]]version[[:space:]]\"1\.([0-9][0-9]*)\.+'
  if [[ $VERSION_STRING =~ $RE_JAVA  ]]; then
    eval $1=${BASH_REMATCH[1]}
  fi
}

acquire_kerberos_tgt() {
  if [ -z $1 ]; then
    echo "Must call with the name of keytab file."
    exit 1
  fi

  # Acquire Kerberos tgt (ticket-granting ticket) if the server provided the
  # principal (in which case the keytab should be non-zero).
  #
  # Note that we cache it in the current directory so that it will be isolated to
  # this hadoop command.
  if [ -n "$SCM_KERBEROS_PRINCIPAL" ]; then
    if [ -d /usr/kerberos/bin ]; then
      export PATH=/usr/kerberos/bin:$PATH
    fi
    which kinit
    if [ $? -ne 0 ]; then
      echo "kinit does not exist on the host."
      exit 1
    fi

    export KRB5CCNAME=$CONF_DIR/krb5cc_$(id -u)
    echo "using $SCM_KERBEROS_PRINCIPAL as Kerberos principal"
    echo "using $KRB5CCNAME as Kerberos ticket cache"
    kinit -c $KRB5CCNAME -kt $CONF_DIR/$1 $SCM_KERBEROS_PRINCIPAL
    if [ $? -ne 0 ]; then
      echo "kinit was not successful."
      exit 1
    fi
    # This is work-around for a bug in kerberos >= 1.8 that prevents java
    # programs from reading from the ticket cache. It's harmless to do it
    # unconditionally - as long as we sleep first, in case kerberos is
    # configured to prevent ticket renewal. If the two kinit calls are
    # too close together, the -R can succeed when it shouldn't, and end
    # up expiring the ticket.
    sleep 1
    kinit -R
  fi
}

# SHOULD NOT BE USED DIRECTLY OUTSIDE OF THIS FILE.
# Helper function to report a CM specific status code. Expects the CM status
# code to report and the exit code to exit with.
__cm_report_status_and_exit_with_code() {
  if [ $# -ne 2 ]; then
    echo "expected 2 arguments - CM status code and exit code" 1>&2
    exit 1
  fi

  # Note that CM_STATUS_CODES is injected into the env by the agent.
  for code in $CM_STATUS_CODES; do
    if [ "$code" == "$1" ]; then
      # Output the error in the format
      # "CM_STATUS_CODE=<value>" as the last line of the stderr stream. Note
      # that this format and writing to stderr is important since the agent will
      # otherwise not be able to extract this error code and pass it along to
      # CM.
      echo CM_STATUS_CODE=$code 1>&2
      exit $2
    fi
  done

  echo "Unexpected CM error code: $1" 1>&2
  exit 1
}

# Reports a CM specific status code and exits with error i.e. with exit code 1.
cm_error_and_exit() {
  # Suppress tracing for this function so that the below script does not show up
  # in the error logs shown to users.
  #
  # Not suppressing the tracing would require making the agent's parsing code
  # more complex and sub-optimal (since more text will need to be searched).
  # Additionally, there is a loop in this code (in the helper function being
  # invoked below) which can cause a lot of text to be output to the error log
  # as the number of enum values increases.
  if [ $# -ne 1 ]; then
    echo "expected 1 argument - CM status code to report" 1>&2
    exit 1
  fi

  __cm_report_status_and_exit_with_code $1 1
}

# Report a CM specific status code and exit successfully i.e. with exit code 0.
cm_success_and_exit() {
  # Suppress tracing for this function so that the below script does not show up
  # in the error logs shown to users.
  #
  # Not suppressing the tracing would require making the agent's parsing code
  # more complex and sub-optimal (since more text will need to be searched).
  # Additionally, there is a loop in this code (in the helper function being
  # invoked below) which can cause a lot of text to be output to the error log
  # as the number of enum values increases.
  set +xv

  if [ $# -ne 1 ]; then
    echo "expected 1 argument - CM status code to report" 1>&2
    exit 1
  fi

  __cm_report_status_and_exit_with_code $1 0
}

replace_hive_hbase_jars_template() {
  # - hive-hbase storage handler jar is same in CDH4 and CDH5
  # - hbase jars are different for CDH4 and CDH5
  #   - hbase/hbase.jar is needed for CDH4 and
  #   - hbase/hbase-server.jar, hbase/hbase-client.jar, hbase/hbase-protocol.jar, hbase/lib/htrace-core-*.jar is needed for CDH5
  HIVE_HBASE_JAR=$(find $CDH_HIVE_HOME/lib -name "hive-hbase-handler-*.jar" 2> /dev/null | tail -n 1)
  if [[ "$FILE" == "hive-site.xml" ]]; then
    HBASE_JAR=$(echo ${HBASE_JAR} | sed "s:,:,file\:\/\/:g")
  fi
  if [[ -n $HIVE_HBASE_JAR && -n $HBASE_JAR ]]; then
      if [[ "$FILE" == "hive-site.xml" ]]; then
        # file:// prefix is required when specifying jars in hive.aux.jars.path in hive-site.xml
        perl -pi -e "s#{{HIVE_HBASE_JAR}}#file://$HIVE_HBASE_JAR,file://$HBASE_JAR#g" $CONF_DIR/$FILE
      else
        perl -pi -e "s#{{HIVE_HBASE_JAR}}#$HIVE_HBASE_JAR,$HBASE_JAR#g" $CONF_DIR/$FILE
      fi
  elif [[ -d $CDH_HBASE_HOME ]]
  then
    echo "ERROR: Failed to find hive-hbase storage handler jars to add in $FILE. Hive queries that use Hbase storage handler may not work until this is fixed."
  fi
}

skip_if_tables_exist() {
  if [ -z $1 ]; then
    echo "Must call with the name of the db properties file."
    exit 1
  fi

  DB_INFO_FILENAME=$1
  JDBC_JARS="$CLOUDERA_MYSQL_CONNECTOR_JAR:$CLOUDERA_POSTGRESQL_JDBC_JAR:$CLOUDERA_ORACLE_CONNECTOR_JAR"
  if [[ -z "$CMF_SERVER_ROOT" ]]; then
    JDBC_JARS_CLASSPATH="/usr/share/cmf/lib/*:$JDBC_JARS"
  else
    JDBC_JARS_CLASSPATH="$CMF_SERVER_ROOT/lib/*:$JDBC_JARS"
  fi
  if [[ "$?" -ne 0 ]]; then
    echo "Failed to count existing tables."
    exit 1
  fi
  if [[ "$NUM_TABLES" -ne "0" ]]; then
    echo "Database already has tables. Skipping table creation."
    exit 0
  fi
}

# When created, the final resting place of config files is unknown,
# so it is marked as {{CMF_CONF_DIR}}. We know what this directory will
# be here in this script, so search-replace it.
replace_conf_dir() {
  echo "CONF_DIR=$CONF_DIR"
  echo "CMF_CONF_DIR=$CMF_CONF_DIR"
  # Exclude files that we don't want to be modified. (OPSAPS-37023)
  EXCLUDE_CMF_FILES=('cloudera-config.sh' 'httpfs.sh' 'hue.sh' 'impala.sh' 'sqoop.sh' 'supervisor.conf' '*.log' '*.keytab' '*jceks')
  find $CONF_DIR -type f ! -path "$CONF_DIR/logs/*" $(printf "! -name %s " ${EXCLUDE_CMF_FILES[@]}) -exec perl -pi -e "s#{{CMF_CONF_DIR}}#$CONF_DIR#g" {} \;
}

# Turn on the execute bit for .sh and .py files.
make_scripts_executable() {
  find $CONF_DIR -regex ".*\.\(py\|sh\)$" -exec chmod u+x {} \;
}

  EXCLUDE_CMF_FILES=('cloudera-config.sh' 'httpfs.sh' 'hue.sh' 'impala.sh' 'sqoop.sh' 'supervisor.conf' '*.log' '*.keytab' '*jceks')
  find $CONF_DIR -type f ! -path "$CONF_DIR/logs/*" $(printf "! -name %s " ${EXCLUDE_CMF_FILES[@]}) -exec perl -pi -e "s#{{CMF_CONF_DIR}}#$CONF_DIR#g" {} \;
}

# Turn on the execute bit for .sh and .py files.
make_scripts_executable() {
  find $CONF_DIR -regex ".*\.\(py\|sh\)$" -exec chmod u+x {} \;
}

# Replace {{PID}} in the heap dump path with the process pid
# See OPSAPS-22106
replace_pid() {
  echo $@ | sed "s#{{PID}}#$$#g"
}

# Append a line to the catalina.properties file. For Tomcat this is
# effectively the same as passing the property in as a -D jvm arg.
# This works because we create the tomcat deployment directory upon
# each startup.
tomcat_set_prop() {
  if [ -z "${CATALINA_PROPERTIES}" ]; then
    if [ ! -e "${CATALINA_BASE}" ]; then
      echo "Can't find Catalina Base ${CATALINA_BASE}"
      exit 1
    fi
    CATALINA_PROPERTIES="${CATALINA_BASE}/conf/catalina.properties"
    if [ ! -e "${CATALINA_PROPERTIES}" ]; then
      echo "Error: can't find ${CATALINA_PROPERTIES}"
      exit 1
    fi
  fi
  echo "$@" >> "${CATALINA_PROPERTIES}"
}

# Add Hadoop native library folder to java library path
set_hadoop_native_library_path() {
  if [ -d "${CDH_HADOOP_HOME}/lib/native" ]; then
    if [ "x$JAVA_LIBRARY_PATH" != "x" ]; then
      JAVA_LIBRARY_PATH="${JAVA_LIBRARY_PATH}:${CDH_HADOOP_HOME}/lib/native"
    else
      JAVA_LIBRARY_PATH="${CDH_HADOOP_HOME}/lib/native"
    fi
  fi
}

# Enable tracing.
set -x
