title: hive LZO压缩格式支持
categories: [CDH,Error]
date: 2017-05-24
---
>[LZO配置](https://www.cloudera.com/documentation/enterprise/latest/topics/admin_data_compression_performance.html
)

## hive 因为仅仅添加了LZO压缩格式的配置路径,却没有导入
暂时先删除LZO配置
```
ddp-hb-01:~ # beeline -u 'jdbc:hive2://10.200.60.99:10000/yanfa;principal=hive/ddp-hb-01.cmdmp.com@CMDMP.COM'
scan complete in 3ms
Connecting to jdbc:hive2://10.200.60.99:10000/yanfa;principal=hive/ddp-hb-01.cmdmp.com@CMDMP.COM
Connected to: Apache Hive (version 1.1.0-cdh5.4.7)
Driver: Hive JDBC (version 1.1.0-cdh5.4.7)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 1.1.0-cdh5.4.7 by Apache Hive
[INFO] Unable to bind key for unsupported operation: backward-delete-word
[INFO] Unable to bind key for unsupported operation: backward-delete-word
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
[INFO] Unable to bind key for unsupported operation: up-history
[INFO] Unable to bind key for unsupported operation: down-history
0: jdbc:hive2://10.200.60.99:10000/yanfa> show databases;
0: jdbc:hive2://10.200.60.99:10000/yanfa> show tables;
0: jdbc:hive2://10.200.60.99:10000/yanfa> select * from tk_user_his limit 10;
```

```
11	11	
     <value>1</value>
12	12	
   </property>
13	13	
   <property>
14	14	
     <name>io.compression.codecs</name>
15		
-    <value>org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.BZip2Codec,org.apache.hadoop.io.compress.DeflateCodec,org.apache.hadoop.io.compress.SnappyCodec,org.apache.hadoop.io.compress.Lz4Codec</value>
15	
+    <value>org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.BZip2Codec,org.apache.hadoop.io.compress.DeflateCodec,org.apache.hadoop.io.compress.SnappyCodec,org.apache.hadoop.io.compress.Lz4Codec,com.hadoop.compression.lzo.LzoCodec,com.hadoop.compression.lzo.LzopCodec</value>
16	16	
   </property>
17	17	
   <property>
18	18	
     <name>hadoop.security.authentication</name>
19	19	
     <value>kerberos</value>

```

```
93	93	
   <node name="ddp-dn-041.cmdmp.com" rack="/A21"/>
94	94	
   <node name="10.200.60.123" rack="/A21"/>
95	95	
   <node name="ddp-dn-042.cmdmp.com" rack="/A21"/>
96	96	
   <node name="10.200.60.124" rack="/A21"/>
97		
-  <node name="ddp-dn-043.cmdmp.com" rack="/A21"/>
98		
-  <node name="10.200.60.125" rack="/A21"/>
99	97	
   <node name="ddp-dn-044.cmdmp.com" rack="/A21"/>
100	98	
   <node name="10.200.60.126" rack="/A21"/>
101	99	
   <node name="ddp-dn-045.cmdmp.com" rack="/A21"/>
102	100	
   <node name="10.200.60.127" rack="/A21"/>
...	...	
@@ -339,8 +337,10 @@
339	337	
   <node name="ddp-dn-170.cmdmp.com" rack="/A15"/>
340	338	
   <node name="10.200.60.81" rack="/A15"/>
341	339	
   <node name="ddp-dn-171.cmdmp.com" rack="/A15"/>
342	340	
   <node name="10.200.60.82" rack="/A15"/>
341	
+  <node name="ddp-dn-172.cmdmp.com" rack="/default"/>
342	
+  <node name="10.200.60.83" rack="/default"/>
343	343	
   <node name="ddp-dn-173.cmdmp.com" rack="/A15"/>
344	344	
   <node name="10.200.60.84" rack="/A15"/>
345	345	
   <node name="ddp-dn-174.cmdmp.com" rack="/A15"/>
346	346	
   <node name="10.200.60.85" rack="/A15"/>
```     

