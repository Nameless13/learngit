title: spark-sql添加
categories: 
- CDH
- ERROR	
date: 2017-07-12
---
# spark-sql添加
CDH版本的spark阉割了spark-sql,可以重新编译cloudera/spark,或者直接在启动时添加所缺失的jar包
>操作系统:SUSE11 SP3
>Spark版本:SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904
>CDH版本:CDH5.10.041
>使用root用户对集群进行部署
## 直接添加所缺jar包
### 下载Apache版Spark
解压后找到jars/目录下的
`hive-cli-1.2.1.spark2.jar`
`spark-hive-thriftserver_2.11-2.1.0.jar`
上传需要使用spark-sql的机器上
### 创建spark-sql
在/opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/bin/下新建**spark-sql**文件
`vi /opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/bin/spark-sql`
```bash
#!/bin/bash
  # Reference: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
  SOURCE="${BASH_SOURCE[0]}"
  BIN_DIR="$( dirname "$SOURCE" )"
  while [ -h "$SOURCE" ]
  do
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    BIN_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
  done
  BIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  CDH_LIB_DIR=$BIN_DIR/../../CDH/lib
  LIB_DIR=$BIN_DIR/../lib
export HADOOP_HOME=$CDH_LIB_DIR/hadoop

# Autodetect JAVA_HOME if not defined
. $CDH_LIB_DIR/bigtop-utils/bigtop-detect-javahome

exec $LIB_DIR/spark2/bin/spark-sql "$@"
```

在/opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/lib/spark2/bin下新建spark-sql,同时添加之前传的两个jar包
`vi /opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/lib/spark2/bin/spark-sql`
```bash
#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ -z "${SPARK_HOME}" ]; then
  source "$(dirname "$0")"/find-spark-home
fi

export _SPARK_CMD_USAGE="Usage: ./bin/spark-sql [options] [cli option]"
#exec "${SPARK_HOME}"/bin/spark-submit --class org.apache.spark.sql.hive.thriftserver.SparkSQLCLIDriver "$@"
exec "${SPARK_HOME}"/bin/spark-submit --jars /home/manage/spark-hive-thriftserver_2.11-2.1.0.jar,/home/manage/hive-cli-1.2.1.spark2.jar --class org.apache.spark.sql.hive.thriftserver.SparkSQLCLIDriver "$@"
```

同时可以设置一个别名指向spark-sql
`alias spark2-sql="/opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/bin/spark-sql"`

### 在log4j中添加spark-sql
路径:/opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/lib/spark2/conf
```
log4j.logger.org.apache.spark.sql.SQLContext=ERROR 
log4j.logger.org.apache.spark.sql.catalyst.analysis.Analyzer=ERROR
```

### spark1.6 spark-sql支持
[spark1.6 spark-sql支持](http://www.javali.org/bigdata/one-trick-on-supporting-sparksql-in-cdh5.html)
其实就是对应的jar包不同,1.6所缺的为spark-assembly-1.6.1-hadoop2.6.0.jar

### SparkHiveServer
直到最近在调研Spark并计划将Spark取代Mapreduce来提升平台的计算效率时，发现Spark-sql能完美的兼容Hive SQL，同时还提供了ThriftServer(就是SparkHiveServer)，不止于此，由于Spark更好的使用了内存，期执行效率是MR/Hive的10倍以上。

其实就是在Spark集群上执行$SPARK_HOME/sbin/start-thriftserver.sh –master=spark://MASTER:7077 就默认开启了10000端口，该服务可以取代hiveserver2，如果与HiveServer2在同一台服务器上，可以先shutdown hiveserver2,再启动spark thriftserver。运行了1个礼拜，服务非常稳定，GC也正常！
`cat start-thriftserver.sh`
```bash
#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Shell script for starting the Spark SQL Thrift server

# Enter posix mode for bash
set -o posix

if [ -z "${SPARK_HOME}" ]; then
  export SPARK_HOME="$(cd "`dirname "$0"`"/..; pwd)"
fi

# NOTE: This exact class name is matched downstream by SparkSubmit.
# Any changes need to be reflected there.
CLASS="org.apache.spark.sql.hive.thriftserver.HiveThriftServer2"

function usage {
  echo "Usage: ./sbin/start-thriftserver [options] [thrift server options]"
  pattern="usage"
  pattern+="\|Spark assembly has been built with Hive"
  pattern+="\|NOTE: SPARK_PREPEND_CLASSES is set"
  pattern+="\|Spark Command: "
  pattern+="\|======="
  pattern+="\|--help"

  "${SPARK_HOME}"/bin/spark-submit --help 2>&1 | grep -v Usage 1>&2
  echo
  echo "Thrift server options:"
  "${SPARK_HOME}"/bin/spark-class $CLASS --help 2>&1 | grep -v "$pattern" 1>&2
}

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
  usage
  exit 0
fi

export SUBMIT_USAGE_FUNCTION=usage

exec "${SPARK_HOME}"/sbin/spark-daemon.sh submit $CLASS 1 --name "Thrift JDBC/ODBC Server" "$@"
```
