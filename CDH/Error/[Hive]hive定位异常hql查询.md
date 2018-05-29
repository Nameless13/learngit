title: hive定位异常hql查询
categories: [CDH,Error]
date: 2018-05-25 14:46:42
---
# hive定位异常hql查询
由于集群HDFS突然增加1个p的存储量,怀疑有任务提交异常

可以在查到具体的hive查询id
hdfs:/nameservice/tmp/hive/hive/ 
然后通过找到YARN对应的application定位出具体hql

后续建议开发增加groupby以及优化join