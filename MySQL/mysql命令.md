title: mysql命令
categories: 
- MySQL
date: 2017-06-30
---
在mysql的命令提示符下，执行下面一句话,查看mysql服务器的所有全局配置信息：
```
show global variables;
show slave status\G
show global variables like "%datadir%";
```
前言：之前因为了修改服务器hostname，导致从库同步失败，一直解决不掉，没办法，只能重新设置同步。
先停止从库同步，并清空同步信息
```
stop slave；
reset slave all;
```
全量备份主库数据

`mysqldump -u root -p --all-databases --routines > senqiang.sql`
全量还原数据库到从库

`mysql -uroot -p < senqiang.sql`
查看主库最新的binlog日志偏移量，从库重新授权同步

`change master to master_host='192.168.0.2',master_user='syncdb',master_password='passwd',master_log_file='mysql-bin.000005',master_log_pos=8188;`
开启从库同步
```
start slave;
show slave status\G;
```
注：备份主库前最好停止主库的写入，记录最新日志偏移量，否则在你还原数据，重新授权同步时会有数据偏差


Error: Error while compiling statement: FAILED: InvalidConfigurationException hive.server2.authentication can't be none in non-testing mode (state=42000,code=40000

