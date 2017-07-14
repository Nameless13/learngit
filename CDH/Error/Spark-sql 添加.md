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


后来发现只要把缺少的两个jar包导入到
cp activation-1.1.1.jar aopalliance-1.0.jar apacheds-i18n-2.0.0-M15.jar apacheds-kerberos-codec-2.0.0-M15.jar api-asn1-api-1.0.0-M20.jar api-util-1.0.0-M20.jar base64-2.3.8.jar bcprov-jdk15on-1.51.jar commons-beanutils-1.7.0.jar commons-beanutils-core-1.8.0.jar commons-configuration-1.6.jar commons-digester-1.8.jar curator-client-2.6.0.jar curator-framework-2.6.0.jar curator-recipes-2.6.0.jar guava-14.0.1.jar guice-3.0.jar guice-servlet-3.0.jar hadoop-annotations-2.6.4.jar hadoop-auth-2.6.4.jar hadoop-client-2.6.4.jar hadoop-common-2.6.4.jar hadoop-hdfs-2.6.4.jar hadoop-mapreduce-client-app-2.6.4.jar hadoop-mapreduce-client-common-2.6.4.jar hadoop-mapreduce-client-core-2.6.4.jar hadoop-mapreduce-client-jobclient-2.6.4.jar hadoop-mapreduce-client-shuffle-2.6.4.jar hadoop-yarn-api-2.6.4.jar hadoop-yarn-client-2.6.4.jar hadoop-yarn-common-2.6.4.jar hadoop-yarn-server-common-2.6.4.jar hadoop-yarn-server-web-proxy-2.6.4.jar hive-beeline-1.2.1.spark2.jar hive-exec-1.2.1.spark2.jar hive-jdbc-1.2.1.spark2.jar htrace-core-3.0.4.jar httpclient-4.5.2.jar jackson-core-asl-1.9.13.jar jackson-mapper-asl-1.9.13.jar java-xmlbuilder-1.0.jar javax.inject-1.jar jaxb-api-2.2.2.jar jets3t-0.9.3.jar jetty-6.1.26.jar jsr305-1.3.9.jar leveldbjni-all-1.8.jar mail-1.4.7.jar mesos-1.0.0-shaded-protobuf.jar mx4j-3.0.2.jar protobuf-java-2.5.0.jar slf4j-api-1.7.16.jar slf4j-log4j12-1.7.16.jar snappy-java-1.1.2.6.jar spark-mesos_2.11-2.1.1.jar stax-api-1.0-2.jar super-csv-2.2.0.jar xercesImpl-2.9.1.jar xmlenc-0.52.jar zookeeper-3.4.6.jar /opt/cloudera/parcels/SPARK2-2.0.0.cloudera2-1.cdh5.7.0.p0.118100/lib/spark2/jars/ 



SparkSQL accesses its metadata via the HMS directly, and does not go through a HS2, so it does not truly get covered fully by Sentry. However, in a Sentry setup the HMS is write-protected via the Sentry Authz Plugin added on it, so DDLs are still protected against, but users can still view all metadata (i.e. they can run SHOW TABLES, SHOW DATABASES, etc. and retrieve full listing [1]).

With Sentry HMS plugin and Sentry HDFS ACL Sync enabled, access to tables' data by Spark programs would be limited to the same rules as your Beeline/other Hive clients would.


