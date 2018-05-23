title: Spark集成S3 Service
categories: [CDH,Spark]
date: 2018-05-23 09:57:35
---
# Spark集成S3 Service
Spark的DataSource支持S3和Swift，考虑到Ceph也提供了S3和Swift的API，而C++的效率也是Python难以望其项背的，所以Spark+Ceph(S3 Service)可能是一个比较合适的方案。

如果想试试Spark with Swift，可以参考[Accessing OpenStack Swift from Spark](http://spark.apache.org/docs/latest/storage-openstack-swift.html)这篇文章，这里不再涉及。
由于我是配置haddop的core-site.xml,所以下面sc的配置并不用,开箱即用

## spark-shell

Spark shell在启动前，需要保证HDFS/YARN已经启动，并且使用--jars指定aws-java-sdk和hadoop-aws两个jar包的位置。我的参数比较多图省事创建了个shell脚本存着。

```
./spark-shell --master yarn-client --principal dtdream/zelda1@ZELDA.COM --keytab /etc/security/dtdream.zelda1.keytab --driver-java-options '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=13838'  --jars /home/dtdream/hadoop/hadoop-2.7.2/share/hadoop/tools/lib/aws-java-sdk-1.7.4.jar,/home/dtdream/hadoop/hadoop-2.7.2/share/hadoop/tools/lib/hadoop-aws-2.7.2.jar
```
进入shell以后：

```
scala> sc.hadoopConfiguration.set("fs.s3a.access.key", "xxx")
scala> sc.hadoopConfiguration.set("fs.s3a.secret.key", "yyyyyyyy")
scala> sc.hadoopConfiguration.set("fs.s3a.endpoint", "192.168.103.224:80")
scala> sc.hadoopConfiguration.set("fs.s3a.connection.ssl.enabled", "false")
scala> val myRdd = sc.textFile("s3a://xxx/diamonds.csv")
scala> myRdd.count
..
16/07/27 11:27:03 INFO DAGScheduler: Submitting ResultStage 0 (s3a://xxx/diamonds.csv MapPartitionsRDD[1] at textFile at <console>:27), which has no missing parents
16/07/27 11:27:03 INFO MemoryStore: Block broadcast_1 stored as values in memory (estimated size 2.9 KB, free 254.7 KB)
16/07/27 11:27:03 INFO MemoryStore: Block broadcast_1_piece0 stored as bytes in memory (estimated size 1762.0 B, free 256.4 KB)
..
16/07/27 11:27:03 INFO TaskSetManager: Starting task 0.0 in stage 0.0 of job 0 (TID 0, zelda3, partition 0,PROCESS_LOCAL, 2254 bytes)
16/07/27 11:27:03 INFO TaskSetManager: Starting task 1.0 in stage 0.0 of job 0 (TID 1, zelda1, partition 1,PROCESS_LOCAL, 2254 bytes)
..
res4: Long = 53940
```

由于我们在sc这里设置了hadoop的配置，所以haddop的core-site.xml那边就不要再设置了，否则会出现参数覆盖的问题。

使用wholeTextFiles处理文件夹里的所有文件，比较适合存放大量小图片的目录：

```
scala> val myRdd = sc.wholeTextFiles("s3a://xxx/")
res4: Long = 3
scala> myRdd2.count
3
```

## Spark SQL

1、没有找到像HDFS或者本地文件这种load data [local] inpath into table xxx这种比较方便的直接从S3导入到hive表的方法。绕路的方法就是hadoop distcp s3a:// -> hdfs://，然后再在SPARK SQL里load。

2、没有找到像Spark集成SQL这种CREATE TEMPORARY TABLE USING XX.XX.XX OPTION (XXX)的办法。其实这种在SPARK SQL里用才是比较直接的，并且没有可以绕开的方法。对于本质是结构化的文本文件来说，使用S3来存储实际没有太大意义；对于非结构化的图片、视频等，如果没有SQL入口的话，就只能强迫用户编写Spark APP来处理了，相对来说门槛更高一点。

参考hortonworks为Redshift写的插件，还是应该提供SQL入口，更友好一些，类似：

```
CREATE TABLE my_table
USING com.databricks.spark.redshift
OPTIONS (
  dbtable 'my_table',
  tempdir 's3n://path/for/temp/data',
  url 'jdbc:redshift://redshifthost:5439/database?user=username&password=pass'
);
```