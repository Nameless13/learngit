jsvc.exec
-Dproc_datanode
-outfile /var/log/hadoop-hdfs/jsvc.out
-errfile /var/log/hadoop-hdfs/jsvc.err
-pidfile /tmp/hadoop_secure_dn.pid
-nodetach -user hdfs -cp 
/var/run/cloudera-scm-agent/process/6860-hdfs-DATANODE:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop/lib/*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop/.//*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-hdfs/./:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-hdfs/lib/*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-hdfs/.//*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-yarn/lib/*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-yarn/.//*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-mapreduce/lib/*:
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop-mapreduce/.//*:
/usr/share/cmf/lib/plugins/tt-instrumentation-5.10.0.jar:
/usr/share/cmf/lib/plugins/event-publish-5.10.0-shaded.jar:
/usr/share/cmf/lib/plugins/navigator/cdh57/audit-plugin-cdh57-2.9.0-shaded.jar
-Xmx1000m
-Dhdfs.audit.logger=INFO,RFAAUDIT
-Dsecurity.audit.logger=INFO,RFAS
-Djava.net.preferIPv4Stack=true
-Dhadoop.log.dir=/var/log/hadoop-hdfs
-Dhadoop.log.file=hadoop-cmf-hdfs-DATANODE-ddp-dn-04.cmdmp.com.log.out
-Dhadoop.home.dir=/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop
-Dhadoop.id.str=hdfs
-Dhadoop.root.logger=INFO,RFA
-Djava.library.path=/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hadoop/lib/native
-Dhadoop.policy.file=hadoop-policy.xml
-Djava.net.preferIPv4Stack=true
-Dhadoop.id.str=hdfs
-jvm
server
-Xms1659895808
-Xmx1659895808
-XX:+UseParNewGC
-XX:+UseConcMarkSweepGC
-XX:CMSInitiatingOccupancyFraction=70
-XX:+CMSParallelRemarkEnabled
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/tmp/hdfs_hdfs-DATANODE-231d9f858c1eae217955379455af5c58_pid6980.hprof
-XX:OnOutOfMemoryError=/usr/lib64/cmf/service/common/killparent.sh
-Dhadoop.security.logger=INFO,RFAS
org.apache.hadoop.hdfs.server.datanode.SecureDataNodeStarter