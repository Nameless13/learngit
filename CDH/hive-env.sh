ddp-cm:/opt/cloudera/parcels/CDH/lib/hive/conf 
# view hive-env.sh 

# HIVE_AUX_JARS_PATH={{HIVE_AUX_JARS_PATH}}
# JAVA_LIBRARY_PATH={{JAVA_LIBRARY_PATH}}
export HADOOP_CONF_DIR="${HADOOP_CONF_DIR:-"$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"}"
HBASE_HIVE_DEFAULT_JAR=$(find /usr/lib/hive/lib -name hive-hbase-handler-*.jar 2> /dev/null | tail -n 1),$(sed "s: :,:g" <<< $(find /usr/lib/hbase -regextype posix-egrep -regex "/usr/lib/hbase/(hbase|hbase-client|hbase-server|hbase-protocol|hbase-common|hbase-hadoop-compat|hbase-hadoop2-compat|(lib/htrace-core.*)).jar" 2> /dev/null))
HIVE_AUX_JARS_PATH=$([[ -d /home/thadoop/hive_lib/ ]] && sed "s: :,:g" <<< $(find /home/thadoop/hive_lib/ -name "*.jar" 2> /dev/null)),$([[ -n $HIVE_AUX_JARS_PATH ]] && echo $HIVE_AUX_JARS_PATH,)$( ([[ ! '/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hive/lib/hive-hbase-handler-1.1.0-cdh5.10.0.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-hadoop-compat.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-common.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-protocol.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/lib/htrace-core4-4.0.1-incubating.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/lib/htrace-core.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/lib/htrace-core-3.2.0-incubating.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-hadoop2-compat.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-server.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-client.jar' =~ HIVE_HBASE_JAR ]] &&  echo /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hive/lib/hive-hbase-handler-1.1.0-cdh5.10.0.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-hadoop-compat.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-common.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-protocol.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/lib/htrace-core4-4.0.1-incubating.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/lib/htrace-core.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/lib/htrace-core-3.2.0-incubating.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-hadoop2-compat.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-server.jar,/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/hbase-client.jar) || echo ${HBASE_HIVE_DEFAULT_JAR:-}),$(find /usr/share/java/mysql-connector-java.jar 2> /dev/null),$(find /usr/share/cmf/lib/postgresql-*jdbc*.jar 2> /dev/null | tail -n 1),$(find /usr/share/java/oracle-connector-java.jar 2> /dev/null)
export HIVE_AUX_JARS_PATH=$(echo $HIVE_AUX_JARS_PATH | sed 's/,,*/,/g' | sed 's/^,//' | sed 's/,$//')
export HADOOP_CLIENT_OPTS="-Xmx2147483648 -XX:MaxPermSize=512M -Djava.net.preferIPv4Stack=true $HADOOP_CLIENT_OPTS"
~                                                                                                                       



---
10.200.65.50	ddp-cm.cmdmp.com	ddp-cm
10.200.65.51	ddp-nn-01.cmdmp.com	ddp-nn-01
10.200.65.52	ddp-nn-02.cmdmp.com	ddp-nn-02

 hdfs://nameservice1/user/thadoop/ods  |        |            |         | thadoop         | ROLE            | *          | false         | 1493369887314000  | --       |
| rptdata                               |        |            |         | thadoop         | ROLE            | *          | false         | 1492619387707000  | --       |
| rpt                                   |        |            |         | thadoop         | ROLE            | *          | false         | 1493023378368000  | --       |
| dly                                   |        |            |         | thadoop         | ROLE            | *          | false         | 1494470669933000  | --       |
| intdata                               |        |            |         | thadoop         | ROLE            | *          | false         | 1494470669573000  | --       |
| msc                                   |        |            |         | thadoop         | ROLE            | *          | false         | 1494470670306000  | --       |
| ods                                   |        |            |         | thadoop         | ROLE            | *          | false         | 1493369642620000  | --       |
| mscdata                               |        |            |         | thadoop         | ROLE            | *          | false         | 1494470670441000  | --       |
| odsdata                               |        |            |         | thadoop         | ROLE            | *          | false         | 1494470670688000  | --       |
| int          


ddp-cm:~ # ls /opt/local/hive/lib/
json-serde.jar  migu-inputformat.jar  spark-streaming.jar  udf-clear_rules.jar
