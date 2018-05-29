title: Hive元数据库SQL查询
categories: [CDH,Error]
date: 2018-05-29 16:33:45
---
# Hive元数据库查询SQL

## 列出hive元数据库中所有表所拥有的分区个数
`use metastore;select d.NAME, a.TBL_NAME, b.count, c.LOCATION from TBLS a join (select TBL_ID,count(*) as count from PARTITIONS group by TBL_ID ) b join SDS c join DBS d where a.TBL_ID=b.TBL_ID and a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID order by b.count;`


## 列出hive元数据库中单个database中所有表所拥有的分区个数
`use metastore;select d.NAME, a.TBL_NAME, b.count, c.LOCATION from TBLS a join (select TBL_ID,count(*) as count from PARTITIONS group by TBL_ID ) b join SDS c join DBS d on a.TBL_ID=b.TBL_ID and a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID and d.NAME='dly' order by b.count;`

## 列出hive元数据库中,所有Database中所有外部表所对应的HDFS路径
`use metastore;select d.NAME,a.TBL_NAME,a.TBL_TYPE,c.LOCATION from TBLS a join SDS c join DBS d where a.SD_ID=c.SD_ID and a.DB_ID=d.DB_ID and a.TBL_TYPE='EXTERNAL_TABLE' order by d.NAME;`

```
DBNAME  TBL_NAME    TBL_TYPE    LOCATION
db1   tb1   EXTERNAL_TABLE  hdfs://ns1/user/xxx/test/join300
db2   tb2   EXTERNAL_TABLE  hdfs://ns1/user/hive/warehouse/db2.db/tb2
db2   tb3   EXTERNAL_TABLE  hdfs://ns1/user/hive/warehouse/db2.db/tb3
db2   tb4   EXTERNAL_TABLE  hdfs://ns1/user/hive/warehouse/db2.db/tb4
db2   tb5   EXTERNAL_TABLE  hdfs://ns1/user/hive/warehouse/db2.db/tb5
```