```
cp activation-1.1.1.jar aopalliance-1.0.jar apacheds-i18n-2.0.0-M15.jar apacheds-kerberos-codec-2.0.0-M15.jar api-asn1-api-1.0.0-M20.jar api-util-1.0.0-M20.jar base64-2.3.8.jar bcprov-jdk15on-1.51.jar commons-beanutils-1.7.0.jar commons-beanutils-core-1.8.0.jar commons-configuration-1.6.jar commons-digester-1.8.jar curator-client-2.6.0.jar curator-framework-2.6.0.jar curator-recipes-2.6.0.jar guava-14.0.1.jar guice-3.0.jar guice-servlet-3.0.jar hadoop-annotations-2.6.4.jar hadoop-auth-2.6.4.jar hadoop-client-2.6.4.jar hadoop-common-2.6.4.jar hadoop-hdfs-2.6.4.jar hadoop-mapreduce-client-app-2.6.4.jar hadoop-mapreduce-client-common-2.6.4.jar hadoop-mapreduce-client-core-2.6.4.jar hadoop-mapreduce-client-jobclient-2.6.4.jar hadoop-mapreduce-client-shuffle-2.6.4.jar hadoop-yarn-api-2.6.4.jar hadoop-yarn-client-2.6.4.jar hadoop-yarn-common-2.6.4.jar hadoop-yarn-server-common-2.6.4.jar hadoop-yarn-server-web-proxy-2.6.4.jar htrace-core-3.0.4.jar httpclient-4.5.2.jar jackson-core-asl-1.9.13.jar jackson-mapper-asl-1.9.13.jar java-xmlbuilder-1.0.jar javax.inject-1.jar jaxb-api-2.2.2.jar jets3t-0.9.3.jar jetty-6.1.26.jar jsr305-1.3.9.jar leveldbjni-all-1.8.jar mail-1.4.7.jar mesos-1.0.0-shaded-protobuf.jar mx4j-3.0.2.jar protobuf-java-2.5.0.jar slf4j-api-1.7.16.jar slf4j-log4j12-1.7.16.jar snappy-java-1.1.2.6.jar spark-mesos_2.11-2.1.1.jar stax-api-1.0-2.jar super-csv-2.2.0.jar xercesImpl-2.9.1.jar xmlenc-0.52.jar zookeeper-3.4.6.jar /opt/cloudera/parcels/SPARK2-2.0.0.cloudera2-1.cdh5.7.0.p0.118100/lib/spark2/jars/ 




hive-beeline-1.2.1.spark2.jar hive-exec-1.2.1.spark2.jar hive-jdbc-1.2.1.spark2.jar 


cp /opt/spark-2.1.1-bin-hadoop2.6/jars/hive-jdbc-1.2.1.spark2.jar /opt/cloudera/parcels/SPARK2-2.0.0.cloudera2-1.cdh5.7.0.p0.118100/lib/spark2/jars/ 
cp /opt/spark-2.1.1-bin-hadoop2.6/jars/hive-beeline-1.2.1.spark2.jar /opt/cloudera/parcels/SPARK2-2.0.0.cloudera2-1.cdh5.7.0.p0.118100/lib/spark2/jars/ 

`rm /opt/cloudera/parcels/SPARK2-2.1.0.cloudera2-1.cdh5.7.0.p0.118100/lib/spark2/jars/hive-exec-1.2.1.spark2.jar`


#!/bin/bash
  SOURCE="${BASH_SOURCE[0]}"  #/opt/cloudera/parcels/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/bin/
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


#!/bin/bash
export HADOOP_HOME=/opt/cloudera/parcels/CDH/lib/hadoop
. /opt/cloudera/parcels/CDH/lib/bigtop-utils/bigtop-detect-javahome
exec $LIB_DIR/spark2/bin/spark-sql "$@"
```



exec $LIB_DIR/spark2/sbin/start-thriftserver.sh --name SparkJDBC --master yarn-client  --num-executors 10 --executor-memory 2g --executor-cores 4 --driver-memory 10g --driver-cores 2  --conf spark.storage.memoryFraction=0.2 --conf spark.shuffle.memoryFraction=0.6 --hiveconf hive.server2.thrift.port=10001 --hiveconf hive.server2.logging.operation.enabled=true --hiveconf hive.server2.authentication.kerberos.principal=hive/ddp-kettle-02.cmdmp.com@CMDMP.COM --hiveconf hive.server2.authentication.kerberos.keytab /root/hiveserver.keytab "$@"


exec $LIB_DIR/spark2/sbin/start-thriftserver.sh --name SparkJDBC --master yarn-client  --hiveconf hive.server2.thrift.port=10001 --hiveconf hive.server2.logging.operation.enabled=true --hiveconf hive.metastore.schema.verification=false --hiveconf hive.server2.authentication.kerberos.principal=hive/ddp-kettle-02.cmdmp.com@CMDMP.COM --hiveconf hive.server2.authentication.kerberos.keytab /root/hiveserver.keytab "$@"


exec $LIB_DIR/spark2/sbin/start-thriftserver.sh --name SparkJDBC --master yarn-client  --hiveconf hive.server2.thrift.port=10000 --hiveconf hive.server2.logging.operation.enabled=true --hiveconf hive.metastore.schema.verification=false --hiveconf spark.sql.thriftServer.incrementalCollect=true --hiveconf hive.server2.authentication.kerberos.principal=hive/ddp-kettle-02.cmdmp.com@CMDMP.COM --hiveconf hive.server2.authentication.kerberos.keytab /root/hiveserver.keytab "$@"

--hiveconf hive.metastore.schema.verification=false
--hiveconf spark.sql.thriftServer.incrementalCollect=true
--hiveconf hive.support.concurrency=true


master ：指定spark提交模式为yarn-client
 
hive.server2.thrift.port : 指定thrift server的端口
 
hive.server2.authentication.kerberos.principal：指定启动thrift server的超级管理员principal，此处超级管理员为hive
 
hive.server2.authentication.kerberos.keytab : 超级管理员对应的keytab　