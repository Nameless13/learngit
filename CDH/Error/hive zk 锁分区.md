Got user-level KeeperException when processing sessionid:0x15bfba733be2c2b type:create cxid:0x8621e1c zxid:0x170a4b8e0d txntype:-1 reqpath:n/a Error Path:/hive_zookeeper_namespace_hive/rptdata/fact_kesheng_sdk_new_device_hourly/src_file_day=20170414/src_file_hour=07 Error:KeeperErrorCode = NodeExists for /hive_zookeeper_namespace_hive/rptdata/fact_kesheng_sdk_new_device_hourly/src_file_day=20170414/src_file_hour=07






2013-11-04 23:52:40,485 ERROR ZooKeeperHiveLockManager (ZooKeeperHiveLockManager.java:unlockPrimitive(447)) - Failed to release ZooKeeper lock:
org.apache.zookeeper.KeeperException$NoNodeException: KeeperErrorCode = NoNode for /hive_zookeeper_namespace/<hiveDBName>/<Table>/<PARTITION>/LOCK-SHARED-0000000000


/hive_zookeeper_namespace_hive/<hiveDBName>/<Table>/LOCK-SHARED-



show locks <hiveDBName>.<Table>

show locks <hiveDBName>.<Table> partition (src_file_day='20170218' , src_file_our='17'); 

可以看到 
| <hiveDBName>@ugc_90103_bossmonthorderlog_test@<PARTITION>/<PARTITION> | SHARED     |
然后把分区删了,重建