3月 22, 下午2点53:37.282	WARN	org.apache.hive.service.cli.thrift.ThriftCLIService	
Error fetching results: 
org.apache.hive.service.cli.HiveSQLException: java.io.IOException: java.lang.RuntimeException: Error in configuring object
	at org.apache.hive.service.cli.operation.SQLOperation.getNextRowSet(SQLOperation.java:329)
	at org.apache.hive.service.cli.operation.OperationManager.getOperationNextRowSet(OperationManager.java:250)
	at org.apache.hive.service.cli.session.HiveSessionImpl.fetchResults(HiveSessionImpl.java:699)
	at sun.reflect.GeneratedMethodAccessor10.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:606)
	at org.apache.hive.service.cli.session.HiveSessionProxy.invoke(HiveSessionProxy.java:78)
	at org.apache.hive.service.cli.session.HiveSessionProxy.access$000(HiveSessionProxy.java:36)
	at org.apache.hive.service.cli.session.HiveSessionProxy$1.run(HiveSessionProxy.java:63)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:415)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1671)
	at org.apache.hive.service.cli.session.HiveSessionProxy.invoke(HiveSessionProxy.java:59)
	at com.sun.proxy.$Proxy23.fetchResults(Unknown Source)
	at org.apache.hive.service.cli.CLIService.fetchResults(CLIService.java:438)
	at org.apache.hive.service.cli.thrift.ThriftCLIService.FetchResults(ThriftCLIService.java:676)
	at org.apache.hive.service.cli.thrift.TCLIService$Processor$FetchResults.getResult(TCLIService.java:1553)
	at org.apache.hive.service.cli.thrift.TCLIService$Processor$FetchResults.getResult(TCLIService.java:1538)
	at org.apache.thrift.ProcessFunction.process(ProcessFunction.java:39)
	at org.apache.thrift.TBaseProcessor.process(TBaseProcessor.java:39)
	at org.apache.hadoop.hive.thrift.HadoopThriftAuthBridge$Server$TUGIAssumingProcessor.process(HadoopThriftAuthBridge.java:692)
	at org.apache.thrift.server.TThreadPoolServer$WorkerProcess.run(TThreadPoolServer.java:285)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
Caused by: java.io.IOException: java.lang.RuntimeException: Error in configuring object
	at org.apache.hadoop.hive.ql.exec.FetchOperator.getNextRow(FetchOperator.java:507)
	at org.apache.hadoop.hive.ql.exec.FetchOperator.pushRow(FetchOperator.java:414)
	at org.apache.hadoop.hive.ql.exec.FetchTask.fetch(FetchTask.java:138)
	at org.apache.hadoop.hive.ql.Driver.getResults(Driver.java:1655)
	at org.apache.hive.service.cli.operation.SQLOperation.getNextRowSet(SQLOperation.java:324)
	... 24 more
Caused by: java.lang.RuntimeException: Error in configuring object
	at org.apache.hadoop.util.ReflectionUtils.setJobConf(ReflectionUtils.java:109)
	at org.apache.hadoop.util.ReflectionUtils.setConf(ReflectionUtils.java:75)
	at org.apache.hadoop.util.ReflectionUtils.newInstance(ReflectionUtils.java:133)
	at org.apache.hadoop.hive.ql.exec.FetchOperator.getInputFormatFromCache(FetchOperator.java:206)
	at org.apache.hadoop.hive.ql.exec.FetchOperator.getNextSplits(FetchOperator.java:360)
	at org.apache.hadoop.hive.ql.exec.FetchOperator.getRecordReader(FetchOperator.java:294)
	at org.apache.hadoop.hive.ql.exec.FetchOperator.getNextRow(FetchOperator.java:445)
	... 28 more
Caused by: java.lang.reflect.InvocationTargetException
	at sun.reflect.GeneratedMethodAccessor43.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:606)
	at org.apache.hadoop.util.ReflectionUtils.setJobConf(ReflectionUtils.java:106)
	... 34 more
Caused by: java.lang.IllegalArgumentException: Compression codec com.hadoop.compression.lzo.LzoCodec not found.
	at org.apache.hadoop.io.compress.CompressionCodecFactory.getCodecClasses(CompressionCodecFactory.java:135)
	at org.apache.hadoop.io.compress.CompressionCodecFactory.<init>(CompressionCodecFactory.java:175)
	at org.apache.hadoop.mapred.TextInputFormat.configure(TextInputFormat.java:45)
	... 38 more
Caused by: java.lang.ClassNotFoundException: Class com.hadoop.compression.lzo.LzoCodec not found
	at org.apache.hadoop.conf.Configuration.getClassByName(Configuration.java:2018)
	at org.apache.hadoop.io.compress.CompressionCodecFactory.getCodecClasses(CompressionCodecFactory.java:128)
	... 40 more


```


