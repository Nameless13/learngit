# ZooKeeper运维
## 运维配置详解
### 基础配置
`http://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html`
- datalogdir
- globalOutstandingLimit
- preAllocSize
- snapCount
- maxClientCnxns
- clientPortAddress
- minSessionTimeout
- maxSessionTimeout
- fsync.warningthresholdms
- autopurge.snapRetainCount
- autopurge.purgeInterval

---
- electionAlg
- initLimit
- leaderServes
- server.x=[hostname]:nnnnn[:nnnnn], etc
- syncLimit (默认5)

---
- forceSync 
- jute.maxbuffer (所有机器所有集群都设置才能生效)
- skipACL




## 4字命令
`echo stat | nc 192.168.1.105 2181`
`echo conf | nc 192.168.1.105 2181`
<!-- 根据单机和集群显示不同信息 -->
`echo cons | nc 192.168.1.105 2181`
`echo crst | nc 192.168.1.105 2181` 
<!-- 重置所有信息 -->
`echo drop | nc 192.168.1.105 2181` 
`echo envi | nc 192.168.1.105 2181` 
`echo ruok | nc 192.168.1.105 2181` 
`echo stat | nc 192.168.1.105 2181` 
`echo srvr | nc 192.168.1.105 2181` 
`echo srst | nc 192.168.1.105 2181` 
`echo wchs | nc 192.168.1.105 2181` 
`echo wchc | nc 192.168.1.105 2181` 
`echo wchp | nc 192.168.1.105 2181` 
`echo mntr | nc 192.168.1.105 2181` 

## 在运维中使用JMX
1. 修改ZK服务器的启动脚本(每一台)
`Vim zkServer.sh`
```
- zooMain="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=true org.apache.zookeeper.server.quorum.QuorumPeerMain"
+ zooMain="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=false  -Djava.rmi.server.hostname=192.168.1.105 -Dcom.sun.management.jmxremote.port=8899 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false org.apache.zookeeper.server.quorum.QuorumPeerMain"
```
`./zkServer.sh stop`
`./zkServer.sh start`

2. jconsole

## 监控平台的搭建和使用
- netflix: exhibitor 
- zabbix