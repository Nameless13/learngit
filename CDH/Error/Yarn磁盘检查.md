title: Yarn磁盘检查
categories: [CDH,Error]
date: 2017-07-06
---
## yarn nodemanage 参数临时修改到100 
保证mapreduce shuffle阶段不会因为磁盘检测问题导致写入失败影响作业进度,cm默认配置为95%

报错如下:
    Directory /mnt/sdd1/yarn/nm error, used space above threshold of 95.0%, removing from list of valid directories

```    
Failed to setup application log directory for application_1494574323287_3723
org.apache.hadoop.ipc.RemoteException(org.apache.hadoop.security.token.SecretManager$InvalidToken): token (token for optaim: HDFS_DELEGATION_TOKEN owner=optaim@CMDMP.COM, renewer=yarn, realUser=, issueDate=1494607575657, maxDate=1495212375657, sequenceNumber=2291196, masterKeyId=599) can't be found in cache


Error: org.apache.hadoop.mapreduce.task.reduce.Shuffle$ShuffleError: error in shuffle in fetcher#8 at org.apache.hadoop.mapreduce.task.reduce.Shuffle.run(Shuffle.java:134) at org.apache.hadoop.mapred.ReduceTask.run(ReduceTask.java:376) at org.apache.hadoop.mapred.YarnChild$2.run(YarnChild.java:164) at java.security.AccessController.doPrivileged(Native Method) at javax.security.auth.Subject.doAs(Subject.java:415) at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1796) at org.apache.hadoop.mapred.YarnChild.main(YarnChild.java:158) Caused by: java.lang.OutOfMemoryError: Java heap space at org.apache.hadoop.io.BoundedByteArrayOutputStream.<init>(BoundedByteArrayOutputStream.java:56) at org.apache.hadoop.io.BoundedByteArrayOutputStream.<init>(BoundedByteArrayOutputStream.java:46) at org.apache.hadoop.mapreduce.task.reduce.InMemoryMapOutput.<init>(InMemoryMapOutput.java:63) at org.apache.hadoop.mapreduce.task.reduce.MergeManagerImpl.unconditionalReserve(MergeManagerImpl.java:309) at org.apache.hadoop.mapreduce.task.reduce.MergeManagerImpl.reserve(MergeManagerImpl.java:299) at org.apache.hadoop.mapreduce.task.reduce.Fetcher.copyMapOutput(Fetcher.java:539) at org.apache.hadoop.mapreduce.task.reduce.Fetcher.copyFromHost(Fetcher.java:348) at org.apache.hadoop.mapreduce.task.reduce.Fetcher.run(Fetcher.java:198)
```