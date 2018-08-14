title: Hive建表中partition过多导致的zk终止服务
categories: [CDH,Error]
date: 2018-05-25 18:12:03
---
# Hive建表中partition过多导致的zk终止服务
一个 ZooKeeper 的节点（ znode ）存储两部分内容：数据和状态，状态中包含 ACL 信息。创建一个 znode 会产生一个 ACL 列表，列表中每个 ACL 包括

需要统计分区(partition)数超过1000的表名,因为后续数据迁移过程中需要对其拆分

虽然每次建表

## 尤其是某些多级分区的hql
```
PARTITIONED BY (                                   
   `src_file_day` string,                           
   `src_file_hour` string,                          
   `grain_ind` string)                              
 ROW FORMAT SERDE 
```

后续:
完成集群数据梳理工作，包括HDFS数据，Hive数据，重点的目录以及table,同时hive部分table的partition数目过多，导致Zookeeper snapshot占用空间异常大大，并且给ZK内存带来压力。后续需要开发人员对Partition进行修改。梳理出所有影响Zookeeper服务的所有table,下线所有不合理的任务流程,没有整改前全部不允许在生产环境调用

## 列出hive元数据库中所有表所拥有的分区个数
`use metastore;select d.NAME, a.TBL_NAME, b.count, c.LOCATION from TBLS a join (select TBL_ID,count(*) as count from PARTITIONS group by TBL_ID ) b join SDS c join DBS d where a.TBL_ID=b.TBL_ID and a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID order by b.count;`


## 列出hive元数据库中单个database中所有表所拥有的分区个数
`use metastore;select d.NAME, a.TBL_NAME, b.count, c.LOCATION from TBLS a join (select TBL_ID,count(*) as count from PARTITIONS group by TBL_ID ) b join SDS c join DBS d on a.TBL_ID=b.TBL_ID and a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID and d.NAME='dly' order by b.count;`