service cloudera-scm-server stop
service cloudera-scm-agent stop
umount /var/run/cloudera-scm-agent/process
rm -rf /usr/share/cmf /var/lib/cloudera* /var/cache/zypp/packages/cloudera-* /var/cache/zypp/raw/cloudera-* /var/cache/zypp/solv/cloudera-* /var/log/cloudera-scm-* /var/run/cloudera-scm-* /etc/cloudera-scm-server*
rpm -qa |grep cloudera
rpm -e cloudera-manager-agent-5.13.0-1.cm5130.p0.55.el7.x86_64
rpm -e cloudera-manager-server-5.13.0-1.cm5130.p0.55.el7.x86_64
rpm -e cloudera-manager-daemons-5.13.0-1.cm5130.p0.55.el7.x86_64
rm -rf /var/lib/hadoop-* /var/lib/impala /var/lib/solr /var/lib/zookeeper /var/lib/hue /var/lib/oozie  /var/lib/pgsql  /var/lib/sqoop2  /data/dfs/  /data/impala/ /data/yarn/  /dfs/ /impala/ /yarn/  /var/run/hadoop-*/ /var/run/hdfs-*/ /usr/bin/hadoop* /usr/bin/zookeeper* /usr/bin/hbase* /usr/bin/hive* /usr/bin/hdfs /usr/bin/mapred /usr/bin/yarn /usr/bin/sqoop* /usr/bin/oozie /etc/hadoop* /etc/zookeeper* /etc/hive* /etc/hue /etc/impala /etc/sqoop* /etc/oozie /etc/hbase* /etc/hcatalog 
rm -rf /opt/cloudera/parcel-cache /opt/cloudera/parcels
ps aux|grep  supervisord |grep -v grep | awk '{print "kill -9 " $2}'|sh
