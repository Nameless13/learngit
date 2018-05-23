title: Rebuild CDH
categories: [CDH,Installation]
date: 2018-05-23 09:57:35
---
# Rebuild CDH
## 删除CDH所有组件
```
service cloudera-scm-server stop
service cloudera-scm-agent stop
umount /var/run/cloudera-scm-agent/process
rm -rf /usr/share/cmf /var/lib/cloudera* /var/cache/zypp/packages/cloudera-* /var/cache/zypp/raw/cloudera-* /var/cache/zypp/solv/cloudera-* /var/log/cloudera-scm-* /var/run/cloudera-scm-* /etc/cloudera-scm-server*
rpm -qa |grep cloudera
rpm -e cloudera-manager-agent-5.10.0-1.cm5100.p0.85.el7.x86_64
rpm -e cloudera-manager-server-5.10.0-1.cm5100.p0.85.el7.x86_64
rpm -e cloudera-manager-daemons-5.10.0-1.cm5100.p0.85.el7.x86_64
rm -rf /var/lib/hadoop-* /var/lib/impala /var/lib/solr /var/lib/zookeeper /var/lib/hue /var/lib/oozie  /var/lib/pgsql  /var/lib/sqoop2  /data/dfs/  /data/impala/ /data/yarn/  /dfs/ /impala/ /yarn/  /var/run/hadoop-*/ /var/run/hdfs-*/ /usr/bin/hadoop* /usr/bin/zookeeper* /usr/bin/hbase* /usr/bin/hive* /usr/bin/hdfs /usr/bin/mapred /usr/bin/yarn /usr/bin/sqoop* /usr/bin/oozie /etc/hadoop* /etc/zookeeper* /etc/hive* /etc/hue /etc/impala /etc/sqoop* /etc/oozie /etc/hbase* /etc/hcatalog 
rm -rf /opt/cloudera/parcel-cache /opt/cloudera/parcels
ps aux|grep  supervisord |grep -v grep | awk '{print "kill -9 " $2}'|sh
```

## 删除所有datanode以及nodemanager产生的数据(建议直接格盘)
```
rm -rf /mnt/sdb1/dfs /mnt/sdc1/dfs /mnt/sdd1/dfs /mnt/sde1/dfs /mnt/sdf1/dfs /mnt/sdg1/dfs /mnt/sdh1/dfs /mnt/sdi1/dfs /mnt/sdj1/dfs /mnt/sdk1/dfs /mnt/sdl1/dfs /mnt/sdm1/dfs /mnt/sdn1/dfs /mnt/sdo1/dfs /mnt/sdp1/dfs /mnt/sdq1/dfs /mnt/sdr1/dfs /mnt/sds1/dfs /mnt/sdt1/dfs /mnt/sdu1/dfs /mnt/sdv1/dfs /mnt/sdw1/dfs /mnt/sdx1/dfs /mnt/sdy1/dfs 
rm -rf /mnt/sdb1/yarn /mnt/sdc1/yarn /mnt/sdd1/yarn /mnt/sde1/yarn /mnt/sdf1/yarn /mnt/sdg1/yarn /mnt/sdh1/yarn /mnt/sdi1/yarn /mnt/sdj1/yarn /mnt/sdk1/yarn /mnt/sdl1/yarn /mnt/sdm1/yarn /mnt/sdn1/yarn /mnt/sdo1/yarn /mnt/sdp1/yarn /mnt/sdq1/yarn /mnt/sdr1/yarn /mnt/sds1/yarn /mnt/sdt1/yarn /mnt/sdu1/yarn /mnt/sdv1/yarn /mnt/sdw1/yarn /mnt/sdx1/yarn /mnt/sdy1/yarn 
```

## 删除数据库
```
drop database metastore_sj_test;
drop database amon_sj_test;
drop database rman_sj_test;
drop database sentry_sj_test;
drop database nav_sj_test;
drop database navms_sj_test;
drop database cm_sj_test;
drop database hue_sj_test;
drop database oozie_sj_test;



drop database metastore_test;
drop database amon_test;
drop database rman_test;
drop database sentry_test;
drop database nav_test;
drop database navms_test;
drop database cm_test;
drop database hue_test;
drop database oozie_test;
```

## 重新init数据库
`/usr/share/cmf/schema/scm_prepare_database.sh -h 10.151.164.28 mysql cm_sj_test cm Cloudera@123`

